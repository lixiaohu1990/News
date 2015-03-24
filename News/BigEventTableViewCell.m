//
//  BigEventTableViewCell.m
//  News
//
//  Created by 李小虎 on 15/3/6.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "BigEventTableViewCell.h"

@implementation BigEventTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableview:(UITableView *)tableview{
    static NSString *ID = @"BigEventTableViewCell";
    BigEventTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        NSArray *cellList = [[NSBundle mainBundle] loadNibNamed:@"BigEventTableViewCell" owner:nil options:nil];
        
        cell = (BigEventTableViewCell *)cellList[0];
        
    }
    return cell;
}

- (void)setItem:(NANewsResp *)item{
    _item = item;
    self.titleLabel.text = item.name;
    self.commentLabel.text = [NSString stringWithFormat:@"%d", item.commentCount];
    NSString *imageStr = [NSString string];
    
    if (!(item.videoUrl && [item.videoUrl isKindOfClass:[NSString class]])){
        self.startPicView.hidden = YES;
    }
    
    if (item.imageUrl && [item.imageUrl isKindOfClass:[NSString class]]){
        imageStr = [NSString stringWithFormat:@"%@%@", BASEIAMGEURL,_item.imageUrl];
    }else{
        imageStr = @"";
    }
    
    [self.imagePic setImageWithURL:[NSURL URLWithString:imageStr]];
}
@end
