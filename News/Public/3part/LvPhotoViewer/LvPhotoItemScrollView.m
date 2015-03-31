//
//  LvPhotoItemScrollView.m
//  CommunityDemo
//
//  Created by guangbo on 14/12/1.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import "LvPhotoItemScrollView.h"

NSString *const LvPhotoItemScrollViewTappedNotification = @"LvPhotoItemScrollViewTappedNotification";

@interface LvPhotoItemScrollView ()

- (void)setupPhotoScrollView;

@end

@implementation LvPhotoItemScrollView

- (instancetype)initWithFrame:(CGRect)frame photoView:(UIImageView *)photoView
{
    if (self = [super initWithFrame:frame]) {
        _photoView = photoView;
        [self setupPhotoScrollView];
    }
    return self;
}

- (void)setupPhotoScrollView
{
    __weak id weakSelf = self;
    self.delegate = weakSelf;
    self.bouncesZoom = YES;
    self.maximumZoomScale = 2*self.minimumZoomScale;
    self.decelerationRate               = UIScrollViewDecelerationRateFast;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    [self addGestureRecognizers];
    
    if (_photoView) {
        _photoView.frame = self.bounds;
        _photoView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        [self addSubview:_photoView];
    }
}

#pragma mark - Scroll view delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _photoView;
}

#pragma mark - Gesture Recognizer

- (void)addGestureRecognizers
{
    __weak id weakSelf = self;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:weakSelf
                                                                               action:@selector(handleTapping:)];
    [self addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:weakSelf
                                                                               action:@selector(handleTapping:)];
    [doubleTap setNumberOfTapsRequired:2.0];
    [self addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

#pragma mark - Handle Tapping 

- (void)handleTapping:(UITapGestureRecognizer *)recognizer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LvPhotoItemScrollViewTappedNotification
                                                        object:recognizer];
    
    // 处理双击
    if (recognizer.numberOfTapsRequired == 2) {
        [self toogleZooming:recognizer];
    }
}

#pragma mark - Toggle Zooming

- (void)toogleZooming:(UITapGestureRecognizer *)recognizer
{
    if (self.minimumZoomScale == self.maximumZoomScale)
    {
        return;
    }
    else if (self.zoomScale > self.minimumZoomScale)
    {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
    else
    {
        [self zoomToRectWithScale:self.maximumZoomScale
                       withCenter:[recognizer locationInView:recognizer.view]
                         animated:YES];
    }
}

- (CGRect)zoomRectWithScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = [self.photoView frame].size.height / scale;
    zoomRect.size.width  = [self.photoView frame].size.width  / scale;
    
    center = [self.photoView convertPoint:center fromView:self];
    
    zoomRect.origin.x    = center.x - ((zoomRect.size.width / 2.0));
    zoomRect.origin.y    = center.y - ((zoomRect.size.height / 2.0));
    
    return zoomRect;
}

- (void)zoomToRectWithScale:(float)scale withCenter:(CGPoint)center animated:(BOOL)animated
{
    if (scale <= 0) {
        return;
    }
    CGRect zoomRect =
    [self zoomRectWithScale:scale
                 withCenter:center];
    
    [self zoomToRect:zoomRect animated:animated];
}

@end
