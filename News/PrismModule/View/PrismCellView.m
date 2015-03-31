//
//  PrismCellView.m
//  PrismDemo
//
//  Created by 彭光波 on 15-3-14.
//  Copyright (c) 2015年 pengguangbo. All rights reserved.
//

#import "PrismCellView.h"

#import "UIImageView+WebCache.h"
#import "NSString+lv.h"

#import "PrismCommImageCell.h"
#import "NAApiConstants.h"
#import "PrismFooter.h"
#import "LvModelWindow.h"
#import "LvPhotoViewerView.h"

NSString *const PrismCellViewMoreCellSelectedNotification = @"PrismCellViewMoreCellSelectedNotification";
NSString *const PrismCellViewCacheButnClickNotification = @"PrismCellViewCacheButnClickNotification";
NSString *const PrismCellViewShareButnClickNotification = @"PrismCellViewShareButnClickNotification";

static const NSUInteger PrismSizePerRow = 3;
static const CGFloat PrismCollectionViewSectionHorizonPadding = 22.f;
static const CGFloat PrismCollectionViewSectionPaddingTop = 20.f;
static const CGFloat PrismCollectionViewCellHorizonSpacing = 10.f;

// 顶部图片复用标示
static NSString *const PrismCoverImageHeaderIdentifier = @"PrismCoverImageHeader";
// 普通图片cell复用标示
static NSString *const PrismCommonImageCellIdentifier = @"PrismImageCell";
// more图片的复用标示
static NSString *const PrismMoreImageCellIdentifier = @"PrismMoreImageCell";

static NSString *const PrismFooteridentifier = @"PrismFooter";

@interface PrismCellView () <UICollectionViewDataSource, UICollectionViewDelegate, LvModelWindowDelegate, LvPhotoViewerViewDelegate>

// 用于展示图片的collection视图
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, weak) IBOutlet UIButton *cacheButn;
@property (nonatomic, weak) IBOutlet UIButton *shareButn;

@property (nonatomic) LvModelWindow *photoViewerModelWindow;
@property (nonatomic) LvPhotoViewerView *photoViewer;

@end

@implementation PrismCellView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupPrismCellView];
}

- (void)setupPrismCellView
{
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[PrismCommImageCell class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:PrismCoverImageHeaderIdentifier];
    [_collectionView registerClass:[PrismCommImageCell class]
        forCellWithReuseIdentifier:PrismCommonImageCellIdentifier];
    [_collectionView registerClass:[PrismCommImageCell class]
        forCellWithReuseIdentifier:PrismMoreImageCellIdentifier];
    [_collectionView registerClass:[PrismFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:PrismFooteridentifier];
    
    [_cacheButn addTarget:self
                   action:@selector(cacheButnClick:)
         forControlEvents:UIControlEventTouchUpInside];
    [_shareButn addTarget:self
                   action:@selector(shareButnClick:)
         forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recvPhotoItemScrollViewTapNote:)
                                                 name:LvPhotoItemScrollViewTappedNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:LvPhotoItemScrollViewTappedNotification
                                                  object:nil];
}

- (void)setPrismInfo:(NANewsResp *)prismInfo
{
    _prismInfo = prismInfo;
    
    // 改变页面
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)setPrismHasCached:(BOOL)prismHasCached
{
    _prismHasCached = prismHasCached;
    
    // 更新界面
    dispatch_async(dispatch_get_main_queue(), ^{
        if (prismHasCached) {
            // 设置已经缓存的效果
        } else {
            // 设置没有缓存的效果
        }
    });
}

#pragma mark - Button action

- (void)cacheButnClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PrismCellViewCacheButnClickNotification object:self];
}

- (void)shareButnClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PrismCellViewShareButnClickNotification object:self];
}

#pragma mark - Collect view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.prismInfo.imageList.count;
    
    NSInteger limitShowNum = [self ImageLimitShowNum];
    // 不超过两行
    if (count > limitShowNum) {
        return limitShowNum + 1;
    }
    
    return count;
}

