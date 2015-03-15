//
//  NACommentResp.h
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAApiRespBaseEntity.h"
#import "NAUser.h"
#import "NANews.h"

/**
 *
 */
@interface NACommentResp : NAApiRespBaseEntity

@property (nonatomic) NAUser *user;
@property (nonatomic, strong)NSString *userName;
@property (nonatomic) NSString *text;
@property (nonatomic) NANews *news;
@property (nonatomic) NSString *type;
@property (nonatomic, strong)NSString *createdDate;
@end
