//
//  BigEventDetailTableViewController.h
//  News
//
//  Created by 李小虎 on 15/3/13.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NANewsResp.h"

@interface BigEventDetailTableViewController : UITableViewController
@property(nonatomic, readonly) NANewsResp *news;
- (instancetype)initWithEventStyle:(BigEventDetailStyle)eventStyle news:(NANewsResp *)news listType:(ListType)listType;
@end