// 限制显示的图片数量
- (NSInteger)ImageLimitShowNum
{
    return PrismSizePerRow * 2 - 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self ImageLimitShowNum]) {
        PrismCommImageCell *commCell = [collectionView dequeueReusableCellWithReuseIdentifier:PrismCommonImageCellIdentifier forIndexPath:indexPath];
        
        NSString *imageUrl = self.prismInfo.imageList[indexPath.row];
        NSURL *imageURL = nil;
        if (imageUrl) {
            imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                             NAServerBaseUrl,
                                             imageUrl]];
        }
        commCell.backgroundColor = [UIColor blackColor];
        commCell.pActyIndicatorView.color = [UIColor whiteColor];
        [commCell.pActyIndicatorView startAnimating];
        [commCell.pImageView setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [commCell.pActyIndicatorView stopAnimating];
            });
        }];
        return commCell;
        
    } else {
        // more cell
        PrismCommImageCell *moreCell = [collectionView dequeueReusableCellWithReuseIdentifier:PrismMoreImageCellIdentifier forIndexPath:indexPath];
        moreCell.backgroundColor = [UIColor grayColor];
        if (!moreCell.pImageView.image) {
            moreCell.pImageView.contentMode = UIViewContentModeCenter;
            moreCell.pImageView.image = [UIImage imageNamed:@"prism_icon_Add"];
        }
        return moreCell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSString *coverImageUrl = self.prismInfo.imageUrl;
        if (coverImageUrl) {
            NSURL *coverURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                                    NAServerBaseUrl,
                                                    coverImageUrl]];
            PrismCommImageCell *coverHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:PrismCoverImageHeaderIdentifier forIndexPath:indexPath];
            
            coverHeader.backgroundColor = [UIColor blackColor];
            coverHeader.pActyIndicatorView.color = [UIColor whiteColor];
            [coverHeader.pActyIndicatorView startAnimating];
            [coverHeader.pImageView setImageWithURL:coverURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [coverHeader.pActyIndicatorView stopAnimating];
                });
            }];
            reusableView = coverHeader;
        } else {
            reusableView = [[UICollectionReusableView alloc]initWithFrame:CGRectZero];
        }
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        PrismFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:PrismFooteridentifier forIndexPath:indexPath];
        footer.title = self.prismInfo.name;
        footer.content = self.prismInfo.nsDescription;
        reusableView = footer;
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat collectionViewWidth = CGRectGetWidth(collectionView.frame);
    
    CGFloat cellWidth = ((collectionViewWidth - PrismCollectionViewSectionHorizonPadding*2) - (PrismSizePerRow - 1)*PrismCollectionViewCellHorizonSpacing)/PrismSizePerRow;
    CGFloat cellHeight = cellWidth * 228.f/352.f;
    
    return CGSizeMake(cellWidth, cellHeight);
}

- (CGSize)      collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat collectionViewWidth = CGRectGetWidth(collectionView.frame);
    
    CGFloat headerWidth = collectionViewWidth;
    CGFloat headerHeight = headerWidth * 718.f/1246.f;
    
    return CGSizeMake(headerWidth, headerHeight);
}

- (CGSize)          collectionView:(UICollectionView *)collectionView
                            layout:(UICollectionViewLayout*)collectionViewLayout
   referenceSizeForFooterInSection:(NSInteger)section
{
    CGFloat width = CGRectGetWidth(collectionView.frame);
    CGFloat height = [PrismFooter footerHeightForContent:self.prismInfo.nsDescription
                                         constraintWidth:width];
    return CGSizeMake(width, height);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets = UIEdgeInsetsMake(PrismCollectionViewSectionPaddingTop,
                                           PrismCollectionViewSectionHorizonPadding,
                                           0,
                                           PrismCollectionViewSectionHorizonPadding);
    return insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return PrismCollectionViewCellHorizonSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return PrismCollectionViewCellHorizonSpacing;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (cell.reuseIdentifier == PrismMoreImageCellIdentifier) {
        // 更多按钮
        [[NSNotificationCenter defaultCenter]postNotificationName:PrismCellViewMoreCellSelectedNotification object:self];
    } else {
        [self.photoViewerModelWindow showWithAnimated:YES];
        [self.photoViewer scrollToPage:indexPath.row animated:NO];
    }
}

- (void)recvPhotoItemScrollViewTapNote:(NSNotification *)note
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)note.object;
    
    if (gesture.numberOfTapsRequired == 1) {
        [_photoViewerModelWindow dismissWithAnimated:YES];
    }
}

- (LvModelWindow *)photoViewerModelWindow
{
    if (!_photoViewerModelWindow) {
        LvModelWindow *win = [[LvModelWindow alloc]initWithPreferStatusBarHidden:YES
                                                    supportedOrientationPortrait:YES
                                          supportedOrientationPortraitUpsideDown:NO
                                               supportedOrientationLandscapeLeft:NO
                                              supportedOrientationLandscapeRight:NO];
        win.modelWindowDelegate = self;
        _photoViewerModelWindow = win;
        
        if (!_photoViewer) {
            LvPhotoViewerView *photoViewer = [[LvPhotoViewerView alloc]initWithFrame:win.windowRootView.bounds];
            photoViewer.delegate = self;
            photoViewer.backgroundColor = [UIColor blackColor];
            photoViewer.frame = win.windowRootView.bounds;
            photoViewer.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
            [win.windowRootView addSubview:photoViewer];
            _photoViewer = photoViewer;
        }
    }
    return _photoViewerModelWindow;
}

#pragma mark - LvModelWindowDelegate

- (void)modelWindowDidShow:(LvModelWindow *)modelWindow
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)modelWindowDidDismiss:(LvModelWindow *)modelWindow
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - LvPhotoViewerViewDelegate

- (NSUInteger)numbersOfPhotoItem:(LvPhotoViewerView *)viewer
{
    return self.prismInfo.imageList.count;
}

- (void)        photoViewer:(LvPhotoViewerView *)viewer
   willShowPhotoOnImageView:(UIImageView *)imageView
                    atIndex:(NSUInteger)index
{
    NSArray *imageUrlList = self.prismInfo.imageList;
    if (index < imageUrlList.count) {
        NSString *imageUrl = imageUrlList[index];
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                                NAServerBaseUrl,
                                                imageUrl]];
        [imageView setImageWithURL:imageURL];
    }
}

@end
