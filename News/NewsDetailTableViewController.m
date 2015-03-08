//
//  NewsDetailTableViewController.m
//  News
//
//  Created by 李小虎 on 15/3/4.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NewsDetailTableViewController.h"
#import "DetailDiscussTableViewCell.h"
#import "SendCommentView.h"
@interface NewsDetailTableViewController ()<DetailDiscussTableViewCellDelegate>

@end

@implementation NewsDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"立场新闻社";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 250;
    }else if(indexPath.row == 1){
        return 88;
    }else{
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"NewsFilmDetailTableViewCell";
//    static NSString *cellIdentifier2 = @"BigEventTableViewCell2";
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"NewsFilmDetailTableViewCell" owner:nil options:nil][0];
        
        return cell;
        
    }else if(indexPath.row == 1){
        UITableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"NewsFilmDetailTableViewCell" owner:nil options:nil][1];
        
        return cell;
    }else if(indexPath.row ==2){
        UITableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"NewsFilmDetailTableViewCell" owner:nil options:nil][2];
        
        return cell;

    }else if (indexPath.row == 3){
        DetailDiscussTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"NewsFilmDetailTableViewCell" owner:nil options:nil][3];
        cell.dicDelegate = self;
        return cell;

    }else{
        UITableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"NewsFilmDetailTableViewCell" owner:nil options:nil][4];
        
        return cell;
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark ------  CELLDELEGATE
- (void)didClickSendbutton:(DetailDiscussTableViewCell *)cell{
//    UIView *viewM = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
//    viewM.backgroundColor = [UIColor blackColor];
//    viewM.alpha = 0.5;
//    viewM.tag = 1000;
//    [self.view addSubview:viewM];
    SendCommentView *view = [[SendCommentView alloc] initWithFrame:self.view.frame];
//    view.center = CGPointMake(self.view.center.x, 200);
//    view.window.windowLevel = UIWindowLevelAlert;
    [view.commentTexfield becomeFirstResponder];
    [self.view addSubview:view];
}
@end
