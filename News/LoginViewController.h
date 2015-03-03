//
//  LoginViewController.h
//  News
//
//  Created by 李小虎 on 15/3/3.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *passWordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *AccountTextfield;
- (IBAction)login:(id)sender;
- (IBAction)registerAction:(id)sender;


@end
