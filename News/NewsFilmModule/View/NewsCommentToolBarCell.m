//
//  NewsCommentToolBarCell.m
//  News
//
//  Created by 彭光波 on 15-4-2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NewsCommentToolBarCell.h"

@interface NewsCommentToolBarCell ()

@end

@implementation NewsCommentToolBarCell

- (void)awakeFromNib
{
    [self setupNewsCommentToolBarCell];
}

- (void)setupNewsCommentToolBarCell
{
    self.clipsToBounds = YES;
}

- (void)setWillingCommentFieldShrink:(BOOL)willingCommentFieldShrink
{
    _willingCommentFieldShrink = willingCommentFieldShrink;
    self.commentField.hidden = willingCommentFieldShrink;
}

+ (CGFloat)cellHeightWithCommentFieldShrink:(BOOL)commentFieldShrink
{
    CGFloat height = 40 + (commentFieldShrink?0:(30 + 8));
    return height;
}

@end
