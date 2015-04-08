//
//  NABaseApi.m
//  NewsAgencyDemo
//
//  Created by guangbo on 15/3/4.
//
//

#import "NABaseApi.h"
#import "NAApiError.h"

@implementation NAApiResponseStatus

- (instancetype)initWithStatus:(NSString *)status memo:(NSString *)memo
{
    if (self = [super init]) {
        self.status = status;
        self.memo = memo;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{status:%@, memo:%@}",
            _status,
            _memo];
}

@end

@implementation NABaseApi

+ (NAApiResponseStatus *)getApiResponseStatusFromRequestResult:(NSDictionary *)reqResult
{
    NAApiResponseStatus *respStatus = nil;
    
    NSString *status = [reqResult objectForKey:@"status"];
    NSString *memo = [reqResult objectForKey:@"memo"];
    
    if (status) {
        respStatus = [[NAApiResponseStatus alloc]initWithStatus:status
                                                           memo:memo];
    }
    
    return respStatus;
}

#pragma mark - Override

- (void)handleRequetResult:(JsonResultApiRequestResult *)requestResult
{
    DLOG(@"%@", requestResult.result);
    
    // 处理错误
    if (![requestResult.result isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    /**
     *  处理服务端返回的错误信息
     */
    NAApiResponseStatus *respStatus = [NABaseApi getApiResponseStatusFromRequestResult:requestResult.result];
    
    // 赋值
    _respStatus = respStatus;
    
    if (!respStatus) {
        return;
    }
    
    // 成功
    if ([NAApiRequestSuccess isEqualToString:respStatus.status] || [NAApiBusinessErr isEqualToString:respStatus.status]) {
        
        // 解析结果，并调用正确结果处理
        id parsedResult;
        if (requestResult.corretResultParser) {
            parsedResult = requestResult.corretResultParser(requestResult.result);
        } else {
            parsedResult = requestResult.result;
        }
        
        if (requestResult.correctResultHandler) {
            requestResult.correctResultHandler(parsedResult);
        }
        
    } else {
        if ([requestResult.apiErrorHandlerMap.allKeys containsObject:respStatus.status]) {
            void(^errorHandler)(void) = [requestResult.apiErrorHandlerMap objectForKey:respStatus.status];
            errorHandler();
        } else if (requestResult.serverErrorHandler) {
            requestResult.serverErrorHandler();
        }
    }
}


#pragma mark - Override

- (NSMutableDictionary *)apiErrorResultHandlerMap
{
    // 注册该api可能会出现的错误
    NSMutableDictionary *apiErrorHandlerMap = [super apiErrorResultHandlerMap];
    
    if (!self.APIRequestResultHandlerDelegate || ![self.APIRequestResultHandlerDelegate conformsToProtocol:@protocol(NABaseApiResultHandlerDelegate)]) {
        return apiErrorHandlerMap;
    }
    
    __weak id weakSelf = self;
    __weak id<NABaseApiResultHandlerDelegate> weakDelegate = (id<NABaseApiResultHandlerDelegate>)self.APIRequestResultHandlerDelegate;
    
    // 注册参数错误处理
    [apiErrorHandlerMap setObject:^{
        if ([weakDelegate respondsToSelector:@selector(failCauseParamError:)]) {
            [weakDelegate failCauseParamError:weakSelf];
        }
    } forKey:NAApiParamErr];
    
    // 注册业务错误处理
    [apiErrorHandlerMap setObject:^{
        if ([weakDelegate respondsToSelector:@selector(failCauseBissnessError:)]) {
            [weakDelegate failCauseBissnessError:weakSelf];
        }
    } forKey:NAApiBusinessErr];
    
    // 注册系统错误处理
    [apiErrorHandlerMap setObject:^{
        if ([weakDelegate respondsToSelector:@selector(failCauseSystemError:)]) {
            [weakDelegate failCauseSystemError:weakSelf];
        }
    } forKey:NAApiSystemErr];
    
    return apiErrorHandlerMap;
}
@end
