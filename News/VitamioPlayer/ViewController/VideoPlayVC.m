//
//  VideoPlayVC.m
//  LvDemos
//
//  Created by guangbo on 15/3/27.
//
//

#import "VideoPlayVC.h"
#import "Vitamio.h"
#import "VPNavigationBar.h"
#import "VPPlayControlView.h"
#import "DurationFormat.h"
#import "LvDirectionPanControl.h"
#import "LvLogTool.h"
#import "VPFastSeekIndicator.h"


NSString *const VPVCPlayerItemDidPlayToEndTimeNotification = @"VPVCPlayerItemDidPlayToEndTimeNotification";

NSString *const VPVCPlayerItemReadyToPlayNotification = @"VPVCPlayerItemReadyToPlayNotification";

NSString *const VPVCPlayPreviousVideoItemNotifiction = @"VPVCPlayPreviousVideoItemNotifiction";

NSString *const VPVCPlayNextVideoItemNotification = @"VPVCPlayNextVideoItemNotification";

NSString *const VPVCDismissNotification = @"VPVCDismissNotification";

NSString *const VPVCUpdateVibrationStrengthNotification = @"VPVCUpdateVibrationStrengthNotification";
NSString *const VPVCVibrationStrengthKey = @"VPVCVibrationStrength";

// 每个像素快进货后退的秒数
static CGFloat const FastForwardSecondsPerPix = 0.5f;

@interface VideoPlayVC () <VMediaPlayerDelegate>
{
    BOOL originalStatusBarHidden;
}

@property (nonatomic) VMediaPlayer *player;
@property (nonatomic) NSTimeInterval currentVideoDuration;
@property (nonatomic) UIView *playerCanvasView;
@property (nonatomic) BOOL hasPreparedToPlay;
@property (nonatomic) BOOL playAfterPrepared;

@property (nonatomic) NSTimer *videoStatusPullTimer;

@property (nonatomic) UIActivityIndicatorView *loadPlayIndicator;

@property (nonatomic) VPNavigationBar *vpNavBar;
@property (nonatomic) VPPlayControlView *playControlV;
// 临时画布设置值
@property (nonatomic) NSString *tempCanvasSettingValue;
// 临时按钮快进设置值
@property (nonatomic) NSString *tempButnFFSettingValue;

// 响应手势操作的view
@property (nonatomic) LvDirectionPanControl *gestureOperateView;
@property (nonatomic) VPFastSeekIndicator *seekIndicator;
@property (nonatomic) NSTimeInterval touchDownVideoPlayTime;
@property (nonatomic) NSTimeInterval waitingFastSeekToTime;
@property (nonatomic) CGFloat vibrationStrength;

/**
 *  视频进度条是否在触碰
 */
@property (nonatomic) BOOL videoProgressSliderOnTouched;

@end

@implementation VideoPlayVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPlayerAndCanvasView];
    
    [self setupGestureOperateView];
    
    [self setupVPNavBar];
    
    [self setupPlayerControlView];
    
    [self setupLoadPlayIndicator];
    
    [self setupSeekIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    originalStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    if (!originalStatusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES
                                                withAnimation:animated?UIStatusBarAnimationFade:UIStatusBarAnimationNone];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    [self resetPlayControlView];
    [self showPlayerNavAndControlPanelWithDismissDelay:-1.f];
    
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (!originalStatusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:animated?UIStatusBarAnimationFade:UIStatusBarAnimationNone];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
    NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    
    [def removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [def removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    
    [self.videoStatusPullTimer invalidate];
    self.playAfterPrepared = NO;
    self.hasPreparedToPlay = NO;
    
    [self.player pause];
    [self.player reset];
    [self.player unSetupPlayer];
}


#pragma mark - 屏幕方向控制

#ifdef __IPHONE_6_0
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
#endif

#ifndef __IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}
#endif

#ifdef __IPHONE_7_0
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
#endif


#pragma mark - Respond to the Remote Control Events

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlTogglePlayPause:
            if ([_player isPlaying]) {
                [_player pause];
            } else {
                [_player start];
            }
            break;
        case UIEventSubtypeRemoteControlPlay:
            [_player start];
            break;
        case UIEventSubtypeRemoteControlPause:
            [_player pause];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previousButnClick:self.playControlV.previousButn];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self nextButnClick:self.playControlV.nextButn];
            break;
        default:
            break;
    }
}

- (void)applicationDidEnterForeground:(NSNotification *)notification
{
    [_player setVideoShown:YES];
    if (![_player isPlaying]) {
        [_player start];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.playControlV.playPauseButn setImage:[self videoPauseImage]
                                             forState:UIControlStateNormal];
        });
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    if ([_player isPlaying]) {
        [_player pause];
        [_player setVideoShown:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.playControlV.playPauseButn setImage:[self videoPlayImage]
                                             forState:UIControlStateNormal];
        });
    }
}


