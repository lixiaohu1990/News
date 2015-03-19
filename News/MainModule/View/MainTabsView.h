//
//  MainTabsView.h
//  News
//
//  Created by 彭光波 on 15-3-19.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabsView : UIView

- (instancetype)initFromNib;

// 新闻片tab
@property (nonatomic, weak) IBOutlet UIView *newsFilmTabBackgroundView;
@property (nonatomic, weak) IBOutlet UIButton *newsFilmTabButn;

// 大事件tab
@property (nonatomic, weak) IBOutlet UIView *bigEventTabBackgroundView;
@property (nonatomic, weak) IBOutlet UIButton *bigEventTabButn;

// 多棱镜tab
@property (nonatomic, weak) IBOutlet UIView *prismTabBackgroundView;
@property (nonatomic, weak) IBOutlet UIButton *prismTabButn;

- (void)updateSelected:(BOOL)selected
          forTabButton:(UIButton *)tabButton
     tabBackgroundView:(UIView *)tabBackgroundView;

@end
