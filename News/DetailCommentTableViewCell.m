//
//  DetailCommentTableViewCell.m
//  News
//
//  Created by 李小虎 on 15/3/8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "DetailCommentTableViewCell.h"

@implementation DetailCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"NewsFilmDetailTableViewCell5";
    DetailCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        NSArray *cellList = [[NSBundle mainBundle] loadNibNamed:@"NewsFilmDetailTableViewCell" owner:nil options:nil];
        
        cell = (DetailCommentTableViewCell *)cellList[4];
        
    }
    return cell;
}

- (void)setItem:(NACommentResp *)item{
    _item = item;
    self.timeLabel.text = item.createdDate;
    self.nameLabel.text = item.userName;
    DLOG(@"%@", item.user.nickName);
    self.contentLabel.text = item.text;
    self.typeLabel.text = @"网友";
}
@end
