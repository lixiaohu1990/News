//
//  MoreVC.m
//  News
//
//  Created by 彭光波 on 15-3-19.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "MoreVC.h"

@interface MoreVC ()

@end

@implementation MoreVC

- (instancetype)initFromStoryboard
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainModule" bundle:nil];
    self = [board instantiateViewControllerWithIdentifier:@"MoreVC"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
