//
//  NAApiGetNews.h
//  News
//
//  Created by 彭光波 on 15-3-9.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAUrlEncodeParamApi.h"
#import "NANewsResp.h"

/**
 *  获取新闻详情, 返回NANewsResp
 */
@interface NAApiGetNews : NAUrlEncodeParamApi

@property (nonatomic, readonly) int itemId;
@property (nonatomic, readonly) int type;

- (instancetype)initWithItemId:(int)itemId type:(int)type;

@end
