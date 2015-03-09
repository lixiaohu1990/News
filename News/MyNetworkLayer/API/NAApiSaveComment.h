//
//  NAApiSaveComment.h
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAUrlEncodeParamApi.h"

/**
 *  保存评论，无关注请求结果
 */
@interface NAApiSaveComment : NAUrlEncodeParamApi

@property (nonatomic, readonly) int userId;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) int nsId;
@property (nonatomic, readonly) NSString *type;

- (instancetype)initWithUserId:(int)userId text:(NSString *)text nsId:(int)nsId type:(NSString *)type;

@end
