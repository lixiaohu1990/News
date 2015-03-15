//
//  IYiMing
//
//  Created by lee on 14/12/2.
//  Copyright (c) 2014年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDUser : NSObject<NSCoding>

@property (nonatomic, strong) NSString *JSESSIONID;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *mobile;

@property (nonatomic, readonly, getter = isLogin) BOOL login;
@property (nonatomic, assign) BOOL firstLogin;

+ (instancetype)sharedUser;
+ (void)setSharedUser:(DDUser *)User;
- (BOOL)saveToDisk;
+ (void)clearUser;

@end
