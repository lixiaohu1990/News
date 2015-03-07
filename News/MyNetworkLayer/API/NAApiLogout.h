//
//  NAApiLogout.h
//  NewsAgencyDemo
//
//  Created by guangbo on 15/3/4.
//
//

#import "NAUrlEncodeParamApi.h"

@protocol NAApiLogoutResultHandlerDelegate <NABaseApiResultHandlerDelegate>

// 处理session过期
- (void)failCauseSessionInvalid:(id)apiRequest;

@end

/**
 *  退出
 *  没有需要关心的正确返回值
 */
@interface NAApiLogout : NAUrlEncodeParamApi

@end
