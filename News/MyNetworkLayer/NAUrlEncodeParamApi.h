//
//  NAUrlEncodeParamApi.h
//  NewsAgencyDemo
//
//  Created by guangbo on 15/3/4.
//
//

#import "NABaseApi.h"
#import "LvUrlEncodeParamApiRequestObject.h"

@interface NAUrlEncodeParamApi : NABaseApi

@property (nonatomic, readonly) NSString *apiMethod;
@property (nonatomic, readonly) NSDictionary *paramDictionary;
@property (nonatomic, readonly) NSString *httpMethod;

- (instancetype)initWithApiMethod:(NSString *)apiMethod
                  paramDictioanry:(NSDictionary *)paramDictionary
                       httpMethod:(NSString *)httpMethod;

@end
