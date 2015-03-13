//
//  MoreView.h
//  News
//
//  Created by 李小虎 on 15/3/3.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoreView;

@protocol MoreViewDelegate <NSObject>
@optional
- (void)moreViewDidloginAction:(MoreView *)moreView;
- (void)moreViewDidsetAction:(MoreView *)moreView;
- (void)moreViewDidcollectAction:(MoreView *)moreView;
- (void)moreViewDidNextDevAction:(MoreView *)moreView;
@end
@interface MoreView : UIView
- (IBAction)loginAction:(id)sender;
- (IBAction)setAction:(id)sender;
- (IBAction)collectionAction:(id)sender;
- (IBAction)dissSelf:(id)sender;
- (IBAction)nextDev:(id)sender;
@property(nonatomic, weak)id<MoreViewDelegate>moreDelegate;
@end
