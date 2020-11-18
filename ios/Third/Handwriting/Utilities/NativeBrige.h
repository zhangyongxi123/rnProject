//
//  NativeBrige.h
//  HyBridMobile
//
//  Created by wuhy on 16/7/5.
//  Copyright © 2016年 wuhy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NativeBrige : UIViewController<UIWebViewDelegate>
- (void)flushOperations;
- (NSString *)stringByExecutingNativeOperation:(NSString *)aOperationJSON;

- (void)operationWithIndex:(NSInteger)aIndex completeWithStatusDictionary:(NSDictionary *)aStatusDictionary;

- (void)fireEventWithName:(NSString *)aName source:(NSString *)aSource andArguments:(id)aArguments;

@end
