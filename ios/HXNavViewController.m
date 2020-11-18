//
//  HXNavViewController.m
//  DailyAccumulation
//
//  Created by edz on 2020/8/18.
//  Copyright © 2020 edz. All rights reserved.
//

#import "HXNavViewController.h"

@interface HXNavViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,assign) BOOL isHandWrite;// 是否是手写页面：手写页面横屏显示

@end

@implementation HXNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //第二步：设置自定义导航控制器的侧滑手势的代理
    self.interactivePopGestureRecognizer.delegate = self;
    
    
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController isHandWrite:(BOOL)isHandWrite{
    self.isHandWrite = isHandWrite;
    return [super initWithRootViewController:rootViewController];
}

//第三步：实现代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}

// 设备支持方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if(_isHandWrite){
        return UIInterfaceOrientationMaskLandscapeLeft;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{

return [self.visibleViewController preferredStatusBarStyle];

}

- (BOOL)prefersStatusBarHidden{

return [self.visibleViewController prefersStatusBarHidden];

}

@end
