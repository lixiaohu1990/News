//
//  NAUser.m
//  News
//
//  Created by 彭光波 on 15-3-8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NAUser.h"

static inline NSDictionary* NAUserApiRespAttributeMapping(){
    static NSDictionary *maps = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        maps = @{@"id":@"uid",
                 @"createdBy":@"createdBy",
                 @"createdDate":@"createdDate",
                 @"lastModifiedBy":@"lastModifiedBy",
                 @"lastModifiedDate":@"lastModifiedDate",
                 @"password":@"password",
                 @"username":@"username",
                 @"imageUrl":@"imageUrl",
                 @"realName":@"realName",
                 @"mobile":@"mobile",
                 @"email":@"email",
                 @"nickName":@"nickName",
                 @"city":@"city",
                 @"sex":@"sex",
                 @"address":@"address",
                 @"accountNonExpired":@"accountNonExpired",
                 @"accountNonLocked":@"accountNonLocked",
                 @"credentialsNonExpired":@"credentialsNonExpired",
                 @"enabled":@"enabled",
                 @"flowId":@"flowId",
                 @"new":@"isNew"};
    });
    return maps;
};

@implementation NAUser

- (instancetype)initWithItemId:(int)itemId version:(NSString *)version createdBy:(int)createdBy createdDate:(int)createdDate lastModifiedBy:(int)lastModifiedBy lastModifiedDate:(int)lastModifiedDate isNew:(BOOL)isNew password:(NSString *)password username:(NSString *)username imageUrl:(NSString *)imageUrl realName:(NSString *)realName mobile:(NSString *)mobile email:(NSString *)email nickName:(NSString *)nickName city:(NSString *)city sex:(NSString *)sex address:(NSString *)address accountNonExpired:(BOOL)accountNonExpired accountNonLocked:(BOOL)accountNonLocked credentialsNonExpired:(BOOL)credentialsNonExpired enabled:(BOOL)enabled flowId:(NSString *)flowId
{
    if (self = [super initWithItemid:itemId
                             version:version
                           createdBy:createdBy
                         createdDate:createdDate
                      lastModifiedBy:lastModifiedBy
                    lastModifiedDate:lastModifiedDate
                                isNew:isNew]) {
        self.password = password;
        self.username = username;
        self.imageUrl = imageUrl;
        self.realName = realName;
        self.mobile = mobile;
        self.email = email;
        self.nickName = nickName;
        self.city =city;
        self.sex = sex;
        self.address = address;
        self.accountNonExpired = accountNonExpired;
        self.accountNonLocked = accountNonLocked;
        self.credentialsNonExpired = credentialsNonExpired;
        self.enabled = enabled;
        self.flowId = flowId;
    }
    return self;
}

- (instancetype)initWithApiRespDictionary:(NSDictionary *)apiRespDictionay
{
    NSNumber *accountNonExpiredObj = apiRespDictionay[@"accountNonExpired"];
    NSNumber *accountNonLockedObj = apiRespDictionay[@"accountNonLocked"];
    NSNumber *credentialsNonExpiredObj = apiRespDictionay[@"credentialsNonExpired"];
    NSNumber *enabledObj = apiRespDictionay[@"enabled"];
    
    if (self = [super initWithApiRespDictionary:apiRespDictionay]) {
        
        self.password = apiRespDictionay[@"password"];
        self.username = apiRespDictionay[@"username"];
        self.imageUrl = apiRespDictionay[@"imageUrl"];
        self.realName = apiRespDictionay[@"realName"];
        self.mobile = apiRespDictionay[@"mobile"];
        self.email = apiRespDictionay[@"email"];
        self.nickName = apiRespDictionay[@"nickName"];
        self.city =apiRespDictionay[@"city"];
        self.sex = apiRespDictionay[@"sex"];
        self.address = apiRespDictionay[@"address"];
        self.accountNonExpired = accountNonExpiredObj.boolValue;
        self.accountNonLocked = accountNonLockedObj.boolValue;
        self.credentialsNonExpired = credentialsNonExpiredObj.boolValue;
        self.enabled = enabledObj.boolValue;
        self.flowId = apiRespDictionay[@"flowId"];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{username:%@, imageUrl:%@, mobile:%@, nickName:%@, city:%@}",
            self.username,
            self.imageUrl,
            self.mobile,
            self.nickName,
            self.city];
}

@end
