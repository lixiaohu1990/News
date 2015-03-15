//
//  NAAPIGetTag.m
//  News
//
//  Created by 李小虎 on 15/3/14.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAAPIGetTag.h"

@implementation NAAPIGetTag
- (instancetype)initWithSelf{
    self = [super initWithApiMethod:@"gt" paramDictioanry:nil httpMethod:HTTP_METHOD_POST];
    return self;

}
@end
