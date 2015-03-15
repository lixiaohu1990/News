//
//  BigEventDetailTableViewController.h
//  News
//
//  Created by 李小虎 on 15/3/13.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigEventDetailTableViewController : UITableViewController
@property(nonatomic, assign)NSInteger newsID;
- (instancetype)initWithEventStyle:(BigEventDetailStyle)eventStyle newsId:(NSInteger)newsId videoPath:(NSString *)videoStr listType:(ListType)listType;
@end
