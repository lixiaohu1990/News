//
//  NAUser.h
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NABaseModel.h"

/**
 *  用户信息model
 */


@interface NAUser : NABaseModel

@property (nonatomic) NSString *password;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *imageUrl;
@property (nonatomic) NSString *realName;
@property (nonatomic) NSString *mobile;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *sex;
@property (nonatomic) NSString *address;
@property (nonatomic) BOOL accountNonExpired;
@property (nonatomic) BOOL accountNonLocked;
@property (nonatomic) BOOL credentialsNonExpired;
@property (nonatomic) BOOL enabled;
@property (nonatomic) NSString *flowId;

- (instancetype)initWithItemId:(int)itemId version:(NSString *)version createdBy:(int)createdBy createdDate:(int)createdDate lastModifiedBy:(int)lastModifiedBy lastModifiedDate:(int)lastModifiedDate isNew:(BOOL)isNew password:(NSString *)password username:(NSString *)username imageUrl:(NSString *)imageUrl realName:(NSString *)realName mobile:(NSString *)mobile email:(NSString *)email nickName:(NSString *)nickName city:(NSString *)city sex:(NSString *)sex address:(NSString *)address accountNonExpired:(BOOL)accountNonExpired accountNonLocked:(BOOL)accountNonLocked credentialsNonExpired:(BOOL)credentialsNonExpired enabled:(BOOL)enabled flowId:(NSString *)flowId;

@end
