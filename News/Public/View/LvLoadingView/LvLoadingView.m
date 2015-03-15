//
//  LvLoadingView.m
//  CommunityDemo
//
//  Created by guangbo on 14/12/9.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import "LvLoadingView.h"

// label和菊花图标的间距
static const CGFloat LvLoadingViewLabelMarginActivityIndicatorView = 8;

@interface LvLoadingView ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

- (void)setupLoadingView;

@end

@implementation LvLoadingView

- (instancetype)init
{
    if (self = [super init]) {
        [self setupLoadingView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupLoadingView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupLoadingView];
    }
    return self;
}

- (void)setupLoadingView
{
    _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidesWhenStopped = YES;
    [self addSubview:_activityIndicatorView];
    
    _textLabel = [[UILabel alloc]init];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.numberOfLines = 1;
    _textLabel.textColor = [UIColor grayColor];
    [self addSubview:_textLabel];
    
    [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _textLabel.textColor = textColor;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    _activityIndicatorView.activityIndicatorViewStyle = activityIndicatorViewStyle;
}

- (void)setLoading:(BOOL)loading
{
    _loading = loading;
    if (loading)
        [_activityIndicatorView startAnimating];
    else
        [_activityIndicatorView stopAnimating];
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textLabel.text = text;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat activityViewWidth = CGRectGetWidth(_activityIndicatorView.frame);
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat constraintWidth = viewWidth - activityViewWidth - LvLoadingViewLabelMarginActivityIndicatorView;
    if (constraintWidth < 0) {
        constraintWidth = MAXFLOAT;
    }
    
    // 居中处理
    CGSize labelSize = [_textLabel.text sizeWithConstraintWidth:constraintWidth font:_textLabel.font];
    
    CGFloat startX = (viewWidth - (labelSize.width + activityViewWidth + LvLoadingViewLabelMarginActivityIndicatorView))/2;
    if (startX < 0) {
        startX = 0;
    }
    _activityIndicatorView.frame = CGRectMake(startX,
                                              0,
                                              CGRectGetWidth(_activityIndicatorView.frame),
                                              CGRectGetHeight(_activityIndicatorView.frame));
    _activityIndicatorView.center = CGPointMake(_activityIndicatorView.center.x, CGRectGetMidY(self.bounds));
    
    _textLabel.frame = CGRectMake(CGRectGetMaxX(_activityIndicatorView.frame) + LvLoadingViewLabelMarginActivityIndicatorView,
                                  0,
                                  labelSize.width,
                                  CGRectGetHeight(self.frame));
}

@end
