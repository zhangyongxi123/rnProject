//
//  ZXCustomWindow.m
//  MosterColock
//
//  Created by wuhongbin on 15/6/25.
//  Copyright (c) 2015年 wuhongbin. All rights reserved.
//

#import "ZXCustomWindow.h"


@interface ZXCustomWindow()

@property (nonatomic, weak) UIView *animationView;

@end

@implementation ZXCustomWindow

- (instancetype)initWithAnimationView:(UIView *)animationView
{
    
    if (self = [super initWithFrame:animationView.frame]) {
        
        self.windowLevel = UIWindowLevelAlert;
        
        self.animationView = animationView;
        
        [self addSubview:self.animationView];
    }
    return self;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    if (!CGRectContainsPoint(self.animationView.frame, touchPoint)){}
//        [self hideWithAnimationTime:self.animationTime];

//    for (UIView *view in self.subviews) {
////        if ([view isKindOfClass:[giftInfoView class]] || [view isKindOfClass:[putView class]]) {
//            [self hideWithAnimationTime:self.animationTime];
////        }
//    }
}

@end
