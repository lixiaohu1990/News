//
//  LvPostJsonApiRequestObject.h
//  CommunityDemo
//
//  Created by guangbo on 14/12/5.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import "LvBaseApiRequestObject.h"

/**
 *  post json内容的请求实体
 */
@interface LvPostJsonApiRequestObject : LvBaseApiRequestObject

@property (nonatomic, strong, readonly) NSString *url;
@property (nonatomic, strong, readonly) NSString *postJson;

- (instancetype)initWithUrl:(NSString *)url postJson:(NSString *)postJson;
- (instancetype)initWithCachePolicy:(NSURLRequestCachePolicy)cachePolicy
                    timeoutInterval:(NSTimeInterval)timeoutInterval
                                url:(NSString *)url 
                           postJson:(NSString *)postJson;

@end
