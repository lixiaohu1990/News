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
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor whiteColor];
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
static const CGFloat VideoTouchItemMinimumLineSpacing = 8.f;
static const CGFloat VideoTouchItemMinimumInteritemSpacing = 8.f;

@interface NewsFilmDetailCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *playerContaintViewHeightConstraint;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descLabel;
@property (nonatomic, weak) IBOutlet UICollectionView *videoCollectionView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *descLabelHeightConstaint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *videoCollectionViewHeightConstraint;

@end

@implementation NewsFilmDetailCell

- (void)awakeFromNib {
    [self setupNewsFilmDetailCell];
}

- (void)setupNewsFilmDetailCell
{
    self.playerContaintView.backgroundColor = [UIColor clearColor];
    
    self.descLabel.numberOfLines = 0;
    
    self.videoCollectionView.delegate = self;
    self.videoCollectionView.dataSource = self;
    self.videoCollectionView.backgroundColor = [UIColor clearColor];
    [self.videoCollectionView registerClass:[NewsFilmDetailVideoItmCell class] forCellWithReuseIdentifier:NewsFilmDetailVideoItmCellIdentifier];
}

- (void)setPlayerContaintViewHeight:(CGFloat)playerContaintViewHeight
{
    _playerContaintViewHeight = playerContaintViewHeight;
    self.playerContaintViewHeightConstraint.constant = playerContaintViewHeight;
}

- (void)setNews:(NANewsResp *)news
{
    _news = news;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@  共%d集",
                            news.name,
                            (int)news.videoList.count];
    self.descLabel.text = news.nsDescription;
    [self.videoCollectionView reloadData];
    
    CGFloat cellWidth = CGRectGetWidth(self.contentView.frame);
    // 重新设置描述内容的高度
    CGFloat descHeight = [NewsFilmDetailCell calculateDescriptionLabelHeightWithContent:news.nsDescription cellWidth:cellWidth];
    self.descLabelHeightConstaint.constant = descHeight;
    
    // 重新设置videoCollectionView的高度
    CGFloat collectionViewHeight = [NewsFilmDetailCell calculateVideoCollectionViewHeightWithVideoNum:news.videoList.count expandAllVideo:YES cellWidth:cellWidth];
    self.videoCollectionViewHeightConstraint.constant = collectionViewHeight;
    
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

+ (CGFloat)cellHeightWithVideoContaintViewHeight:(CGFloat)videoContaintViewHeight
                                            News:(NANewsResp *)news
                                  expandAllVideo:(BOOL)expandAllVideo
                                       cellWidth:(CGFloat)cellWidth
{
    // 计算高度
    CGFloat videoPlayViewHeight = videoContaintViewHeight;
    
    CGFloat descHeight = [self calculateDescriptionLabelHeightWithContent:news.nsDescription cellWidth:cellWidth];
    
    CGFloat collectionViewHeight = [self calculateVideoCollectionViewHeightWithVideoNum:news.videoList.count expandAllVideo:expandAllVideo cellWidth:cellWidth];
    
    return videoPlayViewHeight/*播放器高度*/ + 8/*间隔*/ + [self titleLabelHeight]/*title高度*/ + 8/*间隔*/ + descHeight/*内容高度*/ + 8/*间隔*/ + collectionViewHeight/*视频每集touchItem高度*/ + 8/*间隔*/;
}

+ (CGFloat)titleLabelHeight
{
    return 22.f;
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
    NSUInteger row = ceilf((CGFloat)videoNum/(CGFloat)NewsFilmDetailVideoItmCellNumPerRow);
    
    CGSize videoTouchItemSize = [self videoTouchItemSizeWithCellWidth:cellWidth];
    
    if (row > 0) {
        return row*videoTouchItemSize.height + (row - 1) * VideoTouchItemMinimumLineSpacing;
    }
    return 0;
}

+ (CGSize)videoTouchItemSizeWithCellWidth:(CGFloat)cellWidth
{
    CGFloat collectionViewWidth = cellWidth - 2*8;
    
    CGFloat itemWidth = ((collectionViewWidth - 8*2) - (NewsFilmDetailVideoItmCellNumPerRow - 1)*8)/NewsFilmDetailVideoItmCellNumPerRow;
    
    return CGSizeMake(itemWidth, itemWidth);
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
    cell.textLabel.text = [NSString stringWithFormat:@"%02d",
                           indexPath.row + 1];
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    if (self.playingVideoIndex == indexPath.row) {
        cell.textLabel.backgroundColor = [UIColor blackColor];
    } else {
        cell.textLabel.backgroundColor = [UIColor colorFromRGB:(0x058b80)];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [NewsFilmDetailCell videoTouchItemSizeWithCellWidth:CGRectGetWidth(self.frame)];
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
    return VideoTouchItemMinimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return VideoTouchItemMinimumInteritemSpacing;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NewsFilmDetailCellVideoItemSelectNotification object:self userInfo:@{NewsFilmDetailCellSelectedVideoItemIndexKey:@(indexPath.row)}];
}

@end
