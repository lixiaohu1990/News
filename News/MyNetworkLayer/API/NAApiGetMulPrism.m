//
//  NAApiGetMulPrism.m
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAApiGetMulPrism.h"

@implementation NAApiGetMulPrism

- (instancetype)initWithItemId:(int)itemId
{
    if (self = [super initWithApiMethod:@"getMulPrism"
                        paramDictioanry:@{@"id":@(itemId)}
                             httpMethod:HTTP_METHOD_POST]) {
        _itemId = itemId;
    }
    return self;
}

- (CORRECT_RESULT_PARSER)apiCorrectResultParser
{
    return ^ NAMulPrismResp* (NSDictionary *jsonResult) {
        return [[NAMulPrismResp alloc]initWithRespDictionay:jsonResult];
    };
}

@end
