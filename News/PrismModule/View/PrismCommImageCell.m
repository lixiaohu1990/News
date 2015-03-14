//
//  PrismCommImageCell.m
//  PrismDemo
//
//  Created by 彭光波 on 15-3-14.
//  Copyright (c) 2015年 pengguangbo. All rights reserved.
//

#import "PrismCommImageCell.h"

@implementation PrismCommImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupPrismCommImageCell];
    }
    return self;
}

- (void)setupPrismCommImageCell
{
    // 设置imageView
    UIImageView *pImageV = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
    pImageV.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    pImageV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:pImageV];
    _pImageView = pImageV;
    
    UIActivityIndicatorView *actyIndicatorV = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actyIndicatorV.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    actyIndicatorV.hidesWhenStopped = YES;
    [self.contentView addSubview:actyIndicatorV];
    _pActyIndicatorView = actyIndicatorV;
    
    self.contentView.clipsToBounds = YES;
}

@end
