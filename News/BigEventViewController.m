//
//  BigEventViewController.m
//  News
//
//  Created by 李小虎 on 15/3/2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "BigEventViewController.h"
#import "BigEventTableViewCell.h"
@implementation BigEventViewController
- (void)viewDidLoad{
    self.tableView.backgroundColor = [UIColor grayColor];
//    self.tableView.rowHeight = 206;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSLog(@"%@", NSStringFromCGRect(self.tableView.frame));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 206;
    }else{
        return 100;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"BigEventTableViewCell";
    static NSString *cellIdentifier2 = @"BigEventTableViewCell2";
    if (indexPath.row == 0) {
        BigEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(!cell){
            
            NSArray *cellList = [[NSBundle mainBundle] loadNibNamed:@"BigEventTableViewCell" owner:nil options:nil];
            
            cell = (BigEventTableViewCell *)cellList[0];
        }
        
        return cell;
        
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        
        if(!cell){
            
            NSArray *cellList = [[NSBundle mainBundle] loadNibNamed:@"BigEventTableViewCell" owner:nil options:nil];
            
            cell = (BigEventTableViewCell *)cellList[1];
        }
        
        return cell;

    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NewsDetailTableViewController *control = [[NewsDetailTableViewController alloc] init];
//    [self.navigationController pushViewController:control animated:YES];
}



@end
