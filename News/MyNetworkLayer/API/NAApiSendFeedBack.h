//
//  NAApiSendFeedBack.h
//  News
//
//  Created by 李小虎 on 15/3/14.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAUrlEncodeParamApi.h"

@interface NAApiSendFeedBack : NAUrlEncodeParamApi
@property(nonatomic, strong)NSString *contentStr;
- (instancetype)initWithContentStr:(NSString *)contentStr;
@end
