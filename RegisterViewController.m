//
//  RegisterViewController.m
//  IYiMing
//
//  Created by lee on 14/12/2.
//  Copyright (c) 2014年 lee. All rights reserved.
//
#import "RegisterViewController.h"
#import "DDCityViewController.h"
#import "SVProgressHUD.h"
#import "NAApiRegister.h"
#import "NAApiCVC.h"
#import "NewsFilmViewController.h"
#import "PrismViewController.h"
#import "BigEventViewController.h"
#import "BaseNavigationViewController.h"
#import "MainViewController.h"
#define SECONDS 300
@interface RegisterViewController ()
<UITextFieldDelegate, CityVcDelegate, LvHTTPURLRequestDelegate>
{
    UITextField *iUsernameField;
    UITextField *iPasswordField;
    UITextField *iCodeField;
    UITextField *iCityField;
    NSTimer *timer;
    UIImageView *imageView;
    NSDateFormatter *_dateformatter;
    NSInteger seconds;
    
}
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *passWord;
@property(nonatomic, strong) UIButton *sendButton;
@property (nonatomic) NAApiRegister *registerReq;
@property (nonatomic) NAApiCVC *cvcReq;
@end


@implementation RegisterViewController

- (void)loadView{
    [super loadView];
    seconds = SECONDS;
    _dateformatter = [[NSDateFormatter alloc] init];
    [_dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]];
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"back_icon01"];
    [backbutton setImage:image forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
    backbutton.frame = CGRectMake(10, 32, image.size.width , image.size.height);
    [self.view addSubview:backbutton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    label.text = @"注册";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:label];
    [self addSubCompomentsWithSuperView];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
    [backBarButtonItem setTitle:@""];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]];
    UIImage *image1 = [UIImage imageNamed:@"login_bg"];
    self.view.layer.contents = (id)image1.CGImage;
}

- (void)addSubCompomentsWithSuperView
{
    UIImage *image = [UIImage imageNamed:@"mobilePhone"];
    UIImageView *cityView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x - image.size.width/2, 238/2, image.size.width, image.size.height)];
    cityView.image = image;
    [self.view addSubview:cityView];
    
    image = [UIImage imageNamed:@"mobilePhone"];
    UIImageView *userNameView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x - image.size.width/2, 388/2, image.size.width, image.size.height)];
    userNameView.image = image;
    [self.view addSubview:userNameView];
    
    image = [UIImage imageNamed:@"code"];
    UIImageView *codeView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x - image.size.width/2, 538/2, image.size.width, image.size.height)];
    codeView.image = image;
    [self.view addSubview:codeView];
    
    image = [UIImage imageNamed:@"passwordLabel"];
    UIImageView *passWordView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x - image.size.width/2, 688/2, image.size.width, image.size.height)];
    passWordView.image = image;
    [self.view addSubview:passWordView];
    
    image = [UIImage imageNamed:@"registerandlogin_btn"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 100;
    button.frame = CGRectMake(self.view.center.x - image.size.width / 2.0f, passWordView.frame.origin.y + CGRectGetHeight(passWordView.bounds) + 18.0f, image.size.width, image.size.height);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    iCityField = [[UITextField alloc] initWithFrame:CGRectMake(cityView.frame.origin.x+ 25.0f, cityView.frame.origin.y-8, 245.0f, 35.0f)];
    iCityField.borderStyle = UITextBorderStyleNone;
    iCityField.textColor = [UIColor whiteColor];
    iCityField.delegate = self;
    iCityField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"所属城市"
                                            
                                                                           attributes:@{ NSForegroundColorAttributeName:LOGIN_PLACEHOLDER_COLOR}];
    iCityField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    iCityField.tag = 300;
    [self.view addSubview:iCityField];

    
    iUsernameField = [[UITextField alloc] initWithFrame:CGRectMake(userNameView.frame.origin.x+ 25.0f, userNameView.frame.origin.y-8, 245.0f, 35.0f)];
    iUsernameField.borderStyle = UITextBorderStyleNone;
    iUsernameField.textColor = [UIColor whiteColor];
    iUsernameField.delegate = self;
    iUsernameField.keyboardType = UIKeyboardTypeNumberPad;
    iUsernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入11位手机号"
                                            
                                                                           attributes:@{ NSForegroundColorAttributeName:LOGIN_PLACEHOLDER_COLOR}];
    iUsernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    iUsernameField.tag = 301;
    [self.view addSubview:iUsernameField];
    
    iCodeField = [[UITextField alloc] initWithFrame:CGRectMake(userNameView.frame.origin.x+ 25.0f, codeView.frame.origin.y-8, 150.0f, 35.0f)];
    iCodeField.borderStyle = UITextBorderStyleNone;
    iCodeField.textColor = [UIColor whiteColor];
    iCodeField.delegate = self;
