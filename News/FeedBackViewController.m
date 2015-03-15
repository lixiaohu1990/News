//
//  FeedBackViewController.m
//  News
//
//  Created by 李小虎 on 15/3/11.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "FeedBackViewController.h"
#import "NAApiSendFeedBack.h"
#import "LoginViewController.h"
@interface FeedBackViewController ()<NABaseApiResultHandlerDelegate, UIAlertViewDelegate>
@property(nonatomic, strong)NAApiSendFeedBack *feedbackReq;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn addTarget:self action:@selector(sendFeedBack) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"发送" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    saveBtn.bounds = CGRectMake(0, 0, 50, 50);
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = saveItem;    // Do any additional setup after loading the view from its nib.
}

- (void)sendFeedBack{
    if (![DDUser sharedUser].login) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您尚未登入，请登入后再进行评论" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登入", nil];
        alert.delegate = self;
        [alert show];
    }
    
    if (self.contentLabel.text.length > 0) {
        self.feedbackReq = [[NAApiSendFeedBack alloc] initWithContentStr:self.contentLabel.text];
        self.feedbackReq.APIRequestResultHandlerDelegate = self;
        [self.feedbackReq asyncRequest];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
#pragma mark - Correct result handler
- (void)request:(id)request successRequestWithResult:(id)requestResult
{
//    [self removeFromSuperview];
//    if (self.sDelegate && [self.sDelegate respondsToSelector:@selector(sendCommentDidFinishedWithSendCommentView:)]) {
//        [self.sDelegate sendCommentDidFinishedWithSendCommentView:self];
//    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else{
        LoginViewController *control =  [[LoginViewController alloc] init];
        //    [self.navigationController pushViewController:control animated:YES];
        [self presentViewController:control animated:YES completion:nil];
    }
}


@end
