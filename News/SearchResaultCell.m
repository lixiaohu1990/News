//
//  SearchResaultCell.m
//  News
//
//  Created by 李小虎 on 15/4/2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "SearchResaultCell.h"

@implementation SearchResaultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"cell";
    SearchResaultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        NSArray *cellList = [[NSBundle mainBundle] loadNibNamed:@"SearchResaultCell" owner:nil options:nil];
        
        cell = (SearchResaultCell *)cellList[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

- (void)setRow:(NSInteger)row{
    if (row % 2 == 0) {
        self.cellBgView.backgroundColor = [UIColor colorWithRed:166.0/255.0 green:185.0/255.0 blue:183.0/255.0 alpha:1];
    }else {
        self.cellBgView.backgroundColor = [UIColor colorWithRed:203.0/255.0 green:214.0/255.0 blue:213.0/255.0 alpha:1];
    }
    _row = row;
}
@end
