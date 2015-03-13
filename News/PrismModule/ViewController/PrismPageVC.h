//
//  PrismPageVC.h
//  PrismDemo
//
//  Created by 彭光波 on 15-3-12.
//  Copyright (c) 2015年 pengguangbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NANewsResp.h"

@interface PrismPageVC : UIViewController

- (instancetype)initFromStoryboard;

/**
 *  如果设置为nil，那么显示正在获取的菊花，如果设置非空，那么显示出图片列表
 */
@property (nonatomic) NANewsResp *prismInfo;

/**
 *  设置加载状态
 */
@property (nonatomic) BOOL isLoading;

- (void)setPrismInfo:(NANewsResp *)prismInfo animated:(BOOL)animated;

@end
