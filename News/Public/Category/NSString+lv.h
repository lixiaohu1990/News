//
//  NSString+lv.h
//  CommunityDemo
//
//  Created by guangbo on 14/11/21.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (lv)

/**
 *  文字尺寸计算
 *
 *  @param constraintWidth 宽度约束
 *  @param textFont        字体
 *
 *  @return 文字的尺寸
 */
- (CGSize)sizeWithConstraintWidth:(CGFloat)constraintWidth
                             font:(UIFont *)textFont;

- (NSString *)trimWhitespace;

- (NSUInteger)numberOfLines;

+ (NSString *)uuid;

@end
