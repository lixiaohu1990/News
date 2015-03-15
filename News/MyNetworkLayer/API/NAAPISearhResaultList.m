//
//  NAAPISearhResaultList.m
//  News
//
//  Created by 李小虎 on 15/3/14.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAAPISearhResaultList.h"
#import "NANewsResp.h"
@implementation NAAPISearhResaultList
- (instancetype)initWithSearchStr:(NSString *)searchStr{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (searchStr) {
        [params setObject:searchStr forKey:@"name"];
    }
    if (self = [super initWithApiMethod:@"search" paramDictioanry:params httpMethod:HTTP_METHOD_POST]) {
        
    }
    return self;
    
}

- (CORRECT_RESULT_PARSER)apiCorrectResultParser
{
    return ^ NSArray* (NSDictionary *jsonResult){
        NSArray *nsResults = jsonResult[@"newsDetailList"];
        NSMutableArray *nsEntityResults = [NSMutableArray array];
        for (NSDictionary *nsDictionary in nsResults) {
            NANewsResp *nsResp = [[NANewsResp alloc]initWithRespDictionay:nsDictionary];
            if (nsResp) {
                [nsEntityResults addObject:nsResp];
            }
        }
        return nsEntityResults;
    };
}

@end
