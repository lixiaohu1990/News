//
//  NAApiError.h
//  NewsAgencyDemo
//
//  Created by guangbo on 15/3/4.
//
//

/**
    ##定义错误信息的详细描述
 
    000=调用成功
    111=业务异常
    112=登录失败次数过多
    113=Seesion过期，需重新登陆
    114=Sign无效
    115=参数错误
    999=系统错误
 
 */
static NSString *const NAApiRequestSuccess = @"000";
static NSString *const NAApiBusinessErr = @"111";
static NSString *const NAApiLoginTooMuch = @"112";
static NSString *const NAApiSessionExpires = @"113";
static NSString *const NAApiSignInvalid = @"114";
static NSString *const NAApiParamErr = @"115";
static NSString *const NAApiSystemErr = @"999";