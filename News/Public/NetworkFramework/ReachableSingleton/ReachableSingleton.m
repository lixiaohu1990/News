//
//  ReachableSingleton.m
//  Reachability
//
//  Created by caigee on 14-6-26.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "ReachableSingleton.h"

static ReachableSingleton *_singleton = nil;

@implementation ReachableSingleton

+ (ReachableSingleton *) sharedInstance
{
    static dispatch_once_t token;
    dispatch_once(&token,^{
        _singleton = [[ReachableSingleton alloc]init];
    });
    return _singleton;
}

+ (void)destroyInstance
{
    _singleton = nil;
}

-(BOOL)isConnected
{
    if (self.currentStatus!=NotReachable) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)isConnectedByWifi
{
    if (self.currentStatus==ReachableViaWiFi) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)isConnectedByWwan
{
    if (self.currentStatus==ReachableViaWWAN) {
        return YES;
    }else{
        return NO;
    }
}

-(id)init
{
    self = [super init];
    
    if (self) {
        [self initCurrentNetWork];
    }
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kReachabilityChangedNotification
                                                  object:nil];
    
    [self.currentReachablity stopNotifier];
    _currentReachablity = nil;
}

// 第一次直接获取网络信息
-(void)initCurrentNetWork
{
    _currentReachablity = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    [self.currentReachablity startNotifier];
}

- (NetworkStatus)currentStatus
{
    return self.currentReachablity.currentReachabilityStatus;
}

- (void)reachabilityChanged:(NSNotification *)note
{
    [[NSNotificationCenter defaultCenter]postNotificationName:REACHABLE_CHANGED_NOTIFICATION object:nil];
}

@end
