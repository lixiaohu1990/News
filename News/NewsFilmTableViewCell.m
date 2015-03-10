//
//  NewsFilmTableViewCell.m
//  News
//
//  Created by 李小虎 on 15/3/3.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NewsFilmTableViewCell.h"

@implementation NewsFilmTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"NewsFilmTableViewCell";
    NewsFilmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        NSArray *cellList = [[NSBundle mainBundle] loadNibNamed:@"NewsFilmTableViewCell" owner:nil options:nil];
        
        cell = (NewsFilmTableViewCell *)cellList[0];

    }
    return cell;
}

//- (void)setNewsListItem:(NewsList *)newsListItem{
//    _newsListItem = newsListItem;
//    self.titleLabel.text = _newsListItem.title;
//}

- (void)setItem:(NANewsResp *)item{
    _item = item;
    self.titleLabel.text = _item.name;
    NSString *imageStr = [NSString stringWithFormat:@"%@%@", @"",_item.imageUrl];
    [self.image setImageWithURL:[NSURL URLWithString:imageStr]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
