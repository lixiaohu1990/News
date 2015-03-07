//
//  LvJsonResultHTTPURLRequest.h
//  GalaToy
//
//  Created by 光波 彭 on 14-9-4.
//  Copyright (c) 2014年 Galasmart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LvHTTPURLRequest.h"

/**
 *  异步response数据格式为json的HTTP URL请求
 */
@interface LvJsonResultHTTPURLRequest : LvHTTPURLRequest

/**
 *  请求的json结果处理方法,子类需要重写此方法
 */
- (id(^)(id jsonRequestResult))jsonRequestResultParser;

@end
