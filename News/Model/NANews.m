//
//  NANews.m
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NANews.h"

@implementation NANews

- (instancetype)initWithItemid:(int)itemId version:(NSString *)version createdBy:(int)createdBy createdDate:(int)createdDate lastModifiedBy:(int)lastModifiedBy lastModifiedDate:(int)lastModifiedDate isNew:(BOOL)isNew name:(NSString *)name nsDescription:(NSString *)nsDescription releaseDate:(NSString *)releaseDate flowId:(NSString * )flowId album:(NAAlbum *)album
{
    if (self = [super initWithItemid:itemId version:version createdBy:createdBy createdDate:createdDate lastModifiedBy:lastModifiedBy lastModifiedDate:lastModifiedDate isNew:isNew]) {
        self.name = name;
        self.nsDescription = nsDescription;
        self.releaseDate =releaseDate;
        self.flowId = flowId;
        self.album = album;
    }
    return self;
}

- (instancetype)initWithApiRespDictionary:(NSDictionary *)apiRespDictionay
{
    if (self = [super initWithApiRespDictionary:apiRespDictionay]) {
        self.name = apiRespDictionay[@"name"];
        self.nsDescription = apiRespDictionay[@"description"];
        self.releaseDate = apiRespDictionay[@"releaseDate"];
        self.flowId = apiRespDictionay[@"flowId"];
        self.album = [[NAAlbum alloc]initWithApiRespDictionary:apiRespDictionay[@"album"]];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{name:%@, nsDescription:%@, album:%@, flowId:%@}",
            self.name,
            self.nsDescription,
            self.album,
            self.flowId];
}

@end
