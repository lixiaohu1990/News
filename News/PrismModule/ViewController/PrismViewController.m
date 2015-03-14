//
//  PrismViewController.m
//  PrismDemo
//
//  Created by 彭光波 on 15-3-14.
//  Copyright (c) 2015年 pengguangbo. All rights reserved.
//

#import "PrismViewController.h"
#import "NAApiGetNewsList.h"
#import "UIScrollView+LoadData.h"
#import "PrismCellView.h"
#import "UIAlertView+lv.h"
#import "AllAroundPullView.h"
#import "ShowImageVC.h"

#ifndef NEWS_TYPE_PRISM
#define NEWS_TYPE_PRISM 3
#endif

#ifndef LOAD_DATA_PAGE_SIZE
#define LOAD_DATA_PAGE_SIZE 15
#endif

static NSString * const PrismCellViewReuseIdentifier = @"PrismCellView";

@interface PrismViewController () <NABaseApiResultHandlerDelegate>

@property (nonatomic) AllAroundPullView *leftPullView;
@property (nonatomic) AllAroundPullView *rightPullView;

@property (nonatomic) NAApiGetNewsList *loadInitPrismListReq;
@property (nonatomic) NAApiGetNewsList *refreshPrismListReq;
@property (nonatomic) NAApiGetNewsList *morePrismListReq;
@property (nonatomic) NSMutableArray *prismList;
@property (nonatomic) int currentLoadPage;

@end

@implementation PrismViewController

- (instancetype)init
{
    return [self initFromStoryboard];
}

- (instancetype)initFromStoryboard
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Prism" bundle:nil];
    return [board instantiateViewControllerWithIdentifier:@"PrismViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.prismList = [NSMutableArray array];
    self.currentLoadPage = 1;
    
    self.collectionView.pagingEnabled = YES;
    
    _leftPullView = [[AllAroundPullView alloc] initWithScrollView:self.collectionView position:AllAroundPullViewPositionLeft action:^(AllAroundPullView *view){
        [self refreshData];
    }];
    _leftPullView.activityView.color = [UIColor grayColor];
    [self.collectionView addSubview:_leftPullView];
    
    [self loadInitData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recvMoreCellSelectedNote:)
                                                 name:PrismCellViewMoreCellSelectedNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:PrismCellViewMoreCellSelectedNotification
                                                 object:nil];
}

- (void)recvMoreCellSelectedNote:(NSNotification *)note
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ShowImageVC *showAllImageVC = [[ShowImageVC alloc]init];
        showAllImageVC.imageUrlList = [(NANewsResp *)self.prismList[[self currentShowPage]] imageList];
        [self presentViewController:showAllImageVC animated:YES completion:^{
            [showAllImageVC reloadData];
        }];
    });
}

- (NSUInteger)currentShowPage
{
    UICollectionView *cv = self.collectionView;
    return cv.contentOffset.x/CGRectGetWidth(cv.frame);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.prismList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PrismCellView *prismCellView = [collectionView dequeueReusableCellWithReuseIdentifier:PrismCellViewReuseIdentifier forIndexPath:indexPath];
    
    prismCellView.prismInfo = self.prismList[indexPath.row];
    
    return prismCellView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.frame.size;
}


#pragma mark - Request load data

- (void)loadInitData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView willLoadData];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NAApiGetNewsList *req = [[NAApiGetNewsList alloc]initWithType:NEWS_TYPE_PRISM
                                                                   pageNo:1
                                                                 pageSize:LOAD_DATA_PAGE_SIZE];
            self.loadInitPrismListReq = req;
            
            req.APIRequestResultHandlerDelegate = self;
            [req asyncRequest];
        });
    });
}

- (void)refreshData
{
    [self.refreshPrismListReq cancelRequest];
    self.refreshPrismListReq.APIRequestResultHandlerDelegate = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NAApiGetNewsList *req = [[NAApiGetNewsList alloc]initWithType:NEWS_TYPE_PRISM
                                                               pageNo:1
                                                             pageSize:LOAD_DATA_PAGE_SIZE];
        self.refreshPrismListReq = req;
        
        req.APIRequestResultHandlerDelegate = self;
        [req asyncRequest];
    });
}

- (void)loadMoreData
{
    [self.morePrismListReq cancelRequest];
    self.morePrismListReq.APIRequestResultHandlerDelegate = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NAApiGetNewsList *req = [[NAApiGetNewsList alloc]initWithType:NEWS_TYPE_PRISM
                                                               pageNo:(self.currentLoadPage + 1)
                                                             pageSize:LOAD_DATA_PAGE_SIZE];
        self.morePrismListReq = req;
        
        req.APIRequestResultHandlerDelegate = self;
        [req asyncRequest];
    });
}

#pragma mark - Request delegate methods

