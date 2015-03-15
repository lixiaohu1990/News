//
//  SendCommentView.h
//  News
//
//  Created by 李小虎 on 15/3/8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SendCommentView;
@protocol SendCommentViewDelegate <NSObject>

@optional

-(void)sendCommentDidFinishedWithSendCommentView:(SendCommentView *)view;
-(void)sendCommentDidLoginWithSendCommentView:(SendCommentView *)view;
@end
@interface SendCommentView : UIView
- (IBAction)btnAcion:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *commentTexfield;
@property(nonatomic, assign)NSInteger newsId;
@property(nonatomic, weak)id<SendCommentViewDelegate>sDelegate;

@end
