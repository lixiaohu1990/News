//
//  NAApiRegister.m
//  NewsAgencyDemo
//
//  Created by guangbo on 15/3/4.
//
//

#import "NAApiRegister.h"

@implementation NAApiRegister

- (instancetype)initWithValidateCode:(NSString *)validateCode
                              mobile:(NSString *)mobile
                            username:(NSString *)username
                            password:(NSString *)password
                                city:(NSString *)city
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (validateCode) {
        [params setObject:validateCode forKey:@"validateCode"];
    }
    if (mobile) {
        [params setObject:mobile forKey:@"mobile"];
    }
    if (username) {
        [params setObject:username forKey:@"username"];
    }
    if (password) {
        [params setObject:password forKey:@"password"];
    }
    if (city) {
        [params setObject:city forKey:@"city"];
    }
    if (self = [super initWithApiMethod:@"register"
                        paramDictioanry:params
                             httpMethod:HTTP_METHOD_POST]) {
        _validateCode = validateCode;
        _mobile = mobile;
        _username = username;
        _password = password;
        _city = city;
    }
    
    return self;
}



@end
