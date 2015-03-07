//
//  LvHTTPURLRequest.h
//  GalaToy
//
//  Created by 光波 彭 on 14-9-4.
//  Copyright (c) 2014年 Galasmart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LvLogTool.h"
#import "ReachableSingleton.h"
#import "LvHTTPURLRequestDelegate.h"

/**
 *  异步HTTP URL请求
 */
@interface LvHTTPURLRequest : NSObject <NSURLConnectionDataDelegate>
/**
 *  是否正在请求
 */
@property (nonatomic, readonly) BOOL isOnRequest;

@property (nonatomic, readonly, strong) NSURLRequest *URLRequest;

@property (nonatomic, weak) id<LvHTTPURLRequestDelegate> requestResultHandlerDelegate;

- (instancetype)initWithURLRequest:(NSURLRequest *)request;

/**
 *  异步请求方法
 */
- (void)asyncRequest;
/**
 *  停止异步请求
 */
- (void)cancelRequest;

/**
 *  请求结果处理方法,子类需要重写此方法
 */
- (id(^)(NSData *requestResult))requestResultParser;

@end

/**
 *  同步请求类别
 */
@interface LvHTTPURLRequest (Sync)
/**
 *  同步请求方法
 */
- (id)syncRequest;

@end


/**
 *  HTTP请求结果处理代理基类
 */
@interface BaseHTTPURLRequestResultHandlerProxy : NSObject

/**
 *  在处理之前进行的操作，根据handler方法名称进行hash, 格式:{HandlerName:void(^preHandler)(void)}
 */
@property (nonatomic, readonly) NSMutableDictionary *preHandlerMap;
/**
 *  在处理之后进行的操作，根据handler方法名称进行hash, 格式:{HandlerName:void(^postHandler)(void)}
 */
@property (nonatomic, readonly) NSMutableDictionary *postHandlerMap;
/**
 *  通用的前置处理方法，在所有处理方法处理前都会进行通用前置处理
 */
@property (nonatomic, strong) void(^generalPreHandler)(id object);
/**
 *  通用的后置处理方法，在所有处理方法处理之后都会进行通用后置处理
 */
@property (nonatomic, strong) void(^generalPostHandler)(id object);

/**
 *  在handler处理之前进行pre操作
 *
 *  @param handler
 */
- (void)doPreHandler:(SEL)handler withObject:(id)object;
/**
 *  在handler处理之后进行post操作
 *
 *  @param handler
 */
- (void)doPostHandler:(SEL)handler withObject:(id)object;

/**
 *  在所有handle之前进行pre操作
 *
 *  @param object
 */
- (void)doGeneralPreHandleWithObject:(id)object;
/**
 *  在所有handle之后进行post操作
 *
 *  @param object
 */
- (void)doGeneralPostHandleWithObject:(id)object;

- (void)doHandleErrorForRequest:(id)request withAction:(SEL)action;

/**
 *  处理请求返回网络异常
 *
 *  @param request api请求
 */
- (void)doHandleNetworkUnavaliableForAPIRequest:(id)request;

/**
 *  处理请求返回请求超时情况
 */
- (void)doHandleRequestTimeoutForAPIRequest:(id)request;

/**
 *  处理请求返回服务端出错
 *
 *  @param request api请求
 */
- (void)doHandleServerErrorForAPIRequest:(id)request;

/**
 *  处理请求返回正确数据
 *
 *  @param request       api请求
 *  @param requestResult api请求结果
 */
- (void)request:(id)request doHandleSuccessWithResult:(id)requestResult;

/**
 *  获得顾客（在子类中实现）
 *
 *  @return 顾客
 */
- (id<LvHTTPURLRequestDelegate>)customer;

/**
 *  获得代理（在子类中实现）
 *
 *  @return 代理
 */
- (id<LvHTTPURLRequestDelegate>)proxy;

@end


/**
 *  HTTP请求结果处理代理实现
 */
@interface HTTPURLRequestResultHandlerProxy : BaseHTTPURLRequestResultHandlerProxy <LvHTTPURLRequestDelegate>

@property (nonatomic, weak, readonly) id<LvHTTPURLRequestDelegate> customer;
@property (nonatomic, weak, readonly) id<LvHTTPURLRequestDelegate> proxy;

- (HTTPURLRequestResultHandlerProxy *)initWithCustomer:(id<LvHTTPURLRequestDelegate>)customer
                                                 proxy:(id<LvHTTPURLRequestDelegate>)proxy;

@end

