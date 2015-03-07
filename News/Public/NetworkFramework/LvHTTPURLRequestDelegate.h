//
//  LvHTTPURLRequestDelegate.h
//  CommunityDemo
//
//  Created by guangbo on 14/12/11.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LvHTTPURLRequestDelegate <NSObject>

/**
 *  处理网络不可用情况
 */
@optional
- (void)failCauseNetworkUnavaliable:(id)request;

/**
 *  处理请求超时
 */
@optional
- (void)failCauseRequestTimeout:(id)request;

/**
 *  处理服务端异常情况
 */
@optional
- (void)failCauseServerError:(id)request;

/**
 *  处理正确结果
 */
@optional
- (void)request:(id)request successRequestWithResult:(id)requestResult;

@end
