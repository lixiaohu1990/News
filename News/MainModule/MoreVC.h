//
//  MoreVC.h
//  News
//
//  Created by 彭光波 on 15-3-19.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  字号设置变化的通知，在通知的userInfo中通过NAArticleFontSizeKey获取类型为NSNumber的字号
 */
extern NSString *const NAArticleFontSizeChangedNotification;
extern NSString *const NAArticleFontSizeKey;


@class MoreVC;
@protocol MoreVCDelegate <NSObject>

@optional
- (void)menuNewsFilmButnClick:(MoreVC *)moreVC;
- (void)menuBigEventButnClick:(MoreVC *)moreVC;
- (void)menuPrismButnClick:(MoreVC *)moreVC;
- (void)menuLoginButnClick:(MoreVC *)moreVC;
- (void)menuSettingButnClick:(MoreVC *)moreVC;
- (void)menuFavorButnClick:(MoreVC *)moreVC;
- (void)menuSubscribeButnClick:(MoreVC *)moreVC;
- (void)menuTemplateButnClick:(MoreVC *)moreVC;

@end

@interface MoreVC : UIViewController

@property (nonatomic, weak) id<MoreVCDelegate> delegate;

- (instancetype)initFromStoryboard;

@end
