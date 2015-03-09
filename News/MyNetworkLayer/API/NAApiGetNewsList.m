//
//  NAApiGetNewsList.m
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAApiGetNewsList.h"

@implementation NAApiGetNewsList

- (instancetype)initWithType:(int)type pageNo:(int)pageNo pageSize:(int)pageSize
{
    NSDictionary *params = @{@"type":@(type),
                             @"pageNo":@(pageNo),
                             @"pageSize":@(pageSize)};
    if (self = [super initWithApiMethod:@"getNewsList"
                        paramDictioanry:params
                             httpMethod:HTTP_METHOD_POST]) {
        _type = type;
        _pageNo = pageNo;
        _pageSize = pageSize;
    }
    return self;
}

- (CORRECT_RESULT_PARSER)apiCorrectResultParser
{
    return ^ NSArray* (NSDictionary *jsonResult){
        NSArray *nsResults = jsonResult[@"newsDetailList"];
        NSMutableArray *nsEntityResults = [NSMutableArray array];
        for (NSDictionary *nsDictionary in nsResults) {
            NANewsResp *nsResp = [[NANewsResp alloc]initWithRespDictionay:nsDictionary];
            if (nsResp) {
                [nsEntityResults addObject:nsResp];
            }
        }
        return nsEntityResults;
    };
}

@end
