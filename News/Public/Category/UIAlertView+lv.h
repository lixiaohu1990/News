//
//  UIAlertView+lv.h
//  CommunityDemo
//
//  Created by guangbo on 14/11/27.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (lv)

+ (void)commonAlert:(NSString *)message;

+ (void)commonAlertWithTitle:(NSString *)title message:(NSString *)message actionButtonTitle:(NSString *)actionButtonTitle;

@end
