//
//  NewsFilmViewController.m
//  News
//
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NewsFilmViewController.h"
#import "BigEventViewController.h"

@implementation NewsFilmViewController


- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor yellowColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = @"新闻局";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BigEventViewController *control = [[BigEventViewController alloc] init];
    [self.navigationController pushViewController:control animated:YES];
}
@end
