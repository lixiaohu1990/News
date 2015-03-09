//
//  NAApiGetCommentList.m
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAApiGetCommentList.h"

@implementation NAApiGetCommentList

- (instancetype)initWithPage:(int)page rows:(int)rows
{
    NSDictionary *params = @{@"page":@(page), @"rows":@(rows)};
    if (self = [super initWithApiMethod:@"getCommentList"
                        paramDictioanry:params
                             httpMethod:HTTP_METHOD_POST]) {
        _page = page;
        _rows = rows;
    }
    return self;
}

#pragma mark - Override

- (CORRECT_RESULT_PARSER)apiCorrectResultParser
{
    return ^ NSArray* (NSDictionary *jsonResult) {
        NSArray *listResults = jsonResult[@"commentResps"];
        NSMutableArray *commResults = [NSMutableArray array];
        for (NSDictionary *commntDictionay in listResults) {
            NACommentResp *commResp = [[NACommentResp alloc]initWithRespDictionay:commntDictionay];
            if (commResp) {
                [commResults addObject:commResp];
            }
        }
        return commResults;
    };
}

@end
