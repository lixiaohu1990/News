//
//  ImageScrollView.h
//  IYiMing
//
//  Created by lee on 14/12/2.
//  Copyright (c) 2014年 lee. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol ImageScrollViewDelegate;
@protocol ImageScrollViewDataSource;

@interface ImageScrollView : UIView

@property (nonatomic, weak) id<ImageScrollViewDelegate> delegate;
@property (nonatomic, weak) id<ImageScrollViewDataSource> dataSource;

- (void)reloadData;
- (void)clear;

@end

@protocol ImageScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(ImageScrollView *)view atIndex:(NSInteger)index;
- (void)updateCurPageAtIndex:(NSInteger)index;
- (void)didFinishChange;
@end

@protocol ImageScrollViewDataSource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;

@end