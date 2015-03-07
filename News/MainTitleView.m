//
//  MainTitleView.m
//  News
//
//  Created by 李小虎 on 15/3/7.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "MainTitleView.h"

@implementation MainTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MainTitleView" owner:self options:nil] lastObject];
    self.frame = frame;
    return self;
}
@end
