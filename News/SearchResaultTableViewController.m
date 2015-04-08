//
//  SearchResaultTableViewController.m
//  News
//
//  Created by 李小虎 on 15/3/14.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "SearchResaultTableViewController.h"
#import "NAAPISearhResaultList.h"
#import "NANewsResp.h"
#import "SearchResaultCell.h"
@interface SearchResaultTableViewController ()<NABaseApiResultHandlerDelegate>
@property(nonatomic, strong)NSString *searchStr;
@property(nonatomic, strong)NAAPISearhResaultList *req;
@property(nonatomic, strong)NSArray *tagListArray;;
@end

@implementation SearchResaultTableViewController
- (instancetype)initWithSearchStr:(NSString *)searchStr{
    if (self = [super init]) {
        _searchStr = searchStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _searchStr;
    [self getTagList];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)getTagList{
    self.req = [[NAAPISearhResaultList alloc] initWithSearchStr:self.searchStr];
    self.req.APIRequestResultHandlerDelegate = self;
    [self.req asyncRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self.tagListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NANewsResp *item = self.tagListArray[indexPath.row];
//    static NSString *cellID = @"cell";
    SearchResaultCell *cell = [SearchResaultCell cellWithTableView:tableView];
    cell.titleLabel.text = item.name;
    cell.row = indexPath.row;
//    cell.textLabel.text = item.name;
//    cell.detailTextLabel.text = item.nsDescription;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NANewsResp *item = self.tagListArray[indexPath.row];
    //    BigEventDetailTableViewController *control
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
    //    if (request) {
    //        <#statements#>
    //    }
    DLOG(@"failCauseServerError, %@", request);
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
    DLOG(@"%@", requestResult);
    self.tagListArray = requestResult;
    
    
}

@end
