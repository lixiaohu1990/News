//
//  LvLoadingView.h
//  CommunityDemo
//
//  Created by guangbo on 14/12/9.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+lv.h"

/**
 *  左侧是一个菊花，右边是一段文字的加载指示视图
 */
@interface LvLoadingView : UIView

@property (nonatomic) UIColor *textColor;
@property (nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (nonatomic) NSString *text;
@property (nonatomic) BOOL loading;

@end
