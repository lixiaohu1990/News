//
//  MoreVC.m
//  News
//
//  Created by 彭光波 on 15-3-19.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "MoreVC.h"

NSString *const NAArticleFontSizeChangedNotification = @"NAArticleFontSizeChangedNotification";
NSString *const NAArticleFontSizeKey = @"NAArticleFontSize";

static const NSUInteger NA_MAX_ARTICLE_FONT_SIZE = 45;
static const NSUInteger NA_MIN_ARTICLE_FONT_SIZE = 12;

@interface MoreVC ()

@property (nonatomic, weak) IBOutlet UIButton *menuNewsFilmButn;
@property (nonatomic, weak) IBOutlet UIButton *menuBigEventButn;
@property (nonatomic, weak) IBOutlet UIButton *menuPrismButn;
@property (nonatomic, weak) IBOutlet UIButton *menuLoginButn;
@property (nonatomic, weak) IBOutlet UIButton *menuSettingButn;
@property (nonatomic, weak) IBOutlet UIButton *menuFavorButn;
@property (nonatomic, weak) IBOutlet UIButton *menuSubscribeButn;
@property (nonatomic, weak) IBOutlet UIButton *menuTemplateButn;
@property (nonatomic, weak) IBOutlet UISlider *fontSettingSlider;

@end

@implementation MoreVC

- (instancetype)initFromStoryboard
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainModule" bundle:nil];
    self = [board instantiateViewControllerWithIdentifier:@"MoreVC"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMoreVC];
}

- (void)setupMoreVC
{
    [_menuNewsFilmButn addTarget:self
                          action:@selector(menuButnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    [_menuBigEventButn addTarget:self
                          action:@selector(menuButnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    [_menuPrismButn addTarget:self
                          action:@selector(menuButnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    [_menuLoginButn addTarget:self
                          action:@selector(menuButnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    [_menuSettingButn addTarget:self
                          action:@selector(menuButnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    [_menuFavorButn addTarget:self
                          action:@selector(menuButnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    [_menuSubscribeButn addTarget:self
                          action:@selector(menuButnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    [_menuTemplateButn addTarget:self
                          action:@selector(menuButnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    
    [_fontSettingSlider addTarget:self
                           action:@selector(fontSizeChanged:)
                 forControlEvents:UIControlEventValueChanged];
}

- (void)menuButnClick:(UIButton *)menuButn
{
    if ([menuButn isEqual:_menuNewsFilmButn]) {
        if ([self.delegate respondsToSelector:@selector(menuNewsFilmButnClick:)]) {
            [self.delegate menuNewsFilmButnClick:self];
        }
        return;
    }
    
    if ([menuButn isEqual:_menuBigEventButn]) {
        if ([self.delegate respondsToSelector:@selector(menuBigEventButnClick:)]) {
            [self.delegate menuBigEventButnClick:self];
        }
        return;
    }
    
    if ([menuButn isEqual:_menuPrismButn]) {
        if ([self.delegate respondsToSelector:@selector(menuPrismButnClick:)]) {
            [self.delegate menuPrismButnClick:self];
        }
        return;
    }
    
    if ([menuButn isEqual:_menuLoginButn]) {
        if ([self.delegate respondsToSelector:@selector(menuLoginButnClick:)]) {
            [self.delegate menuLoginButnClick:self];
        }
        return;
    }
    
    if ([menuButn isEqual:_menuSettingButn]) {
        if ([self.delegate respondsToSelector:@selector(menuSettingButnClick:)]) {
            [self.delegate menuSettingButnClick:self];
        }
        return;
    }
    
    if ([menuButn isEqual:_menuFavorButn]) {
        if ([self.delegate respondsToSelector:@selector(menuFavorButnClick:)]) {
            [self.delegate menuFavorButnClick:self];
        }
        return;
    }
    
    if ([menuButn isEqual:_menuSubscribeButn]) {
        if ([self.delegate respondsToSelector:@selector(menuSubscribeButnClick:)]) {
            [self.delegate menuSubscribeButnClick:self];
        }
        return;
    }
    
    if ([menuButn isEqual:_menuTemplateButn]) {
        if ([self.delegate respondsToSelector:@selector(menuTemplateButnClick:)]) {
            [self.delegate menuTemplateButnClick:self];
        }
        return;
    }
}

- (void)fontSizeChanged:(UISlider *)slider
{
    NSUInteger fontSize = (slider.value/(slider.maximumValue - slider.minimumValue))*(NA_MAX_ARTICLE_FONT_SIZE - NA_MIN_ARTICLE_FONT_SIZE);
    [[NSNotificationCenter defaultCenter] postNotificationName:NAArticleFontSizeChangedNotification object:self userInfo:@{NAArticleFontSizeKey:@(fontSize)}];
}

@end
