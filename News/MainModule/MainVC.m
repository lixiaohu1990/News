//
//  MainVC.m
//  News
//
//  Created by 彭光波 on 15-3-19.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "MainVC.h"
#import "MainTitleView.h"
#import "UIBarButtonItem+lv.h"

#import "NewsFilmViewController.h"
#import "BigEventViewController.h"
#import "PrismViewController.h"
#import "MoreVC.h"
#import "SearchVC.h"

#import "MainTabsView.h"


@interface MainVC ()

@property (nonatomic) MainTitleView *mainTitleView;
@property (nonatomic) UIBarButtonItem *searchBarItem;
@property (nonatomic) UIBarButtonItem *moreBarItem;

@property (nonatomic) MainTabsView *mainTabsView;

@property (nonatomic) NewsFilmViewController *newsFilmVC;
@property (nonatomic) BigEventViewController *bigEventVC;
@property (nonatomic) PrismViewController *prismVC;

@property (nonatomic) MoreVC *moreVC;
@property (nonatomic) SearchVC *searchVC;

@property (nonatomic) UIButton *selectedTabButn;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBarItems];
    
    [self setupMainTabsView];
    
    self.selectedTabButn = self.mainTabsView.newsFilmTabButn;
    
    [self.mainTabsView updateSelected:YES
                         forTabButton:self.mainTabsView.newsFilmTabButn
                    tabBackgroundView:self.mainTabsView.newsFilmTabBackgroundView];
    
    [self transitionToTabVC:self.newsFilmVC];
}

- (void)setupNavigationBarItems
{
    // 设置titleView
    _mainTitleView = [[MainTitleView alloc]initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    108,
                                                                    38)];
    self.navigationItem.titleView = _mainTitleView;
    
    // 设置logo
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          112,
                                                                          38)];
    leftView.image = [UIImage imageNamed:@"logo"];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = btn;
    
    // 设置 search, more bar item
    _searchBarItem = [UIBarButtonItem createBarButtonItemWithNormalImage:[UIImage imageNamed:@"icon_seach"] highlightImage:nil target:self action:@selector(showSearchView)];
    _moreBarItem = [UIBarButtonItem createBarButtonItemWithNormalImage:[UIImage imageNamed:@"icon_List"] highlightImage:nil target:self action:@selector(showMoreView)];
    self.navigationItem.rightBarButtonItems = @[_searchBarItem, _moreBarItem];
}

- (CGFloat)statusBarHeight
{
    return CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
}

- (CGFloat)navigationbarHeight
{
    return CGRectGetHeight(self.navigationController.navigationBar.frame);
}

- (void)setupMainTabsView
{
    CGFloat marginTop = 0.f;
#ifdef __IPHONE_7_0
    marginTop += [self statusBarHeight] + [self navigationbarHeight];
#endif
    _mainTabsView = [[MainTabsView alloc]initFromNib];
    _mainTabsView.frame = CGRectMake(0,
                                     marginTop,
                                     CGRectGetWidth(self.view.bounds),
                                     44.f);
    
    _mainTabsView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_mainTabsView];
    
    [_mainTabsView.newsFilmTabButn addTarget:self
                                      action:@selector(tabButnClick:)
                            forControlEvents:UIControlEventTouchUpInside];
    [_mainTabsView.bigEventTabButn addTarget:self
                                      action:@selector(tabButnClick:)
                            forControlEvents:UIControlEventTouchUpInside];
    [_mainTabsView.prismTabButn addTarget:self
                                      action:@selector(tabButnClick:)
                            forControlEvents:UIControlEventTouchUpInside];
}

- (NewsFilmViewController *)newsFilmVC
{
    if (!_newsFilmVC) {
        _newsFilmVC = [[NewsFilmViewController alloc]init];
    }
    return _newsFilmVC;
}

- (BigEventViewController *)bigEventVC
{
    if (!_bigEventVC) {
        _bigEventVC = [[BigEventViewController alloc]init];
    }
    return _bigEventVC;
}

