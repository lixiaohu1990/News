//
//  ReachableSingleton.h
//  Reachability
//
//  Created by caigee on 14-6-26.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

#define REACHABLE_CHANGED_NOTIFICATION @"REACHABLE_CHANGED_NOTIFICATION"


@interface ReachableSingleton : NSObject

@property (nonatomic, readonly)Reachability *currentReachablity;
@property (nonatomic, readonly)NetworkStatus currentStatus;

/**
 *  拿到唯一实例
 */
+ (ReachableSingleton *) sharedInstance;

/**
 *  销毁实例
 */
+ (void)destroyInstance;

-(BOOL)isConnected;
-(BOOL)isConnectedByWifi;
-(BOOL)isConnectedByWwan;
@end
