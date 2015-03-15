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

/**
 *  单个多棱镜View
 */
@interface PrismCellView : UICollectionViewCell

/**
 *  通过设置多棱镜信息更新界面展示的数据信息
 */
@property (nonatomic) NANewsResp *prismInfo;

@end
