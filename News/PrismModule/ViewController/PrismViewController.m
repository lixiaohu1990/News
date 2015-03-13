//
//  PrismViewController.m
//  News
//
//  Created by 李小虎 on 15/3/2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "PrismViewController.h"
#import "NAApiGetNewsList.h"
#import "NAApiGetNews.h"
#import "PrismPageVC.h"

static const int NewsTypePrism = 3;
static const int BasePageNo = 1;

/**
 *  获取当个多棱镜信息请求
 */
@interface GetOnePrismRequest : NAApiGetNewsList

- (instancetype)initWithPageNo:(int)pageNo;

@end

@implementation GetOnePrismRequest

- (instancetype)initWithPageNo:(int)pageNo
{
    self = [super initWithType:NewsTypePrism pageNo:pageNo pageSize:1];
    return self;
}

@end

@interface GetPrismDetailRequest : NAApiGetNews

@property (nonatomic) int pageNo;

- (instancetype)initWithItemId:(int)itemId;

@end

@implementation GetPrismDetailRequest

- (instancetype)initWithItemId:(int)itemId
{
    self = [super initWithItemId:itemId type:NewsTypePrism];
    return self;
}

@end


static const int PrismPagePreLoadCount = 3;   // 预先加载页面的数量

@interface PrismViewController () <NABaseApiResultHandlerDelegate, UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView;
// 多棱镜page集合，用于左右滑动
@property (nonatomic) NSMutableArray *prismPageVCArray;

// 每次只获取一个多棱镜, 通过它获取到id，然后查询具体的多棱镜信息
@property (nonatomic) GetOnePrismRequest *getOnePrismReq;
// 获取到的多棱镜信息保存到这个列表
@property (nonatomic) NSMutableArray *gotPrismArray;

// 当前显示的多棱镜index
@property (nonatomic) NSUInteger currentShowPrismIndex;

// 获取多棱镜详情的请求
@property (nonatomic) GetPrismDetailRequest *getPrismDetailReq;

@end

@implementation PrismViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.gotPrismArray = [NSMutableArray array];
    
    [self setupScrollView];
    
    [self setScrollViewContentPages:self.prismPageVCArray.count];
    [self setScrollViewContentOffsetPageIndex:self.prismPageVCArray.count/2];
    
    self.currentShowPrismIndex = 0;
    
    PrismPageVC *currentPageVC = [self currentShowPrismPageVC];
    [currentPageVC setPrismInfo:nil];
    [currentPageVC setIsLoading:YES];
    [self RequestGetOnePrismOfPageNo:BasePageNo];
}

#pragma mark - Pages

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_scrollView];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    [self setupScrollPages];
}

- (void)setupScrollPages
{
    NSMutableArray *pages = [NSMutableArray array];
    
    CGFloat scrollWidth = CGRectGetWidth(self.scrollView.frame);
    CGFloat scrollHeight = CGRectGetHeight(self.scrollView.frame);
    for (int i = 0; i < PrismPagePreLoadCount; i ++)
    {
        PrismPageVC *pageVC = [[PrismPageVC alloc]initFromStoryboard];
        [pages addObject:pageVC];
        
        // 添加到scrollView上
        pageVC.view.frame = CGRectMake(i * scrollWidth, 0, scrollWidth, scrollHeight);
        [self addChildViewController:pageVC];
        [self.scrollView addSubview:pageVC.view];
        [pageVC didMoveToParentViewController:self];
        pageVC.prismInfo = nil;
        pageVC.isLoading = YES;
    }
    
    self.prismPageVCArray = pages;
}

- (PrismPageVC *)currentShowPrismPageVC
{
    NSInteger currentPageIndex = [self currentPageIndex];
    if (self.prismPageVCArray.count > currentPageIndex) {
        return self.prismPageVCArray[currentPageIndex];
    }
    return nil;
}

- (NSUInteger)currentPageIndex
{
    return self.scrollView.contentOffset.x/CGRectGetWidth(self.scrollView.frame);
}

