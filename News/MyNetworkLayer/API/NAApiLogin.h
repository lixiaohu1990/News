//
//  NAApiLogin.h
//  NewsAgencyDemo
//
//  Created by guangbo on 15/3/4.
//
//

#import "NAUrlEncodeParamApi.h"

/**
 *  登录
 *  没有需要关心的正确返回值
 */
@interface NAApiLogin : NAUrlEncodeParamApi

@property (nonatomic, readonly) NSString *username;
@property (nonatomic, readonly) NSString *password;

- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password;

@end
