//
//  VPVC.h
//  News
//
//  Created by 彭光波 on 15-4-7.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VitamioPlayerView.h"

/**
 *  VPVC播放上一个视频按钮click的通知
 */
extern NSString *const VPVCPreviousButtonClickNotifiction;

/**
 *  VPVC播放下一个视频按钮click的通知
 */
extern NSString *const VPVCNextButtonClickNotification;

/**
 *  VPVC页面后退按钮click的通知
 */
extern NSString *const VPVCNavgationBarBackButtonClickNotification;

/**
 *  视频播放VC全屏切换按钮点击通知
 */
extern NSString *const VPVCFullScreenSwitchButtonClickNotification;

@interface VPVC : UIViewController

@property (nonatomic, readonly) VitamioPlayerView *playerView;

- (void)setupVideoPlayerView:(VitamioPlayerView *)playerView;
- (void)removeVideoPlayerView;

/**
 *  更新全屏的图标
 */
- (void)updateFullScreenButtonImageForFullScreenState:(BOOL)fullScreenState;

@end
