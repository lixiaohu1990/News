//
//  NAAPIGetTagList.h
//  News
//
//  Created by 李小虎 on 15/3/14.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAUrlEncodeParamApi.h"

@interface NAAPIGetTagList : NAUrlEncodeParamApi
- (instancetype)initWithTag:(NSString *)tagStr;
@end

/*
 http://115.29.248.18:8080/NewsAgency/rest?method=gtn&tag=社会   获取某标签的新闻列表
 */