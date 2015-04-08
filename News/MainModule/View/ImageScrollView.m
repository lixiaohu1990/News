//
//  ImageScrollView.m
//  IYiMing
//
//  Created by lee on 14/12/2.
//  Copyright (c) 2014年 lee. All rights reserved.
//

#import "ImageScrollView.h"

#define DEFAULT_TIME_INTERVAL 1.0f

@interface ImageScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *curScrollView;
@property (nonatomic, strong) UIPageControl *curPageControl;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, strong) NSMutableArray *curViews;

@end

@implementation ImageScrollView

- (void)dealloc
{
    self.curScrollView = nil;
    self.curPageControl = nil;
    self.curViews = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)clear {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.curPage = 0;
    self.totalPages = 0;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.curScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.curScrollView.delegate = self;
        self.curScrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        self.curScrollView.showsHorizontalScrollIndicator = NO;
        self.curScrollView.showsVerticalScrollIndicator = NO;
        
        self.curScrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        self.curScrollView.pagingEnabled = YES;
        [self addSubview:self.curScrollView];
        
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 30;
        rect.size.height = 30;
        self.curPageControl = [[UIPageControl alloc] initWithFrame:rect];
        self.curPageControl.userInteractionEnabled = NO;
        
        [self addSubview:self.curPageControl];
        
        _curPage = 0;
        
    }
    return self;
}

- (void)setDataSource:(id<ImageScrollViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

- (void)reloadData
{
    self.totalPages = [_dataSource numberOfPages];
    if (_totalPages == 0) {
        return;
    }
    self.curPageControl.numberOfPages = _totalPages;
    [self loadData];
    
    [self performSelector:@selector(updateNextView)
               withObject:nil
               afterDelay:DEFAULT_TIME_INTERVAL];
}

- (void)updateNextView {
    [self.curScrollView setContentOffset:CGPointMake(self.frame.size.width * 2, 0) animated:YES];
    

    
}

- (void)loadData
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(updateNextView)
                                               object:nil];
    
    self.curPageControl.currentPage = _curPage;
    
    
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [self.curScrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:_curPage];
    
    for (int i = 0; i < 3; i++) {
        UIView *v = [self.curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];

        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        [self.curScrollView addSubview:v];
    }
    
    [self.curScrollView setContentOffset:CGPointMake(self.curScrollView.frame.size.width, 0)];
    if ([_delegate respondsToSelector:@selector(updateCurPageAtIndex:)]) {
        [_delegate updateCurPageAtIndex:_curPage];
    }
    
    [self performSelector:@selector(updateNextView)
               withObject:nil
               afterDelay:DEFAULT_TIME_INTERVAL];
}

- (void)getDisplayImagesWithCurpage:(int)page {
    int pre = [self validPageValue:_curPage-1];
    int last = [self validPageValue:_curPage+1];
    
    if (!self.curViews) {
        self.curViews = [[NSMutableArray alloc] init];
    }
    
    [self.curViews removeAllObjects];
    
    [self.curViews addObject:[_dataSource pageAtIndex:pre]];
    [self.curViews addObject:[_dataSource pageAtIndex:page]];
    [self.curViews addObject:[_dataSource pageAtIndex:last]];
}

- (int)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_curPage];
    }
    
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == _curPage) {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];

            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [self.curScrollView addSubview:v];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    if (_curScrollView.contentOffset.y < 0) {
        _curScrollView.contentOffset = CGPointMake(_curScrollView.contentOffset.x, 0);
    }
    
    if (_curScrollView.contentOffset.y > 0) {
        _curScrollView.contentOffset = CGPointMake(_curScrollView.contentOffset.x, 0);
    }
    
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        if (_curPage == [self.dataSource numberOfPages]-2) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishChange)]) {
                [self.delegate didFinishChange];
                return;
            }
        }
        _curPage = [self validPageValue:_curPage+1];
        [self loadData];
        
    }
    
    //往上翻
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage-1];
        [self loadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
    [self.curScrollView setContentOffset:CGPointMake(self.curScrollView.frame.size.width, 0) animated:YES];
    
}

@end
