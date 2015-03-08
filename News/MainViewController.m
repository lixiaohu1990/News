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
#import "UISearchView.h"
#import "LoginViewController.h"
#import "MainTitleView.h"
@interface MainViewController ()<MoreViewDelegate>

@end

@implementation MainViewController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    self.indicator.backgroundColor = [UIColor clearColor];
    
    
//    UIBarButtonItem *changeVCsItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
//                                                                                   target:self
//                                                                                   action:@selector(changeVCs)];
    UIButton *searchbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [searchbtn setImage:[UIImage imageNamed:@"icon_seach"] forState:UIControlStateNormal];
    [searchbtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchDown];
    
    UIButton *morebtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [morebtn setImage:[UIImage imageNamed:@"icon_List"] forState:UIControlStateNormal];
    [morebtn addTarget:self action:@selector(changeVCs) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *changeVCsItem = [[UIBarButtonItem alloc] initWithCustomView:searchbtn];
    UIBarButtonItem *searchVCsItem = [[UIBarButtonItem alloc] initWithCustomView:morebtn];
    
//    UIBarButtonItem *searchVCsItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
//                                                                                   target:self
//                                                                                   action:@selector(search)];
    
    //    self.slideSegmentController.navigationItem.rightBarButtonItem = changeVCsItem;
    self.navigationItem.rightBarButtonItems = @[searchVCsItem, changeVCsItem];
    
    MainTitleView *titleView =
    
    [[MainTitleView alloc] initWithFrame:CGRectMake(0, 0, 112, 38)];
//    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 38)];
//    titleView.image = [UIImage imageNamed:@"titile.jpg"];
//    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.titleView = titleView;
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 38)];
    leftView.image = [UIImage imageNamed:@"logo"];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = btn;
}

- (void)changeVCs{
    MoreView *moreView = [[[NSBundle mainBundle] loadNibNamed:@"MoreView" owner:self options:nil] lastObject];
    moreView.moreDelegate = self;
//    MoreView *moreView = [[MoreView alloc] init];
    CGFloat height = CGRectGetHeight(self.view.bounds)-44;
    moreView.frame = CGRectMake(0, -height,  CGRectGetWidth(self.view.bounds),  height);
    moreView.tag = 1000;
    [self.view addSubview:moreView];
    
    [UIView transitionWithView:moreView duration:0.8 options:0 animations:^{
            moreView.frame = CGRectMake(0, 44,  CGRectGetWidth(self.view.bounds),  CGRectGetHeight(self.view.bounds)-44);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)search{
    UISearchView *moreView = [[[NSBundle mainBundle] loadNibNamed:@"UISearchView" owner:self options:nil] lastObject];
//    moreView.moreDelegate = self;
    //    MoreView *moreView = [[MoreView alloc] init];
    CGFloat height = CGRectGetHeight(self.view.bounds)-44;
    moreView.frame = CGRectMake(0, -height,  CGRectGetWidth(self.view.bounds),  height);
    moreView.tag = 1000;
    [self.view addSubview:moreView];
    
    [UIView transitionWithView:moreView duration:0.8 options:0 animations:^{
        moreView.frame = CGRectMake(0, 44,  CGRectGetWidth(self.view.bounds),  CGRectGetHeight(self.view.bounds)-44);
    } completion:^(BOOL finished) {
        
    }];

}

- (void)moreViewDidloginAction:(MoreView *)moreView{
    LoginViewController *control =  [[LoginViewController alloc] init];
//    [self.navigationController pushViewController:control animated:YES];
    [self presentViewController:control animated:YES completion:nil];
}
@end
