//
//  HBDrawSettingBoard.m
//  DemoAntiAliasing
//
//  Created by 伍宏彬 on 15/11/4.
//  Copyright © 2015年 HB. All rights reserved.
//

#import "HBDrawSettingBoard.h"
#import "UIView+WHB.h"
#import "MJExtension.h"
#import "HBBallColorModel.h"
#import "UIColor+help.h"

@interface HBDrawSettingBoard()
{
    NSIndexPath *_lastIndexPath;
}
@property (weak, nonatomic) HBColorBall *ballView;
@property (weak, nonatomic) IBOutlet UIButton *pickImageButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomViewH;
@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (nonatomic, copy) boardSettingBlock stype;
@property (weak, nonatomic) UISlider *sliderView;
@end

@implementation HBDrawSettingBoard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI{
    self.backgroundColor = [UIColor colorWithRed:16.0f/255 green:142.0f/255  blue:233.0f/255 alpha:1.0f];
    
    UIButton *backPage = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 80, 50)];
    [backPage setTitle:@"取消" forState:UIControlStateNormal];
    [backPage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backPage addTarget:self action:@selector(backPage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backPage];
    
    UIButton *xiangpica = [[UIButton alloc] initWithFrame:CGRectMake(backPage.width+backPage.x, 10, 100, 50)];
    [xiangpica setTitle:@"切换橡皮擦" forState:UIControlStateNormal];
    [xiangpica setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [xiangpica setTitle:@"切换画笔" forState:UIControlStateSelected];
    [xiangpica setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [xiangpica addTarget:self action:@selector(changeDrawStatu:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:xiangpica];
    
    UIButton *chehui = [[UIButton alloc] initWithFrame:CGRectMake(xiangpica.width+xiangpica.x, 10, 80, 50)];
    [chehui setTitle:@"撤回" forState:UIControlStateNormal];
    [chehui setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chehui addTarget:self action:@selector(chehui:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:chehui];
    
    UIButton *qingchu = [[UIButton alloc] initWithFrame:CGRectMake(chehui.width+chehui.x, 10, 80, 50)];
    [qingchu setTitle:@"清除" forState:UIControlStateNormal];
    [qingchu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [qingchu addTarget:self action:@selector(qingchu:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:qingchu];
    
    UIButton *baocun = [[UIButton alloc] initWithFrame:CGRectMake(qingchu.width+qingchu.x, 10, 80, 50)];
    [baocun setTitle:@"保存" forState:UIControlStateNormal];
    [baocun setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [baocun addTarget:self action:@selector(baocun:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:baocun];
    
    
    // ===========================
    UIButton *jiexi = [[UIButton alloc] initWithFrame:CGRectMake(baocun.width+baocun.x, 10, 80, 50)];
    [jiexi setTitle:@"解析" forState:UIControlStateNormal];
    [jiexi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [jiexi addTarget:self action:@selector(jiexi:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:jiexi];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat normalW = self.width * 0.25;
    
    UIButton *btn = [self.buttomView.subviews firstObject];
    
    self.buttomViewH.constant = normalW * btn.currentImage.size.height / btn.currentImage.size.width;
}
- (void)getSettingType:(boardSettingBlock)type
{
    self.stype = type;
}
- (CGFloat)getLineWidth
{
    return self.ballView.lineWidth;
}
- (UIColor *)getLineColor
{
    return self.ballView.ballColor;
}

-(void)backPage:(UIButton *)sender{
    [[self currentVC].navigationController popViewControllerAnimated:YES];
}

-(void)changeDrawStatu:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.stype) {
        self.stype(setTypeEraser);
    }
}

-(void)chehui:(UIButton *)sender{
    if (self.stype) {
        self.stype(setTypeBack);
    }
}

-(void)qingchu:(UIButton *)sender{
    if (self.stype) {
        self.stype(setTypeClearAll);
    }
}

-(void)baocun:(UIButton *)sender{
    if (self.stype) {
        self.stype(setTypeSave);
    }
}

-(void)jiexi:(UIButton *)sender{
    if (self.stype) {
        self.stype(setTypeJiexi);
    }
}

- (UIViewController *)currentVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

@end
