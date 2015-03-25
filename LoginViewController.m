//  IYiMing
//
//  Created by lee on 14/12/2.
//  Copyright (c) 2014年 lee. All rights reserved.
//
//#import "UINavigationController+TRVSNavigationControllerTransition.h"
#import "LoginViewController.h"
//#import "DDForgetPwViewController.h"
#import "SVProgressHUD.h"
#import "RegisterViewController.h"
#import "NAApiLogin.h"
#import "BigEventViewController.h"
#import "NewsFilmViewController.h"
#import "PrismViewController.h"
#import "MainViewController.h"
@interface LoginViewController ()<LvHTTPURLRequestDelegate,UITextFieldDelegate>
{
UITextField *iUsernameField;
UITextField *iPasswordField;

UIImageView *imageView;
}
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *passWord;
@property(nonatomic, assign) BOOL threeTimesError;
@property (nonatomic) NAApiLogin *loginRec;

@end

@implementation LoginViewController

- (void)dealloc
{
    
}

- (void)loadView {
    [super loadView];
    
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"back_icon01"];
    [backbutton setImage:image forState:UIControlStateNormal];
//    [backbutton addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
    backbutton.frame = CGRectMake(10, 32, image.size.width , image.size.height);
    [backbutton addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    label.text = @"登陆";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:label];
    [self addSubCompomentsWithSuperView];
    
    UIImage *image1 = [UIImage imageNamed:@"login_bg"];
    self.view.layer.contents = (id)image1.CGImage;
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]];
    
}
- (void)addSubCompomentsWithSuperView
{
    
    UIImage *image = [UIImage imageNamed:@"usernameLabel"];
    UIImageView *userNameView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x - image.size.width/2, 238/2, image.size.width, image.size.height)];
    userNameView.image = image;
    
    [self.view addSubview:userNameView];
    
    image = [UIImage imageNamed:@"passwordLabel"];
    UIImageView *passWordView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x - image.size.width/2, 432/2, image.size.width, image.size.height)];
    passWordView.image = image;
    [self.view addSubview:passWordView];
    
    image = [UIImage imageNamed:@"login_btn"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 100;
    button.frame = CGRectMake(self.view.center.x - image.size.width / 2.0f, passWordView.frame.origin.y + CGRectGetHeight(passWordView.bounds) + 18.0f, image.size.width, image.size.height);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *registerImage = [UIImage imageNamed:@"register_btn"];
    [registerBtn setImage:registerImage forState:UIControlStateNormal];
    registerBtn.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y + button.frame.size.height + 10, registerImage.size.width, registerImage.size.height);
    [registerBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.tag = 200;
    [self.view addSubview:registerBtn];

    iUsernameField = [[UITextField alloc] initWithFrame:CGRectMake(userNameView.frame.origin.x+ 25.0f, userNameView.frame.origin.y-8, 245.0f, 35.0f)];
    iUsernameField.borderStyle = UITextBorderStyleNone;
//    iUsernameField.keyboardType = [];
    iUsernameField.textColor = [UIColor whiteColor];
    iUsernameField.delegate = self;
    iUsernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"用户名/手机号"
                                            
                                                                           attributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor]}];
    iUsernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    iUsernameField.tag = 101;
    [self.view addSubview:iUsernameField];
    
    iPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(passWordView.frame.origin.x+ 25.0f, passWordView.frame.origin.y-8, 245.0f, 35.0f)];
    iPasswordField.delegate = self;
    iPasswordField.secureTextEntry = YES;
    iPasswordField.textColor = [UIColor whiteColor];
    iPasswordField.borderStyle = UITextBorderStyleNone;
    iPasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    iPasswordField.tag = 102;
//    iPasswordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码"
//                             
//                                                            attributes:@{ NSForegroundColorAttributeName:LOGIN_PLACEHOLDER_COLOR}];
    [self.view addSubview:iPasswordField];

}
- (void)returnBack:(UIButton *)sender{
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)loginConnection{
    [iUsernameField resignFirstResponder];
    [iPasswordField resignFirstResponder];
    self.loginRec = [[NAApiLogin alloc]initWithUsername:iUsernameField.text password:iPasswordField.text];
    self.loginRec.APIRequestResultHandlerDelegate = self;
    [self.loginRec asyncRequest];
}
- (void)buttonPressed:(UIButton *)sender
{
//    self.threeTimesError = YES;
    if(sender.tag == 100)
    {
//        if(!iUsernameField.text || iUsernameField.text.length != 11)
//        {
//            [SVProgressHUD showErrorWithStatus:@"请输入正确的11位手机号"];
//            return;
//        }
//        if(!iPasswordField.text || iPasswordField.text.length < 1)
//        {
//            [SVProgressHUD showErrorWithStatus:@"密码长度不得低于6位"];
//            return;
//        }
        //获得系统时间
        NSDate * senddate=[NSDate date];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
//        [dateformatter setDateFormat:@"HH:mm"];
//        NSString * locationString=[dateformatter stringFromDate:senddate];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString * timeString=[dateformatter stringFromDate:senddate];
        NSLog(@"%@", timeString);
        __block BOOL loginSuccess = 0;
        [self loginConnection];

    }
    else if(sender.tag == 200)
    {
        NSLog(@"注册");
//        RegisterViewController *control = [[RegisterViewController alloc] init];
        RegisterViewController *control = [[RegisterViewController alloc] init];
        UINavigationController *registerNav = [[UINavigationController alloc] initWithRootViewController:control];
//        [self.navigationController pushViewController:control animated:YES];
        [self presentModalViewController:registerNav animated:YES];
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self.tabBarController setHidesBottomBarWhenPushed:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(imageView)
    {
        [imageView removeFromSuperview];
        imageView = nil;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    DLOG(@"failCauseServerError");
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
    
    [DDUser sharedUser].mobile = iUsernameField.text;
    [[DDUser sharedUser] saveToDisk];
    
    NSLog(@"%@", requestResult);
    //        [self dismissModalViewControllerAnimated:YES];
    
    NewsFilmViewController *newsVc = [[NewsFilmViewController alloc] init];
    //    newsVc.title = @"新闻片";
    
    BigEventViewController *bigVc = [[BigEventViewController alloc] init];
    //    bigVc.title = @"大事件";
    
    PrismViewController *prismVc = [[PrismViewController alloc] init];
    //    prismVc.title = @"多棱镜";
    
    MainViewController *main = [[MainViewController alloc] initWithViewControllers:@[newsVc, bigVc, prismVc]];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:main];
    self.view.window.rootViewController = navi;
    
    return;

}


@end
