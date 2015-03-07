//
//  LvUrlEncodeParamApiRequestObject.h
//  CommunityDemo
//
//  Created by guangbo on 14/12/5.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import "LvBaseApiRequestObject.h"

/**
 *  以url encode方式请求的请求实体
 */
@interface LvUrlEncodeParamApiRequestObject : LvBaseApiRequestObject

@property (nonatomic, strong, readonly) NSString *url;
@property (nonatomic, strong, readonly) NSDictionary *paramDictioanry;
@property (nonatomic, strong, readonly) NSString *httpMethod;

- (instancetype)initWithUrl:(NSString *)url
            paramDictioanry:(NSDictionary *)paramDictioanry
                 httpMethod:(NSString *)httpMethod;

- (instancetype)initWithCachePolicy:(NSURLRequestCachePolicy)cachePolicy
                    timeoutInterval:(NSTimeInterval)timeoutInterval
                                url:(NSString *)url
                    paramDictioanry:(NSDictionary *)paramDictioanry
                         httpMethod:(NSString *)httpMethod;

@end
