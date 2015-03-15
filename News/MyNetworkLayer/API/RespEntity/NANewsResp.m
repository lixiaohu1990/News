//
//  NANewsResp.m
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NANewsResp.h"
#import "NSObject+ClassFilter.h"

@implementation NANewsResp

- (instancetype)initWithRespDictionay:(NSDictionary *)respDictionay
{
    if (self = [super initWithRespDictionay:respDictionay]) {
        self.name = [respDictionay[@"name"] objectIsKindOfClass:[NSString class]];
        self.newsType = [respDictionay[@"type"] objectIsKindOfClass:[NSString class]];
        self.nsDescription = [respDictionay[@"description"] objectIsKindOfClass:[NSString class]];
        self.releaseDate = ((NSNumber *)[respDictionay[@"releaseDate"]objectIsKindOfClass:[NSNumber class]]).intValue;
        self.imageUrl = [respDictionay[@"imageUrl"] objectIsKindOfClass:[NSString class]];
        self.vedioUrl = [respDictionay[@"videoUrl"] objectIsKindOfClass:[NSString class]];
        self.flowId = [respDictionay[@"flowId"] objectIsKindOfClass:[NSString class]];
        self.favoriteFlag = [respDictionay[@"favoriteFlag"] objectIsKindOfClass:[NSString class]];
        self.commentCount = ((NSNumber *)[respDictionay[@"commnetCount"] objectIsKindOfClass:[NSNumber class]]).intValue;
        self.newsID = ((NSNumber *)[respDictionay[@"id"] objectIsKindOfClass:[NSNumber class]]).intValue;
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
    }
    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"{name:%@, nsDescription:%@, imageUrl:%@, vedioUrl:%@, commentCount:%d}", self.name, self.nsDescription, self.imageUrl, self.vedioUrl, self.commentCount];
}

@end
