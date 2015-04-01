//
//  VideoPlayVC.h
//  LvDemos
//
//  Created by guangbo on 15/3/27.
//
//

#import <UIKit/UIKit.h>

/**
 *  VPVC里播放的节目播放结束的通知
 */
extern NSString *const VPVCPlayerItemDidPlayToEndTimeNotification;

/**
 *  准备好播放的通知
 */
extern NSString *const VPVCPlayerItemReadyToPlayNotification;

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
 *  变化了震动强度的通知，在通知的userInfo中使用VPVCVibrationStrengthKey获取类型为NSNumber的强度值, 介于0-1之间
 */
extern NSString *const VPVCUpdateVibrationStrengthNotification;
extern NSString *const VPVCVibrationStrengthKey;

@interface VideoPlayVC : UIViewController

@property (nonatomic, readonly) NSURL *videoURL;

// 是否在播放
@property (nonatomic, readonly, getter=isPlaying) BOOL playing;

- (void)preparePlayURL:(NSURL *)videoURL immediatelyPlay:(BOOL)immediatelyPlay;
- (void)play;
- (void)pause;
- (void)stop;

@end
