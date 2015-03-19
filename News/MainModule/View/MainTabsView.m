//
//  MainTabsView.m
//  News
//
//  Created by 彭光波 on 15-3-19.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "MainTabsView.h"

@implementation MainTabsView

- (instancetype)initFromNib
{
    self = [[NSBundle mainBundle]loadNibNamed:@"MainTabsView" owner:nil options:nil][0];
    return self;
}

- (void)awakeFromNib
{
    [self setupMainTabsView];
}

- (void)setupMainTabsView
{
    self.backgroundColor = [UIColor clearColor];
    
    [self updateSelected:NO
            forTabButton:_newsFilmTabButn
       tabBackgroundView:_newsFilmTabBackgroundView];
    
    [self updateSelected:NO
            forTabButton:_bigEventTabButn
       tabBackgroundView:_bigEventTabBackgroundView];
    
    [self updateSelected:NO
            forTabButton:_prismTabButn
       tabBackgroundView:_prismTabBackgroundView];
}

- (void)updateSelected:(BOOL)selected
          forTabButton:(UIButton *)tabButton
     tabBackgroundView:(UIView *)tabBackgroundView
{
    if (selected) {
        tabButton.backgroundColor = [UIColor colorWithRed:80.f/255.f
                                                    green:201.f/255.f
                                                     blue:186.f/255.f
                                                    alpha:1];
        [tabButton setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateNormal];
        tabBackgroundView.backgroundColor = [UIColor blackColor];
    } else {
        tabBackgroundView.backgroundColor = [UIColor colorWithRed:80.f/255.f
                                                    green:201.f/255.f
                                                     blue:186.f/255.f
                                                    alpha:1];
        [tabButton setTitleColor:[UIColor blackColor]
                        forState:UIControlStateNormal];
        tabButton.backgroundColor = [UIColor whiteColor];
    }
}

@end
