//
//  NewsFilmTableViewCell.h
//  News
//
//  Created by 李小虎 on 15/3/3.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsList.h"
#import "NANewsResp.h"

@class NewsFilmTableViewCell;
@protocol NewsFilmTableViewCellDelegate <NSObject>
@optional
- (void)newsFilmTableViewCellDidShare:(NewsFilmTableViewCell *)cell;

@end
@interface NewsFilmTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic ,strong)NewsList *newsListItem;
@property (nonatomic, strong)NANewsResp *item;
@property (nonatomic, weak)id<NewsFilmTableViewCellDelegate>nDelegate;
- (IBAction)shareAction:(id)sender;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
