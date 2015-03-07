//
//  PrismViewController.m
//  News
//
//  Created by 李小虎 on 15/3/2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "PrismViewController.h"

@implementation PrismViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
