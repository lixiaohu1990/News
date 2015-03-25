//
//  UIBarButtonItem+lv.m
//  GalaToy
//
//  Created by guangbo on 14/11/24.
//  Copyright (c) 2014年 Galasmart. All rights reserved.
//

#import "UIBarButtonItem+lv.h"

@implementation UIBarButtonItem (lv)

+ (UIBarButtonItem *)createBarButtonItemWithNormalImage:(UIImage *)normalImage
                                         highlightImage:(UIImage *)highlightImage
                                                 target:(id)target
                                                 action:(SEL)action
{
    if (!normalImage && !highlightImage) {
#ifdef DEBUG
        NSLog(@"createBarButtonItem, normal image or highlitgh image cannot be null.");
#endif
        return nil;
    }
    
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *image = normalImage;
    if (!image)
        image = highlightImage;
    barButton.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    [barButton setImage:image forState:UIControlStateNormal];
    
    image = highlightImage;
    if (!image)
        image = normalImage;
    
    [barButton setImage:image forState:UIControlStateSelected];
    [barButton setImage:image forState:UIControlStateHighlighted];
    
    if (target && action) {
        [barButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [[UIBarButtonItem alloc]initWithCustomView:barButton];
}

@end
