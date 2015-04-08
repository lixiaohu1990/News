//
//  VitamioPlayerView.m
//  News
//
//  Created by 彭光波 on 15-4-7.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "VitamioPlayerView.h"

NSString *const VitamioPlayerCurrentVideoDidPlayToEndTimeNotification = @"VitamioPlayerCurrentVideoDidPlayToEndTimeNotification";

/**
 *  预备播放的通知
 */
NSString *const VitamioPlayerPrepareToPlayNotification = @"VitamioPlayerPrepareToPlayNotification";

/**
 *  成功准备播放的通知
 */
NSString *const VitamioPlayerSucceedToReadyToPlayNotification = @"VitamioPlayerSucceedToReadyToPlayNotification";

/**
 *  失败准备播放的通知
 */
NSString *const VitamioPlayerFailToReadyToPlayNotification = @"VitamioPlayerFailToReadyToPlayNotification";

/**
 *  播放器将要
 */
NSString *const VitamioPlayerPrepareToSeekNotification = @"VitamioPlayerPrepareToSeekNotification";

/**
 *  成功定位的通知
 */
NSString *const VitamioPlayerSucceedToSeekNotification = @"VitamioPlayerSucceedToSeekNotification";

/**
 *  失败定位的通知
 */
NSString *const VitamioPlayerFailToSeekNotification = @"VitamioPlayerFailToSeekNotification";

/**
 *  播放的通知
 */
NSString *const VitamioPlayerDidPlayNotification = @"VitamioPlayerDidPlayNotification";

/**
 *  暂停的通知
 */
NSString *const VitamioPlayerDidPauseNotification = @"VitamioPlayerDidPauseNotification";

@interface VitamioPlayerView ()

// 单位：毫秒
@property (nonatomic) CGFloat currentVideoDuration;
@property (nonatomic) UIView *playerCanvasView;
@property (nonatomic) BOOL hasPreparedToPlay;
@property (nonatomic) BOOL playAfterPrepared;

@property (nonatomic) NSTimer *videoStatusPullTimer;

@property (nonatomic, readonly) VMediaPlayer *player;

@end

@implementation VitamioPlayerView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupVitamioPlayerView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupVitamioPlayerView];
    }
    return self;
}

- (void)unsetPlayer
{
    [self.player reset];
    [self.player unSetupPlayer];
}

- (void)setupVitamioPlayerView
{
    _player = [VMediaPlayer sharedInstance];
    
    [_player reset];
    [_player unSetupPlayer];
    
    BOOL result = [_player setupPlayerWithCarrierView:self withDelegate:self];
    
    DLOG(@"set result: %d", result);
    
    self.videoFillMode = VMVideoFillModeFit;
    
    NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    [def addObserver:self
            selector:@selector(applicationDidEnterForeground:)
                name:UIApplicationDidBecomeActiveNotification
              object:nil];
    [def addObserver:self
            selector:@selector(applicationDidEnterBackground:)
                name:UIApplicationWillResignActiveNotification
              object:nil];
}

- (void)dealloc
{
    [self unsetPlayer];
    
    NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    [def removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [def removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)setVideoFillMode:(emVMVideoFillMode)videoFillMode
{
    _videoFillMode = videoFillMode;
    [_player setVideoFillMode:videoFillMode];
}

- (CGFloat)videoDuration
{
    return self.currentVideoDuration;
}

- (CGFloat)videoCurrentPosition
{
    return [self.player getCurrentPosition];
}

- (BOOL)isPlaying
{
    return self.player.isPlaying;
}

- (void)preparePlayURL:(NSURL *)videoURL immediatelyPlay:(BOOL)immediatelyPlay
{
    if (!videoURL)
        return;
    
    [self.player reset];
    _videoURL = videoURL;
    self.playAfterPrepared = immediatelyPlay;
    if (self.player) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:VitamioPlayerPrepareToPlayNotification object:self];
        
        [self.player setDataSource:videoURL];
        [self.player prepareAsync];
    }
}

