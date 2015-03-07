//
//  LvPostMultiFormDataApiRequestObject.h
//  CommunityDemo
//
//  Created by guangbo on 14/12/5.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import "LvBaseApiRequestObject.h"

/**
 *  post multi form内容的请求实体
 */
@interface LvPostMultiFormDataApiRequestObject : LvBaseApiRequestObject

@property (nonatomic, strong, readonly) NSString *url;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *fileName;
@property (nonatomic, strong, readonly) NSData *data;

- (instancetype)initWithUrl:(NSString *)url
                       name:(NSString *)name
                   fileName:(NSString *)fileName
                       data:(NSData *)data;

- (instancetype)initWithCachePolicy:(NSURLRequestCachePolicy)cachePolicy
                    timeoutInterval:(NSTimeInterval)timeoutInterval
                                url:(NSString *)url
                               name:(NSString *)name
                           fileName:(NSString *)fileName
                               data:(NSData *)data;

@end
