//
//  DetailDiscussTableViewCell.h
//  News
//
//  Created by 李小虎 on 15/3/8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailDiscussTableViewCell;
@protocol DetailDiscussTableViewCellDelegate <NSObject>

@optional
- (void)didClickSendbutton:(DetailDiscussTableViewCell *)cell;

@end
@interface DetailDiscussTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
- (IBAction)sendComment:(id)sender;
@property (nonatomic, weak) id<DetailDiscussTableViewCellDelegate>dicDelegate;
@end
