//
//  NABaseModel.m
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NABaseModel.h"

@implementation NABaseModel

- (instancetype)initWithItemid:(int)itemId
                       version:(NSString *)version
                     createdBy:(int)createdBy
                   createdDate:(int)createdDate
                lastModifiedBy:(int)lastModifiedBy
              lastModifiedDate:(int)lastModifiedDate
                         isNew:(BOOL)isNew
{
    if (self  = [super init]) {
        self.itemId = itemId;
        self.version = version;
        self.createdBy = createdBy;
        self.createdDate = createdDate;
        self.lastModifiedBy = lastModifiedBy;
        self.lastModifiedDate = lastModifiedDate;
        self.isNew = isNew;
    }
    return self;
}

- (instancetype)initWithApiRespDictionary:(NSDictionary *)apiRespDictionay
{
    return [self initWithItemid:((NSNumber *)apiRespDictionay[@"id"]).intValue
                        version:apiRespDictionay[@"version"]
                      createdBy:((NSNumber *)apiRespDictionay[@"createdBy"]).intValue
                    createdDate:((NSNumber *)apiRespDictionay[@"createdDate"]).intValue
                 lastModifiedBy:((NSNumber *)apiRespDictionay[@"lastModifiedBy"]).intValue
               lastModifiedDate:((NSNumber *)apiRespDictionay[@"lastModifiedDate"]).intValue isNew:((NSNumber *)apiRespDictionay[@"new"]).boolValue];
}

@end
