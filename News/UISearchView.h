//
//  UISearchView.h
//  News
//
//  Created by 李小虎 on 15/3/7.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UISearchView;
@protocol UISearchViewDelegate <NSObject>

@optional
- (void)searchViewDidSelectedTagWithSearchView:(UISearchView *)view withTagStr:(NSString *)tagStr;
- (void)searchViewDidDissmissSearchView:(UISearchView *)view;
- (void)searchViewDidSearchWithSearchStr:(NSString *)searchStr;
@end
@interface UISearchView : UIView
- (IBAction)dissMiss:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn1;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn2;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn3;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn4;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn5;
@property (weak, nonatomic) IBOutlet UITextField *searchContentTextField;
@property (nonatomic ,strong)NSArray *tagArray;
@property (nonatomic, weak) id<UISearchViewDelegate>sDelegate;
- (IBAction)searchAction:(id)sender;
- (IBAction)tagAction:(id)sender;
+ (id)viewFromNib;
@end
