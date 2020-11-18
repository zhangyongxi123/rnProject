//
//  HXBackButtonItem.h
//  DailyAccumulation
//
//  Created by edz on 2020/8/18.
//  Copyright © 2020 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXBackButtonItem : UIBarButtonItem
+ (HXBackButtonItem *)creatBackItemWithTarget:(id)target action:(SEL)action;

+ (HXBackButtonItem *)creatBackItemWithTarget:(id)target action:(SEL)action icon:(NSString *)icon;

+ (HXBackButtonItem *)creatRightItemWithTarget:(id)target action:(SEL)action;

+ (HXBackButtonItem *)creatRightItemWithTarget:(id)target action:(SEL)action icon:(NSString *)icon;
@end

NS_ASSUME_NONNULL_END
