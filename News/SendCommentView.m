//
//  SendCommentView.m
//  News
//
//  Created by 李小虎 on 15/3/8.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "SendCommentView.h"
#import "NAApiSaveComment.h"
#import "LoginViewController.h"
@interface SendCommentView ()<NABaseApiResultHandlerDelegate, UIAlertViewDelegate>
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
        if (![DDUser sharedUser].login) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您尚未登入，请登入后再进行评论" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登入", nil];
            alert.delegate = self;
            [alert show];
        }
        if (!self.commentTexfield.text.length) {
            [UIAlertView commonAlert:@"评论内容不能为空"];
        }
        NSLog(@"评论");
        [self saveComment];
    }
}

- (void)saveComment
{
    self.saveCommentReq = [[NAApiSaveComment alloc]initWithText:self.commentTexfield.text nsId:self.newsId];
    self.saveCommentReq.APIRequestResultHandlerDelegate = self;
    [self.saveCommentReq asyncRequest];
}

#pragma mark - Correct result handler
- (void)request:(id)request successRequestWithResult:(id)requestResult
{
    [self removeFromSuperview];
    if (self.sDelegate && [self.sDelegate respondsToSelector:@selector(sendCommentDidFinishedWithSendCommentView:)]) {
        [self.sDelegate sendCommentDidFinishedWithSendCommentView:self];
    }
}
#pragma mark - NABaseApiResultHandlerDelegate methods

- (void)failCauseNetworkUnavaliable:(id)request
{
    DLOG(@"failCauseNetworkUnavaliable");
}

- (void)failCauseRequestTimeout:(id)request
{
    DLOG(@"failCauseRequestTimeout");
}

- (void)failCauseServerError:(id)request
{
//    if (request) {
//        <#statements#>
//    }
    DLOG(@"failCauseServerError, %@", request);
}

- (void)failCauseBissnessError:(id)apiRequest
{
    DLOG(@"failCauseBissnessError, status:%@", ((NABaseApi *)apiRequest).respStatus);
}

- (void)failCauseSystemError:(id)apiRequest
{
    DLOG(@"failCauseSystemError, status:%@", ((NABaseApi *)apiRequest).respStatus);
}

- (void)failCauseParamError:(id)apiRequest
{
    DLOG(@"failCauseParamError, status:%@", ((NABaseApi *)apiRequest).respStatus);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else{
        if (self.sDelegate && [self.sDelegate respondsToSelector:@selector(sendCommentDidLoginWithSendCommentView:)]) {
            [self.sDelegate sendCommentDidLoginWithSendCommentView:self];
        }

    }
}
@end
