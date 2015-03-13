//
//  NSObject+ClassFilter.m
//  PrismDemo
//
//  Created by 彭光波 on 15-3-12.
//  Copyright (c) 2015年 pengguangbo. All rights reserved.
//

#import "NSObject+ClassFilter.h"

@implementation NSObject (ClassFilter)

- (id)objectIsKindOfClass:(Class)clazz
{
    if (!clazz) {
        return nil;
    }
    if ([self isKindOfClass:clazz]) {
        return self;
    }
    return nil;
}

@end