- (void)play
{
    self.playAfterPrepared = YES;
    if (self.hasPreparedToPlay) {
        if (!self.player.isPlaying) {
            [UIApplication sharedApplication].idleTimerDisabled = YES;
            [self.player start];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:VitamioPlayerDidPlayNotification object:self];
        }
    }
}

- (void)pause
{
    self.playAfterPrepared = NO;
    
    if (self.player.isPlaying) {
        [self.player pause];
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:VitamioPlayerDidPauseNotification object:self];
}

- (void)stop
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self pause];
    [self.player reset];
}

- (void)videoSeekToPosition:(CGFloat)position
{
    [[NSNotificationCenter defaultCenter]postNotificationName:VitamioPlayerPrepareToSeekNotification object:self];
    
    [self.player seekTo:position];
}


- (void)applicationDidEnterForeground:(NSNotification *)notification
{
    [_player setVideoShown:YES];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [_player setVideoShown:NO];
    [self pause];
}


#pragma mark - VMediaPlayerDelegate

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    DLOG(@"mediaPlayer:didPrepared");
    self.hasPreparedToPlay = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VitamioPlayerSucceedToReadyToPlayNotification object:self];
    
    self.currentVideoDuration = [player getDuration];
    if (self.playAfterPrepared) {
        [self play];
    }
}

- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    DLOG(@"playbackComplete");
    
    self.hasPreparedToPlay = NO;

    [[NSNotificationCenter defaultCenter] postNotificationName:VitamioPlayerCurrentVideoDidPlayToEndTimeNotification
                                                        object:self];
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
    DLOG(@"play failed");
    self.hasPreparedToPlay = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VitamioPlayerFailToReadyToPlayNotification
                                                        object:self];
}

#pragma mark VMediaPlayerDelegate Implement / Optional

- (void)mediaPlayer:(VMediaPlayer *)player setupManagerPreference:(id)arg
{
    player.decodingSchemeHint = VMDecodingSchemeSoftware;
    player.autoSwitchDecodingScheme = NO;
}

- (void)mediaPlayer:(VMediaPlayer *)player setupPlayerPreference:(id)arg
{
    // Set buffer size, default is 1024KB(1*1024*1024).
    //	[player setBufferSize:256*1024];
    [player setBufferSize:512*1024];
    //	[player setAdaptiveStream:YES];
    
    [player setVideoQuality:VMVideoQualityMedium];
    
    //    player.useCache = YES;
    //    [player setCacheDirectory:[self getCacheRootDirectory]];
}

- (void)mediaPlayer:(VMediaPlayer *)player seekComplete:(id)arg
{
    DLOG(@"seekComplete");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VitamioPlayerSucceedToSeekNotification object:self];
}

- (void)mediaPlayer:(VMediaPlayer *)player notSeekable:(id)arg
{
    DLOG(@"notSeekable");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VitamioPlayerFailToSeekNotification object:self];
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingStart:(id)arg
{
    DLOG(@"开始缓冲");
    
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingUpdate:(id)arg
{
    DLOG(@"缓冲变化");
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingEnd:(id)arg
{
    DLOG(@"结束缓冲");
}

- (void)mediaPlayer:(VMediaPlayer *)player downloadRate:(id)arg
{
    
}

- (void)mediaPlayer:(VMediaPlayer *)player videoTrackLagging:(id)arg
{
    // TODO:提示暂停一下
}

#pragma mark VMediaPlayerDelegate Implement / Cache

- (void)mediaPlayer:(VMediaPlayer *)player cacheNotAvailable:(id)arg
{
    DLOG(@"不能缓存");
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheStart:(id)arg
{
    DLOG(@"开始缓存");
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheUpdate:(id)arg
{
    DLOG(@"缓冲变化");
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheSpeed:(id)arg
{
    //	NSLog(@"NAL .... media cacheSpeed: %dKB/s", [(NSNumber *)arg intValue]);
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheComplete:(id)arg
{
    NSLog(@"NAL .... media cacheComplete");
}

@end
