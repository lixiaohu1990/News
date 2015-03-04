//
//  NewsFilmViewController.m
//  News
//
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NewsFilmViewController.h"
#import "NewsDetailTableViewController.h"
#import "NewsFilmTableViewCell.h"
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
    NewsDetailTableViewController *control = [[NewsDetailTableViewController alloc] init];
    [self.navigationController pushViewController:control animated:YES];
}

@end
