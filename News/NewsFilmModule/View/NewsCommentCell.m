//
//  NewsCommentCell.m
//  News
//
//  Created by 彭光波 on 15-4-2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NewsCommentCell.h"
#import "NSString+lv.h"

static const CGFloat NewsCommentCellHeightWithoutContent = 43.f;

@interface NewsCommentCell ()

@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *userTypeLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIView *contentContainner;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentContainnerHeightConstraint;

@end

@implementation NewsCommentCell

- (void)awakeFromNib {
    [self setupNewsCommentCell];
}

- (void)setupNewsCommentCell
{
    
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    self.userNameLabel.text = userName;
}

- (void)setUserType:(NSString *)userType
{
    _userType = userType;
    self.userTypeLabel.text = userType;
}

- (void)setDateText:(NSString *)dateText
{
    _dateText = dateText;
    self.dateLabel.text = dateText;
}

- (void)setComment:(NSString *)comment
{
    _comment = comment;
    self.contentLabel.text = comment;
    
    CGFloat commentLabelHeight = [NewsCommentCell contentLabelHeightWithComment:comment constraintWidth:CGRectGetWidth(self.contentLabel.frame)];
    
    CGFloat cellHeight = NewsCommentCellHeightWithoutContent + commentLabelHeight;
    self.contentContainnerHeightConstraint.constant = (cellHeight + 2*4.f);
}

+ (CGFloat)contentLabelHeightWithComment:(NSString *)comment constraintWidth:(CGFloat)constraintWidth
{
    UIFont *font = [UIFont boldSystemFontOfSize:12.f];
    CGSize commentLabelSize = [comment sizeWithConstraintWidth:constraintWidth
                                                          font:font];
    if (commentLabelSize.height < font.lineHeight) {
        return font.lineHeight;
    } else {
        return commentLabelSize.height;
    }
}

+ (CGFloat)cellHeightWithComment:(NSString *)comment cellWidth:(CGFloat)cellWidth
{
    CGFloat commentLabelHeight = [NewsCommentCell contentLabelHeightWithComment:comment constraintWidth:cellWidth - 2*22.f];
    CGFloat cellHeight = NewsCommentCellHeightWithoutContent + commentLabelHeight;
    return cellHeight;
}

@end
