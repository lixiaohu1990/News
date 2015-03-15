//
//  NAAPISearhResaultList.h
//  News
//
//  Created by 李小虎 on 15/3/14.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAUrlEncodeParamApi.h"

@interface NAAPISearhResaultList : NAUrlEncodeParamApi
- (instancetype)initWithSearchStr:(NSString *)searchStr;
@end
