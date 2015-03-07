//
//  NAApiLogout.m
//  NewsAgencyDemo
//
//  Created by guangbo on 15/3/4.
//
//

#import "NAApiLogout.h"
#import "NAApiError.h"

@implementation NAApiLogout

- (instancetype)init
{
    self = [super initWithApiMethod:@"logout"
                    paramDictioanry:nil
                         httpMethod:HTTP_METHOD_POST];
    return self;
}

#pragma mark - Override

- (NSMutableDictionary *)apiErrorResultHandlerMap
{
    NSMutableDictionary *apiErrorHandlerMap = [super apiErrorResultHandlerMap];
    
    if (!self.APIRequestResultHandlerDelegate || ![self.APIRequestResultHandlerDelegate conformsToProtocol:@protocol(NAApiLogoutResultHandlerDelegate)]) {
        return apiErrorHandlerMap;
    }
    
    __weak id weakSelf = self;
    __weak id<NAApiLogoutResultHandlerDelegate> weakDelegate = (id<NAApiLogoutResultHandlerDelegate>)self.APIRequestResultHandlerDelegate;
    
    // 注册session过期错误处理
    [apiErrorHandlerMap setObject:^{
        if ([weakDelegate respondsToSelector:@selector(failCauseSessionInvalid:)]) {
            [weakDelegate failCauseSessionInvalid:weakSelf];
        }
    } forKey:NAApiSessionExpires];
    
    return apiErrorHandlerMap;
}

@end
