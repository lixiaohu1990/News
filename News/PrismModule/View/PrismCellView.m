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

@interface PrismCellView () <UICollectionViewDataSource, UICollectionViewDelegate>

// 用于展示图片的collection视图
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
// 底部容器视图
@property (nonatomic, weak) IBOutlet UIView *bottomContainnerView;
@property (nonatomic, weak) IBOutlet UILabel *prismTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *prismContentLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *prismContentLabelHeightConst;

@property (nonatomic, weak) IBOutlet UIButton *cacheButn;
@property (nonatomic, weak) IBOutlet UIButton *shareButn;

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
    
    [_cacheButn addTarget:self
                   action:@selector(cacheButnClick:)
         forControlEvents:UIControlEventTouchUpInside];
    [_shareButn addTarget:self
                   action:@selector(shareButnClick:)
         forControlEvents:UIControlEventTouchUpInside];
}

- (void)setPrismInfo:(NANewsResp *)prismInfo
{
    _prismInfo = prismInfo;
    
    // 改变页面
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        
        self.prismTitleLabel.text = prismInfo.name;
        self.prismContentLabel.text = prismInfo.nsDescription;
        
        // 改变内容高度
        CGSize despSize = [prismInfo.nsDescription sizeWithConstraintWidth:CGRectGetWidth(self.prismContentLabel.frame) font:self.prismContentLabel.font];
        
        CGFloat finalHeight = despSize.height;
        CGFloat lineHeight = self.prismContentLabel.font.lineHeight;
        NSInteger row = ceilf(despSize.height/lineHeight);
        if (row > 2) {
            finalHeight = 2*lineHeight;
        }
        self.prismContentLabelHeightConst.constant = finalHeight;
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
        // 添加按钮
        [[NSNotificationCenter defaultCenter]postNotificationName:PrismCellViewMoreCellSelectedNotification object:self];
    }
}

@end
