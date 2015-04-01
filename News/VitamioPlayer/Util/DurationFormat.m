//
//  DurationFormat.m
//  LvDemos
//
//  Created by guangbo on 15/3/19.
//
//

#import "DurationFormat.h"

@implementation DurationFormat

+ (NSString *)durationTextForDuration:(NSTimeInterval)duration
{
    if (duration < 0) {
        return @"-:-:-";
    }
    
    NSInteger hours = duration/(60*60);
    NSInteger mins = (duration - hours*60*60)/60;
    NSInteger secs = duration - hours*60*60 - mins*60;
    
    NSMutableString *durationText = [NSMutableString string];
    
    [durationText appendFormat:@"%d:", hours];
    
    if (mins >= 10) {
        [durationText appendFormat:@"%d:", mins];
    } else {
        [durationText appendFormat:@"0%d:", mins];
    }
    
    if (secs >= 10) {
        [durationText appendFormat:@"%d", secs];
    } else {
        [durationText appendFormat:@"0%d", secs];
    }
    
    return durationText;
}

@end
