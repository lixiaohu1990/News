//
//  NAApiGetCommentList.h
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAUrlEncodeParamApi.h"
#import "NACommentResp.h"

// 获取评论列表，返回一个NSArray，其item类型为NACommentResp类型
@interface NAApiGetCommentList : NAUrlEncodeParamApi

// 页大小
@property (nonatomic, readonly) int page;
// 页码
@property (nonatomic, readonly) int rows;

- (instancetype)initWithPage:(int)page rows:(int)rows;

@end
