//
//  AppDelegate.m
//  LTVestbagDemo
//
//  Created by huanyu.li on 2019/11/10.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "AppDelegate.h"
#import "LTLaunchViewController.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //设置主屏
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    [self showLaunchLodingPage];
    return YES;
}

- (void)showLaunchLodingPage
{
    LTLaunchViewController *launchPage = [[LTLaunchViewController alloc] init];
    launchPage.completionBlock = ^(BOOL success) {
        UIViewController *vc = nil;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:100.f];
        if (success)
        {
            // 展示B面
            vc = [[ViewController alloc] init];
            titleLabel.text = @"B";
        }
        else
        {
            // 展示A面
            vc = [[UIViewController alloc] init];
            vc.view.backgroundColor = UIColor.yellowColor;
            titleLabel.text = @"A";
        }
        
        [titleLabel sizeToFit];
        titleLabel.center = vc.view.center;
        [vc.view addSubview:titleLabel];
        self.window.rootViewController = vc;
    };
    self.window.rootViewController = launchPage;
    [self.window makeKeyAndVisible];
}


@end
