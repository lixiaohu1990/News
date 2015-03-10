//
//  NewsFilmViewController.m
//  News
//
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NewsFilmViewController.h"
#import "NewsDetailTableViewController.h"
#import "NewsFilmTableViewCell.h"
#import "NewFileDispalyViewController.h"
#import "CBViewController.h"
#import "NAApiGetNewsList.h"
#import "NewsList.h"
#import "NANewsResp.h"
//#import "XCTAssert.h"
@interface NewsFilmViewController ()<NABaseApiResultHandlerDelegate>
@property (nonatomic) NAApiGetNewsList *getNewsListReq;
@property(nonatomic, strong)NSArray *ListArray;
@end
@implementation NewsFilmViewController


- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor yellowColor];
    self.tableview.rowHeight = 260;
//    NSLog(@"%@", NSStringFromCGRect(self.tableview.frame));
    [self GetNewsList];
}

- (void)GetNewsList
{
    self.getNewsListReq = [[NAApiGetNewsList alloc]initWithType:1 pageNo:1 pageSize:10];
    self.getNewsListReq.APIRequestResultHandlerDelegate = self;
    [self.getNewsListReq asyncRequest];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsFilmTableViewCell *cell = [NewsFilmTableViewCell cellWithTableView:tableView];
    cell.item = self.ListArray[indexPath.row];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NANewsResp *item = self.ListArray[indexPath.row];
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
    
    self.ListArray = requestResult;
    [self.tableview reloadData];
}


@end