//    iCityField.keyboardType = UIKeyboardTypeNumberPad;
    iCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"短信验证码"
                                            
                                                                           attributes:@{ NSForegroundColorAttributeName:LOGIN_PLACEHOLDER_COLOR}];
    iCodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    iCodeField.tag = 302;
    [self.view addSubview:iCodeField];

    UIButton *codeSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeSendBtn setTitleColor:LOGIN_CODESENDER_COLOR forState:UIControlStateNormal];
    [codeSendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    codeSendBtn.titleLabel.text = @"获取验证码";

    [codeSendBtn setFont:[UIFont systemFontOfSize:13.0f]];
    codeSendBtn.frame = CGRectMake(iCodeField.frame.origin.x+CGRectGetWidth(iCodeField.frame)+20 - 50, iCodeField.frame.origin.y, 150, 35);

    _sendButton = codeSendBtn;
    [codeSendBtn addTarget:self action:@selector(senderCoder:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeSendBtn];
    
    iPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(passWordView.frame.origin.x+ 25.0f, passWordView.frame.origin.y-8, 245.0f, 35.0f)];
    iPasswordField.delegate = self;
    iPasswordField.secureTextEntry = YES;
    iPasswordField.borderStyle = UITextBorderStyleNone;
    iPasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    iPasswordField.tag = 303;
    iPasswordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码"
                                            
                                                                           attributes:@{ NSForegroundColorAttributeName:LOGIN_PLACEHOLDER_COLOR}];
    [self.view addSubview:iPasswordField];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [iCityField resignFirstResponder];
}
- (void)returnBack:(UIButton *)sender{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)senderCoder:(UIButton *)sender{
    //获得系统时间
    NSDate * senddate=[NSDate date];
    NSString * timeString=[_dateformatter stringFromDate:senddate];
//    [DDConnection getCoderConnectionWithTimestamp:timeString mobile:iUsernameField.text finishBlock:^(NSDictionary *json, BOOL success) {
//        if (success) {
////            iCodeField.text = json[@"json"][@"memo"];
//
//        }
//        
//    }];
    // 获取验证码
    
    self.cvcReq.APIRequestResultHandlerDelegate = nil;
    [self.cvcReq cancelRequest];
    
    NSString *mobile = iUsernameField.text;
    
    // 获取到验证码后显示到验证码输入框中
    self.cvcReq = [[NAApiCVC alloc]initWithMobile:mobile];
    self.cvcReq.APIRequestResultHandlerDelegate = self;
    [self.cvcReq asyncRequest];

    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

- (void)sendCodeConnection{
    [iUsernameField resignFirstResponder];
    [iCodeField resignFirstResponder];
    [iPasswordField resignFirstResponder];
    [iCodeField resignFirstResponder];
    //获得系统时间
    if(!iUsernameField.text || iUsernameField.text.length != 11)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的11位手机号"];
        return;
    }

    // 注册
    
    self.registerReq.APIRequestResultHandlerDelegate = nil;
    [self.registerReq cancelRequest];
    
    NSString *mobile = iUsernameField.text;
    NSString *pwd = iPasswordField.text;
    NSString *validateCode =iCodeField.text;
    
    // 获取到验证码后显示到验证码输入框中
    self.registerReq = [[NAApiRegister alloc]initWithValidateCode:validateCode
                                                           mobile:mobile
                                                         username:mobile
                                                         password:pwd
                                                             city:@"北京"];
    self.registerReq.APIRequestResultHandlerDelegate = self;
    [self.registerReq asyncRequest];

}
- (void)buttonPressed:(UIButton *)sender
{
    if(sender.tag == 100)
    {
        if(!iUsernameField.text || iUsernameField.text.length != 11)
        {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的11位手机号"];
            return;
        }
        if(!iCityField.text || iCityField.text.length == 0 )
        {
            [SVProgressHUD showErrorWithStatus:@"请选择城市"];
            return;
        }
        if(!iCodeField.text || iCodeField.text.length != 6)
        {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的6位验证码"];
            return;
        }
        if(!iPasswordField.text || iPasswordField.text.length < 6)
        {
            [SVProgressHUD showErrorWithStatus:@"密码长度不得低于6位"];
            return;
        }
        [self sendCodeConnection];
    }
    else if(sender.tag == 200)
    {
        
        
    }
}
#pragma mark - Uitexfield
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if (textField.tag == 300) {
        DDCityViewController *cityController = [[DDCityViewController alloc] init];
//        cityController.type = DDCityOptionTypeLocation;
        
        cityController.title = @"所属城市";
        cityController.myDelegate = self;
        [self.navigationController pushViewController:cityController animated:YES];
//        [self presentModalViewController:cityController animated:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didSelectedCity:(NSString *)city{
    iCityField.text = city;
    if ([iCityField.text length]) {
        [iUsernameField becomeFirstResponder];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 100 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(void)timerFireMethod:(NSTimer *)theTimer {
    if (seconds == 1) {
        [theTimer invalidate];
        seconds = SECONDS;
        [_sendButton setTitle:@"     获取验证码     " forState: UIControlStateNormal];
                //        [_sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_sendButton setEnabled:YES];
    }else{
        [_sendButton setEnabled:NO];
        seconds--;
        NSString *title = [NSString stringWithFormat:@" %d秒后重新获取",seconds];

                [_sendButton setTitle:title forState:UIControlStateDisabled];
    }
}

- (void)releaseTImer {
    if (timer) {
        if ([timer respondsToSelector:@selector(isValid)]) {
            if ([timer isValid]) {
                [timer invalidate];
                seconds = SECONDS;
            }
        }
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

- (void)request:(id)request successRequestWithResult:(id)requestResult
{
    if ([request isEqual:_cvcReq]) {
        NSString *validateCode = (NSString *)requestResult;
        dispatch_async(dispatch_get_main_queue(), ^{
//            iCodeField.text = validateCode;
        });
        return;
    }
    
    if ([request isEqual:_registerReq]) {
        
        [UIAlertView commonAlert:@"注册成功"];
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
        BaseNavigationViewController *navi = [[BaseNavigationViewController alloc] initWithRootViewController:main];
        self.view.window.rootViewController = navi;

        return;
    }
}

@end
