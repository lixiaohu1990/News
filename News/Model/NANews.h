//
//  NANews.h
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NABaseModel.h"
#import "NAAlbum.h"

@interface NANews : NABaseModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *nsDescription;
@property (nonatomic) NSString *releaseDate;
@property (nonatomic) NSString *flowId;
@property (nonatomic) NAAlbum *album;

- (instancetype)initWithItemid:(int)itemId version:(NSString *)version createdBy:(int)createdBy createdDate:(int)createdDate lastModifiedBy:(int)lastModifiedBy lastModifiedDate:(int)lastModifiedDate isNew:(BOOL)isNew name:(NSString *)name nsDescription:(NSString *)nsDescription releaseDate:(NSString *)releaseDate flowId:(NSString * )flowId album:(NAAlbum *)album;

@end
