//
//  NAApiGetComment.m
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAApiGetComment.h"

@implementation NAApiGetComment

- (instancetype)initWithItemId:(int)itemId
{
    if (self = [super initWithApiMethod:@"getComment"
                        paramDictioanry:@{@"id":@(itemId)}
                             httpMethod:HTTP_METHOD_POST]) {
        _itemId = itemId;
    }
    return self;
}

- (CORRECT_RESULT_PARSER)apiCorrectResultParser
{
    return ^ NACommentResp* (NSDictionary *jsonResult) {
        return [[NACommentResp alloc]initWithRespDictionay:jsonResult];
    };
}

@end
