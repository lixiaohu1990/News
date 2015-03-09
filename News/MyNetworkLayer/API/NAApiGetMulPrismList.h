//
//  NAApiGetMulPrismList.h
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAUrlEncodeParamApi.h"
#import "NAMulPrismResp.h"

/**
 *  获取多棱镜列表，返回NSArray, 其item类型为NAMulPrismResp
 */
@interface NAApiGetMulPrismList : NAUrlEncodeParamApi

// 页大小
@property (nonatomic, readonly) int page;
// 页码
@property (nonatomic, readonly) int rows;

- (instancetype)initWithPage:(int)page rows:(int)rows;

@end
