//
//  NAApiGetMulPrism.h
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAUrlEncodeParamApi.h"
#import "NAMulPrismResp.h"

/**
 *  获取多棱镜详情，返回NAMulPrismResp
 */
@interface NAApiGetMulPrism : NAUrlEncodeParamApi

@property (nonatomic, readonly) int itemId;

- (instancetype)initWithItemId:(int)itemId;

@end
