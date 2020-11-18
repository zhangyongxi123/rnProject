//
//  HBDrawViewController.m
//  HyBridMobile
//
//  Created by edz on 2020/9/22.
//  Copyright © 2020 wuhy. All rights reserved.
//

#import "HBDrawViewController.h"
#import "UIView+WHB.h"
#import "HBDrawingBoard.h"
#import "MJExtension.h"
#import "HBDrawSettingBoard.h"
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

@interface HBDrawViewController ()<HBDrawingBoardDelegate>
@property (nonatomic, strong) HBDrawingBoard *drawView;// 画板view
@property (nonatomic, strong) HBDrawSettingBoard *settingBoard;// 工具栏view
@property (nonatomic, retain) UISlider *slider;
@end

@implementation HBDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.drawView];
    [self.view addSubview:self.settingBoard];
    [self.view addSubview:self.slider];
    
}
//- (BOOL)shouldAutorotate {
//    return NO;
//}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    if([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//
//        NSInteger val = UIInterfaceOrientationLandscapeLeft;//横屏
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

// slider变动时改变label值
- (void)sliderValueChanged:(id)sender {
    _slider = (UISlider *)sender;
    // HBDrawingBoard的宽高必须为整数
    self.drawView.frame= CGRectMake(0, (Screen_Height-self.drawView.imageHeight)*_slider.value+70, (int)Screen_Width, (int)self.drawView.imageHeight);
    NSLog(@"%@",NSStringFromCGRect(self.drawView.frame));
}

#pragma mark - HBDrawingBoardDelegate
- (void)drawBoard:(HBDrawingBoard *)drawView drawingStatus:(HBDrawingStatus)drawingStatus model:(HBDrawModel *)model{
    
//    NSLog(@"%@",model.keyValues);
}
- (HBDrawingBoard *)drawView
{
    if (!_drawView) {
        
        _drawView = [[HBDrawingBoard alloc] initWithFrame:CGRectMake(0, 70, self.view.width, self.view.height-70) settingBoard:self.settingBoard image:self.image slider:self.slider];
        _drawView.delegate = self;
    }
    return _drawView;
}

- (HBDrawSettingBoard *)settingBoard
{
    if (!_settingBoard) {
        _settingBoard = [[HBDrawSettingBoard alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70)];
    }
    return _settingBoard;
}

- (UISlider *)slider
{
    if (!_slider) {
        // 滑动条slider
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(-100, Screen_Height/2, 300, 10)];
        _slider.tag=102;
        _slider.minimumValue = 0;// 设置最小值
        _slider.maximumValue = 1;// 设置最大值
        _slider.value = 0;//设置初始值
        //        slider.value = (slider.minimumValue + slider.maximumValue) / 2;// 设置初始值
        _slider.continuous = YES;// 设置可连续变化
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
        //设置旋转90度
        _slider.transform = CGAffineTransformMakeRotation(1.57079633);
        _slider.hidden = YES;
    }
    return _slider;
}

@end
