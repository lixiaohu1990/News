//
//  NAAPIGetTagList.m
//  News
//
//  Created by 李小虎 on 15/3/14.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAAPIGetTagList.h"
#import "NANewsResp.h"
@implementation NAAPIGetTagList
- (instancetype)initWithTag:(NSString *)tagStr{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (tagStr) {
        [params setObject:tagStr forKey:@"tag"];
    }
    if (self = [super initWithApiMethod:@"gtn" paramDictioanry:params httpMethod:HTTP_METHOD_POST]) {
        
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
