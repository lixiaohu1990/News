//
//  NewFeatureViewController.m
//  News
//
//  Created by 李小虎 on 15/4/6.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "ImageScrollView.h"
#import "MainVC.h"
@interface NewFeatureViewController ()<ImageScrollViewDataSource, ImageScrollViewDelegate>
@property(nonatomic, strong)ImageScrollView *headScrollView;
@property(nonatomic, strong)NSArray *array;
@end

@implementation NewFeatureViewController

- (NSArray *)array{
    if (_array == nil) {
        _array = [[NSArray alloc] init];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = @[@"main.jpg", @"main2.jpg", @"main3.jpg"];
    self.headScrollView = [[ImageScrollView alloc] initWithFrame:self.view.bounds];
    self.headScrollView.delegate = self;
    self.headScrollView.dataSource = self;
    [self.view addSubview:self.headScrollView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - DDImageScrollView Delegate & DataSource
- (NSInteger)numberOfPages {
    return self.array.count;
}

- (UIView *)pageAtIndex:(NSInteger)index {
    UIImageView *picView = [[UIImageView alloc] initWithFrame:self.headScrollView.bounds];
    picView.contentMode = UIViewContentModeScaleAspectFill;
    picView.layer.masksToBounds = YES;
    picView.image = [UIImage imageNamed:self.array[index]];
    
    return picView;
}
- (void)didClickPage:(ImageScrollView *)view atIndex:(NSInteger)index{
    
}

- (void)didFinishChange{
    UINavigationController *mainNav = [[UINavigationController alloc]initWithRootViewController:[[MainVC alloc]init]];
    self.view.window.rootViewController = mainNav;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    self.headScrollView = nil;
}
@end
