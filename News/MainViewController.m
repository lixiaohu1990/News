//
//  MainViewController.m
//  News
//
//  Created by 李小虎 on 15/3/3.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "MainViewController.h"
#import "NewsFilmViewController.h"
#import "PrismViewController.h"
#import "BigEventViewController.h"
#import "MoreView.h"
#import "LoginViewController.h"
@interface MainViewController ()<MoreViewDelegate>

@end

@implementation MainViewController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    self.indicator.backgroundColor = [UIColor redColor];
    
    
    UIBarButtonItem *changeVCsItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                   target:self
                                                                                   action:@selector(changeVCs)];
    
    UIBarButtonItem *searchVCsItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                   target:self
                                                                                   action:@selector(search)];
    
    //    self.slideSegmentController.navigationItem.rightBarButtonItem = changeVCsItem;
    self.navigationItem.rightBarButtonItems = @[changeVCsItem, searchVCsItem];
    
    UIView *weatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    weatherView.backgroundColor = [UIColor blackColor];
    self.navigationItem.titleView = weatherView;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    leftView.backgroundColor = [UIColor blueColor];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = btn;
}

- (void)changeVCs{
    MoreView *moreView = [[[NSBundle mainBundle] loadNibNamed:@"MoreView" owner:self options:nil] lastObject];
    moreView.moreDelegate = self;
//    MoreView *moreView = [[MoreView alloc] init];
    moreView.frame = CGRectMake(0, 44,  CGRectGetWidth(self.view.bounds),  CGRectGetHeight(self.view.bounds)-44);
    moreView.tag = 1000;
    [self.view addSubview:moreView];
}

- (void)moreViewDidloginAction:(MoreView *)moreView{
    LoginViewController *control =  [[LoginViewController alloc] init];
    [self.navigationController pushViewController:control animated:YES];
}
@end
