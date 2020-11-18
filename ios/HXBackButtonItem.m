//
//  HXBackButtonItem.m
//  DailyAccumulation
//
//  Created by edz on 2020/8/18.
//  Copyright © 2020 edz. All rights reserved.
//

#import "HXBackButtonItem.h"

//屏幕宽
#define HX_ScreenWidth   [[UIScreen mainScreen] bounds].size.width

//屏幕高
#define HX_ScreenHeight  [[UIScreen mainScreen] bounds].size.height

@implementation HXBackButtonItem
+ (HXBackButtonItem *)creatBackItemWithTarget:(id)target action:(SEL)action
{
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"1icon_shangyiyue"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 60, 100);
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(10, -45, 10, 10);
    
    HXBackButtonItem * item = [[HXBackButtonItem alloc] initWithCustomView:leftBtn];
    [leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return item;
}

+ (HXBackButtonItem *)creatBackItemWithTarget:(id)target action:(SEL)action icon:(NSString *)icon{
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 60, 100);
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(10, -45, 10, 10);
    HXBackButtonItem * item = [[HXBackButtonItem alloc] initWithCustomView:leftBtn];
    [leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return item;
}

+(HXBackButtonItem *)creatRightItemWithTarget:(id)target action:(SEL)action{
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"1icon_more"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(HX_ScreenWidth-80, 0, 60, 100);
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -50);
    
    HXBackButtonItem * item = [[HXBackButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return item;
}

+(HXBackButtonItem *)creatRightItemWithTarget:(id)target action:(SEL)action icon:(NSString *)icon{
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(HX_ScreenWidth-80, 0, 60, 100);
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -50);
    
    HXBackButtonItem * item = [[HXBackButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return item;
}
@end
