//
//  NewsFilmDetailVC.h
//  News
//
//  Created by 彭光波 on 15-4-2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NANewsResp.h"

@interface NewsFilmDetailVC : UITableViewController

@property (nonatomic, readonly) NANewsResp *news;

- (instancetype)initWithNews:(NANewsResp *)news;

@end
