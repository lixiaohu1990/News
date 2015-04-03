//
//  NewsCommentCell.h
//  News
//
//  Created by 彭光波 on 15-4-2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCommentCell : UITableViewCell

@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *userType;
@property (nonatomic) NSString *dateText;
@property (nonatomic) NSString *comment;

+ (CGFloat)cellHeightWithComment:(NSString *)comment cellWidth:(CGFloat)cellWidth;

@end
