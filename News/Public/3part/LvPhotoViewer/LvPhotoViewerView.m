//
//  LvPhotoViewerView.m
//  CommunityDemo
//
//  Created by guangbo on 15/3/26.
//  Copyright (c) 2015年 1024. All rights reserved.
//

#import "LvPhotoViewerView.h"

@interface LvPhotoViewerItemCell : UICollectionViewCell

@property (nonatomic, readonly) LvPhotoItemScrollView *itemView;

@end

@implementation LvPhotoViewerItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupPhotoViewerItemCell];
    }
    return self;
}

- (void)setupPhotoViewerItemCell
{
    LvPhotoItemScrollView *itemV = [[LvPhotoItemScrollView alloc]initWithFrame:self.contentView.bounds
                                                                     photoView:[[UIImageView alloc]init]];
    itemV.photoView.contentMode = UIViewContentModeScaleAspectFit;
    itemV.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    [self.contentView addSubview:itemV];
    _itemView = itemV;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _itemView.contentSize = self.contentView.bounds.size;
}

@end


/**
 *  默认颜色
 */
static inline UIColor* LvPhotoViewerDefaultPageIndicatorTintColor() {return [UIColor colorWithWhite:1 alpha:0.5];};
static inline UIColor* LvPhotoViewerDefaultCurrentPageIndicatorTintColor() {return [UIColor whiteColor];}

static NSString *const LvPhotoViewerItemCellIdentifier = @"LvPhotoViewerItemCell";

@interface LvPhotoViewerView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UIPageControl *viewerPageControl;

@end

@implementation LvPhotoViewerView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupPhotoViewerView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupPhotoViewerView];
    }
    return self;
}

- (void)setupPhotoViewerView
{
    // 设置collection view
    UICollectionViewFlowLayout *clvFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    clvFlowLayout.minimumLineSpacing = 0;
    clvFlowLayout.minimumInteritemSpacing = 0;
    clvFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *clv = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:clvFlowLayout];
    clv.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    clv.backgroundColor = [UIColor clearColor];
    clv.delegate = self;
    clv.dataSource = self;
    clv.alwaysBounceHorizontal = YES;
    clv.alwaysBounceVertical = NO;
    clv.showsHorizontalScrollIndicator = NO;
    clv.showsVerticalScrollIndicator = NO;
    clv.pagingEnabled = YES;
    
    [clv registerClass:[LvPhotoViewerItemCell class] forCellWithReuseIdentifier:LvPhotoViewerItemCellIdentifier];
    
    [self addSubview:clv];
    _collectionView = clv;
    
    
    // 设置 page control
    UIPageControl *viewerPageControl = [[UIPageControl alloc]init];
    viewerPageControl.pageIndicatorTintColor = LvPhotoViewerDefaultPageIndicatorTintColor();
    viewerPageControl.currentPageIndicatorTintColor = LvPhotoViewerDefaultCurrentPageIndicatorTintColor();
    viewerPageControl.hidesForSinglePage = YES;
    
    [self addSubview:viewerPageControl];
    
    viewerPageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageControl]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"pageControl":viewerPageControl}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:viewerPageControl
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
    _viewerPageControl = viewerPageControl;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recvOrientationChangedNote:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIDeviceOrientationDidChangeNotification
                                                 object:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numbers = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(numbersOfPhotoItem:)]) {
        numbers = [self.delegate numbersOfPhotoItem:self];
    }
    
    self.viewerPageControl.numberOfPages = numbers;
    
    return numbers;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LvPhotoViewerItemCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:LvPhotoViewerItemCellIdentifier
                                                                                forIndexPath:indexPath];
    itemCell.backgroundColor = [UIColor clearColor];
    LvPhotoItemScrollView *itemView = itemCell.itemView;
    itemView.backgroundColor = [UIColor clearColor];
    [itemView setZoomScale:itemView.minimumZoomScale animated:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoViewer:willShowPhotoOnImageView:atIndex:)]) {
        [self.delegate          photoViewer:self
                   willShowPhotoOnImageView:itemCell.itemView.photoView
                                    atIndex:indexPath.row];
    }
    
    return itemCell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.bounds.size;
}


#pragma mark - UIScrollViewDelegate

- (void)updateCurrentPage
{
    _viewerPageControl.currentPage = self.currentPage;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scroll
{
    [self updateCurrentPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll
{
    [self updateCurrentPage];
}


#pragma mark - Public methods

- (NSUInteger)currentPage
{
    return (self.collectionView.contentOffset.x / CGRectGetWidth(self.collectionView.bounds));
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    _viewerPageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    _viewerPageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)scrollToPage:(NSUInteger)pageIndex animated:(BOOL)animated
{
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    if (itemCount <= pageIndex)
        return;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:pageIndex
                                                                    inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:animated];
    if (!animated) {
        [self updateCurrentPage];
    }
}

#pragma mark - rotate notification

- (void)recvOrientationChangedNote:(NSNotification *)note
{
    UICollectionViewFlowLayout *flowlayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    [flowlayout invalidateLayout];
    [self scrollToPage:_viewerPageControl.currentPage animated:NO];
}

@end