#pragma mark - VMediaPlayerDelegate Implement

#pragma mark VMediaPlayerDelegate Implement / Required

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    DLOG(@"mediaPlayer:didPrepared");
    self.hasPreparedToPlay = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VPVCPlayerItemReadyToPlayNotification
                                                        object:self];
    
    self.currentVideoDuration = [player getDuration]/1000.f;
    if (self.playAfterPrepared) {
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        [self.player start];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadPlayIndicator stopAnimating];
            [self dismissPlayerNavAndControlPanel];
            [self.playControlV.playPauseButn setImage:[self videoPauseImage]
                                             forState:UIControlStateNormal];
            
            self.playControlV.progressSlider.value = 0;
            self.playControlV.playProgressLabel.text = [DurationFormat durationTextForDuration:0];
            self.playControlV.remainTimeLabel.text = [DurationFormat durationTextForDuration:self.currentVideoDuration];
            
            [self.videoStatusPullTimer invalidate];
            self.videoStatusPullTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/3
                                                                         target:self
                                                                       selector:@selector(pulledVideoStatus:)
                                                                       userInfo:nil
                                                                        repeats:YES];
        });
    }
}

- (void)pulledVideoStatus:(NSTimer *)timer
{
    if (self.videoProgressSliderOnTouched)
        return;
    
    if (self.currentVideoDuration > 0) {
        long currentPosition = [self.player getCurrentPosition]/1000.f;
        self.playControlV.progressSlider.value = (CGFloat)currentPosition/(CGFloat)self.currentVideoDuration;
        self.playControlV.playProgressLabel.text = [DurationFormat durationTextForDuration:currentPosition];
        self.playControlV.remainTimeLabel.text = [DurationFormat durationTextForDuration:(self.currentVideoDuration - currentPosition)];
    }
}

- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    DLOG(@"playbackComplete");
    
    self.hasPreparedToPlay = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.videoStatusPullTimer invalidate];
        [self resetPlayControlView];
        [self showPlayerNavAndControlPanelWithDismissDelay:5.f];
    });
    
    [self.player pause];
    [self.player seekTo:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VPVCPlayerItemDidPlayToEndTimeNotification
                                                        object:self];
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
    DLOG(@"play failed");
    self.hasPreparedToPlay = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadPlayIndicator stopAnimating];
        [self showPlayerNavAndControlPanelWithDismissDelay:-1.f];
    });
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadPlayIndicator stopAnimating];
    });
}

- (void)mediaPlayer:(VMediaPlayer *)player notSeekable:(id)arg
{
    DLOG(@"notSeekable");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadPlayIndicator stopAnimating];
    });
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

- (void)setupPlayerAndCanvasView
{
    if (!_playerCanvasView) {
        UIView *canvasV = [[UIView alloc]initWithFrame:self.view.bounds];
        canvasV.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:canvasV];
        _playerCanvasView = canvasV;
    }
    if (!_player) {
        _player = [VMediaPlayer sharedInstance];
        [_player setupPlayerWithCarrierView:self.playerCanvasView withDelegate:self];
    }
}

/**
 *  设置响应手势操作view，手势包括：1.single tap 显示导航栏河操作栏 2.double tap 切换视频画布模式 3.左拽回看 4.右拽向前 5.上拽增强振动强度 6.下拽减少震动强度
 */
