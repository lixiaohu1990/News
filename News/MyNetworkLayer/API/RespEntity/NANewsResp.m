//
//  NANewsResp.m
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NANewsResp.h"
#import "NSObject+ClassFilter.h"

@class NAVideo;
@implementation NANewsResp

- (instancetype)initWithRespDictionay:(NSDictionary *)respDictionay
{
    if (self = [super initWithRespDictionay:respDictionay]) {
        self.name = [respDictionay[@"name"] objectIsKindOfClass:[NSString class]];
        self.nsDescription = [respDictionay[@"description"] objectIsKindOfClass:[NSString class]];
        self.releaseDate = ((NSNumber *)[respDictionay[@"releaseDate"]objectIsKindOfClass:[NSNumber class]]).longLongValue;
        self.imageUrl = [respDictionay[@"imageUrl"] objectIsKindOfClass:[NSString class]];
        self.videoUrl = [respDictionay[@"videoUrl"] objectIsKindOfClass:[NSString class]];
        self.flowId = [respDictionay[@"flowId"] objectIsKindOfClass:[NSString class]];
        self.favoriteFlag = [respDictionay[@"favoriteFlag"] objectIsKindOfClass:[NSString class]];
        self.commentCount = ((NSNumber *)[respDictionay[@"commentCount"] objectIsKindOfClass:[NSNumber class]]).intValue;
        
        NSArray *imageUrlObjectList = [respDictionay[@"imageList"] objectIsKindOfClass:[NSArray class]];
        NSMutableArray *imageUrls = [NSMutableArray array];
        for (NSDictionary *imageUrlObject in imageUrlObjectList) {
            NSString *imageUrl = imageUrlObject[@"imageUrl"];
            if (imageUrl && [imageUrl isKindOfClass:[NSString class]]) {
                [imageUrls addObject:imageUrl];
            }
        }
        self.imageList = imageUrls;
        
        self.tag = [respDictionay[@"tag"] objectIsKindOfClass:[NSString class]];
        self.author = [respDictionay[@"author"] objectIsKindOfClass:[NSString class]];
        
        NSArray *videoList = [respDictionay[@"videoList"] objectIsKindOfClass:[NSArray class]];
        NSMutableArray *videos = [NSMutableArray array];
        for (NSDictionary *videoObj in videoList) {
            NAVideo *video = [[NAVideo alloc]initWithDictionary:videoObj];
            if (video) {
                [videos addObject:video];
            }
        }
        self.videoList = videos;
    }
    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"{name:%@, nsDescription:%@, imageUrl:%@, vedioUrl:%@, commentCount:%d}", self.name, self.nsDescription, self.imageUrl, self.videoUrl, self.commentCount];
}

@end

@implementation NAVideo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.vDescription = [dictionary[@"description"] objectIsKindOfClass:[NSString class]];
        self.videoUrl = [dictionary[@"videoUrl"] objectIsKindOfClass:[NSString class]];
        self.name = [dictionary[@"name"] objectIsKindOfClass:[NSString class]];
        self.number = [(NSNumber *)[dictionary[@"number"] objectIsKindOfClass:[NSNumber class]] intValue];
    }
    return self;
}

@end
