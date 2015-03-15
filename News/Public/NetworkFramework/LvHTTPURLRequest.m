//
//  LvURLRequest.m
//  GalaToy
//
//  Created by 光波 彭 on 14-9-4.
//  Copyright (c) 2014年 Galasmart. All rights reserved.
//

#import "LvHTTPURLRequest.h"

@interface LvHTTPURLRequest ()

@property (nonatomic, strong) NSURLConnection *conn;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation LvHTTPURLRequest

@synthesize URLRequest;
@synthesize conn;
@synthesize isOnRequest;
@synthesize responseData;

- (instancetype)initWithURLRequest:(NSURLRequest *)request
{
    if (self = [super init]) {
        URLRequest = request;
    }
    return self;
}


- (void)asyncRequest
{
    if (!URLRequest) {
        DLOG(@"URLRequest为空，不能请求");
        return;
    }
    
    if (![ReachableSingleton sharedInstance].isConnected) {
        DLOG(@"没有可用的网络，不能请求");
        [self handleNetworkUnavaliable];
        return;
    }
//    DLOG(@"%@", URLRequest.URL);
    responseData = [NSMutableData data];
    isOnRequest = YES;
    conn = [NSURLConnection connectionWithRequest:URLRequest delegate:self];
    if (!conn) {
        [self handleNetworkUnavaliable];
        isOnRequest = NO;
    }
    
    /**
     *  如果在子线程中调用asyncRequest, 那么线程可能在这里就会消亡，进入不了NSURLConnectionDelegate的方法中。
     *  使用NSRunLoop，可以解决这个问题
     */
    NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
    while (isOnRequest) {
        [currentRunLoop runMode:NSDefaultRunLoopMode
                     beforeDate:[NSDate distantFuture]];
    }
}

- (void)cancelRequest
{
    [conn cancel];
    responseData = nil;
    isOnRequest = NO;
}

- (id(^)(NSData *requestResult))requestResultParser
{
    return nil;
}

- (void)handleNetworkUnavaliable
{
    if (self.requestResultHandlerDelegate
        && [self.requestResultHandlerDelegate respondsToSelector:@selector(failCauseNetworkUnavaliable:)]) {
        [self.requestResultHandlerDelegate failCauseNetworkUnavaliable:self];
    }
}

- (void)handleRequestTimeount
{
    if (self.requestResultHandlerDelegate
        && [self.requestResultHandlerDelegate respondsToSelector:@selector(failCauseRequestTimeout:)]) {
        [self.requestResultHandlerDelegate failCauseRequestTimeout:self];
    }
}

- (void)handleServerError
{
    if (self.requestResultHandlerDelegate
        && [self.requestResultHandlerDelegate respondsToSelector:@selector(failCauseServerError:)]) {
        [self.requestResultHandlerDelegate failCauseServerError:self];
    }
}

- (void)handleSuccess
{
    if (!self.requestResultHandlerDelegate)
        return;
    
    id parsedResponseData;
    id (^resultParser)(NSData *) = [self requestResultParser];
    if (resultParser) {
        parsedResponseData = resultParser(responseData);
    } else {
        parsedResponseData = responseData;
    }
    if ([self.requestResultHandlerDelegate respondsToSelector:@selector(request:successRequestWithResult:)]) {
        [self.requestResultHandlerDelegate request:self
                          successRequestWithResult:parsedResponseData];
    }
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DLOG(@"LvHTTPURLRequest, didFailWithError: %@", error.localizedDescription);
    
    [self handleRequestTimeount];
    isOnRequest = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    DLOG(@"%@", response.URL);
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
        if (httpResp.statusCode >= 500) {
            [self handleServerError];
            [self cancelRequest];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self handleSuccess];
    isOnRequest = NO;
}

@end


@implementation LvHTTPURLRequest (Sync)

- (id)syncRequest
{
    if (!URLRequest) {
        DLOG(@"URLRequest为空，不能请求");
        return nil;
    }
    
    if (![[ReachableSingleton sharedInstance] isConnected]) {
        DLOG(@"没有可用的网络，不能请求");
        return nil;
    }
    DLOG(@"%@", URLRequest.URL);
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *syncResponseData = [NSURLConnection sendSynchronousRequest:URLRequest
                                                     returningResponse:&response
                                                                 error:&error];
    if (error) {
        DLOG(@"syncRequest, error: %@", error.localizedDescription);
        return nil;
    }
    
    id parsedResponseData;
    id (^resultParser)(NSData *) = [self requestResultParser];
    if (resultParser) {
        parsedResponseData = resultParser(syncResponseData);
    } else {
        parsedResponseData = syncResponseData;
    }
    
    return parsedResponseData;
}

