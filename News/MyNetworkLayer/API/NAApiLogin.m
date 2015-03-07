//
//  NAApiLogin.m
//  NewsAgencyDemo
//
//  Created by guangbo on 15/3/4.
//
//

#import "NAApiLogin.h"

@implementation NAApiLogin

- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password
{
    if (self = [super initWithApiMethod:@"login"
                        paramDictioanry:@{@"username":username,
                                          @"password":password}
                             httpMethod:HTTP_METHOD_POST]) {
        _username = username;
        _password = password;
    }
    return self;
}

@end
