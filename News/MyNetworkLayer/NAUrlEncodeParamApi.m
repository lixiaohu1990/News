//
//  NAUrlEncodeParamApi.m
//  NewsAgencyDemo
//
//  Created by guangbo on 15/3/4.
//
//

#import "NAUrlEncodeParamApi.h"
#import "NAApiConstants.h"

@implementation NAUrlEncodeParamApi

- (instancetype)initWithApiMethod:(NSString *)apiMethod
                  paramDictioanry:(NSDictionary *)paramDictionary
                       httpMethod:(NSString *)httpMethod
{
    NSString *url = [NSString stringWithFormat:@"%@?method=%@",
                     NAApiBaseUrl,
                     apiMethod];
    
    // 对于一些含有特殊字符的url需要处理下
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DLOG(@"--------------url***%@******", url);
    LvUrlEncodeParamApiRequestObject
    *reqObject = [[LvUrlEncodeParamApiRequestObject alloc]initWithUrl:url
                                                      paramDictioanry:paramDictionary
                                                           httpMethod:httpMethod];
    self = [super initWithURLRequest:reqObject.apiRequest];
    if (self) {
        _apiMethod = apiMethod;
        _paramDictionary = paramDictionary;
        _httpMethod = httpMethod;
    }
    return self;
}

@end
