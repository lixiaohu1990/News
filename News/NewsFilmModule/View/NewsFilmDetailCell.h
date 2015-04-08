//
//  NewsFilmDetailCell.h
//  News
//
//  Created by 彭光波 on 15-4-2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NANewsResp.h"

// 视频选择的通知,通过userInfo中的NewsFilmDetailCellSelectedVideoItemIndexKey获取NSNumber类型的选中信息
extern NSString *const NewsFilmDetailCellVideoItemSelectNotification;
extern NSString *const NewsFilmDetailCellSelectedVideoItemIndexKey;

@interface NewsFilmDetailCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *playerContaintView;

@property (nonatomic) CGFloat playerContaintViewHeight;

@property (nonatomic) NANewsResp *news;
// 是否展开所有视频
@property (nonatomic) BOOL expandAllVideo;

@property (nonatomic) NSUInteger playingVideoIndex;

+ (CGFloat)cellHeightWithVideoContaintViewHeight:(CGFloat)videoContaintViewHeight
                                            News:(NANewsResp *)news
                                  expandAllVideo:(BOOL)expandAllVideo
                                       cellWidth:(CGFloat)cellWidth;

@end
