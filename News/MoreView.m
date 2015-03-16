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
    if (self.moreDelegate!=nil || [self respondsToSelector:@selector(moreViewDidsetAction:)]) {
        [self.moreDelegate moreViewDidsetAction:self];
    }
}

- (IBAction)collectionAction:(id)sender {
    NSLog(@"collect");
    if (self.moreDelegate!=nil || [self respondsToSelector:@selector(moreViewDidsetAction:)]) {
        [self.moreDelegate moreViewDidNextDevAction:self];
    }

}

- (IBAction)dissSelf:(id)sender {
    [self removeFromSuperview];
    if (self.moreDelegate!=nil || [self respondsToSelector:@selector(moreViewDidDismissAction:)]) {
        [self.moreDelegate moreViewDidDismissAction:self];
    }
}

- (IBAction)nextDev:(id)sender {
    if (self.moreDelegate!=nil || [self respondsToSelector:@selector(moreViewDidsetAction:)]) {
        [self.moreDelegate moreViewDidNextDevAction:self];
    }
}
@end
