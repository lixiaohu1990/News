//
//  UIAlertView+lv.m
//  CommunityDemo
//
//  Created by guangbo on 14/11/27.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import "UIAlertView+lv.h"

@implementation UIAlertView (lv)

+ (void)commonAlert:(NSString *)message
{
    [self commonAlertWithTitle:nil message:message actionButtonTitle:nil];
}

+ (void)commonAlertWithTitle:(NSString *)title message:(NSString *)message actionButtonTitle:(NSString *)actionButtonTitle
{
    NSString *buttonTitle = actionButtonTitle;
    if (!buttonTitle) {
        buttonTitle = @"OK";
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[[UIAlertView alloc]initWithTitle:title
                                   message:message
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:buttonTitle, nil]
         show];
    });
}

@end
