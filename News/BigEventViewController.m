//
//  BigEventViewController.m
//  News
//
//  Created by 李小虎 on 15/3/2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "BigEventViewController.h"
#import "BigEventTableViewCell.h"
#import "NAApiGetNewsList.h"
#import "BigEventTableViewCell.h"
#import "BigEventTableViewCell1.h"
#import "NANewsResp.h"
#import "NewsDetailTableViewController.h"
//#import "BigEventTextTableViewCell.h"
@interface BigEventViewController ()<NABaseApiResultHandlerDelegate>{
    int _currentPage;
}
@property(nonatomic, strong)NAApiGetNewsList *getNewsListReq;
@property(nonatomic, strong)NSMutableArray *listArray;
@end
@implementation BigEventViewController
- (void)viewDidLoad{
    self.tableView.backgroundColor = [UIColor grayColor];
//    self.tableView.rowHeight = 206;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSLog(@"%@", NSStringFromCGRect(self.tableView.frame));
    [self setupRefresh];
    [self GetNewsList];
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
    self.getNewsListReq = [[NAApiGetNewsList alloc]initWithType:2 pageNo:_currentPage pageSize:PAGESIZE];
    self.getNewsListReq.APIRequestResultHandlerDelegate = self;
    [self.getNewsListReq asyncRequest];
}
//- (void)getNewsList
//{
//    self.getNewsListReq = [[NAApiGetNewsList alloc]initWithType:2 pageNo:_currentPage pageSize:PAGESIZE];
//    self.getNewsListReq.APIRequestResultHandlerDelegate = self;
//    [self.getNewsListReq asyncRequest];
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NANewsResp *item = self.listArray[indexPath.row];
    if (!item.imageUrl) {
        return 206;
    }else{
        return 100;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NANewsResp *item = self.listArray[indexPath.row];
    if (!item.vedioUrl) {
        BigEventTableViewCell *cell = [BigEventTableViewCell cellWithTableview:tableView];
        cell.item = item;
        return cell;

    }else{
        if (!item.imageUrl) {
            BigEventTableViewCell1 *cell = [BigEventTableViewCell1 cellWithTableView:tableView];
            cell.item = item;
            return cell;
        }else{
            BigEventTableViewCell *cell = [BigEventTableViewCell cellWithTableview:tableView];
            cell.item = item;
            return cell;

        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NANewsResp *item = self.ListArray[indexPath.row];
    DLOG(@"%@", item);
    NewsDetailTableViewController  *control = [[NewsDetailTableViewController alloc] initWithVideoPath:item.vedioUrl];
    //        [self.navigationController pushViewController:control animated:YES];
    [self presentModalViewController:control animated:YES];
}

#pragma mark - NABaseApiResultHandlerDelegate methods

- (void)failCauseNetworkUnavaliable:(id)request
{
    DLOG(@"failCauseNetworkUnavaliable");
}

- (void)failCauseRequestTimeout:(id)request
{
    DLOG(@"failCauseRequestTimeout");
}

- (void)failCauseServerError:(id)request
{
    DLOG(@"failCauseServerError");
}

- (void)failCauseBissnessError:(id)apiRequest
{
    DLOG(@"failCauseBissnessError, status:%@", ((NABaseApi *)apiRequest).respStatus);
}

- (void)failCauseSystemError:(id)apiRequest
{
    DLOG(@"failCauseSystemError, status:%@", ((NABaseApi *)apiRequest).respStatus);
}

- (void)failCauseParamError:(id)apiRequest
{
    DLOG(@"failCauseParamError, status:%@", ((NABaseApi *)apiRequest).respStatus);
}

#pragma mark - Correct result handler
- (void)request:(id)request successRequestWithResult:(id)requestResult
{
    
    if (_currentPage == 1) {
        self.listArray = [NSMutableArray arrayWithArray:requestResult];
    }else{
        [self.listArray addObjectsFromArray:requestResult];
    }
    [self.tableView reloadData];
}


@end
