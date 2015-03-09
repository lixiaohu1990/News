//
//  NAApiGetNews.m
//  News
//
//  Created by 彭光波 on 15-3-9.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAApiGetNews.h"

@implementation NAApiGetNews

- (instancetype)initWithItemId:(int)itemId type:(int)type
{
    if (self = [super initWithApiMethod:@"getNews"
                        paramDictioanry:@{@"id":@(itemId),
                                          @"type":@(type)}
                             httpMethod:HTTP_METHOD_POST]) {
        _itemId = itemId;
        _type = type;
    }
    return self;
}

- (CORRECT_RESULT_PARSER)apiCorrectResultParser
{
    return ^ NANewsResp* (NSDictionary *jsonResult){
        return [[NANewsResp alloc]initWithRespDictionay:jsonResult];
    };
}

@end
