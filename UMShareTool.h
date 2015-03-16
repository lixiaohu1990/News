//
//  UMShareTool.h
//  News
//
//  Created by 李小虎 on 15/3/16.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"

@interface UMShareTool : NSObject

/*
 control 要实现UMSocialUIDelegate协议
 
 shareText:要分享的文字内容  传nil使用默认的文字
 
 imageName:分享的图标， 传nil时表示使用默认的icon图标
 */
+(void)initWechatshareWithController:(UIViewController *)control shareText:(NSString *)shareText shareImageName:(NSString *)imageName;


@end
