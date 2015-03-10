//
//  BigEventTableViewCell1.h
//  News
//
//  Created by 李小虎 on 15/3/10.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NANewsResp.h"
@interface BigEventTableViewCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong)NANewsResp *item;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
