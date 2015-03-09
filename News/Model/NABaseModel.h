//
//  NABaseModel.h
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NABaseModel : NSObject

@property (nonatomic) int itemId;
@property (nonatomic) NSString *version;
@property (nonatomic) int createdBy;
@property (nonatomic) int createdDate;
@property (nonatomic) int lastModifiedBy;
@property (nonatomic) int lastModifiedDate;
@property (nonatomic) BOOL isNew;

- (instancetype)initWithItemid:(int)itemId
                       version:(NSString *)version
                     createdBy:(int)createdBy
                   createdDate:(int)createdDate
                lastModifiedBy:(int)lastModifiedBy
              lastModifiedDate:(int)lastModifiedDate
                         isNew:(BOOL)isNew;

- (instancetype)initWithApiRespDictionary:(NSDictionary *)apiRespDictionay;

@end