- (void)finishScroll
{
    NSInteger currentPage = [self currentPageIndex];
    
    // 应该要显示的数据的index
    NSUInteger beforePageIndex = self.prismPageVCArray.count/2;
    NSInteger prismIndex =  self.currentShowPrismIndex + (currentPage - beforePageIndex);
    
    PrismPageVC *currentPageVC = self.prismPageVCArray[currentPage];
    if (prismIndex < 0) {
        // 向前查询
        currentPageVC.prismInfo = nil;
        currentPageVC.isLoading = YES;
        [self RequestGetOnePrismOfPageNo:BasePageNo];
        return;
    }
    
    if (prismIndex >= self.gotPrismArray.count) {
        // 向后查询
        currentPageVC.prismInfo = nil;
        currentPageVC.isLoading = YES;
        [self RequestGetOnePrismOfPageNo:(int)(prismIndex + 1)];
        return;
    }
    
    // 不变
    
    self.currentShowPrismIndex = prismIndex;
    
    currentPageVC = self.prismPageVCArray[beforePageIndex];
    currentPageVC.isLoading = NO;
    NANewsResp *willShowItem = self.gotPrismArray[prismIndex];
    if (currentPageVC.prismInfo.itemId != willShowItem.itemId) {
        [currentPageVC setPrismInfo:willShowItem animated:YES];
        
        // 兼顾左
        NSUInteger currentPageIndex = beforePageIndex;
        if (currentPageIndex > 0) {
            PrismPageVC *prePageVC = self.prismPageVCArray[currentPageIndex - 1];
            if (prismIndex > 0) {
                [prePageVC setPrismInfo:self.gotPrismArray[prismIndex - 1]];
                prePageVC.isLoading = NO;
            } else {
                [prePageVC setPrismInfo:nil];
                prePageVC.isLoading = YES;
            }
        }
        
        // 兼顾右
        if (currentPageIndex < self.prismPageVCArray.count - 1) {
            PrismPageVC *nextPageVC = self.prismPageVCArray[currentPageIndex + 1];
            if (prismIndex < self.gotPrismArray.count - 1) {
                [nextPageVC setPrismInfo:self.gotPrismArray[prismIndex + 1]];
                nextPageVC.isLoading = NO;
            } else {
                [nextPageVC setPrismInfo:nil];
                nextPageVC.isLoading = YES;
            }
        }
    }
    
//    [self performSelector:@selector(setScrollViewContentOffsetPageIndex:) withObject:@(beforePageIndex) afterDelay:0.1];
//    [self setScrollViewContentPages:self.prismPageVCArray.count];
    [self setScrollViewContentOffsetPageIndex:beforePageIndex];
    
//    currentPageVC = [self currentShowPrismPageVC];
//    currentPageVC.isLoading = NO;
//    NANewsResp *willShowItem = self.gotPrismArray[prismIndex];
//    if (currentPageVC.prismInfo.itemId != willShowItem.itemId) {
//        [currentPageVC setPrismInfo:willShowItem animated:YES];
//        
//        // 兼顾左
//        NSUInteger currentPageIndex = [self currentPageIndex];
//        if (currentPageIndex > 0) {
//            PrismPageVC *prePageVC = self.prismPageVCArray[currentPageIndex - 1];
//            if (prismIndex > 0) {
//                [prePageVC setPrismInfo:self.gotPrismArray[prismIndex - 1]];
//                prePageVC.isLoading = NO;
//            } else {
//                [prePageVC setPrismInfo:nil];
//                prePageVC.isLoading = YES;
//            }
//        }
//        
//        // 兼顾右
//        if (currentPageIndex < self.prismPageVCArray.count - 1) {
//            PrismPageVC *nextPageVC = self.prismPageVCArray[currentPageIndex + 1];
//            if (prismIndex < self.gotPrismArray.count - 1) {
//                [nextPageVC setPrismInfo:self.gotPrismArray[prismIndex + 1]];
//                nextPageVC.isLoading = NO;
//            } else {
//                [nextPageVC setPrismInfo:nil];
//                nextPageVC.isLoading = YES;
//            }
//        }
//    }
}

- (void)setScrollViewContentPages:(NSUInteger)contentPages
{
    self.scrollView.contentSize = CGSizeMake(contentPages * CGRectGetWidth(self.scrollView.frame),
                                             CGRectGetHeight(self.scrollView.frame));
}

- (void)setScrollViewContentOffsetPageIndex:(NSUInteger)contentOffsetPageIndex
{
    self.scrollView.contentOffset = CGPointMake(contentOffsetPageIndex * CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
}


#pragma mark - Requests

- (void)RequestGetOnePrismOfPageNo:(int)pageNo
{
    if (self.getOnePrismReq.isOnRequest)
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            GetOnePrismRequest *getOnePrismReq = [[GetOnePrismRequest alloc]initWithPageNo:pageNo];
            self.getOnePrismReq = getOnePrismReq;
            
            getOnePrismReq.APIRequestResultHandlerDelegate = self;
            [getOnePrismReq asyncRequest];
        });
    });
}

