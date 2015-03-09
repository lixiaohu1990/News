//
//  NAMulPrismResp.m
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAMulPrismResp.h"

@implementation NAMulPrismResp

- (instancetype)initWithRespDictionay:(NSDictionary *)respDictionay
{
    if (self = [super initWithRespDictionay:respDictionay]) {
        self.name = respDictionay[@"name"];
        self.url = respDictionay[@"url"];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{name:%@, url:%@}", self.name, self.url];
}

@end
