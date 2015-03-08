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
    cbPlayerController = [[CyberPlayerController alloc] initWithContentURL:url];
    //设置视频显示的位置
    [cbPlayerController.view setFrame: self.view.frame];
    //将视频显示view添加到当前view中
    [self.view addSubview:cbPlayerController.view];
    cbPlayerController.shouldAutoplay = YES;
    [cbPlayerController prepareToPlay];
//    cbPlayerController.dolbyEnabled = YES;
    //注册监听，当播放器完成视频的初始化后会发送CyberPlayerLoadDidPreparedNotification通知，
    //此时naturalSize/videoHeight/videoWidth/duration等属性有效。

    [super viewDidLoad];
//    sliderProgress.continuous = true;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
