//
//  UIScrollView+LoadData.h
//  CommunityDemo
//
//  Created by guangbo on 14/12/9.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LoadData.h"

@interface UIScrollView (LoadData)

/**
 *  调用了[super willLoadData],同时不让tableView滚动
 */
- (void)willLoadData;

/**
 *  调用了[super finishLoadData],同时让tableView滚动
 */
- (void)finishLoadData;

@end
