//
//  UIBarButtonItem+lv.h
//  GalaToy
//
//  Created by guangbo on 14/11/24.
//  Copyright (c) 2014年 Galasmart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (lv)

+ (UIBarButtonItem *)createBarButtonItemWithNormalImage:(UIImage *)normalImage
                                         highlightImage:(UIImage *)highlightImage
                                                 target:(id)target
                                                 action:(SEL)action;

@end
