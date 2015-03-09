//
//  NAApiRegister.h
//  NewsAgencyDemo
//
//  Created by guangbo on 15/3/4.
//
//

#import "NAUrlEncodeParamApi.h"

/**
 *  注册，没有需要关心的正确返回值
 */
@interface NAApiRegister : NAUrlEncodeParamApi

@property (nonatomic, readonly) NSString *validateCode;
@property (nonatomic, readonly) NSString *mobile;
@property (nonatomic, readonly) NSString *username;
@property (nonatomic, readonly) NSString *password;
@property (nonatomic, readonly) NSString *city;

- (instancetype)initWithValidateCode:(NSString *)validateCode
                              mobile:(NSString *)mobile
                            username:(NSString *)username
                            password:(NSString *)password
                                city:(NSString *)city;

@end
