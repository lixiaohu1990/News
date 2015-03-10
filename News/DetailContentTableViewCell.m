//
//  DetailContentTableViewCell.m
//  News
//
//  Created by 李小虎 on 15/3/8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "DetailContentTableViewCell.h"

@implementation DetailContentTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"DetailContentTableViewCell";
    DetailContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        NSArray *cellList = [[NSBundle mainBundle] loadNibNamed:@"NewsFilmDetailTableViewCell" owner:nil options:nil];
        
        cell = (DetailContentTableViewCell *)cellList[1];
        
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)detailContentAciton:(id)sender {
    NSLog(@"查看详细");
}
- (void)setItem:(NANewsResp *)item{
    _item = item;
    self.titleLabel.text = item.name;
    self.contentLabel.text = item.nsDescription;
}

@end
