//
//  DDCityViewController.h
//  IYiMing
//
//  Created by lee on 14/12/2.
//  Copyright (c) 2014年 lee. All rights reserved.
//
#import "DDBaseTableViewController.h"

@protocol CityVcDelegate <NSObject>

@optional
- (void)didSelectedCity:(NSString *)city;

@end
@interface DDCityViewController : DDBaseTableViewController

//@property (nonatomic) DDCityOptionType type;
@property (nonatomic, weak)id <CityVcDelegate>myDelegate;
@end
