//
//  LvPostMultiFormDataApiRequestObject.m
//  CommunityDemo
//
//  Created by guangbo on 14/12/5.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import "LvPostMultiFormDataApiRequestObject.h"

@implementation LvPostMultiFormDataApiRequestObject

- (instancetype)initWithUrl:(NSString *)url
                       name:(NSString *)name
                   fileName:(NSString *)fileName
                       data:(NSData *)data
{
    return [self initWithCachePolicy:NSURLRequestUseProtocolCachePolicy
                     timeoutInterval:DEFAULT_REQUEST_TIMEOUT
                                 url:url
                                name:name
                            fileName:fileName
                                data:data];
}

- (instancetype)initWithCachePolicy:(NSURLRequestCachePolicy)cachePolicy
                    timeoutInterval:(NSTimeInterval)timeoutInterval
                                url:(NSString *)url
                               name:(NSString *)name
                           fileName:(NSString *)fileName
                               data:(NSData *)data
{
    if (self = [super init]) {
        
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:cachePolicy
                                                       timeoutInterval:timeoutInterval];
        
        [req setHTTPMethod:HTTP_METHOD_POST];
        
        NSString *boundary = @"---------------------------toy1024";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [req addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        //The file to upload
        NSMutableData *postData = [NSMutableData data];
        [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, fileName]dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[NSData dataWithData:data]];
        
        // close the form
        [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [req setHTTPBody:postData];
        
        self.apiRequest = req;
    }
    
    return self;
}

@end
