//
//  VitamioPlayerView.m
//  News
//
//  Created by 彭光波 on 15-4-7.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "VitamioPlayerView.h"

NSString *const VPVCPlayerItemDidPlayToEndTimeNotification = @"VPVCPlayerItemDidPlayToEndTimeNotification";

NSString *const VPVCPlayerItemReadyToPlayNotification = @"VPVCPlayerItemReadyToPlayNotification";

static VitamioPlayerView *instance;

@implementation VitamioPlayerView

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VitamioPlayerView alloc]initWithFrame:CGRectZero];
    });
    return instance;
}

+ (void)destoryInstance
{
    [instance.player reset];
    [instance.player unSetupPlayer];
    
    instance = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _player = [VMediaPlayer sharedInstance];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _player = [VMediaPlayer sharedInstance];
    }
    return self;
}

@end
