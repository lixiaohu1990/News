//
//  NAAlbum.h
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NABaseModel.h"

@interface NAAlbum : NABaseModel

@property (nonatomic) NSString *name;
@property (nonatomic) int count;
@property (nonatomic) BOOL isNew;

- (instancetype)initWithItemid:(int)itemId version:(NSString *)version createdBy:(int)createdBy createdDate:(int)createdDate lastModifiedBy:(int)lastModifiedBy lastModifiedDate:(int)lastModifiedDate isNew:(BOOL)isNew name:(NSString *)name count:(int)count;

@end
