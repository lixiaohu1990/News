//
//  NewsFilmDetailTableViewCell.h
//  News
//
//  Created by 李小虎 on 15/3/6.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFilmDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagePic;
@property (nonatomic, strong)NSString *picStr;
@property(nonatomic, assign)CGFloat cellHeight;
@end
