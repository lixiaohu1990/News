//
//  VPVC.m
//  News
//
//  Created by 彭光波 on 15-4-7.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "VPVC.h"
#import "VPNavigationBar.h"
#import "VPPlayControlView.h"
#import "DurationFormat.h"
#import "LvDirectionPanControl.h"
#import "LvLogTool.h"
#import "VPFastSeekIndicator.h"
#import "VitamioPlayerView.h"

/**
 *  VPVC播放上一个视频按钮click的通知
 */
NSString *const VPVCPreviousButtonClickNotifiction = @"VPVCPreviousButtonClickNotifiction";

/**
 *  VPVC播放下一个视频按钮click的通知
 */
NSString *const VPVCNextButtonClickNotification = @"VPVCNextButtonClickNotification";

/**
 *  VPVC页面后退按钮click的通知
 */
NSString *const VPVCNavgationBarBackButtonClickNotification = @"VPVCNavgationBarBackButtonClickNotification";

/**
 *  视频播放VC全屏切换按钮点击通知
 */
NSString *const VPVCFullScreenSwitchButtonClickNotification = @"VPVCFullScreenSwitchButtonClickNotification";

// 每个像素快进货后退的秒数
static const CGFloat FastForwardSecondsPerPix = 0.5f;

// 显示播放进度条的最小长度
static const CGFloat ShowVideoProgressSliderMinWidth = 150.f;

@interface VPVC ()

{
    BOOL originalStatusBarHidden;
}

@property (nonatomic) NSTimer *videoStatusPullTimer;

@property (nonatomic) UIActivityIndicatorView *loadPlayIndicator;

@property (nonatomic) VPNavigationBar *vpNavBar;
@property (nonatomic) VPPlayControlView *playControlV;

// 响应手势操作的view
@property (nonatomic) LvDirectionPanControl *gestureOperateView;
@property (nonatomic) VPFastSeekIndicator *seekIndicator;
@property (nonatomic) CGFloat touchDownVideoPlayTime;
@property (nonatomic) CGFloat waitingFastSeekToTime;

/**
 *  视频进度条是否在触碰
 */
@property (nonatomic) BOOL videoProgressSliderOnTouched;

@end

@implementation VPVC

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

    [self addObserverPlayerNotifications];
    
    [self resetPlayControlView];
    [self showPlayerNavAndControlPanelWithDismissDelay:-1.f];
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
    
    [self removeObserverPlayerNotifications];
    
    [self.videoStatusPullTimer invalidate];
}

- (void)addObserverPlayerNotifications
{
    NSNotificationCenter *nf = [NSNotificationCenter defaultCenter];
    [nf addObserver:self selector:@selector(recvPlayerCurrentVideoPlayEndedNote:) name:VitamioPlayerCurrentVideoDidPlayToEndTimeNotification object:nil];
    [nf addObserver:self selector:@selector(recvPlayerDidPauseNote:) name:VitamioPlayerDidPauseNotification object:nil];
    [nf addObserver:self selector:@selector(recvPlayerDidPlayNote:) name:VitamioPlayerDidPlayNotification object:nil];
    [nf addObserver:self selector:@selector(recvPlayerFailToReadyToPlayNote:) name:VitamioPlayerFailToReadyToPlayNotification object:nil];
    [nf addObserver:self selector:@selector(recvPlayerFailToSeekNote:) name:VitamioPlayerFailToSeekNotification object:nil];
    [nf addObserver:self selector:@selector(recvPlayerPrepareToPlayNote:) name:VitamioPlayerPrepareToPlayNotification object:nil];
    [nf addObserver:self selector:@selector(recvPlayerPrepareToSeekNote:) name:VitamioPlayerPrepareToSeekNotification object:nil];
    [nf addObserver:self selector:@selector(recvPlayerSucceedToReadyToPlayNote:) name:VitamioPlayerSucceedToReadyToPlayNotification object:nil];
    [nf addObserver:self selector:@selector(recvPlayerSucceedToSeekNote:) name:VitamioPlayerSucceedToSeekNotification object:nil];
}


