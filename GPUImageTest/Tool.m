//
//  Tool.m
//  IFree
//
//  Created by wuyiguang on 16/2/17.
//  Copyright (c) 2016年 YG. All rights reserved.
//

#import "Tool.h"

@implementation Tool

+ (MBProgressHUD *)showHUDText:(NSString *)message
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:KeyWindow];
    
    [KeyWindow addSubview:hud];
    
    hud.mode = MBProgressHUDModeText;
    
    hud.removeFromSuperViewOnHide = YES;
    
    hud.dimBackground = YES;
    
    hud.labelText = message;
    
    [hud show:YES];
    
    [hud hide:YES afterDelay:1.5];
    
    return hud;
}

+ (MBProgressHUD *)showHUDIndicatView:(NSString *)message
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:KeyWindow];
    
    [KeyWindow addSubview:hud];
    
    hud.labelText = message;
    
    hud.removeFromSuperViewOnHide = YES;
    
    [hud show:YES];
    
    return hud;
}

@end
