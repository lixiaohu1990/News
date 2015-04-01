//
//  NANewsResp.h
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAApiRespBaseEntity.h"

@interface NANewsResp : NAApiRespBaseEntity

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *nsDescription;
@property (nonatomic) long long releaseDate;
@property (nonatomic) NSString *imageUrl;
@property (nonatomic) NSString *videoUrl;
@property (nonatomic) NSString *flowId;
@property (nonatomic) NSString *favoriteFlag;
@property (nonatomic) int commentCount;
@property (nonatomic) NSArray *imageList;
@property (nonatomic) NSString *tag;
@property (nonatomic) NSString *author;

/**
 *  Item类型为NAVideo的NSArray
 */
@property (nonatomic) NSArray *videoList;

@end

@interface NAVideo : NSObject

@property (nonatomic) NSString *vDescription;
@property (nonatomic) NSString *videoUrl;
@property (nonatomic) NSString *name;
@property (nonatomic) int number;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
