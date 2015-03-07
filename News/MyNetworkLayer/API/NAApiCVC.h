//
//  NAApiCVC.h
//  NewsAgencyDemo
//
//  Created by guangbo on 15/3/4.
//
//

#import "NAUrlEncodeParamApi.h"

// 请求验证码, 返回NSString类型的结果
@interface NAApiCVC : NAUrlEncodeParamApi

@property (nonatomic, readonly) NSString *mobile;

- (instancetype)initWithMobile:(NSString *)mobile;

@end