@end



@implementation BaseHTTPURLRequestResultHandlerProxy
@synthesize preHandlerMap;
@synthesize postHandlerMap;
@synthesize generalPreHandler;
@synthesize generalPostHandler;

- (BaseHTTPURLRequestResultHandlerProxy *)init
{
    if (self = [super init]) {
        preHandlerMap = [NSMutableDictionary dictionary];
        postHandlerMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)doPreHandler:(SEL)handler withObject:(id)object
{
    if (!handler) return;
    
    void(^preHandler)(id) = [preHandlerMap objectForKey:NSStringFromSelector(handler)];
    if (preHandler) {
        preHandler(object);
    }
}

- (void)doPostHandler:(SEL)handler withObject:(id)object
{
    if (!handler) return;
    
    void(^postHandler)(id) = [postHandlerMap objectForKey:NSStringFromSelector(handler)];
    if (postHandler) {
        postHandler(object);
    }
}

- (void)doGeneralPreHandleWithObject:(id)object;
{
    if (generalPreHandler) {
        generalPreHandler(object);
    }
}

- (void)doGeneralPostHandleWithObject:(id)object
{
    if (generalPostHandler) {
        generalPostHandler(object);
    }
}

- (void)doHandleErrorForRequest:(id)request withAction:(SEL)action
{
    if (!request || !action)
        return;
    
    [self doGeneralPreHandleWithObject:nil];
    [self doPreHandler:action withObject:nil];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    if ([[self customer] respondsToSelector:action]) {
        [[self customer] performSelector:action withObject:request];
    } else if ([[self proxy] respondsToSelector:action]) {
        [[self proxy] performSelector:action withObject:request];
    }

#pragma clang diagnostic pop
    
    [self doGeneralPostHandleWithObject:nil];
    [self doPostHandler:action withObject:nil];
}

- (void)doHandleNetworkUnavaliableForAPIRequest:(id)request
{
    [self doHandleErrorForRequest:request
                       withAction:@selector(failCauseNetworkUnavaliable:)];
}

- (void)doHandleRequestTimeoutForAPIRequest:(id)request
{
    [self doHandleErrorForRequest:request
                       withAction:@selector(failCauseRequestTimeout:)];
}

- (void)doHandleServerErrorForAPIRequest:(id)request
{
    [self doHandleErrorForRequest:request
                       withAction:@selector(failCauseServerError:)];
}

- (void)request:(LvHTTPURLRequest *)request doHandleSuccessWithResult:(id)requestResult
{
    [self doGeneralPreHandleWithObject:requestResult];
    
    SEL handler = @selector(request:successRequestWithResult:);
    [self doPreHandler:handler withObject:requestResult];
    
    if ([[self customer] respondsToSelector:handler]) {
        [[self customer] request:request successRequestWithResult:requestResult];
    } else if ([[self proxy] respondsToSelector:handler]) {
        [[self proxy] request:request successRequestWithResult:requestResult];
    }
    
    [self doGeneralPostHandleWithObject:requestResult];
    
    [self doPostHandler:handler withObject:requestResult];
}

- (id<LvHTTPURLRequestDelegate>)customer
{
    return nil;
}

- (id<LvHTTPURLRequestDelegate>)proxy
{
    return nil;
}

@end


@implementation HTTPURLRequestResultHandlerProxy

#pragma mark - Override customer
@synthesize customer;
#pragma mark - Override proxy
@synthesize proxy;

- (HTTPURLRequestResultHandlerProxy *)initWithCustomer:(id<LvHTTPURLRequestDelegate>)c
                                                 proxy:(id<LvHTTPURLRequestDelegate>)p
{
    if (self = [super init]) {
        customer = c;
        proxy = p;
    }
    return self;
}

#pragma mark - LvHTTPURLRequestDelegate

- (void)failCauseNetworkUnavaliable:(id)request
{
    [self doHandleNetworkUnavaliableForAPIRequest:request];
}

- (void)failCauseRequestTimeout:(id)request
{
    [self doHandleRequestTimeoutForAPIRequest:request];
}

- (void)failCauseServerError:(id)request
{
    [self doHandleServerErrorForAPIRequest:request];
}

- (void)request:(id)request successRequestWithResult:(id)requestResult
{
    [self request:request doHandleSuccessWithResult:requestResult];
}

@end