- (void)setupGestureOperateView
{
    if (!_gestureOperateView) {
        _gestureOperateView = [[LvDirectionPanControl alloc]initWithFrame:self.view.bounds];
        _gestureOperateView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_gestureOperateView];
        
        _gestureOperateView.userInteractionEnabled = YES;
        
        // 添加单击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
        [_gestureOperateView addGestureRecognizer:singleTap];
        
        // 添加双击
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [_gestureOperateView addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        // 添加其他手势
        
        [_gestureOperateView addTarget:self action:@selector(directionPanTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_gestureOperateView addTarget:self action:@selector(directionPanTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [_gestureOperateView addTarget:self action:@selector(directionPanTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
        [_gestureOperateView addTarget:self action:@selector(directionPanValChanged:) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)setupVPNavBar
{
    if (!_vpNavBar) {
        // 设置nav
        _vpNavBar = [[VPNavigationBar alloc]initFromNib];
        _vpNavBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
        _vpNavBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44);
        [self.view addSubview:_vpNavBar];
        
        [_vpNavBar.backButn addTarget:self
                               action:@selector(dismissPlayer)
                     forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setupPlayerControlView
{
    if (!_playControlV) {
        // 设置play control
        _playControlV = [[VPPlayControlView alloc]initFromNib];
        _playControlV.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        CGFloat playCtrlHeight = 44;
        _playControlV.frame = CGRectMake(0,
                                         CGRectGetHeight(self.view.frame) - playCtrlHeight,
                                         CGRectGetWidth(self.view.frame),
                                         playCtrlHeight);
        [self.view addSubview:_playControlV];
        
        // 设置按钮事件
        [_playControlV.playPauseButn addTarget:self
                                        action:@selector(playPauseButnClick:)
                              forControlEvents:UIControlEventTouchUpInside];
        [_playControlV.previousButn addTarget:self
                                       action:@selector(previousButnClick:)
                             forControlEvents:UIControlEventTouchUpInside];
        [_playControlV.nextButn addTarget:self
                                   action:@selector(nextButnClick:)
                         forControlEvents:UIControlEventTouchUpInside];
        
        // 设置滑动条事件
        [_playControlV.progressSlider addTarget:self
                                         action:@selector(videoProgressChanged:)
                               forControlEvents:UIControlEventValueChanged];
        [_playControlV.progressSlider addTarget:self
                                         action:@selector(videoProgressDownTouched:)
                               forControlEvents:UIControlEventTouchDown];
        [_playControlV.progressSlider addTarget:self
                                         action:@selector(videoProgressUpTouched:)
                               forControlEvents:UIControlEventTouchUpInside];
        [_playControlV.progressSlider addTarget:self
                                         action:@selector(videoProgressUpTouched:)
                               forControlEvents:UIControlEventTouchUpOutside];
        [_playControlV.progressSlider addTarget:self
                                         action:@selector(videoProgressUpTouched:)
                               forControlEvents:UIControlEventTouchCancel];
    }
}

- (void)setupLoadPlayIndicator
{
    if (!_loadPlayIndicator) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.hidesWhenStopped = YES;
        indicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        indicator.center = self.view.center;
        
        [self.view addSubview:indicator];
        [indicator stopAnimating];
        _loadPlayIndicator = indicator;
    }
}


- (void)setupSeekIndicator
{
    if (!_seekIndicator) {
        VPFastSeekIndicator *indicator = [[VPFastSeekIndicator alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
        indicator.seekTimeText = @"--/--";
        indicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        indicator.center = self.view.center;
        indicator.hidden = YES;
        [self.view addSubview:indicator];
        _seekIndicator = indicator;
    }
}


#pragma mark - Button actions

- (void)dismissPlayer
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:VPVCDismissNotification
                                                            object:nil];
    }];
}


- (UIImage *)videoPauseImage
{
    static UIImage *pauseImg = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pauseImg = [UIImage imageNamed:@"vp_pause"];
    });
    return pauseImg;
}

- (UIImage *)videoPlayImage
{
    static UIImage *playImg = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playImg = [UIImage imageNamed:@"vp_play"];
    });
    return playImg;
}

- (void)playPauseButnClick:(UIButton *)butn
{
    if (!self.player.isPlaying) {
        [self play];
    } else {
        [self pause];
    }
}

// 上一个视频点击事件
- (void)previousButnClick:(UIButton *)butn
{
    
    [self.videoStatusPullTimer invalidate];
    [self pause];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:VPVCPlayPreviousVideoItemNotifiction object:self];
}

// 下一个视频按钮点击事件
- (void)nextButnClick:(UIButton *)butn
{
    [self.videoStatusPullTimer invalidate];
    [self pause];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:VPVCPlayNextVideoItemNotification object:self];
}

// 视频进度变化事件
- (void)videoProgressChanged:(LvNormalSlider *)progressSlider
{
    
}

- (void)videoProgressDownTouched:(LvNormalSlider *)progressSlider
{
    self.videoProgressSliderOnTouched = YES;
}

- (void)videoProgressUpTouched:(LvNormalSlider *)progressSlider
{
    self.videoProgressSliderOnTouched = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadPlayIndicator startAnimating];
    });
    [self.player seekTo:(long)(progressSlider.value * self.currentVideoDuration * 1000)];
}




#pragma mark - Gestures

