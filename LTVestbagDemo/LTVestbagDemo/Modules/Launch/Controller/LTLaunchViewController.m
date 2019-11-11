//
//  LTLaunchViewController.m
//  LTVestbagDemo
//
//  Created by huanyu.li on 2019/11/10.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTLaunchViewController.h"
#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface LTLaunchViewController ()

@property (nonatomic, strong) UIView *emptyView;
@property (class, nonatomic, assign) BOOL haveShow;

@end

@implementation LTLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.greenColor;
    [self checkServerReachability];
}

- (void)checkServerReachability
{
    // 检测网络
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if (reachability.currentReachabilityStatus == NotReachable)
    {
        // 网络不可用
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(networkDidChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        [reachability startNotifier];
        self.emptyView.hidden = NO;
    }
    else
    {
        // 网络可用
        // 是否展示过B面
        if (LTLaunchViewController.haveShow)
        {
            [self completionWithState:YES];
            return;
        }
        
        // 是否到时间了
        if (![self compareTime:@"2019-12-01"])
        {
            [self completionWithState:NO];
            return;
        }
        
        // 是否是在中国
        if (![self isInChina])
        {
            [self completionWithState:NO];
            return;
        }
        
        [self request:^(BOOL success) {
            [self completionWithState:success];
            LTLaunchViewController.haveShow = success;
        }];
    }
}

// 如果返回YES,表示时间到了，返回NO就表示时间没到
- (BOOL)compareTime:(NSString *)timeString
{
    BOOL timeUp = NO;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *time = [dateFormatter dateFromString:timeString];
    NSComparisonResult result = [[NSDate date] compare:time];
    if (result != NSOrderedAscending)
    {
        timeUp = YES;
    }
    return timeUp;
}

- (void)completionWithState:(BOOL)state
{
    if (self.completionBlock)
    {
        self.completionBlock(state);
        self.completionBlock = nil;
    }
}

- (void)request:(LTLaunchCompletion)completion
{
    // 发起网络请求，这里并不真正发起请求，仅通过延时来模拟这个过程
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion)
        {
            completion(NO);
        }
    });
}

- (void)networkDidChanged:(NSNotification*)notification
{
    Reachability *reach = [notification object];
    switch (reach.currentReachabilityStatus)
    {
        case ReachableViaWiFi:
        case ReachableViaWWAN:
        {
            [self checkServerReachability];
            self.emptyView.hidden = YES;
            break;
        }
            
        default:
            break;
    }
}

- (BOOL)isInChina
{
    BOOL isInChina = NO;
    
    // 系统语言:中文
    BOOL isChinese = NO;
    NSArray *languageArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    // Get the user's language
    NSString *language = languageArray.firstObject;
    isChinese = [language containsString:@"zh"];
    
    // 设备机型:iPhone
    BOOL isIPhone = NO;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        isIPhone = YES;
    }
    // 当前系统时区:Asia/Hong_Kong、Asia/Shanghai、Asia/Harbin
    BOOL isChinaTimeZone = NO;
    NSString *systemTimeZoneName = [NSTimeZone systemTimeZone].name;
    NSArray *ChinaTimeZone = @[@"Asia/Hong_Kong", @"Asia/Shanghai", @"Asia/Harbin"];;
    isChinaTimeZone = [ChinaTimeZone containsObject:systemTimeZoneName];
    
    // 当前地区国家:zh_CN
    BOOL isChinaLocale = NO;
    NSString *country = [NSLocale currentLocale].localeIdentifier;
    isChinaLocale = [country containsString:@"zh"];
    
    isInChina = isChinese && isIPhone && isChinaTimeZone && isChinaLocale;
    return isInChina;
}

- (UIView *)emptyView
{
    if (!_emptyView)
    {
        UIView *emptyView = [[UIView alloc] init];
        emptyView.frame = self.view.bounds;
        emptyView.backgroundColor = UIColor.whiteColor;
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColor.blackColor;
        label.font = [UIFont systemFontOfSize:17.f];
        label.text = @"请打开蜂窝网络移动数据或使用无线局域网来访问app";
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        label.center = emptyView.center;
        [emptyView addSubview:label];
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@" 刷新 " forState:UIControlStateNormal];
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = UIColor.blackColor.CGColor;
        [button sizeToFit];
        button.center = CGPointMake(label.center.x, label.center.y + 40.f);
        [emptyView addSubview:button];
        [button addTarget:self action:@selector(checkServerReachability) forControlEvents:UIControlEventTouchUpInside];
        
        _emptyView = emptyView;
        [self.view addSubview:emptyView];
    }
    return _emptyView;
}


+ (BOOL)haveShow
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"LTLaunchViewController_haveShow"];
}

+ (void)setHaveShow:(BOOL)haveShow
{
    [[NSUserDefaults standardUserDefaults] setBool:haveShow forKey:@"LTLaunchViewController_haveShow"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
