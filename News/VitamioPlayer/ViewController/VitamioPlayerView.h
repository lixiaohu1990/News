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
 *  当前播放的节目播放结束的通知
 */
extern NSString *const VitamioPlayerCurrentVideoDidPlayToEndTimeNotification;

/**
 *  预备播放的通知
 */
extern NSString *const VitamioPlayerPrepareToPlayNotification;

/**
 *  成功准备播放的通知
 */
extern NSString *const VitamioPlayerSucceedToReadyToPlayNotification;

/**
 *  失败准备播放的通知
 */
extern NSString *const VitamioPlayerFailToReadyToPlayNotification;

/**
 *  播放器将要
 */
extern NSString *const VitamioPlayerPrepareToSeekNotification;

/**
 *  成功定位的通知
 */
extern NSString *const VitamioPlayerSucceedToSeekNotification;

/**
 *  失败定位的通知
 */
extern NSString *const VitamioPlayerFailToSeekNotification;

/**
 *  播放的通知
 */
extern NSString *const VitamioPlayerDidPlayNotification;

/**
 *  暂停的通知
 */
extern NSString *const VitamioPlayerDidPauseNotification;

/**
 *  播放器视图
 */
@interface VitamioPlayerView : UIView <VMediaPlayerDelegate>

@property (nonatomic) emVMVideoFillMode videoFillMode;

- (void)unsetPlayer;

@property (nonatomic, readonly) NSURL *videoURL;

/**
 *  当前播放视频的时长，单位：毫秒
 */
@property (nonatomic, readonly) CGFloat videoDuration;

/**
 *  当前播放视频的进度位置，单位：毫秒
 */
@property (nonatomic, readonly) CGFloat videoCurrentPosition;

// 是否在播放
@property (nonatomic, readonly, getter=isPlaying) BOOL playing;

- (void)preparePlayURL:(NSURL *)videoURL immediatelyPlay:(BOOL)immediatelyPlay;
- (void)play;
- (void)pause;
- (void)stop;

/**
 *  视频到某个位置，单位：毫秒
 */
- (void)videoSeekToPosition:(CGFloat)position;

@end
