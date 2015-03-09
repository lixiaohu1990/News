//
//  NAApiRespBaseEntity.h
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAApiRespBaseEntity : NSObject

@property (nonatomic) NSString *status;
@property (nonatomic) NSString *memo;
@property (nonatomic) int itemId;

- (instancetype)initWithRespDictionay:(NSDictionary *)respDictionay;

@end
