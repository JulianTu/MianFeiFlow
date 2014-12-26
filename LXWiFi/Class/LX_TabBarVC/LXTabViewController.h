//
//  LXTabViewController.h
//  乐享WiFi
//
//  Created by keyrun on 14-9-16.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXTabViewController : UITabBarController <UIAlertViewDelegate>

@property (nonatomic,assign) int state;
-(void)checkUpdate; 
-(void)loadTabViewControllers ;
-(void)requestWelcomeAndShow;
@end
