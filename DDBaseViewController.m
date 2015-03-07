//
//  DDBaseViewController.m
//  DDMessage
//
//  Created by HuiPeng Huang on 13-12-26.
//  Copyright (c) 2013年 HuiPeng Huang. All rights reserved.
//

#import "DDBaseViewController.h"
#import "DDBarButton.h"

@interface DDBaseViewController ()

@end

@implementation DDBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.hidden = YES;
    if (!self.first) {
        DDBarButton *backButton = [[DDBarButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImage:[UIImage imageNamed:@"back_icon01"] forState:UIControlStateNormal];
        if (iOS7) {
            backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 40);
        }else {
            backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
        }
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor]}];
//    if (IS_IOS_7) {
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor redColor]]
                                                      forBarMetrics:UIBarMetricsDefault];
//    }
    
//    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
