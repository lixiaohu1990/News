//
//  AppDelegate.m
//  News
//
//  Created by 李小虎 on 15/3/2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "AppDelegate.h"
#import "NewsFilmViewController.h"
#import "PrismViewController.h"
#import "BigEventViewController.h"
#import "BaseNavigationViewController.h"
#import "MainViewController.h"

@interface AppDelegate ()
@property(nonatomic, strong)BaseNavigationViewController *nav;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self configureController];
    
    
    self.window.rootViewController = _nav;
    
    [self.window makeKeyAndVisible];
    return YES;
    return YES;
}

- (void)configureController{
    NewsFilmViewController *newsVc = [[NewsFilmViewController alloc] init];
//    newsVc.title = @"新闻片";
    
    BigEventViewController *bigVc = [[BigEventViewController alloc] init];
//    bigVc.title = @"大事件";
    
    PrismViewController *prismVc = [[PrismViewController alloc] init];
//    prismVc.title = @"多棱镜";
    
    MainViewController *main = [[MainViewController alloc] initWithViewControllers:@[newsVc, bigVc, prismVc]];
    BaseNavigationViewController *navi = [[BaseNavigationViewController alloc] initWithRootViewController:main];
    _nav = navi;

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
