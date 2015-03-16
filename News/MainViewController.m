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
#import "SettingTableViewController.h"
#import "NAAPIGetTag.h"
#import "SearchTagTableViewController.h"
#import "SearchResaultTableViewController.h"
@interface MainViewController ()<MoreViewDelegate, NABaseApiResultHandlerDelegate, UISearchViewDelegate>
@property(nonatomic, strong)NSArray *tagArray;
@property(nonatomic, strong)NAAPIGetTag *req;
@property(nonatomic, strong)UISearchView *searchView;
@property(nonatomic, strong)MoreView *moreView;
@end

@implementation MainViewController

- (void)loadView {
    [super loadView];
    
}
- (void)getTag{
    self.req = [[NAAPIGetTag alloc] initWithSelf];
    self.req.APIRequestResultHandlerDelegate = self;
    [self.req asyncRequest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    self.indicator.backgroundColor = [UIColor clearColor];
    [self getTag];
    
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
    if (self.moreView) {
        return;
    }
    self.searchView = nil;
    [[self.view viewWithTag:2001] removeFromSuperview];
    MoreView *moreView = [[[NSBundle mainBundle] loadNibNamed:@"MoreView" owner:self options:nil] lastObject];
    moreView.tag = 2000;
    moreView.moreDelegate = self;
//    MoreView *moreView = [[MoreView alloc] init];
    CGFloat height = CGRectGetHeight(self.view.bounds)-44;
    moreView.frame = CGRectMake(0, -height,  CGRectGetWidth(self.view.bounds),  height);
//    moreView.tag = 2000;
    self.moreView = moreView;
    [self.view addSubview:self.moreView];
    
    [UIView transitionWithView:moreView duration:0.8 options:0 animations:^{
            moreView.frame = CGRectMake(0, 44,  CGRectGetWidth(self.view.bounds),  CGRectGetHeight(self.view.bounds)-44);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)search{
    if (self.searchView) {
        return;
    }
    self.moreView = nil;
    [[self.view viewWithTag:2000] removeFromSuperview];
    UISearchView *moreView = [UISearchView viewFromNib];
    moreView.tag = 2001;
    moreView.sDelegate = self;
//    moreView.moreDelegate = self;
    //    MoreView *moreView = [[MoreView alloc] init];
    moreView.tagArray = _tagArray;
    CGFloat height = CGRectGetHeight(self.view.bounds)-44;
    moreView.frame = CGRectMake(0, -height,  CGRectGetWidth(self.view.bounds),  height);
//    moreView.tag = 1000;
    self.searchView = moreView;
    [self.view addSubview:self.searchView];
    
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

- (void)moreViewDidsetAction:(MoreView *)moreView{
    SettingTableViewController *control = [[SettingTableViewController alloc] init];
    [self.navigationController pushViewController:control animated:YES];
}

- (void)moreViewDidNextDevAction:(MoreView *)moreView{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"神秘功能，尽在下一版，敬请期待～" delegate:self cancelButtonTitle:@"好的，我知道了" otherButtonTitles:nil, nil];
    [alert show];
}
- (void)moreViewDidDismissAction:(MoreView *)moreView{
    self.moreView = nil;
}
- (void)searchViewDidSelectedTagWithSearchView:(UISearchView *)view withTagStr:(NSString *)tagStr{
    SearchTagTableViewController *control = [[SearchTagTableViewController alloc] initWithTagStr:tagStr];
    [self.navigationController pushViewController:control animated:YES];
    
}

- (void)searchViewDidSearchWithSearchStr:(NSString *)searchStr{
    SearchResaultTableViewController *control = [[SearchResaultTableViewController alloc] initWithSearchStr:searchStr];
    [self.navigationController pushViewController:control animated:YES];
    
}

- (void)searchViewDidDissmissSearchView:(UISearchView *)view{
    self.searchView = nil;
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
    NSArray *tagArray = requestResult[@"tags"];
    self.tagArray = tagArray;
    
}
@end
