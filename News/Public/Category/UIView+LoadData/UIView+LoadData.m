//
//  UIView+LoadData.m
//  CommunityDemo
//
//  Created by guangbo on 14/12/9.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import "UIView+LoadData.h"

@implementation UIView (LoadData)

- (void)willLoadData
{
    LvLoadingView *loadIndicatorView = (LvLoadingView *)[self viewWithTag:ViewLoadIndicatorTag];
    if (!loadIndicatorView) {
        loadIndicatorView = [[LvLoadingView alloc]initWithFrame:self.bounds];
        loadIndicatorView.tag = ViewLoadIndicatorTag;
        loadIndicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [self addSubview:loadIndicatorView];
    }
    loadIndicatorView.loading = YES;
    loadIndicatorView.text = NSLocalizedStringFromTable(@"loading", @"UIView+LoadData", nil);
    [self bringSubviewToFront:loadIndicatorView];
}

- (void)finishLoadData
{
    LvLoadingView *loadIndicatorView = (LvLoadingView *)[self viewWithTag:ViewLoadIndicatorTag];
    if (loadIndicatorView) {
        loadIndicatorView.loading = NO;
        loadIndicatorView.text = nil;
        [loadIndicatorView removeFromSuperview];
    }
}

@end
