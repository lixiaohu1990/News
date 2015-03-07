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

//#import "LvJsonResultApiRequest.h"
@interface LoginViewController ()<LvHTTPURLRequestDelegate,UITextFieldDelegate>
{
UITextField *iUsernameField;
UITextField *iPasswordField;

UIImageView *imageView;
}
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *passWord;
@property(nonatomic, assign) BOOL threeTimesError;

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
- (void)buttonPressed:(UIButton *)sender
{
//    self.threeTimesError = YES;
    if(sender.tag == 100)
    {
        if(!iUsernameField.text || iUsernameField.text.length != 11)
        {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的11位手机号"];
            return;
        }
        if(!iPasswordField.text || iPasswordField.text.length < 6)
        {
            [SVProgressHUD showErrorWithStatus:@"密码长度不得低于6位"];
            return;
        }
        //获得系统时间
        NSDate * senddate=[NSDate date];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
//        [dateformatter setDateFormat:@"HH:mm"];
//        NSString * locationString=[dateformatter stringFromDate:senddate];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString * timeString=[dateformatter stringFromDate:senddate];
        NSLog(@"%@", timeString);
        __block BOOL loginSuccess = 0;
//        [DDConnection loginConnectionWithTimestamp:timeString password:iPasswordField.text username:iUsernameField.text version:@"1.0" finishBlock:^(NSDictionary *json, BOOL success) {
//            if (success) {
//                NSLog(@"aaaaaaaa%@", json);
//            
////                [DDUser sharedShip].sharedShip
//                [DDConnection getUserInfoConnectionWithTimestamp:timeString WithFinishBlock:^(NSDictionary *json, BOOL success) {
//                    if (success) {
//                        NSLog(@"user%@", json);
//                        if (![NSObject isNullWithObject:json[@"json"][@"address"]]) {
//                            [DDUser sharedUser].address = json[@"json"][@"address"];
//                        }else{
//                            [DDUser sharedUser].address = @"";
//                        }
//                        if (![NSObject isNullWithObject:json[@"json"][@"city"]]) {
//                            [DDUser sharedUser].city = json[@"json"][@"city"];
//                        }else{
//                            [DDUser sharedUser].city = @"";
//                        }
//                        if (![NSObject isNullWithObject:json[@"json"][@"imageUrl"]]) {
//                            [DDUser sharedUser].imageUrl = json[@"json"][@"imageUrl"];
//                        }else{
//                            [DDUser sharedUser].imageUrl = @"";
//                        }
//                        if (![NSObject isNullWithObject:json[@"json"][@"nickName"]]) {
//                            [DDUser sharedUser].nickName = json[@"json"][@"nickName"];
//                        }else{
//                            [DDUser sharedUser].nickName = json[@"json"][@"mobile"];
//                        }
//                        if (![NSObject isNullWithObject:json[@"json"][@"realName"]]) {
//                            [DDUser sharedUser].realName = json[@"json"][@"realName"];
//                        }else{
//                            [DDUser sharedUser].realName = @"";
//                        }
//                        if (![NSObject isNullWithObject:json[@"json"][@"sex"]]) {
//                            [DDUser sharedUser].sex = json[@"json"][@"sex"];
//                        }else{
//                            [DDUser sharedUser].sex = @"";
//                        }
//                        if (![NSObject isNullWithObject:json[@"json"][@"username"]]) {
//                            [DDUser sharedUser].username = json[@"json"][@"username"];
//                        }else{
//                            [DDUser sharedUser].username = json[@"json"][@"mobile"];
//                        }
//                        if (![NSObject isNullWithObject:json[@"json"][@"mobile"]]) {
//                            [DDUser sharedUser].mobile = json[@"json"][@"mobile"];
//                        }else{
//                            [DDUser sharedUser].mobile = @"";
//                        }
//                        [[DDUser sharedUser] saveToDisk];
//                    }
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                }];
//
//                
//
//            }
//            
//            
//        }];
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

@end
