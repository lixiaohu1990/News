//
//  NAApiCVC.m
//  NewsAgencyDemo
//
//  Created by guangbo on 15/3/4.
//
//

#import "NAApiCVC.h"
#import "NAApiError.h"

@implementation NAApiCVC

- (instancetype)initWithMobile:(NSString *)mobile
{
    if (self = [super initWithApiMethod:@"cvc"
                        paramDictioanry:@{@"mobile":mobile}
                             httpMethod:HTTP_METHOD_POST]) {
        _mobile = mobile;
    }
    return self;
}

#pragma mark - Override

- (CORRECT_RESULT_PARSER)apiCorrectResultParser
{
    return ^ NSString* (NSDictionary *jsonResult) {
        NSString *cvcCode = [jsonResult objectForKey:@"memo"];
        return cvcCode;
    };
}

@end
