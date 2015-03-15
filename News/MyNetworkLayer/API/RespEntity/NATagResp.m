//
//  NATagResp.m
//  News
//
//  Created by 李小虎 on 15/3/14.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NATagResp.h"

@implementation NATagResp
- (instancetype)initWithRespDictionay:(NSDictionary *)respDictionay
{
    if (self = [super initWithRespDictionay:respDictionay]) {
        self.tag = respDictionay[@"name"];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{tag:%@}", self.tag];
}
@end
