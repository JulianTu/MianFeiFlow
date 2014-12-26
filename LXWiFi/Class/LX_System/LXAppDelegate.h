//
//  LXAppDelegate.h
//  LXWiFi
//
//  Created by keyrun on 14-9-16.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/sysctl.h>
#import <AdSupport/ASIdentifierManager.h>
#import "OpenUDID.h"
@interface LXAppDelegate : UIResponder <UIApplicationDelegate ,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
