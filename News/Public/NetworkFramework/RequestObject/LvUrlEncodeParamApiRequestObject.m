//
//  LvUrlEncodeParamApiRequestObject.m
//  CommunityDemo
//
//  Created by guangbo on 14/12/5.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import "LvUrlEncodeParamApiRequestObject.h"

@implementation LvUrlEncodeParamApiRequestObject

- (instancetype)initWithUrl:(NSString *)url
            paramDictioanry:(NSDictionary *)paramDictioanry
                 httpMethod:(NSString *)httpMethod
{
    return [self initWithCachePolicy:NSURLRequestUseProtocolCachePolicy
                     timeoutInterval:DEFAULT_REQUEST_TIMEOUT
                                 url:url
                     paramDictioanry:paramDictioanry
                          httpMethod:httpMethod];
}

- (instancetype)initWithCachePolicy:(NSURLRequestCachePolicy)cachePolicy
                    timeoutInterval:(NSTimeInterval)timeoutInterval
                                url:(NSString *)url
                    paramDictioanry:(NSDictionary *)paramDictioanry
                         httpMethod:(NSString *)httpMethod
{
    if (self = [super init]) {
        
        NSMutableURLRequest *req;
        
        if ([HTTP_METHOD_GET isEqualToString:httpMethod]) {
            
            NSString *paramUrlEncodeString = createParamEncodeStringWithParamDictioanry(paramDictioanry);
            NSString *completeUrl = [NSString stringWithFormat:@"%@?%@",
                                     url,
                                     paramUrlEncodeString];
            
            req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:completeUrl]
                                          cachePolicy:cachePolicy
                                      timeoutInterval:timeoutInterval];
        } else {
            
            NSString *paramUrlEncodeString = createParamEncodeStringWithParamDictioanry(paramDictioanry);
            if (!paramUrlEncodeString)
                paramUrlEncodeString = @"";
            
            NSURL *reqUrl = [NSURL URLWithString:url];
            req = [NSMutableURLRequest requestWithURL:reqUrl cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
            
            [req addValue: [NSString stringWithFormat:@"%d", (int)paramUrlEncodeString.length] forHTTPHeaderField:@"Content-Length"];
            
            [req setHTTPBody: [paramUrlEncodeString dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [req addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setHTTPMethod:httpMethod];
        
        self.apiRequest = req;
        
        _url = url;
        
        _paramDictioanry = paramDictioanry;
        _httpMethod = httpMethod;
    }
    
    return self;
}

@end
