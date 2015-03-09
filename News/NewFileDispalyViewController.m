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
//    [self configureVideo];
//    sliderProgress.continuous = true;

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self configureVideo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}
- (void)configureVideo{
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
    cbPlayerController.view.translatesAutoresizingMaskIntoConstraints = NO;
    //将视频显示view添加到当前view中
    [self.view addSubview:cbPlayerController.view];
//    CGRect frame = cell.frame;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:[UIImage imageNamed:@"back_icon01"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-30, 30, 30)];
    //    [startBtn setImage:[UIImage imageNamed:@"back_icon01"] forState:UIControlStateNormal];
    //    [startBtn setTitle:@"播放" forState:UIControlStateNormal];
    //    [startBtn setTitle:@"暂停" forState:UIControlStateSelected];
    //    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startBtn setImage:[UIImage imageNamed:@"36"] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *stopBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height-30, 30, 30)];
    [stopBtn setImage:[UIImage imageNamed:@"37"] forState:UIControlStateNormal];
    //    [stopBtn setTitle:@"停止" forState:UIControlStateNormal];
    //    [stopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [stopBtn setImage:[UIImage imageNamed:@"back_icon01"] forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
    
//    _remainsProgress = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-100, cell.frame.size.height-30, 100, 30)];
//    _remainsProgress.textColor = [UIColor whiteColor];
    [self.view addSubview:btn];
    [cbPlayerController.view addSubview:startBtn];
    [cbPlayerController.view addSubview:stopBtn];
//    [cbPlayerController.view addSubview:_remainsProgress];
    //    cbPlayerController.playbackState = CBPMovieScalingModeFill;
    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cbPlayerController.view
//                                                                 attribute:NSLayoutAttributeWidth
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:cell.contentView
//                                                                 attribute:NSLayoutAttributeWidth
//                                                                multiplier:1.0
//                                                                  constant:0]];//设置子视图的宽度和父视图的宽度相同
//    
//    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cbPlayerController.view
//                                                                 attribute:NSLayoutAttributeHeight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:cell.contentView
//                                                                 attribute:NSLayoutAttributeHeight
//                                                                multiplier:1.0
//                                                                  constant:0]];//设置子视图的高度是父视图高度的一半
    
    
    cbPlayerController.shouldAutoplay = YES;
    //    [cbPlayerController pause];
    [cbPlayerController prepareToPlay];
//    [self startTimer];
    
}

-(void)returnBack:(UIButton *)sender{
    //    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissModalViewControllerAnimated:YES];
}

-(void)start:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [cbPlayerController pause];
    }else{
        [cbPlayerController play];
    }
}

-(void)stop:(UIButton *)sender{
    
    [cbPlayerController stop];
    
}

@end
