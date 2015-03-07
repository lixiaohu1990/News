//
//  LvJsonResultApiRequest.m
//  CommunityDemo
//
//  Created by guangbo on 14/12/5.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import "LvJsonResultApiRequest.h"

@implementation JsonResultApiRequestResult

- (instancetype)    initResult:(id)result
     networkUnavaliableHandler:(ERROR_RESULT_HANDLER)networkUnavaliableHandler
            serverErrorHandler:(ERROR_RESULT_HANDLER)serverErrorHandler
            apiErrorHandlerMap:(NSDictionary *)apiErrorHandlerMap
          correctResultHandler:(CORRECT_RESULT_HANDLER)correctResultHandler
            corretResultParser:(CORRECT_RESULT_PARSER)corretResultParser
{
    if (self = [super init]) {
        self.result = result;
        self.networkUnavaliableHandler = networkUnavaliableHandler;
        self.serverErrorHandler = serverErrorHandler;
        self.apiErrorHandlerMap = apiErrorHandlerMap;
        self.correctResultHandler = correctResultHandler;
        self.corretResultParser = corretResultParser;
    }
    return self;
}

@end


@interface LvJsonResultApiRequest () <LvHTTPURLRequestDelegate>

@property (nonatomic) JsonResultApiRequestResult *requestResult;

@end

@implementation LvJsonResultApiRequest

/**
 *  api 请求因网络不可用请求失败的处理方法
 */
- (ERROR_RESULT_HANDLER)APIRequestFailCauseNetworkUnavaliableHandler
{
    __weak LvJsonResultApiRequest *weakSelf = self;
    return ^{
        if (weakSelf.APIRequestResultHandlerDelegate
            && [weakSelf.APIRequestResultHandlerDelegate respondsToSelector:@selector(failCauseNetworkUnavaliable:)]) {
            [weakSelf.APIRequestResultHandlerDelegate failCauseNetworkUnavaliable:weakSelf];
        }
    };
}

- (ERROR_RESULT_HANDLER)APIRequestFailCauseRequestTimeoutHandler
{
    __weak LvJsonResultApiRequest *weakSelf = self;
    return ^{
        if (weakSelf.APIRequestResultHandlerDelegate
            && [weakSelf.APIRequestResultHandlerDelegate respondsToSelector:@selector(failCauseRequestTimeout:)]) {
            [weakSelf.APIRequestResultHandlerDelegate failCauseRequestTimeout:weakSelf];
        }
    };
}

/**
 *  api 请求因服务端出现错误请求失败的处理方法
 */
- (ERROR_RESULT_HANDLER)APIRequestFailCauseServerErrorHandler
{
    __weak LvJsonResultApiRequest *weakSelf = self;
    return ^{
        if (weakSelf.APIRequestResultHandlerDelegate
            && [weakSelf.APIRequestResultHandlerDelegate respondsToSelector:@selector(failCauseServerError:)]) {
            [weakSelf.APIRequestResultHandlerDelegate failCauseServerError:weakSelf];
        }
    };
}

/**
 *  api 请求返回成功结果并解析完后的处理方法
 */
- (CORRECT_RESULT_HANDLER)APIRequestSuccessResultHandler
{
    __weak LvJsonResultApiRequest *weakSelf = self;
    return ^(id requestResult) {
        if (weakSelf.APIRequestResultHandlerDelegate
            && [weakSelf.APIRequestResultHandlerDelegate respondsToSelector:@selector(request:successRequestWithResult:)]) {
            [weakSelf.APIRequestResultHandlerDelegate request:weakSelf
                                     successRequestWithResult:requestResult];
        }
    };
}

- (void)setAPIRequestResultHandlerDelegate:(id<LvHTTPURLRequestDelegate>)delegate
{
    [self setRequestResultHandlerDelegate:delegate];
    _APIRequestResultHandlerDelegate = delegate;
}

#pragma mark - Override
- (void)setRequestResultHandlerDelegate:(id<LvHTTPURLRequestDelegate>)delegate
{
    /**
     *  不要把值设置给requestResultHandlerDelegate
     */
    
}

#pragma mark - Override
- (id<LvHTTPURLRequestDelegate>)requestResultHandlerDelegate
{
    /**
     *  返回自己，自己接管LvHTTPURLRequestDelegate的实现
     */
    __weak id<LvHTTPURLRequestDelegate> weakSelf = self;
    return weakSelf;
}

#pragma mark - Override
- (CORRECT_RESULT_PARSER)jsonRequestResultParser
{
    return nil;
}

#pragma mark - LvHTTPURLRequestDelegate

- (void)request:(id)request successRequestWithResult:(id)jsonResult
{
    self.requestResult = [[JsonResultApiRequestResult alloc]initResult:jsonResult
                                             networkUnavaliableHandler:[self APIRequestFailCauseNetworkUnavaliableHandler]
                                                    serverErrorHandler:[self APIRequestFailCauseServerErrorHandler]
                                                    apiErrorHandlerMap:[self apiErrorResultHandlerMap]
                                                  correctResultHandler:[self APIRequestSuccessResultHandler]
                                                    corretResultParser:[self apiCorrectResultParser]];
    [self handleRequetResult:self.requestResult];
}


- (void)failCauseNetworkUnavaliable:(id)request;
{
    [self APIRequestFailCauseNetworkUnavaliableHandler]();
}

- (void)failCauseRequestTimeout:(id)request
{
    [self APIRequestFailCauseRequestTimeoutHandler]();
}

- (void)failCauseServerError:(id)request;
{
    [self APIRequestFailCauseServerErrorHandler]();
}

- (CORRECT_RESULT_PARSER)apiCorrectResultParser
{
    return nil;
}

- (NSMutableDictionary *)apiErrorResultHandlerMap
{
    return [NSMutableDictionary dictionary];
}

- (void)handleRequetResult:(JsonResultApiRequestResult *)requestResult
{
    // Do nothing
}

@end