- (PrismViewController *)prismVC
{
    if (!_prismVC) {
        _prismVC = [[PrismViewController alloc]init];
    }
    return _prismVC;
}

- (void)tabButnClick:(UIButton *)butn
{
    if (self.selectedTabButn == butn) {
        return;
    }
    
    self.selectedTabButn = butn;
    
    if ([butn isEqual:_mainTabsView.newsFilmTabButn]) {
        [self.mainTabsView updateSelected:YES
                             forTabButton:butn
                        tabBackgroundView:self.mainTabsView.newsFilmTabBackgroundView];
        [self.mainTabsView updateSelected:NO
                             forTabButton:self.mainTabsView.bigEventTabButn
                        tabBackgroundView:self.mainTabsView.bigEventTabBackgroundView];
        [self.mainTabsView updateSelected:NO
                             forTabButton:self.mainTabsView.prismTabButn
                        tabBackgroundView:self.mainTabsView.prismTabBackgroundView];
        [self transitionToTabVC:self.newsFilmVC];
        return;
    }
    
    if ([butn isEqual:_mainTabsView.bigEventTabButn]) {
        [self.mainTabsView updateSelected:YES
                             forTabButton:butn
                        tabBackgroundView:self.mainTabsView.bigEventTabBackgroundView];
        [self.mainTabsView updateSelected:NO
                             forTabButton:self.mainTabsView.newsFilmTabButn
                        tabBackgroundView:self.mainTabsView.newsFilmTabBackgroundView];
        [self.mainTabsView updateSelected:NO
                             forTabButton:self.mainTabsView.prismTabButn
                        tabBackgroundView:self.mainTabsView.prismTabBackgroundView];
        [self transitionToTabVC:self.bigEventVC];
        return;
    }
    
    if ([butn isEqual:_mainTabsView.prismTabButn]) {
        [self.mainTabsView updateSelected:YES
                             forTabButton:butn
                        tabBackgroundView:self.mainTabsView.prismTabBackgroundView];
        [self.mainTabsView updateSelected:NO
                             forTabButton:self.mainTabsView.newsFilmTabButn
                        tabBackgroundView:self.mainTabsView.newsFilmTabBackgroundView];
        [self.mainTabsView updateSelected:NO
                             forTabButton:self.mainTabsView.bigEventTabButn
                        tabBackgroundView:self.mainTabsView.bigEventTabBackgroundView];
        [self transitionToTabVC:self.prismVC];
        return;
    }
}

- (void)transitionToTabVC:(UIViewController *)tabVC
{
    UIViewController *fromVC = [self.childViewControllers lastObject];
    
    if ([tabVC isEqual:fromVC]) {
        return;
    }
    
    CGSize viewSize = self.view.bounds.size;
    CGFloat childMarginTop = CGRectGetMaxY(_mainTabsView.frame);
    tabVC.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
    tabVC.view.frame = CGRectMake(0,
                                  childMarginTop,
                                  viewSize.width,
                                  viewSize.height - childMarginTop);
    [self addChildViewController:tabVC];
    
    if (!fromVC) {
        [self.view addSubview:tabVC.view];
        [tabVC didMoveToParentViewController:self];
        return;
    }
    
    [fromVC willMoveToParentViewController:nil];
    /**
     *  transitionFromViewController方法会自动把childVC.view add 到 self.view中
     * 因此，假如自己再[self.view addSubView:childVC.view]会出现
     * Unbalanced calls to begin/end appearance transitions的问题
     * @see http://osdir.com/ml/general/2014-04/msg42887.html
     */
    [self transitionFromViewController:fromVC
                      toViewController:tabVC
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:^(BOOL finished) {
                                
                                [tabVC didMoveToParentViewController:self];
                                
                                [fromVC removeFromParentViewController];
                                [fromVC.view removeFromSuperview];
                            }];
}


- (void)showSearchView
{
    // TODO: 显示搜索的视图
}

- (void)showMoreView
{
    // TODO: 显示more的视图
}


@end
