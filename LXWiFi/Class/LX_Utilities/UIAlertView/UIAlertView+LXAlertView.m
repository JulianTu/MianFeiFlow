//
//  UIAlertView+LXAlertView.m
//  乐享WiFi
//
//  Created by keyrun on 14-9-16.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "UIAlertView+LXAlertView.h"

@implementation UIAlertView (LXAlertView)
static id alertView =nil ;

+(id)showNetTipAlertView{
    if (alertView  == nil) {
        alertView = [[self alloc] initWithTitle:@"提示" message:@"网络不给力，请再试试吧" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"点击刷新", nil];
    }
    return alertView ;
}
+(BOOL)isExistAlertView{
    if (alertView == nil) {
        return NO ;
    }else{
        return YES ;
    }
}
+(void)resetNetTipAlertView {
    alertView = nil;
}

@end
