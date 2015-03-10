//
//  SendCommentView.m
//  News
//
//  Created by 李小虎 on 15/3/8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "SendCommentView.h"
#import "NAApiSaveComment.h"
@interface SendCommentView ()<NABaseApiResultHandlerDelegate>
@property (nonatomic) NAApiSaveComment *saveCommentReq;
@end
@implementation SendCommentView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SendCommentView" owner:self options:nil] lastObject];
    self.frame = frame;
    return self;
}
- (IBAction)btnAcion:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 501) {
        [self removeFromSuperview];

    }else{
        if (!self.commentTexfield.text.length) {
            [UIAlertView commonAlert:@"评论内容不能为空"];
        }
        NSLog(@"评论");
        [self saveComment];
    }
}

- (void)saveComment
{
    self.saveCommentReq = [[NAApiSaveComment alloc]initWithUserId:1 text:self.commentTexfield.text nsId:1 type:@"新闻片"];
    self.saveCommentReq.APIRequestResultHandlerDelegate = self;
    [self.saveCommentReq asyncRequest];
}
@end