- (void)singleTap:(UITapGestureRecognizer *)tap
{
    DLOG(@"single tap");
    // 显示或隐藏导航栏和操作栏
    if (self.vpNavBar.alpha == 0) {
        [self showPlayerNavAndControlPanelWithDismissDelay:5.f];
    } else {
        [self dismissPlayerNavAndControlPanel];
    }
    
    if (!self.seekIndicator.hidden) {
        self.seekIndicator.hidden = YES;
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tap
{
    // 切换画布模式
    DLOG(@"double tap");
    
    if ([self.player getVideoFillMode] == VMVideoFillModeFit) {
        [self.player setVideoFillMode:VMVideoFillModeStretch];
    } else {
        [self.player setVideoFillMode:VMVideoFillModeFit];
    }
}

- (void)directionPanTouchDown:(LvDirectionPanControl *)panControl
{
    self.touchDownVideoPlayTime = [self.player getCurrentPosition]/1000.f;
}

- (void)directionPanTouchUp:(LvDirectionPanControl *)panControl
{
    if (!self.seekIndicator.hidden) {
        self.seekIndicator.hidden = YES;
    }
    self.touchDownVideoPlayTime = 0;
    
    if (panControl.panDirection == LvPanDirectionHorizon) {
        if (self.waitingFastSeekToTime >= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loadPlayIndicator startAnimating];
            });
            [self.player seekTo:(long)(self.waitingFastSeekToTime * 1000)];
        }
    }
}

- (void)directionPanValChanged:(LvDirectionPanControl *)panControl
{
    if (panControl.panDirection == LvPanDirectionHorizon) {
        // horizon方向：前进或后退
        
        VPFastSeekIndicator *seekIndicator = self.seekIndicator;
        if (seekIndicator.hidden) {
            seekIndicator.hidden = NO;
        }
        
        // 拖拽距离
        CGFloat panDistance = panControl.currentTrackPoint.x - panControl.beiginTrackPoint.x;
        seekIndicator.fastForward = (panDistance >= 0);
        
        long videoDuration = self.currentVideoDuration;
        if (videoDuration > 0) {
            NSTimeInterval seekTime = panDistance * FastForwardSecondsPerPix + self.touchDownVideoPlayTime;
            if (seekTime > videoDuration) {
                seekTime = videoDuration;
            } else if (seekTime < 0) {
                seekTime = 0;
            }
            seekIndicator.seekTimeText = [NSString stringWithFormat:@"%@/%@",
                                          [DurationFormat durationTextForDuration:seekTime],
                                          [DurationFormat durationTextForDuration:videoDuration]];
            self.waitingFastSeekToTime = seekTime;
        } else {
            self.waitingFastSeekToTime = -1;
        }
        return;
    }
}


- (void)preparePlayURL:(NSURL *)videoURL immediatelyPlay:(BOOL)immediatelyPlay
{
    [self.player reset];
    _videoURL = videoURL;
    self.playAfterPrepared = immediatelyPlay;
    if (self.player) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self resetPlayControlView];
            [self.loadPlayIndicator startAnimating];
        });
        [self.player setDataSource:videoURL];
        [self.player prepareAsync];
    }
}

- (BOOL)isPlaying
{
    return self.player.isPlaying;
}

- (void)play
{
    self.playAfterPrepared = YES;
    if (self.hasPreparedToPlay) {
        if (!self.player.isPlaying) {
            [UIApplication sharedApplication].idleTimerDisabled = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.playControlV.playPauseButn setImage:[self videoPauseImage]
                                                 forState:UIControlStateNormal];
            });
            [self.player start];
        }
    }
}

- (void)stop
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self pause];
    [self.player reset];
}

- (void)pause
{
    self.playAfterPrepared = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playControlV.playPauseButn setImage:[self videoPlayImage]
                                         forState:UIControlStateNormal];
    });
    if (self.player.isPlaying) {
        [self.player pause];
    }
}

- (void)resetPlayControlView
{
    [_playControlV.playPauseButn setImage:[self videoPlayImage] forState:UIControlStateNormal];
    [_playControlV.progressSlider setValue:0.f];
    [_playControlV.playProgressLabel setText:[DurationFormat durationTextForDuration:0]];
    [_playControlV.remainTimeLabel setText:[DurationFormat durationTextForDuration:0]];
}

/**
 *  显示控件，过段时间隐藏
 *  @param dismissDelay 隐藏时间间隔，>0 时才有效
 */
- (void)showPlayerNavAndControlPanelWithDismissDelay:(NSTimeInterval)dismissDelay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(dismissPlayerNavAndControlPanel)
                                                   object:nil];
        __weak VideoPlayVC *weakSelf = self;
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakSelf.vpNavBar.alpha = 1;
            weakSelf.playControlV.alpha = 1;
        } completion:^(BOOL finished){
            [[UIApplication sharedApplication]endIgnoringInteractionEvents];
            if (dismissDelay > 0) {
                // 定时隐藏导航栏河操作栏
                [self performSelector:@selector(dismissPlayerNavAndControlPanel)
                           withObject:nil
                           afterDelay:dismissDelay];
            }
        }];
    });
}

- (void)dismissPlayerNavAndControlPanel
{
    __weak VideoPlayVC *weakSelf = self;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.vpNavBar.alpha = 0;
        weakSelf.playControlV.alpha = 0;
    } completion:^(BOOL finished){
        [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    }];
}

@end
