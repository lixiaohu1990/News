//
//  LvJsonResultHTTPURLRequest.m
//  GalaToy
//
//  Created by 光波 彭 on 14-9-4.
//  Copyright (c) 2014年 Galasmart. All rights reserved.
//

#import "LvJsonResultHTTPURLRequest.h"

@implementation LvJsonResultHTTPURLRequest

#pragma mark - Overrdie 
- (id(^)(NSData *))requestResultParser
{
    __weak LvJsonResultHTTPURLRequest *weakSelf = self;
    return ^id(NSData *requestResult){
        if (!requestResult)
            return nil;
        
        NSError *err = nil;
        id jsonResult = [NSJSONSerialization JSONObjectWithData:requestResult
                                                        options:kNilOptions
                                                          error:&err];
        if (err) {
            DLOG(@"LvJsonResultHTTPURLRequest, parse response error: %@", err.localizedDescription);
            return nil;
        }
        if (weakSelf.jsonRequestResultParser) {
            return weakSelf.jsonRequestResultParser(jsonResult);
        } else {
            return jsonResult;
        }
    };
}

- (id(^)(id jsonRequestResult))jsonRequestResultParser
{
    return nil;
}

@end
