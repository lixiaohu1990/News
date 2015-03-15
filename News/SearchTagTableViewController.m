//
//  SearchTagTableViewController.m
//  News
//
//  Created by 李小虎 on 15/3/14.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "SearchTagTableViewController.h"
#import "NAAPIGetTagList.h"
#import "NANewsResp.h"
#import "BigEventDetailTableViewController.h"
@interface SearchTagTableViewController ()<NABaseApiResultHandlerDelegate>
@property(nonatomic, strong)NSString *tagStr;
@property(nonatomic, strong)NAAPIGetTagList *req;
@property(nonatomic, strong)NSArray *tagListArray;;
@end

@implementation SearchTagTableViewController
- (instancetype)initWithTagStr:(NSString *)tagStr{
    if (self = [super init]) {
        _tagStr = tagStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _tagStr;
    [self getTagList];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)getTagList{
    self.req = [[NAAPIGetTagList alloc] initWithTag:self.tagStr];
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
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.nsDescription;
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
