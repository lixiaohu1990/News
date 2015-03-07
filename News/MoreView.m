//
//  MoreView.m
//  News
//
//  Created by 李小虎 on 15/3/3.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "MoreView.h"
@implementation MoreView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)loginAction:(id)sender {
    if (self.moreDelegate!=nil || [self respondsToSelector:@selector(moreViewDidloginAction:)]) {
        [self.moreDelegate moreViewDidloginAction:self];
    }
}

- (IBAction)setAction:(id)sender {
    NSLog(@"set");
}

- (IBAction)collectionAction:(id)sender {
    NSLog(@"collect");
}

- (IBAction)dissSelf:(id)sender {
    [self removeFromSuperview];
}
@end
