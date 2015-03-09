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
@implementation NewsFilmViewController


- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor yellowColor];
    self.tableview.rowHeight = 260;
    NSLog(@"%@", NSStringFromCGRect(self.tableview.frame));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"NewsFilmTableViewCell";
    NewsFilmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        
        NSArray *cellList = [[NSBundle mainBundle] loadNibNamed:@"NewsFilmTableViewCell" owner:nil options:nil];
        
        cell = (NewsFilmTableViewCell *)cellList[0];
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row != 0 || indexPath.row != 1) {
        NewsDetailTableViewController  *control = [[NewsDetailTableViewController alloc] init];
//        [self.navigationController pushViewController:control animated:YES];
        [self presentModalViewController:control animated:YES];
    }else{
        NewsDetailTableViewController *control = [[NewsDetailTableViewController alloc] init];
        [self.navigationController pushViewController:control animated:YES];

    }
}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
//}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//
//{
//    
//    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
//    
//}
//
//- (BOOL)shouldAutorotate
//
//{
//    
//    return NO;
//    
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//
//{
//    
//    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
//    
//}
@end
