//
//  NSObject+ClassFilter.h
//  PrismDemo
//
//  Created by 彭光波 on 15-3-12.
//  Copyright (c) 2015年 pengguangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ClassFilter)

/**
 *  判断某个对象是否是某个类的实例, 如果是返回自己，不是则返回nil
 */
- (id)objectIsKindOfClass:(Class)clazz;

@end
