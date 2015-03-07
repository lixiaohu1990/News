//
//  IYiMing
//
//  Created by lee on 14/12/2.
//  Copyright (c) 2014年 lee. All rights reserved.
//
#import "DDUser.h"

static DDUser *myUser = nil;

@implementation DDUser
//使那些非关联返回类型的方法返回所在类的类型！

+ (instancetype)sharedUser {
    if (!myUser) {
        @try {
            myUser = [[self loadFromDisk] retain];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            if (!myUser)
                myUser = [[self alloc] init];
        }
    }
    return myUser;
}

+ (void)setSharedUser:(DDUser *)User
{
    if (myUser != User) {
        [myUser release];
        myUser = [User retain];
    }
}

+ (NSString *)userSavePath
{
    static NSString *savePath = nil;
    if (!savePath) {
        savePath = [[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
                     stringByAppendingPathComponent:@"user.dat"] retain];
    }
    return savePath;
}

+ (DDUser *)loadFromDisk
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:DDUser.userSavePath];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
//        self.cId = 1871;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onResignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {

        self.JSESSIONID = [aDecoder decodeObjectForKey:@"JSESSIONID"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.realName = [aDecoder decodeObjectForKey:@"realName"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.address = [aDecoder decodeObjectForKey:@"address"];


        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onResignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.JSESSIONID forKey:@"JSESSIONID"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.realName forKey:@"realName"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.address forKey:@"address"];

    
}

- (BOOL)isLogin
{
    return (![NSObject isNullWithObject:self.mobile]);
}

- (void)onResignActive:(NSNotification*)notification
{
    if (self.isLogin)
        [self saveToDisk];
}

- (BOOL)saveToDisk
{
    return [NSKeyedArchiver archiveRootObject:self
                                       toFile:DDUser.userSavePath];
}

+ (void)clearUser{
    DDUser *user = [DDUser sharedUser];
    user.mobile = nil;
    user.username = nil;
    user.sex = nil;
    user.realName = nil;
    user.nickName = nil;
    user.imageUrl = nil;
    user.city = nil;
    user.address = nil;
    [user saveToDisk];
}
@end
