//
//  Tool.h
//  IFree
//
//  Created by wuyiguang on 16/2/17.
//  Copyright (c) 2016年 YG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "MBProgressHUD+Show.h"

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define KeyWindow [UIApplication sharedApplication].delegate.window

@interface Tool : NSObject

/** 纯文本提示 */
+ (MBProgressHUD *)showHUDText:(NSString *)message;

/** 带菊花提示 <需调用停止>*/
+ (MBProgressHUD *)showHUDIndicatView:(NSString *)message;



@end
