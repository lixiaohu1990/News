//
//  NAApiSaveComment.m
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAApiSaveComment.h"

@implementation NAApiSaveComment

- (instancetype)initWithUserId:(int)userId text:(NSString *)text nsId:(int)nsId type:(NSString *)type
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(userId) forKey:@"userId"];
    if (text) {
        [params setObject:text forKey:@"text"];
    }
    [params setObject:@(nsId) forKey:@"newsId"];
    if (type) {
        [params setObject:type forKey:@"type"];
    }
    if (self = [super initWithApiMethod:@"saveComment" paramDictioanry:params httpMethod:HTTP_METHOD_POST]) {
        _userId = userId;
        _text = text;
        _nsId = nsId;
        _type = type;
    }
    return self;
}

@end
