//
//  NANewsResp.m
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NANewsResp.h"

@implementation NANewsResp

- (instancetype)initWithRespDictionay:(NSDictionary *)respDictionay
{
    if (self = [super initWithRespDictionay:respDictionay]) {
        self.name = respDictionay[@"name"];
        self.nsDescription = respDictionay[@"description"];
        self.releaseDate = ((NSNumber *)respDictionay[@"releaseDate"]).intValue;
        self.imageUrl = respDictionay[@"imageUrl"];
        self.vedioUrl = respDictionay[@"vedioUrl"];
        self.flowId = respDictionay[@"flowId"];
        self.favoriteFlag = respDictionay[@"favoriteFlag"];
        self.commentCount = ((NSNumber *)respDictionay[@"commentCount"]).intValue;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{name:%@, nsDescription:%@, imageUrl:%@, vedioUrl:%@, commentCount:%d}", self.name, self.nsDescription, self.imageUrl, self.vedioUrl, self.commentCount];
}

@end
