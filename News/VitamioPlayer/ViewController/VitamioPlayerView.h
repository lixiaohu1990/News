//
//  VitamioPlayerView.h
//  News
//
//  Created by 彭光波 on 15-4-7.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vitamio.h"

/**
 *  VPVC里播放的节目播放结束的通知
 */
extern NSString *const VPVCPlayerItemDidPlayToEndTimeNotification;

/**
 *  准备好播放的通知
 */
extern NSString *const VPVCPlayerItemReadyToPlayNotification;

/**
 *  播放器视图
 */
@interface VitamioPlayerView : UIView

@property (nonatomic, readonly) VMediaPlayer *player;

+ (instancetype)shareInstance;

+ (void)destoryInstance;

@end
