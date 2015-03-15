
//  IYiMing
//
//  Created by lee on 14/12/2.
//  Copyright (c) 2014年 lee. All rights reserved.
//

#import "DDBaseViewController.h"

@protocol LoginControllerDelegate;
@interface LoginViewController : DDBaseViewController

@property (nonatomic, weak) id<LoginControllerDelegate> delegate;

@end

@protocol LoginControllerDelegate <NSObject>

- (void)updateHomeOfClubInfo;

@end
