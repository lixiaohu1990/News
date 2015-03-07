//
//  LvJsonResultApiRequest.h
//  CommunityDemo
//
//  Created by guangbo on 14/12/5.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import "LvJsonResultHTTPURLRequest.h"

typedef void(^ERROR_RESULT_HANDLER)(void);
typedef void(^CORRECT_RESULT_HANDLER)(id);
typedef id(^CORRECT_RESULT_PARSER)(id);

/**
 *  返回json结果的api结果处理类
 */
@interface JsonResultApiRequestResult : NSObject

// 请求回的数据
@property (nonatomic, strong) id result;

// 网络不可用处理
@property (nonatomic, strong) ERROR_RESULT_HANDLER networkUnavaliableHandler;

// 服务端出现异常处理
@property (nonatomic, strong) ERROR_RESULT_HANDLER serverErrorHandler;

/**
 *  错误码处理字典, key是错误码，value是ERROR_RESULT_HANDLER类型的handler
 */
@property (nonatomic, strong) NSDictionary *apiErrorHandlerMap;

// 正确结果处理
@property (nonatomic, strong) CORRECT_RESULT_HANDLER correctResultHandler;

/**
 *  正确结果解析器
 */
@property (nonatomic, strong) CORRECT_RESULT_PARSER corretResultParser;

- (instancetype)    initResult:(id)result
     networkUnavaliableHandler:(ERROR_RESULT_HANDLER)networkUnavaliableHandler
            serverErrorHandler:(ERROR_RESULT_HANDLER)serverErrorHandler
            apiErrorHandlerMap:(NSDictionary *)apiErrorHandlerMap
          correctResultHandler:(CORRECT_RESULT_HANDLER)correctResultHandler
            corretResultParser:(CORRECT_RESULT_PARSER)corretResultParser;

/**
 *  处理结果，结果可能是NSDictionary, NSArray, NSNumber 
 *
 *  @param  待处理的结果
 */
- (void)handleResult:(id)result;

@end



@interface LvJsonResultApiRequest : LvJsonResultHTTPURLRequest

/**
 *  api请求结果处理代理, 对于继承自LvAPIHTTPRequest的请求，只需要设置APIRequestResultHandlerDelegate，
 *  而不要再设置父类的requestResultHandlerDelegate
 */
@property (nonatomic, weak) id<LvHTTPURLRequestDelegate> APIRequestResultHandlerDelegate;

#pragma mark - BEGIN：下面的方法根据需要，在子类中实现
/**
 *  api 请求完后，该block方法对请求返回成功结果进行解析，解析成子类指定类型的结果
 */
- (CORRECT_RESULT_PARSER)apiCorrectResultParser;

/**
 *  把需要处理的错误码以及handler注册到该字典中，假如子类重写该方法，需要调用[super APIRequestErrorResultHandlerMap],
 *  然后子类继续在该基础上添加新的key-value
 *
 *  @return 错误码处理字典
 */
- (NSMutableDictionary *)apiErrorResultHandlerMap;

/**
 *  处理请求返回的结果，在子类中实现
 */
- (void)handleRequetResult:(JsonResultApiRequestResult *)requestResult;

#pragma mark - END

@end
