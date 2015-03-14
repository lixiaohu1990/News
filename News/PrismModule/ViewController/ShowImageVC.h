//
//  ShowImageVC.h
//  PrismDemo
//
//  Created by 彭光波 on 15-3-14.
//  Copyright (c) 2015年 pengguangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowImageVC : UIViewController

#pragma mark - Init

- (instancetype)init;

- (instancetype)initFromStoryboard;

@property (nonatomic) NSArray *imageUrlList;

- (void)reloadData;

@end
