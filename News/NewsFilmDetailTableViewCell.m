//
//  NewsFilmDetailTableViewCell.m
//  News
//
//  Created by 李小虎 on 15/3/6.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NewsFilmDetailTableViewCell.h"

@implementation NewsFilmDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPicStr:(NSString *)picStr{
    NSString *imageStr = [NSString stringWithFormat:@"%@%@",BASEIAMGEURL,self.picStr];
    [self.imagePic setImageWithURL:[NSURL URLWithString:imageStr]];
}
@end
