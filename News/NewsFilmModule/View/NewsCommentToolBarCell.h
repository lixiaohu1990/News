//
//  NewsCommentToolBarCell.h
//  News
//
//  Created by 彭光波 on 15-4-2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  新闻评论工具条cell
 */
@interface NewsCommentToolBarCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *commentNumLabel;
@property (nonatomic, weak) IBOutlet UIButton *publishCommentButn;
@property (nonatomic, weak) IBOutlet UITextField *commentField;

// 评论框是否收缩
@property (nonatomic) BOOL willingCommentFieldShrink;

+ (CGFloat)cellHeightWithCommentFieldShrink:(BOOL)commentFieldShrink;

@end
