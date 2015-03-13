//
//  PrismPageVC.m
//  PrismDemo
//
//  Created by 彭光波 on 15-3-12.
//  Copyright (c) 2015年 pengguangbo. All rights reserved.
//

#import "PrismPageVC.h"
#import "NAApiGetNewsList.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "NSString+lv.h"

static const NSUInteger PrismSizePerRow = 3;
static const CGFloat PrismCollectionViewSectionHorizonPadding = 22.f;
static const CGFloat PrismCollectionViewSectionPaddingTop = 20.f;
static const CGFloat PrismCollectionViewCellHorizonSpacing = 10.f;

#ifndef BASE_IMAGE_URL
#define BASE_IMAGE_URL @"http://115.29.248.18:8080/NewsAgency"
#endif

#ifndef PAGENO
#define PAGENO 1
#endif

#ifndef PAGESIZE
#define PAGESIZE 20
#endif

/**
 *  PrismCell
 */
@interface PrismCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView *prismImageView;
@end

@implementation PrismCell

@end

/**
 *
 */
@interface PrismHeader : UICollectionReusableView
@property (nonatomic, weak) IBOutlet UIImageView *prismImageView;
@end

@implementation PrismHeader

@end

@interface PrismPageVC () <UICollectionViewDataSource, UICollectionViewDelegate>

// 用于展示图片的collection视图
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
// 底部容器视图
@property (nonatomic, weak) IBOutlet UIView *bottomContainnerView;
@property (nonatomic, weak) IBOutlet UILabel *prismTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *prismContentLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *prismContentLabelHeightConst;

// 获取多棱镜状态视图
@property (nonatomic) UIActivityIndicatorView *getPrismIndicatorView;

@end

@implementation PrismPageVC

- (instancetype)initFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Prism" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"PrismPageVC"];
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupGetPrismIndicatorView];
    
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setupGetPrismIndicatorView
{
    if (!self.getPrismIndicatorView) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        indicatorView.hidesWhenStopped = YES;
        indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:indicatorView];
        
        // 设置约束
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:indicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        self.getPrismIndicatorView = indicatorView;
    }
}

- (void)setIsLoading:(BOOL)isLoading
{
    _isLoading = isLoading;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isLoading) {
            [self.getPrismIndicatorView startAnimating];
        } else {
            [self.getPrismIndicatorView stopAnimating];
        }
    });
}

- (void)setPrismInfo:(NANewsResp *)prismInfo
{
    [self setPrismInfo:prismInfo animated:NO];
}

- (void)setPrismInfo:(NANewsResp *)prismInfo animated:(BOOL)animated
{
    _prismInfo = prismInfo;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!prismInfo) {
            void(^doAnimation)() = ^{
                self.collectionView.alpha = 0;
                self.bottomContainnerView.alpha = 0;
            };
            if (animated) {
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    doAnimation();
                } completion:nil];
            } else {
                doAnimation();
            }
        } else {
            
            // 把信息设置到页面
            void(^doAnimation)() = ^{
                self.collectionView.alpha = 1;
                self.bottomContainnerView.alpha = 1;
            };
            if (animated) {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.collectionView.alpha = 0.3;
                    self.bottomContainnerView.alpha = 0.3;
                } completion:^(BOOL finished){
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        doAnimation();
                    } completion:nil];
                }];
            } else {
                doAnimation();
            }
            
            [self.collectionView reloadData];
            self.prismTitleLabel.text = prismInfo.name;
            
            self.prismContentLabel.text = prismInfo.nsDescription;
            CGSize despSize = [prismInfo.nsDescription sizeWithConstraintWidth:CGRectGetWidth(self.prismContentLabel.frame) font:self.prismContentLabel.font];
            self.prismContentLabelHeightConst.constant = despSize.height;
        }
    });
}

#pragma mark - Collect view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.prismInfo.imageList.count;
    if (count > 0) {
        return count - 1;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PrismCell *prismCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PrismCell"
                                                                     forIndexPath:indexPath];
    NSString *imageUrl = self.prismInfo.imageList[indexPath.row + 1];
    NSURL *imageURL = nil;
    if (imageUrl) {
        imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                         BASE_IMAGE_URL,
                                         imageUrl]];
    }
    [prismCell.prismImageView setImageWithURL:imageURL];
    
    return prismCell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.prismInfo.imageList.count > 0)
        return 1;
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSInteger count = self.prismInfo.imageList.count;
        if (count > 0) {
            PrismHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"PrismHeader" forIndexPath:indexPath];
            header.prismImageView.clipsToBounds = YES;
            // 头一张大图
            NSString *imageUrl = self.prismInfo.imageList[0];
            // load image
            NSURL *imageURL = nil;
            if (imageUrl) {
                imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                                 BASE_IMAGE_URL,
                                                 imageUrl]];
            }
            [header.prismImageView setImageWithURL:imageURL];
            reusableView = header;
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

@end
