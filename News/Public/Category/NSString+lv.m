//
//  NSString+lv.m
//  CommunityDemo
//
//  Created by guangbo on 14/11/21.
//  Copyright (c) 2014年 1024. All rights reserved.
//

#import "NSString+lv.h"

@implementation NSString (lv)

- (CGSize)sizeWithConstraintWidth:(CGFloat)constraintWidth
                             font:(UIFont *)textFont
{
    if (!textFont)
        return CGSizeZero;
    
    NSString *nText = [self copy];
    if (!nText) {
        nText = @"";
    }
    CGFloat nConstraintWidth = constraintWidth;
    if (nConstraintWidth < 0) {
        nConstraintWidth = 0;
    }
    CGSize constraintSize = CGSizeMake(nConstraintWidth, MAXFLOAT);
    CGSize nSize;
    
#ifdef __IPHONE_7_0
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary* stringAttributes = @{NSFontAttributeName: textFont,
                                       NSParagraphStyleAttributeName: paragraphStyle};
    nSize = [nText boundingRectWithSize: constraintSize
                                options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                             attributes: stringAttributes
                                context: nil].size;
#else
    nSize = [nText sizeWithFont: textFont
              constrainedToSize: constraintSize
                  lineBreakMode: NSLineBreakByCharWrapping];
#endif
    
    nSize.height = ceilf(nSize.height);
    return nSize;
}

- (NSString *)trimWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSUInteger)numberOfLines
{
    return [self componentsSeparatedByString:@"\n"].count + 1;
}

+(NSString*) uuid
{
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    NSString *guid = (__bridge NSString *)newUniqueIDString;
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    NSString *uuid = [guid lowercaseString];
    return uuid;
}

@end
