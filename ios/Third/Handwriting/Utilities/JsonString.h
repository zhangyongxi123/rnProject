//
//  JsonString.h
//  HoriMobileTest1
//
//  Created by wuhy on 16/4/27.
//  Copyright © 2016年 wuhy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonString : NSObject

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end
