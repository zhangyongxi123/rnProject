//
//  HXNavViewController.h
//  DailyAccumulation
//
//  Created by edz on 2020/8/18.
//  Copyright © 2020 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXNavViewController : UINavigationController
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController isHandWrite:(BOOL)isHandWrite;
@end

NS_ASSUME_NONNULL_END
