//
//  BaseTableViewController.m
//  News
//
//  Created by 李小虎 on 15/3/2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "BaseTableViewController.h"
@interface BaseTableViewController ()

@end
@implementation BaseTableViewController

- (void)loadView{
    [super loadView];
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64-44) style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor grayColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 100)];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 110;
//}
@end
