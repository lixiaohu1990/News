//
//  NewsFilmDetailCell.m
//  News
//
//  Created by 彭光波 on 15-4-2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NewsFilmDetailCell.h"
#import "NSString+lv.h"
#import "UIColor+lv.h"

NSString *const NewsFilmDetailCellVideoItemSelectNotification = @"NewsFilmDetailCellVideoItemSelectNotification";
NSString *const NewsFilmDetailCellSelectedVideoItemIndexKey = @"NewsFilmDetailCellSelectedVideoItemIndex";

@interface NewsFilmDetailVideoItmCell : UICollectionViewCell
@property (nonatomic, readonly) UILabel *textLabel;
@end

@implementation NewsFilmDetailVideoItmCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupNewsFilmDetailVideoItmCell];
    }
    return self;
}

- (void)setupNewsFilmDetailVideoItmCell
{
    UILabel *textLabel = [[UILabel alloc]initWithFrame:self.bounds];
    textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont systemFontOfSize:11.f];
    [self.contentView addSubview:textLabel];
     _textLabel = textLabel;
}

@end


// 点击展开其他视频的按钮
static const CGFloat NewsFilmDetailCellExpandOtherVideoButnWidth = 70.f;
static NSString *const NewsFilmDetailVideoItmCellIdentifier = @"NewsFilmDetailVideoItmCell";
static const NSUInteger NewsFilmDetailVideoItmCellNumPerRow = 10;

@interface NewsFilmDetailCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) NSLayoutConstraint *descLabelHeightConstaint;
@property (nonatomic, weak) NSLayoutConstraint *videoCollectionViewHeightConstraint;

@end

@implementation NewsFilmDetailCell

- (void)awakeFromNib {
    [self setupNewsFilmDetailCell];
}

- (void)setupNewsFilmDetailCell
{
    self.playerContaintView.backgroundColor = [UIColor clearColor];
    
    self.videoCollectionView.delegate = self;
    self.videoCollectionView.dataSource = self;
    self.videoCollectionView.backgroundColor = [UIColor clearColor];
    [self.videoCollectionView registerClass:[NewsFilmDetailVideoItmCell class] forCellWithReuseIdentifier:NewsFilmDetailVideoItmCellIdentifier];
}

- (void)setNews:(NANewsResp *)news
{
    _news = news;
    
    // TODO: 计算描述内容的高度
    
    // TODO: 计算videoCollectionView的高度
}

- (void)setExpandAllVideo:(BOOL)expandAllVideo
{
    _expandAllVideo = expandAllVideo;
    
    // TODO:计算展开后的高度
    
}

- (void)setPlayingVideoIndex:(NSUInteger)playingVideoIndex
{
    _playingVideoIndex = playingVideoIndex;
    [self.videoCollectionView reloadData];
}

+ (CGFloat)cellHeightWithNews:(NANewsResp *)news
               expandAllVideo:(BOOL)expandAllVideo
                    cellWidth:(CGFloat)cellWidth
{
    // TODO:计算高度
    return 0;
}

+ (CGFloat)calculateDescriptionLabelHeightWithContent:(NSString *)content
                                            cellWidth:(CGFloat)cellWidth
{
    CGSize descSize = [content sizeWithConstraintWidth:(cellWidth - 2*8) font:[UIFont systemFontOfSize:13.f]];
    return descSize.height;
}

+ (CGFloat)calculateVideoCollectionViewHeightWithVideoNum:(NSUInteger)videoNum
                                           expandAllVideo:(BOOL)expandAllVideo
                                                cellWidth:(CGFloat)cellWidth
{
    // 计算高度
    // FIXME: 暂时忽略expandAllVideo的情况，全部展开
    
    
    return 0;
}

#pragma mark - Video collection view data source and delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger count = self.news.videoList.count;
    return count>0?1:0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.news.videoList.count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewsFilmDetailVideoItmCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NewsFilmDetailVideoItmCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%02d", indexPath.row + 1];
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    if (self.playingVideoIndex == indexPath.row) {
        cell.backgroundColor = [UIColor blackColor];
    } else {
        cell.backgroundColor = [UIColor colorFromRGB:(0x058b80)];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat collectionViewWidth = CGRectGetWidth(collectionView.frame);
    
    CGFloat cellWidth = ((collectionViewWidth - 8*2) - (NewsFilmDetailVideoItmCellNumPerRow - 1)*8)/NewsFilmDetailVideoItmCellNumPerRow;
    
    return CGSizeMake(cellWidth, cellWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    return insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NewsFilmDetailCellVideoItemSelectNotification object:self userInfo:@{NewsFilmDetailCellSelectedVideoItemIndexKey:@(indexPath.row)}];
}

@end
