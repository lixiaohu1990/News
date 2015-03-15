//
//  NAApiSaveComment.m
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAApiSaveComment.h"

@implementation NAApiSaveComment

- (instancetype)initWithText:(NSString *)text nsId:(NSInteger)nsId{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:@(userId) forKey:@"userId"];
//    [params setObject:@"1" forKey:@"userId"];
    if (text) {
        [params setObject:text forKey:@"text"];
    }
    if (nsId) {
        [params setObject:@(nsId) forKey:@"newsId"];
    }
//    [params setObject:@(nsId) forKey:@"newsId"];
//    [params setObject:@"1" forKey:@"newsId"];
//    if (type) {
//        [params setObject:type forKey:@"type"];
//    }
    if (self = [super initWithApiMethod:@"publishComment" paramDictioanry:params httpMethod:HTTP_METHOD_POST]) {
//        _userId = userId;
        _text = text;
        _nsId = nsId;
//        _type = type;
    }
    return self;
}

@end
