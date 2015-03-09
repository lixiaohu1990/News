//
//  NACommentResp.m
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NACommentResp.h"

@implementation NACommentResp

- (instancetype)initWithRespDictionay:(NSDictionary *)respDictionay
{
    if (self = [super initWithRespDictionay:respDictionay]) {
        self.user = [[NAUser alloc]initWithApiRespDictionary:respDictionay[@"user"]];
        self.text = respDictionay[@"text"];
        self.news = [[NANews alloc]initWithApiRespDictionary:respDictionay[@"news"]];
        self.type = respDictionay[@"type"];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{user:%@, text:%@, news:%@, type:%@}",
            self.user,
            self.text,
            self.news,
            self.type];
}

@end
