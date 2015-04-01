//
//  UIColor+lv.m
//  CommunityDemo
//
//  Created by guangbo on 14/11/21.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import "UIColor+lv.h"

@implementation UIColor (lv)

+ (UIColor *)colorFromRGB:(int)rgbValue
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0
                           alpha:1.0];
}

@end
