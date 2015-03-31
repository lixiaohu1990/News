//
//  PrismFooter.m
//  News
//
//  Created by 彭光波 on 15-3-28.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "PrismFooter.h"
#import "NSString+lv.h"

#define PrismFooterCOntentLabelFont [UIFont systemFontOfSize:14.f]

@interface PrismFooter ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *contentLabel;
@property (nonatomic) NSLayoutConstraint *contentLabelHeightConstraint;

@end

@implementation PrismFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupPrismFooter];
    }
    return self;
}

- (void)setupPrismFooter
{
    UILabel *titleLabel = [[UILabel alloc]init];
    self.titleLabel = titleLabel;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:19];
    [self addSubview:titleLabel];
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[titleLabel]-22-|" options:0 metrics:nil views:@{@"titleLabel":titleLabel}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:20]];
    [titleLabel addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:25]];
    
    
    UILabel *contentLabel = [[UILabel alloc]init];
    self.contentLabel = contentLabel;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.font = PrismFooterCOntentLabelFont;
    contentLabel.numberOfLines = 0;
    [self addSubview:contentLabel];
    
    contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[contentLabel]-22-|" options:0 metrics:nil views:@{@"contentLabel":contentLabel}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:8]];
    self.contentLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:contentLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:40];
    [contentLabel addConstraint:self.contentLabelHeightConstraint];
    
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    self.contentLabel.text = content;
    self.contentLabelHeightConstraint.constant = [PrismFooter heightForContentLabelWithContent:content constraintWidth:CGRectGetWidth(self.contentLabel.frame)];
}

+ (CGFloat)heightForContentLabelWithContent:(NSString *)content
                            constraintWidth:(CGFloat)constraintWidth
{
    CGSize contentSize = [content sizeWithConstraintWidth:constraintWidth
                                                     font:PrismFooterCOntentLabelFont];
    return contentSize.height;
}

+ (CGFloat)footerHeightForContent:(NSString *)content
                  constraintWidth:(CGFloat)constraintWidth
{
    return (20.f + 25.f + 8.f + [self heightForContentLabelWithContent:content
                                                       constraintWidth:constraintWidth]);
}

@end
