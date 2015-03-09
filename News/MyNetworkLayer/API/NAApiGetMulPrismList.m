//
//  NAApiGetMulPrismList.m
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAApiGetMulPrismList.h"

@implementation NAApiGetMulPrismList

- (instancetype)initWithPage:(int)page rows:(int)rows
{
    NSDictionary *params = @{@"page":@(page), @"rows":@(rows)};
    if (self = [super initWithApiMethod:@"getMulPrismList"
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
        NSArray *listResults = jsonResult[@"mulPrismResps"];
        NSMutableArray *mulPrismResults = [NSMutableArray array];
        for (NSDictionary *mulPrismDictionay in listResults) {
            NAMulPrismResp *mulPrismResp = [[NAMulPrismResp alloc]initWithRespDictionay:mulPrismDictionay];
            if (mulPrismResp) {
                [mulPrismResults addObject:mulPrismResp];
            }
        }
        return mulPrismResults;
    };
}

@end
