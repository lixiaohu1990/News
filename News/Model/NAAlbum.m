//
//  NAAlbum.m
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAAlbum.h"

@implementation NAAlbum

- (instancetype)initWithItemid:(int)itemId version:(NSString *)version createdBy:(int)createdBy createdDate:(int)createdDate lastModifiedBy:(int)lastModifiedBy lastModifiedDate:(int)lastModifiedDate isNew:(BOOL)isNew name:(NSString *)name count:(int)count
{
    if (self = [super initWithItemid:itemId version:version createdBy:createdBy createdDate:createdDate lastModifiedBy:lastModifiedBy lastModifiedDate:lastModifiedDate isNew:isNew]) {
        self.name = name;
        self.count = count;
    }
    return self;
}

- (instancetype)initWithApiRespDictionary:(NSDictionary *)apiRespDictionay
{
    if (self = [super initWithApiRespDictionary:apiRespDictionay]) {
        self.name = apiRespDictionay[@"name"];
        self.count = ((NSNumber *)apiRespDictionay[@"count"]).intValue;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{name:%@, count:%d}", self.name, self.count];
}

@end
