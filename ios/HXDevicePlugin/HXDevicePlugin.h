//
//  HXDevicePlugin.h
//  horimobilern
//
//  Created by hxdl on 2020/11/12.
//



#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXDevicePlugin : NSObject <RCTBridgeModule>


- (void)getDeviceInfo:(NSString*)command;

@end

NS_ASSUME_NONNULL_END