- (void)RequestGetPrismDetailForID:(int)itemID atPageNo:(int)pageNo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.getPrismDetailReq.isOnRequest) {
            self.getPrismDetailReq.APIRequestResultHandlerDelegate = nil;
            [self.getPrismDetailReq cancelRequest];
        }
        GetPrismDetailRequest *getDetailReq = [[GetPrismDetailRequest alloc]initWithItemId:itemID];
        getDetailReq.pageNo = pageNo;
        self.getPrismDetailReq = getDetailReq;
        
        getDetailReq.APIRequestResultHandlerDelegate = self;
        [getDetailReq asyncRequest];
    });
}

#pragma mark - NABaseApiResultHandlerDelegate methods

- (void)failCauseNetworkUnavaliable:(id)request
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // TODO: 提示出错，可以用一个类别来专门处理错误提醒以及提供再次刷新使用。提供背景颜色，提示文字颜色，可以用"轻触以重新加载..."的方式进行
    });
}

- (void)failCauseRequestTimeout:(id)request
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // TODO: 提示出错，可以用一个类别来专门处理错误提醒以及提供再次刷新使用。提供背景颜色，提示文字颜色，可以用"轻触以重新加载..."的方式进行
    });
}

- (void)failCauseServerError:(id)request
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // TODO: 提示出错，可以用一个类别来专门处理错误提醒以及提供再次刷新使用。提供背景颜色，提示文字颜色，可以用"轻触以重新加载..."的方式进行
    });
}

- (void)failCauseBissnessError:(id)apiRequest
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // TODO: 提示出错，可以用一个类别来专门处理错误提醒以及提供再次刷新使用。提供背景颜色，提示文字颜色，可以用"轻触以重新加载..."的方式进行
    });
}

- (void)failCauseSystemError:(id)apiRequest
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // TODO: 提示出错，可以用一个类别来专门处理错误提醒以及提供再次刷新使用。提供背景颜色，提示文字颜色，可以用"轻触以重新加载..."的方式进行
    });
}

- (void)failCauseParamError:(id)apiRequest
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // TODO: 提示出错，可以用一个类别来专门处理错误提醒以及提供再次刷新使用。提供背景颜色，提示文字颜色，可以用"轻触以重新加载..."的方式进行
    });
}

- (void)request:(id)request successRequestWithResult:(id)requestResult
{
    if ([request isEqual:self.getOnePrismReq]) {
        NSArray *reqResults = (NSArray *)requestResult;
        
        if (reqResults.count == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                PrismPageVC *showPage = [self currentShowPrismPageVC];
                [showPage setIsLoading:NO];
                
                // TODO: 提示没有更新的数据了，同时改变contentOffset，使移动到最近查看的一页内容
                [self setScrollViewContentPages:self.prismPageVCArray.count];
                [self setScrollViewContentOffsetPageIndex:self.prismPageVCArray.count/2];
            });
            return;
        }
        
        NANewsResp *result = reqResults[0];
        
        // 判断是否查询详情
        BOOL requestDetail = YES;
        if (self.getOnePrismReq.pageNo == BasePageNo) {
            // 获取第一页
            if (self.gotPrismArray.count != 0) {
                NANewsResp *firstPrism = self.gotPrismArray[0];
                requestDetail = (firstPrism.itemId != result.itemId);
            }
        }
        
        // 查询详情
        if (requestDetail) {
            [self RequestGetPrismDetailForID:result.itemId
                                    atPageNo:self.getOnePrismReq.pageNo];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                PrismPageVC *showPage = [self currentShowPrismPageVC];
                [showPage setIsLoading:NO];
                
                // TODO: 改变contentOffset，使移动到最近查看的一页内容,也是最中间位置
                [self setScrollViewContentPages:self.prismPageVCArray.count];
                [self setScrollViewContentOffsetPageIndex:self.prismPageVCArray.count/2];
            });
        }
        
        return;
    }
    
    if ([request isEqual:self.getPrismDetailReq]) {
        
        self.currentShowPrismIndex = self.getPrismDetailReq.pageNo - BasePageNo;
        
        NANewsResp *result = (NANewsResp *)requestResult;
        
        // 设置到数据里
        if (self.getPrismDetailReq.pageNo > self.gotPrismArray.count) {
            // 获取到尾部的数据
            [self.gotPrismArray addObject:result];
        } else {
            // 获取到头部的数据
            [self.gotPrismArray insertObject:result atIndex:0];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            PrismPageVC *showPage = [self currentShowPrismPageVC];
            [showPage setIsLoading:NO];
            
            // 设置到界面
            [self setScrollViewContentPages:self.prismPageVCArray.count];
            [self setScrollViewContentOffsetPageIndex:self.prismPageVCArray.count/2];
            showPage = [self currentShowPrismPageVC];
            [showPage setPrismInfo:result animated:YES];
        });
        
        return;
    }
}


#pragma mark - Scroll view delegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self finishScroll];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self finishScroll];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
}

@end

