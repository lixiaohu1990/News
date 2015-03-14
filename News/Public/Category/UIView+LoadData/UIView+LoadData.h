//
//  UIView+LoadData.h
//  CommunityDemo
//
//  Created by guangbo on 14/12/9.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LvLoadingView.h"

static const int ViewLoadIndicatorTag = 189011;

@interface UIView (LoadData)

- (void)willLoadData;

- (void)finishLoadData;

@end
