//
//  DetailCommentTableViewCell.h
//  News
//
//  Created by 李小虎 on 15/3/8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NACommentResp.h"
@interface DetailCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) NACommentResp *item;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
