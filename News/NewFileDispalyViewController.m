//
//  NewFileDispalyViewController.m
//  News
//
//  Created by 李小虎 on 15/3/8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NewFileDispalyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CyberPlayerController.h"
@interface NewFileDispalyViewController ()
{
    NSString *videoFullPath;
    CyberPlayerController *cbPlayerController;
    NSTimer *timer;

}
@end

@implementation NewFileDispalyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频播放";
    videoFullPath = @"http://115.29.248.18:8080/NewsAgency/file/getVideo/3/1";
    NSURL *url = [NSURL URLWithString: videoFullPath];
    if (!url) {
        url = [NSURL URLWithString:[videoFullPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; }
    [cbPlayerController setContentURL: url];
    
    //请添加您百度开发者中心应用对应的APIKey和SecretKey。
    NSString* msAK=@"TwthXSKCmkGbR9DbYUriGmT7";
    NSString* msSK=@"irre7k4rzRjGqPnM";
    
    //添加开发者信息
    [[CyberPlayerController class ]setBAEAPIKey:msAK SecretKey:msSK ];
    //当前只支持CyberPlayerController的单实例
    cbPlayerController = [[CyberPlayerController alloc] init];
    //设置视频显示的位置
    [cbPlayerController.view setFrame: self.view.frame];
    //将视频显示view添加到当前view中
    [self.view addSubview:cbPlayerController.view];
    cbPlayerController.dolbyEnabled = YES;
    //注册监听，当播放器完成视频的初始化后会发送CyberPlayerLoadDidPreparedNotification通知，
    //此时naturalSize/videoHeight/videoWidth/duration等属性有效。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onpreparedListener:)
                                                 name: CyberPlayerLoadDidPreparedNotification
                                               object:nil];
    //注册监听，当播放器完成视频播放位置调整后会发送CyberPlayerSeekingDidFinishNotification通知，
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(seekComplete:)
                                                 name:CyberPlayerSeekingDidFinishNotification
                                               object:nil];
    //注册网速监听，在播放器播放过程中，没秒发送实时网速(单位：bps）CyberPlayerGotNetworkBitrateKbNotification通知。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showNetworkStatus:)
                                                 name:CyberPlayerGotNetworkBitrateNotification
                                               object:nil];
    
    [super viewDidLoad];
//    sliderProgress.continuous = true;
    [self startPlayback];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) onpreparedListener: (NSNotification*)aNotification
{
    //视频文件完成初始化，开始播放视频并启动刷新timer。
//    playButtonText.titleLabel.text = @"pause";
    [self startTimer];
}
- (void)seekComplete:(NSNotification*)notification
{
    //开始启动UI刷新
    [self startTimer];
}
- (void)startTimer{
    //为了保证UI刷新在主线程中完成。
    [self performSelectorOnMainThread:@selector(startTimeroOnMainThread) withObject:nil waitUntilDone:NO];
}
- (void)startTimeroOnMainThread{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
}
- (void)stopTimer{
    if ([timer isValid])
    {
        [timer invalidate];
    }
    timer = nil;
}

- (void)startPlayback{
    NSURL *url = [NSURL URLWithString:videoFullPath];
    if (!url)
    {
        url = [NSURL URLWithString:[videoFullPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    /*
     switch (mpPlayerController.playbackState) {
     case MPMoviePlaybackStateStopped:
     [mpPlayerController setContentURL:url];
     [mpPlayerController prepareToPlay];
     break;
     case MPMoviePlaybackStatePaused:
     [mpPlayerController play];
     break;
     case MPMoviePlaybackStatePlaying:
     [mpPlayerController pause];
     break;
     default:
     break;
     }
     */
    switch (cbPlayerController.playbackState) {
        case CBPMoviePlaybackStateStopped:
        case CBPMoviePlaybackStateInterrupted:
            [cbPlayerController setContentURL:url];
            //            [cbPlayerController setExtSubtitleFile:@"http://bcs.duapp.com/subtitle/34677636.srt?sign=MBO:2af85f6e5c42fbc804bd9eee337e652d:9rJd06c8jKHb63SKzdYp3PWQYe4%3D"];
            //            [cbPlayerController setExtSubtitleFile:@"http://10.10.10.254:80/data/UsbDisk1/Volume3/The.Big.Bang.Theory.S08E01.720p.HDTV.X264-DIMENSION.srt"];
            //[cbPlayerController setExtSubtitleFile:[self getTestFilePath]];
            //初始化完成后直接播放视频，不需要调用play方法
            cbPlayerController.shouldAutoplay = YES;
            //初始化视频文件
            [cbPlayerController prepareToPlay];
//            [playButtonText setTitle:@"pause" forState:UIControlStateNormal];
            break;
        case CBPMoviePlaybackStatePlaying:
            //如果当前正在播放视频时，暂停播放。
            [cbPlayerController pause];
//            [playButtonText setTitle:@"play" forState:UIControlStateNormal];
            break;
        case CBPMoviePlaybackStatePaused:
            //如果当前播放视频已经暂停，重新开始播放。
            [cbPlayerController start];
//            [playButtonText setTitle:@"pause" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
