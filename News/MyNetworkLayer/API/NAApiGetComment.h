//
//  NAApiGetComment.h
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAUrlEncodeParamApi.h"
#import "NACommentResp.h"

/**
 *  获取评论详情，返回的结果为NACommentResp类型
 */
@interface NAApiGetComment : NAUrlEncodeParamApi

@property (nonatomic, readonly) int itemId;

- (instancetype)initWithItemId:(int)itemId;

@end
