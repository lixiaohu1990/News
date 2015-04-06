//
//  LvPhotoViewerView.h
//  CommunityDemo
//
//  Created by guangbo on 15/3/26.
//  Copyright (c) 2015年 1024. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LvPhotoItemScrollView.h"

@class LvPhotoViewerView;
@protocol LvPhotoViewerViewDelegate <NSObject>

@required

- (NSUInteger)numbersOfPhotoItem:(LvPhotoViewerView *)viewer;

@optional

/**
 *  将要显示图片
 *
 *  @param viewer
 *  @param imageView 将要显示的图片视图
 *  @param index     将要显示的图片所在索引
 */
- (void)        photoViewer:(LvPhotoViewerView *)viewer
   willShowPhotoOnImageView:(UIImageView *)imageView
                    atIndex:(NSUInteger)index;

@end

@interface LvPhotoViewerView : UIView

@property (nonatomic, weak) id<LvPhotoViewerViewDelegate> delegate;
@property (nonatomic) UIColor *pageIndicatorTintColor;
@property (nonatomic) UIColor *currentPageIndicatorTintColor;

/**
 *  当前页面索引
 */
@property (nonatomic, readonly) NSUInteger currentPage;

/**
 *  重新拉取数据
 */
- (void)reloadData;

/**
 *  视图滚动到某个位置
 *
 *  @param pageIndex
 *  @param animated
 */
- (void)scrollToPage:(NSUInteger)pageIndex animated:(BOOL)animated;

@end
