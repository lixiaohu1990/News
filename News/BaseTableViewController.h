//
//  BaseTableViewController.h
//  News
//
//  Created by 李小虎 on 15/3/2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableview;
@end
