//
//  LvBaseApiRequestObject.h
//  CommunityDemo
//
//  Created by guangbo on 14/12/5.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  根据字典构建k1=v1&k2=v2形式的字符串
 *
 *  @param paramDictioanry 字典
 *
 *  @return 字符串
 */
static inline NSString* createParamEncodeStringWithParamDictioanry(NSDictionary *paramDictioanry)
{
    NSMutableString *paramEncodeString = [NSMutableString string];
    for (int i = 0; i < paramDictioanry.count; i++) {
        NSString *key = [paramDictioanry.allKeys objectAtIndex:i];
        NSString *value = [paramDictioanry objectForKey:key];
        [paramEncodeString appendFormat:@"%@=%@", key, value];
        if (i != (paramDictioanry.count - 1)) {
            [paramEncodeString appendString:@"&"];
        }
    }
    return paramEncodeString;
}


static NSString *const HTTP_METHOD_GET = @"GET";
static NSString *const HTTP_METHOD_POST = @"POST";
static const int DEFAULT_REQUEST_TIMEOUT = 30;


/**
 *  基础api请求类
 */
@interface LvBaseApiRequestObject : NSObject

@property (nonatomic, strong) NSURLRequest *apiRequest;

@end
