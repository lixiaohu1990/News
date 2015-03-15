//
//  BigEventTableViewCell1.m
//  News
//
//  Created by 李小虎 on 15/3/10.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "BigEventTableViewCell1.h"

@implementation BigEventTableViewCell1

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"BigEventTableViewCell2";
    BigEventTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"BigEventTableViewCell" owner:self options:nil][1];
    }
    return cell;
}

- (void)setCommentResp:(NACommentResp *)commentResp{
    _commentResp = commentResp;
    self.titleLabel.text = commentResp.createdDate;
}
- (void)setItem:(NANewsResp *)item{
    _item = item;
    self.titleLabel.text = item.name;
    self.commentNumLabel.text = [NSString stringWithFormat:@"%d", item.commentCount];
    self.contentLabel.text = item.nsDescription;
    
    }
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
