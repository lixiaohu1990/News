//
//  LvPostJsonApiRequestObject.m
//  CommunityDemo
//
//  Created by guangbo on 14/12/5.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import "LvPostJsonApiRequestObject.h"

@implementation LvPostJsonApiRequestObject

- (instancetype)initWithUrl:(NSString *)url postJson:(NSString *)postJson
{
    return [self initWithCachePolicy:NSURLRequestUseProtocolCachePolicy
                     timeoutInterval:DEFAULT_REQUEST_TIMEOUT
                                 url:url
                            postJson:postJson];
}

- (instancetype)initWithCachePolicy:(NSURLRequestCachePolicy)cachePolicy
                    timeoutInterval:(NSTimeInterval)timeoutInterval
                                url:(NSString *)url
                           postJson:(NSString *)postJson
{
    if (self = [super init]) {
        
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
        
        [req setHTTPMethod:HTTP_METHOD_POST];
        [req addValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
        [req addValue: [NSString stringWithFormat:@"%d", (int)postJson.length] forHTTPHeaderField:@"Content-Length"];
        [req setHTTPBody:[postJson dataUsingEncoding:NSUTF8StringEncoding]];
        
        self.apiRequest = req;
        
        _postJson = postJson;
    }
    return self;
}

@end
