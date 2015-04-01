//
//  UIColor+lv.h
//  CommunityDemo
//
//  Created by guangbo on 14/11/21.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (lv)

/**
 *  根据rgb值得到颜色
 *
 *  @param rgbValue rgb值
 *
 *  @return 颜色
 */
+ (UIColor *)colorFromRGB:(int)rgbValue;

@end
