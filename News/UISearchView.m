//
//  UISearchView.m
//  News
//
//  Created by 李小虎 on 15/3/7.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "UISearchView.h"
#import "NAAPIGetTag.h"

@interface UISearchView ()<NABaseApiResultHandlerDelegate>
@property(nonatomic, strong)NAAPIGetTag *req;
@end
@implementation UISearchView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
- (IBAction)searchAction:(id)sender {
    if (self.sDelegate && [self.sDelegate respondsToSelector:@selector(searchViewDidSearchWithSearchStr:)]) {
        [self.sDelegate searchViewDidSearchWithSearchStr:self.searchContentTextField.text];
    }
    
}

- (IBAction)tagAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSString *tagStr = btn.titleLabel.text;
    if (self.sDelegate && [self.sDelegate respondsToSelector:@selector(searchViewDidSelectedTagWithSearchView:withTagStr:)]) {
        [self.sDelegate searchViewDidSelectedTagWithSearchView:self withTagStr:tagStr];
    }
}

+ (id)viewFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] objectAtIndex:0];
}
- (void)setTagArray:(NSArray *)tagArray{
    _tagArray = tagArray;
    [self.tagBtn1 setTitle:tagArray[0] forState:UIControlStateNormal];
    [self.tagBtn2 setTitle:tagArray[1] forState:UIControlStateNormal];
    [self.tagBtn3 setTitle:tagArray[2] forState:UIControlStateNormal];
    [self.tagBtn4 setTitle:tagArray[3] forState:UIControlStateNormal];
}

- (IBAction)dissMiss:(id)sender {
    [self removeFromSuperview];
    if (self.sDelegate || [self.sDelegate respondsToSelector:@selector(searchViewDidDissmissSearchView:)]) {
        [self.sDelegate searchViewDidDissmissSearchView:self];
    }
}


@end