- (void)removeObserverPlayerNotifications
{
    NSNotificationCenter *nf = [NSNotificationCenter defaultCenter];
    [nf removeObserver:self name:VitamioPlayerCurrentVideoDidPlayToEndTimeNotification object:nil];
    [nf removeObserver:self name:VitamioPlayerDidPauseNotification object:nil];
    [nf removeObserver:self name:VitamioPlayerDidPlayNotification object:nil];
    [nf removeObserver:self name:VitamioPlayerFailToReadyToPlayNotification object:nil];
    [nf removeObserver:self name:VitamioPlayerFailToSeekNotification object:nil];
    [nf removeObserver:self name:VitamioPlayerPrepareToPlayNotification object:nil];
    [nf removeObserver:self name:VitamioPlayerPrepareToSeekNotification object:nil];
    [nf removeObserver:self name:VitamioPlayerSucceedToReadyToPlayNotification object:nil];
    [nf removeObserver:self name:VitamioPlayerSucceedToSeekNotification object:nil];
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

#pragma mark - Override

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma mark = Notfications

- (void)recvPlayerCurrentVideoPlayEndedNote:(NSNotification *)note
{
    if (![_playerView isEqual:note.object]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.videoStatusPullTimer invalidate];
        [self resetPlayControlView];
        [self showPlayerNavAndControlPanelWithDismissDelay:5.f];
    });
}

- (void)recvPlayerDidPauseNote:(NSNotification *)note
{
    if (![_playerView isEqual:note.object]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.videoStatusPullTimer invalidate];
        [self.playControlV.playPauseButn setImage:[self videoPlayImage]
                                         forState:UIControlStateNormal];
    });
}

- (void)recvPlayerDidPlayNote:(NSNotification *)note
{
    if (![_playerView isEqual:note.object]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playControlV.playPauseButn setImage:[self videoPauseImage]
                                         forState:UIControlStateNormal];
        
        [self.videoStatusPullTimer invalidate];
        self.videoStatusPullTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/3 target:self selector:@selector(pulledVideoStatus:) userInfo:nil repeats:YES];
    });
}

- (void)recvPlayerFailToReadyToPlayNote:(NSNotification *)note
{
    if (![_playerView isEqual:note.object]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadPlayIndicator stopAnimating];
        [self showPlayerNavAndControlPanelWithDismissDelay:-1.f];
    });
}

- (void)recvPlayerFailToSeekNote:(NSNotification *)note
{
    if (![_playerView isEqual:note.object]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadPlayIndicator stopAnimating];
    });
}

- (void)recvPlayerPrepareToPlayNote:(NSNotification *)note
{
    if (![_playerView isEqual:note.object]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadPlayIndicator startAnimating];
    });
}

- (void)recvPlayerPrepareToSeekNote:(NSNotification *)note
{
    if (![_playerView isEqual:note.object]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadPlayIndicator startAnimating];
    });
}

- (void)recvPlayerSucceedToReadyToPlayNote:(NSNotification *)note
{
    if (![_playerView isEqual:note.object]) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadPlayIndicator stopAnimating];
        [self dismissPlayerNavAndControlPanel];
        [self.playControlV.playPauseButn setImage:[self videoPauseImage]
                                         forState:UIControlStateNormal];
        
        self.playControlV.progressSlider.value = 0;
        self.playControlV.playProgressLabel.text = [DurationFormat durationTextForDuration:0];
        self.playControlV.remainTimeLabel.text = [DurationFormat durationTextForDuration:_playerView.videoDuration/1000.f];
    });
}

- (void)recvPlayerSucceedToSeekNote:(NSNotification *)note
{
    if (![_playerView isEqual:note.object]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadPlayIndicator stopAnimating];
    });
}

#pragma mark - Private methods

- (void)pulledVideoStatus:(NSTimer *)timer
{
    if (self.videoProgressSliderOnTouched)
        return;
    
    if (_playerView.videoDuration > 0) {
        self.playControlV.progressSlider.value = _playerView.videoCurrentPosition/_playerView.videoDuration;
        self.playControlV.playProgressLabel.text = [DurationFormat durationTextForDuration:_playerView.videoCurrentPosition/1000.f];
        self.playControlV.remainTimeLabel.text = [DurationFormat durationTextForDuration:(_playerView.videoDuration - _playerView.videoCurrentPosition)/1000.f];
    }
}

#pragma mark - Setup methods

- (void)setupVideoPlayerView:(VitamioPlayerView *)playerView
{
    if (!playerView)
        return;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[self.view subviews] containsObject:playerView]) {
            [_playerView removeFromSuperview];
            
            _playerView = playerView;
            
            playerView.frame = self.view.bounds;
            playerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
            
            [self.view insertSubview:playerView atIndex:0];
            
            // 更新界面状态
            if (playerView.isPlaying) {
                [self.playControlV.playPauseButn setImage:[self videoPauseImage]
                                                 forState:UIControlStateNormal];
                
                [self.videoStatusPullTimer invalidate];
                self.videoStatusPullTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/3 target:self selector:@selector(pulledVideoStatus:) userInfo:nil repeats:YES];
            } else {
                [self.playControlV.playPauseButn setImage:[self videoPlayImage]
                                                 forState:UIControlStateNormal];
            }
            
            if (_playerView.videoDuration > 0) {
                self.playControlV.progressSlider.value = _playerView.videoCurrentPosition/_playerView.videoDuration;
                self.playControlV.playProgressLabel.text = [DurationFormat durationTextForDuration:_playerView.videoCurrentPosition/1000.f];
                self.playControlV.remainTimeLabel.text = [DurationFormat durationTextForDuration:(_playerView.videoDuration - _playerView.videoCurrentPosition)/1000.f];
            } else {
                self.playControlV.progressSlider.value = 0;
                self.playControlV.playProgressLabel.text = [DurationFormat durationTextForDuration:0];
                self.playControlV.remainTimeLabel.text = [DurationFormat durationTextForDuration:0];
            }
        }
    });
}

