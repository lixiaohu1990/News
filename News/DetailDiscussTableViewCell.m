//
//  DetailDiscussTableViewCell.m
//  News
//
//  Created by 李小虎 on 15/3/8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "DetailDiscussTableViewCell.h"

@implementation DetailDiscussTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sendComment:(id)sender {
    if (self.dicDelegate!=nil || [self respondsToSelector:@selector(didClickSendbutton:)]) {
        [self.dicDelegate didClickSendbutton:self];
    }
}
@end
