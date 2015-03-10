//
//  NewsList.m
//  News
//
//  Created by 李小虎 on 15/3/9.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NewsList.h"
#define VIDEOURL @"http://115.29.248.18:8080/NewsAgency/file/"
@implementation NewsList
+ (instancetype)newsListWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        DLOG(@"%@",dict);
        self.title = dict[@"name"];
        self.imageUrl = dict[@"imageUrl"];
//        NSString *videoUrlM = [NSString stringWithFormat:@"%@%@", VIDEOURL, dict[@"vedioUrl"]];
//        self.videoUrl = videoUrlM;
    }
    return self;
}
@end