- (void)removeVideoPlayerView
{
    if (_playerView) {
        [_playerView removeFromSuperview];
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
                               action:@selector(clickNavBackButton:)
                     forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setupPlayerControlView
{
    if (!_playControlV) {
        // 设置play control
        _playControlV = [[VPPlayControlView alloc]initFromNib];
        _playControlV.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        CGFloat playCtrlHeight = 80.f;
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
        
        // 设置全屏切换按钮事件
        [_playControlV.fullScreenSwithButn addTarget:self
                                              action:@selector(fullScreenSwithButnClick:)
                                    forControlEvents:UIControlEventTouchUpInside];
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

- (void)clickNavBackButton:(UIButton *)butn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:VPVCNavgationBarBackButtonClickNotification
                                                        object:self];
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
    if (_playerView.isPlaying) {
        [_playerView pause];
    } else {
        [_playerView play];
    }
}

// 上一个视频点击事件
- (void)previousButnClick:(UIButton *)butn
{
    [[NSNotificationCenter defaultCenter]postNotificationName:VPVCPreviousButtonClickNotifiction object:self];
}

// 下一个视频按钮点击事件
- (void)nextButnClick:(UIButton *)butn
{
    [[NSNotificationCenter defaultCenter]postNotificationName:VPVCNextButtonClickNotification object:self];
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
}


- (void)fullScreenSwithButnClick:(UIButton *)butn
{
    [[NSNotificationCenter defaultCenter]postNotificationName:VPVCFullScreenSwitchButtonClickNotification object:self];
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
    
    emVMVideoFillMode fillMode = [_playerView videoFillMode];
    if (fillMode == VMVideoFillModeFit) {
        [_playerView setVideoFillMode:VMVideoFillModeStretch];
    } else {
        [_playerView setVideoFillMode:VMVideoFillModeFit];
    }
}

- (void)directionPanTouchDown:(LvDirectionPanControl *)panControl
{
    self.touchDownVideoPlayTime = [_playerView videoCurrentPosition];
}

- (void)directionPanTouchUp:(LvDirectionPanControl *)panControl
{
    if (!self.seekIndicator.hidden) {
        self.seekIndicator.hidden = YES;
    }
    self.touchDownVideoPlayTime = 0;
    
    if (panControl.panDirection == LvPanDirectionHorizon) {
        if (self.waitingFastSeekToTime >= 0) {
            [_playerView videoSeekToPosition:self.waitingFastSeekToTime];
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
        
        CGFloat videoDuration = _playerView.videoDuration;
        if (videoDuration > 0) {
            CGFloat seekTime = panDistance * FastForwardSecondsPerPix * 1000.f + self.touchDownVideoPlayTime;
            if (seekTime > videoDuration) {
                seekTime = videoDuration;
            } else if (seekTime < 0) {
                seekTime = 0;
            }
            seekIndicator.seekTimeText = [NSString stringWithFormat:@"%@/%@",
                                          [DurationFormat durationTextForDuration:seekTime/1000.f],
                                          [DurationFormat durationTextForDuration:videoDuration/1000.f]];
            self.waitingFastSeekToTime = seekTime/1000.f;
        } else {
            self.waitingFastSeekToTime = -1;
        }
        return;
    }
}

- (void)updateFullScreenButtonImageForFullScreenState:(BOOL)fullScreenState
{
    UIImage *img = nil;
    if (fullScreenState) {
        img = [UIImage imageNamed:@"vp_exit_fullscreen"];
    } else {
        img = [UIImage imageNamed:@"vp_turn_fullscreen"];
    }
    [self.playControlV.fullScreenSwithButn setImage:img forState:UIControlStateNormal];
    [self.playControlV.fullScreenSwithButn setImage:img forState:UIControlStateHighlighted];
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
        __weak VPVC *weakSelf = self;
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
    __weak VPVC *weakSelf = self;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.vpNavBar.alpha = 0;
        weakSelf.playControlV.alpha = 0;
    } completion:^(BOOL finished){
        [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    }];
}

@end
