//
//  NABaseApi.h
//  NewsAgencyDemo
//
//  Created by guangbo on 15/3/4.
//
//

#import "LvJsonResultApiRequest.h"

@protocol NABaseApiResultHandlerDelegate <LvHTTPURLRequestDelegate>

// 参数错误处理
@optional
- (void)failCauseParamError:(id)apiRequest;

// 业务错误处理
@optional
- (void)failCauseBissnessError:(id)apiRequest;

// 系统错误处理
@optional
- (void)failCauseSystemError:(id)apiRequest;

@end

// api返回的状态信息
@interface NAApiResponseStatus : NSObject
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *memo;
@end


@interface NABaseApi : LvJsonResultApiRequest

// 返回状态信息
@property (nonatomic, readonly) NAApiResponseStatus *respStatus;

#pragma mark - Override handleRequetResult: method

- (void)handleRequetResult:(JsonResultApiRequestResult *)requestResult;

#pragma mark - Override apiErrorResultHandlerMap method

- (NSMutableDictionary *)apiErrorResultHandlerMap;

@end
