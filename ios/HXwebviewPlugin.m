//
//  HXwebviewPlugin.m
//  horimobilern
//
//  Created by wuhy on 2020/11/12.
//

#import "HXwebviewPlugin.h"
#import "HXwebview.h"
#import "HXNavViewController.h"
#import <React/RCTLog.h>

@interface HXwebviewPlugin()

@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) NSString *fileUrl;
@property (nonatomic,strong) NSString *callbackId;

@end

@implementation HXwebviewPlugin

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(addEvent:(NSString *)params)
{
  RCTLogInfo(@"Pretending to create an event %@ at %@",params);
  
  [self jumpFilePreViewVC];

}


//-(void)openWebView:(NSString *)command{
//    _fileName = [command.arguments objectAtIndex:0];
////    _fileUrl = [command.arguments objectAtIndex:1];
//    NSLog(@"参数%@===%@",_fileName,_fileUrl);
// 
//    [self jumpFilePreViewVC];
//}

-(void)jumpFilePreViewVC{
    dispatch_async(dispatch_get_main_queue(), ^{

      HXwebview *filePreVC = [[HXwebview alloc] init];
      filePreVC.fileName = self->_fileName;
      filePreVC.fileUrl = self->_fileUrl;
        
      HXNavViewController* nav = [[HXNavViewController alloc]initWithRootViewController:filePreVC];
      nav.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self.viewController presentViewController:nav animated:YES completion:nil];

      UINavigationController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
      [vc presentViewController:nav animated:YES completion:nil];
      
      
    });
}

@end

