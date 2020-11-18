//
//  HXDevicePlugin.m
//  horimobilern
//
//  Created by hxdl on 2020/11/12.
//



#import "HXDevicePlugin.h"
#import "SFHFKeychainUtils.h"
#import "Reachability.h"
#import <React/RCTLog.h>




@implementation HXDevicePlugin

RCT_EXPORT_MODULE();

//RCT_EXPORT_METHOD(addEvent:(NSString *)name location:(NSString *)location)
//{
//  RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
//
//}

RCT_EXPORT_METHOD(findEvents:(RCTResponseSenderBlock)callback)
{
   //返回dic数据给前段
  NSDictionary* deviceProperties = [self deviceProperties];
  callback(@[deviceProperties]);
}


-(void)getDeviceInfo:(NSString *)command{
    //返回dic数据给前段
    NSDictionary* deviceProperties = [self deviceProperties];
}

- (NSDictionary*)deviceProperties
{
    //应用唯一标识，重新安装会变
    NSString *deviceId = [self getDeviceId];
    //网络
    NSString *deviceNetwork = [self getNetWorkInfo];
    //IOS版本
    NSString *deviceVersion = [[UIDevice currentDevice] systemVersion];
    //设备名称
    NSString *deviceName = [[UIDevice currentDevice].name stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return @{
             @"platform": @"IOS",
             @"deviceName":deviceName,
             @"deviceVersion": deviceVersion,
             @"deviceId": deviceId,
             @"deviceNetwork":deviceNetwork,
             @"deviceVersion":deviceVersion
    };
}

//获取deviceid 应用的唯一标识
-(NSString *)getDeviceId{
    NSString *SERVICE_NAME = [[NSBundle mainBundle] bundleIdentifier];//最好用程序的bundle id
    NSString * str =  [SFHFKeychainUtils getPasswordForUsername:@"UUID" andServiceName:SERVICE_NAME error:nil];  // 从keychain获取数据
    if ([str length]<=0)
    {
        str  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];  // 保存UUID作为手机唯一标识符
        [SFHFKeychainUtils storeUsername:@"UUID"
                             andPassword:str
                          forServiceName:SERVICE_NAME
                          updateExisting:1
                                   error:nil];  // 往keychain添加数据
    }
    return str;
}

- (NSString *)getNetWorkInfo
{
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSString *net = @"wifi";
    switch (internetStatus) {
        case ReachableViaWiFi:
            net = @"wifi";
            break;
            
        case ReachableViaWWAN:
            net = @"wwan";
            break;
            
        case NotReachable:
            net = @"no";
            
        default:
            break;
    }
    return net;
}
@end


//#import "HXDevicePlugin.h"
//
//@interface HXDevicePlugin ()
//
//@end
//
//@implementation HXDevicePlugin
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
////
////  HXDevicePlugin.m
////  HelloWorld
////
////  Created by wuhy on 2020/9/17.
////

