//
//  LvPhotoItemScrollView.h
//  CommunityDemo
//
//  Created by guangbo on 14/12/1.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  LvPhotoItemScrollView的tap手势通知
 */
extern NSString * const LvPhotoItemScrollViewTappedNotification;

/**
 *  图片item滚动视图
 */
@interface LvPhotoItemScrollView : UIScrollView

@property (nonatomic, readonly) UIImageView *photoView;

- (instancetype)initWithFrame:(CGRect)frame photoView:(UIImageView *)photoView;

@end
