//
//  UMShareTool.m
//  News
//
//  Created by 李小虎 on 15/3/16.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "UMShareTool.h"

@interface UMShareTool ()

@end
@implementation UMShareTool

+ (void)initWechatshareWithController:(UIViewController *)control shareText:(NSString *)shareText shareImageName:(NSString *)imageName{
    if (shareText == nil) {
        shareText = @"新闻局是一款集齐最新资讯的App，快来下载吧，www.umeng.com/social";
    }
    if (imageName == nil) {
        imageName = @"icon.png";
    }
    
    [UMSocialSnsService presentSnsIconSheetView:control
                                         appKey:UmengAppkey
                                      shareText:shareText
                                     shareImage:[UIImage imageNamed:imageName]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite]
                                       delegate:control];
}

@end
