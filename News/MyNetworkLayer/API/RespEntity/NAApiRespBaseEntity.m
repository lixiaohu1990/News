//
//  NAApiRespBaseEntity.m
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAApiRespBaseEntity.h"

@implementation NAApiRespBaseEntity

- (instancetype)initWithStatus:(NSString *)status
                          memo:(NSString *)memo
                        itemId:(int)itemId
{
    if (self = [super init]) {
        self.status = status;
        self.memo = memo;
        self.itemId = itemId;
    }
    return self;
}

- (instancetype)initWithRespDictionay:(NSDictionary *)respDictionay
{
    return [self initWithStatus:respDictionay[@"status"]
                           memo:respDictionay[@"memo"] itemId:((NSNumber *)respDictionay[@"id"]).intValue];
}

@end
