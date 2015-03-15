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
 
 http://115.29.248.18:8080/NewsAgency/rest?method=publishComment&newsId=1&text=很好  发评论
 */
@interface NAApiSaveComment : NAUrlEncodeParamApi

@property (nonatomic, readonly) int userId;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) int nsId;
@property (nonatomic, readonly) NSString *type;

- (instancetype)initWithText:(NSString *)text nsId:(NSInteger)nsId;

@end