- (void)failCauseNetworkUnavaliable:(id)request
{
    if ([request isEqual:self.loadInitPrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView finishLoadData];
            [UIAlertView commonAlert:@"加载失败，请检查网络"];
        });
        return;
    }
    
    if ([request isEqual:self.refreshPrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.leftPullView finishedLoading];
            [UIAlertView commonAlert:@"加载失败，请检查网络"];
        });
        return;
    }
    
    if ([request isEqual:self.morePrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rightPullView finishedLoading];
            [UIAlertView commonAlert:@"加载失败，请检查网络"];
        });
        return;
    }
}

- (void)failCauseRequestTimeout:(id)request
{
    if ([request isEqual:self.loadInitPrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView finishLoadData];
            [UIAlertView commonAlert:@"请求超时，网速太慢了"];
        });
        return;
    }
    
    if ([request isEqual:self.refreshPrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.leftPullView finishedLoading];
            [UIAlertView commonAlert:@"请求超时，网速太慢了"];
        });
        return;
    }
    
    if ([request isEqual:self.morePrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rightPullView finishedLoading];
            [UIAlertView commonAlert:@"请求超时，网速太慢了"];
        });
        return;
    }
}

- (void)failCauseServerError:(id)request
{
    if ([request isEqual:self.loadInitPrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView finishLoadData];
            [UIAlertView commonAlert:@"加载失败，请稍后再试"];
        });
        return;
    }
    
    if ([request isEqual:self.refreshPrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.leftPullView finishedLoading];
            [UIAlertView commonAlert:@"加载失败，请稍后再试"];
        });
        return;
    }
    
    if ([request isEqual:self.morePrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rightPullView finishedLoading];
            [UIAlertView commonAlert:@"加载失败，请稍后再试"];
        });
        return;
    }
}

- (void)failCauseSystemError:(id)request
{
    if ([request isEqual:self.loadInitPrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView finishLoadData];
            [UIAlertView commonAlert:@"加载失败，请稍后再试"];
        });
        return;
    }
    
    if ([request isEqual:self.refreshPrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.leftPullView finishedLoading];
            [UIAlertView commonAlert:@"加载失败，请稍后再试"];
        });
        return;
    }
    
    if ([request isEqual:self.morePrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rightPullView finishedLoading];
            [UIAlertView commonAlert:@"加载失败，请稍后再试"];
        });
        return;
    }
}

- (void)failCauseBissnessError:(id)request
{
    if ([request isEqual:self.loadInitPrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView finishLoadData];
            [UIAlertView commonAlert:@"加载失败，请稍后再试"];
        });
        return;
    }
    
    if ([request isEqual:self.refreshPrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.leftPullView finishedLoading];
            [UIAlertView commonAlert:@"加载失败，请稍后再试"];
        });
        return;
    }
    
    if ([request isEqual:self.morePrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rightPullView finishedLoading];
            [UIAlertView commonAlert:@"加载失败，请稍后再试"];
        });
        return;
    }
}

- (void)failCauseParamError:(id)request
{
    if ([request isEqual:self.loadInitPrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView finishLoadData];
            [UIAlertView commonAlert:@"加载失败，请联系工作人员"];
        });
        return;
    }
    
    if ([request isEqual:self.refreshPrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.leftPullView finishedLoading];
            [UIAlertView commonAlert:@"加载失败，请联系工作人员"];
        });
        return;
    }
    
    if ([request isEqual:self.morePrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rightPullView finishedLoading];
            [UIAlertView commonAlert:@"加载失败，请联系工作人员"];
        });
        return;
    }
}

- (void)request:(id)request successRequestWithResult:(id)requestResult
{
    if ([request isEqual:self.loadInitPrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView finishLoadData];
            [self refreshWithData:(NSArray *)requestResult];
        });
        return;
    }
    
    if ([request isEqual:self.refreshPrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.leftPullView finishedLoading];
            [self refreshWithData:(NSArray *)requestResult];
        });
        return;
    }
    
    if ([request isEqual:self.morePrismListReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rightPullView finishedLoading];
            if (requestResult && [requestResult isKindOfClass:[NSArray class]]) {
                if ([(NSArray *)requestResult count] == 0)
                    return ;
                
                self.currentLoadPage ++;
                NSInteger originCount = self.prismList.count;
                [self.prismList addObjectsFromArray:requestResult];
                
                [self.collectionView reloadData];
                
                [self updatePullLeftRefreshView];
                
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:originCount inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            }
        });
        return;
    }
}

- (void)refreshWithData:(NSArray *)data
{
    if (data) {
        [self.prismList removeAllObjects];
        [self.prismList addObjectsFromArray:data];
        [self.collectionView reloadData];
    }
    [self updatePullLeftRefreshView];
}

- (void)updatePullLeftRefreshView
{
    // right
    if (_rightPullView)
        return;
    _rightPullView = [[AllAroundPullView alloc] initWithScrollView:self.collectionView position:AllAroundPullViewPositionRight action:^(AllAroundPullView *view){
        [self loadMoreData];
    }];
    _rightPullView.activityView.color = [UIColor grayColor];
    [self.collectionView addSubview:_rightPullView];
}

@end
