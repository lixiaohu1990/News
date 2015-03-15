//
//  NACommentResp.m
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NACommentResp.h"

@implementation NACommentResp

- (instancetype)initWithRespDictionay:(NSDictionary *)respDictionay
{
    if (self = [super initWithRespDictionay:respDictionay]) {
        self.user = [[NAUser alloc]initWithApiRespDictionary:respDictionay[@"user"]];
        self.userName = respDictionay[@"username"];
        self.text = respDictionay[@"text"];
        self.news = [[NANews alloc]initWithApiRespDictionary:respDictionay[@"news"]];
        self.type = respDictionay[@"type"];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        //用[NSDate date]可以获取系统当前时间
//        NSDate *dateStr = [dateFormatter dateFromString:respDictionay[@"createdDate"]];
//        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[respDictionay[@"createdDate"] longValue]]];
        double date = [respDictionay[@"createdDate"] doubleValue]/1000.f;
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
        //输出格式为：2010-10-27 10:22:13
//        NSLog(@"%@",currentDateStr);
        
        self.createdDate = currentDateStr;
        

    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{user:%@, text:%@, news:%@, type:%@}",
            self.user,
            self.text,
            self.news,
            self.type];
}

@end
