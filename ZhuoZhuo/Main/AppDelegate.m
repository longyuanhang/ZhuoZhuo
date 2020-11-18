//
//  AppDelegate.m
//  ZhuoZhuo
//
//  Created by wisesoft on 2020/11/17.
//  Copyright © 2020 wisesoft. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    MainViewController *mainVc = [[MainViewController alloc]init];
    self.window.rootViewController = mainVc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}





@end
