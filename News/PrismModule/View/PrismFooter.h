//
//  PrismFooter.h
//  News
//
//  Created by 彭光波 on 15-3-28.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PrismFooter : UICollectionReusableView

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *content;

/**
 *  计算高度
 */
+ (CGFloat)footerHeightForContent:(NSString *)content
                  constraintWidth:(CGFloat)constraintWidth;

@end
