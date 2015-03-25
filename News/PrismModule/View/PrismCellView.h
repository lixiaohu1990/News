//
//  PrismCellView.h
//  PrismDemo
//
//  Created by 彭光波 on 15-3-14.
//  Copyright (c) 2015年 pengguangbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NANewsResp.h"

// 多棱镜更多cell的点击通知
extern NSString *const PrismCellViewMoreCellSelectedNotification;

// 多棱镜缓存按钮的点击通知
extern NSString *const PrismCellViewCacheButnClickNotification;

// 多棱镜分享按钮的点击通知
extern NSString *const PrismCellViewShareButnClickNotification;

/**
 *  单个多棱镜View
 */
@interface PrismCellView : UICollectionViewCell

/**
 *  通过设置多棱镜信息更新界面展示的数据信息
 */
@property (nonatomic) NANewsResp *prismInfo;

/**
 *  通过设置已缓存信息更新界面的相关信息
 */
@property (nonatomic) BOOL prismHasCached;

@end
