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
//#import "BigEventTextTableViewCell.h"
@interface BigEventViewController ()<NABaseApiResultHandlerDelegate>
@property(nonatomic, strong)NAApiGetNewsList *getNewsListReq;
@property(nonatomic, strong)NSArray *listArray;
@end
@implementation BigEventViewController
- (void)viewDidLoad{
    self.tableView.backgroundColor = [UIColor grayColor];
//    self.tableView.rowHeight = 206;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSLog(@"%@", NSStringFromCGRect(self.tableView.frame));
    [self getNewsList];
}

- (void)getNewsList
{
    self.getNewsListReq = [[NAApiGetNewsList alloc]initWithType:2 pageNo:1 pageSize:10];
    self.getNewsListReq.APIRequestResultHandlerDelegate = self;
    [self.getNewsListReq asyncRequest];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
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
//    NewsDetailTableViewController *control = [[NewsDetailTableViewController alloc] init];
//    [self.navigationController pushViewController:control animated:YES];
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
    
    self.listArray = requestResult;
    [self.tableView reloadData];
}


@end
