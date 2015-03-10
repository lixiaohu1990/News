//
//  DetailContentTableViewCell.h
//  News
//
//  Created by 李小虎 on 15/3/8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NANewsResp.h"
@interface DetailContentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *CountLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property(nonatomic ,strong)NANewsResp *item;
- (IBAction)detailContentAciton:(id)sender;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
