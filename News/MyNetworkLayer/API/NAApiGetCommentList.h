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
@property (nonatomic, readonly) NSInteger page;
// 页码
@property (nonatomic, readonly) NSInteger rows;

- (instancetype)initWithPage:(NSInteger)page rows:(NSInteger)rows newsID:(NSInteger)newsID;

@end
