//
//  NAApiSendFeedBack.m
//  News
//
//  Created by 李小虎 on 15/3/14.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAApiSendFeedBack.h"
#import "NAApiError.h"
@implementation NAApiSendFeedBack

- (instancetype)initWithContentStr:(NSString *)contentStr{
    {
        if (self = [super initWithApiMethod:@"fb"
                            paramDictioanry:@{@"content":contentStr}
                                 httpMethod:HTTP_METHOD_POST]) {
            _contentStr = contentStr;
        }
        return self;
    }
}

@end
