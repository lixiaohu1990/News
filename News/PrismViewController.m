//
//  PrismViewController.m
//  News
//
//  Created by 李小虎 on 15/3/2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "PrismViewController.h"

@interface PrismViewController ()
{
    int _currentPage;
}
@end
@implementation PrismViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupRefresh];
}

- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在拼命加载中,请稍候...";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在拼命加载中,请稍候...";
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self getItemListConnection];
    [self.tableView headerEndRefreshing];
}

- (void)footerRereshing
{
    [self pullUpgetItemListConnection];
    [self.tableView footerEndRefreshing];
}
- (void)pullUpgetItemListConnection{
    _currentPage++;
    [self GetNewsList];
}

- (void)getItemListConnection{
    _currentPage = PAGENO;
    [self GetNewsList];
    
}

- (void)GetNewsList
{
//    self.getNewsListReq = [[NAApiGetNewsList alloc]initWithType:1 pageNo:_currentPage pageSize:PAGESIZE];
//    self.getNewsListReq.APIRequestResultHandlerDelegate = self;
//    [self.getNewsListReq asyncRequest];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 205;
    }else if(indexPath.row == 4){
        return 44;
    }else{
        return 75;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"NewsFilmDetailTableViewCell";
    //    static NSString *cellIdentifier2 = @"BigEventTableViewCell2";
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"PrismTableViewCell" owner:nil options:nil][0];
        
        return cell;
        
    }else if(indexPath.row == 1){
        UITableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"PrismTableViewCell" owner:nil options:nil][1];
        
        return cell;
    }else if(indexPath.row ==2){
        UITableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"PrismTableViewCell" owner:nil options:nil][2];
        
        return cell;
        
    }else if (indexPath.row == 3){
        UITableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"PrismTableViewCell" owner:nil options:nil][3];
        
        return cell;
        
    }else{
        UITableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"PrismTableViewCell" owner:nil options:nil][4];
        
        return cell;
    }
    
}


@end
