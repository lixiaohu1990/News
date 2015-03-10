//
//  BigEventTableViewCell.h
//  News
//
//  Created by 李小虎 on 15/3/6.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NANewsResp.h"
@interface BigEventTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagePic;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (nonatomic, strong)NANewsResp *item;
+(instancetype)cellWithTableview:(UITableView *)tableview;
@end
