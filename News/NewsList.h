//
//  NewsList.h
//  News
//
//  Created by 李小虎 on 15/3/9.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsList : NSObject
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *imageUrl;
@property(nonatomic, strong)NSString *videoUrl;
+ (instancetype)newsListWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
