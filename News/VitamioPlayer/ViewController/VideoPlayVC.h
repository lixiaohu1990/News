//
//  VideoPlayVC.h
//  LvDemos
//
//  Created by guangbo on 15/3/27.
//
//

#import <UIKit/UIKit.h>
#import "Vitamio.h"

/**
 *  VPVC播放上一个视频的通知
 */
extern NSString *const VPVCPlayPreviousVideoItemNotifiction;

/**
 *  VPVC播放下一个视频的通知
 */
extern NSString *const VPVCPlayNextVideoItemNotification;

/**
 *  VPVC页面关闭的通知
 */
extern NSString *const VPVCDismissNotification;

/**
 *  视频播放VC全屏切换按钮点击通知
 */
extern NSString *const VPVCFullScreenSwitchButtonClickNotification;

/**
 *  使用model方式弹出该播放器VC
 */
@interface VideoPlayVC : UIViewController

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

/**
 *  更新全屏的图标
 */
- (void)updateFullScreenButtonImageForFullScreenState:(BOOL)fullScreenState;

@end
