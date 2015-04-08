//
//  SearchResaultCell.h
//  News
//
//  Created by 李小虎 on 15/4/2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResaultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cellBgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign)NSInteger row;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
