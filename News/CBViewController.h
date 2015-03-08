//
//  CBViewController.h
//  SampleOne
//
//  Copyright Baidu All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBViewController : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *networkLabel;
@property (retain, nonatomic) IBOutlet UIView *mpPlayerView;
@property (retain, nonatomic) IBOutlet UIView *cbPlayerView;
- (IBAction)onClickPlay:(id)sender;
- (IBAction)onClickStop:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *currentProgress;
@property (retain, nonatomic) IBOutlet UILabel *remainsProgress;
@property (retain, nonatomic) IBOutlet UISlider *sliderProgress;
- (IBAction)onDragSlideValueChanged:(id)sender;
- (IBAction)onDragSlideDone:(id)sender;
- (IBAction)onDragSlideStart:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *playButtonText;
@property (retain, nonatomic) IBOutlet UITextField *playContentText;
@property (retain, nonatomic) IBOutlet UITextField *subContentText;
@property (nonatomic, assign) NSTimeInterval lastPlayDuration;  //切到后台前最后播放的时间
- (IBAction)returnBack:(id)sender;
// 即将进入后台
- (void)willResignActive;
// 从后台返回
- (void)didBecomeActive;
@end
