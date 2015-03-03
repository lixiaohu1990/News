//
//  BaseTableViewController.m
//  News
//
//  Created by 李小虎 on 15/3/2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "BaseTableViewController.h"
@interface BaseTableViewController ()
@property(nonatomic, strong)UITableView *tableview;
@end
@implementation BaseTableViewController

- (void)loadView{
    [super loadView];
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

@end
