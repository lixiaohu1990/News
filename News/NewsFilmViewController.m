//
//  NewsFilmViewController.m
//  News
//
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NewsFilmViewController.h"
#import "NewsFilmTableViewCell.h"

#import "NAApiGetNewsList.h"
#import "NewsList.h"
#import "NANewsResp.h"
#import "BigEventDetailTableViewController.h"
#import "VideoPlayVC.h"
#import "NewsFilmDetailVC.h"

//#import "XCTAssert.h"
@interface NewsFilmViewController ()<NABaseApiResultHandlerDelegate, NewsFilmTableViewCellDelegate, UMSocialUIDelegate>{
    int _currentPage;
}
@property (nonatomic) NAApiGetNewsList *getNewsListReq;
@property(nonatomic, strong)NSMutableArray *ListArray;
@end
@implementation NewsFilmViewController


- (void)viewDidLoad{
//    self.view.backgroundColor = [UIColor yellowColor];
    self.tableView.rowHeight = 260;
    self.tableView.backgroundColor = [UIColor grayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    NSLog(@"%@", NSStringFromCGRect(self.tableview.frame));
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
    self.getNewsListReq = [[NAApiGetNewsList alloc]initWithType:1 pageNo:_currentPage pageSize:PAGESIZE];
    self.getNewsListReq.APIRequestResultHandlerDelegate = self;
    [self.getNewsListReq asyncRequest];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsFilmTableViewCell *cell = [NewsFilmTableViewCell cellWithTableView:tableView];
    cell.nDelegate = self;
    cell.item = self.ListArray[indexPath.row];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NANewsResp *item = self.ListArray[indexPath.row];
    DLOG(@"%@", item);
//    BigEventDetailTableViewController *control = [[BigEventDetailTableViewController alloc] initWithEventStyle:BigeventdetailStyleVideo news:item listType:NewsFilmType];
//    [self presentModalViewController:control animated:YES];
    
    NewsFilmDetailVC *detailVC = [[NewsFilmDetailVC alloc]initWithNews:item];
    detailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:detailVC animated:YES completion:nil];
    
//    if (item.videoList.count > 0) {
//        NSURL *videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
//                                                BASEVIDEOURL,
//                                                ((NAVideo *)item.videoList[0]).videoUrl]];
//        if (!videoURL)
//            return;
//        VideoPlayVC *videoPlayVC = [[VideoPlayVC alloc]init];
//        [self presentViewController:videoPlayVC animated:YES completion:^{
//            [videoPlayVC preparePlayURL:videoURL immediatelyPlay:YES];
//        }];
//    }
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
        self.ListArray = [NSMutableArray arrayWithArray:requestResult];
    }else{
        [self.ListArray addObjectsFromArray:requestResult];
    }
    [self.tableView reloadData];
}

- (void)newsFilmTableViewCellDidShare:(NewsFilmTableViewCell *)cell{
    [UMShareTool initWechatshareWithController:self shareText:cell.item.name shareImageName:nil];
}

@end
