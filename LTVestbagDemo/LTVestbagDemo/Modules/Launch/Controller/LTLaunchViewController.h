//
//  LTLaunchViewController.h
//  LTVestbagDemo
//
//  Created by huanyu.li on 2019/11/10.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 如果为success 为 YES，则应该显示B面
typedef void(^LTLaunchCompletion)(BOOL success);

@interface LTLaunchViewController : UIViewController

@property (nonatomic, copy, nullable) LTLaunchCompletion completionBlock;

@end

NS_ASSUME_NONNULL_END
