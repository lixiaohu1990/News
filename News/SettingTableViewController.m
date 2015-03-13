//
//  SettingTableViewController.m
//  News
//
//  Created by 李小虎 on 15/3/11.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "SettingTableViewController.h"
#import "FeedBackViewController.h"
#import "AboutUSViewController.h"
@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"意见反馈";
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"关于我们";
    }else{
        cell.textLabel.text = @"当前版本";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        FeedBackViewController *control = [[FeedBackViewController alloc] init];
        [self.navigationController pushViewController:control animated:YES];
    }else if(indexPath.row == 1){
        AboutUSViewController *control = [[AboutUSViewController alloc] init];
        [self.navigationController pushViewController:control animated:YES];
    }else{
        NSString *version = [NSString stringWithFormat:@"当前版本v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:version delegate:self cancelButtonTitle:@"好的，我知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
