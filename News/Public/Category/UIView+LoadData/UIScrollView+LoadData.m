//
//  UIScrollView+LoadData.m
//  CommunityDemo
//
//  Created by guangbo on 14/12/9.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import "UIScrollView+LoadData.h"

@implementation UIScrollView (LoadData)

- (void)willLoadData
{
    [super willLoadData];
    self.scrollEnabled = NO;
}

- (void)finishLoadData
{
    [super finishLoadData];
    self.scrollEnabled = YES;
}

@end
