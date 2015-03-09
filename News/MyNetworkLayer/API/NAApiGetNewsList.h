//
//  NAApiGetNewsList.h
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAUrlEncodeParamApi.h"
#import "NANewsResp.h"

/**
 *  获取新闻列表，返回NSArray, 其item的类型为NANewsResp
 */
@interface NAApiGetNewsList : NAUrlEncodeParamApi

@property (nonatomic, readonly) int type;
@property (nonatomic, readonly) int pageNo;
@property (nonatomic, readonly) int pageSize;

- (instancetype)initWithType:(int)type pageNo:(int)pageNo pageSize:(int)pageSize;

@end
