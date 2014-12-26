//
//  TaskViewController.h
//  91TaoJin
//
//  Created by keyrun on 14-5-7.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMAlertView.h"

#import <StoreKit/SKStoreProductViewController.h>
#import <WPLib/AppConnect.h>
#import <Escore/YJFUserMessage.h>
#import <Escore/YJFInitServer.h>
#import <Escore/YJFIntegralWall.h>
#import <MBJoy/MBJoyView.h>
#import "FallPlant.h"

#import "AssetZoneManager.h"
#import "MobiSageJoyViewController.h"
#import "MobisageSDK.h"
#import "YouMiView.h"
#import "UploadViewController.h"
#import "DMAdView.h"
#import "TaskTableView.h"
#import "RewardHongBaoView.h"
//test
@interface TaskViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, TMAlertViewDelegate,MBJoyViewDelegate,AssetZoneManagerDelegate,MobiSageJoyDelegate,MobiSageFloatWindowDelegate,MyOfferAPIDelegate ,SKStoreProductViewControllerDelegate,UploadImageSuccessDelegate, YouMiDelegate ,DMAdViewDelegate, TaskTableViewDelegate,NSURLConnectionDataDelegate ,NSURLConnectionDelegate,RewardHongBaoViewDelegate,UIWebViewDelegate>

@property (nonatomic,strong) MobiSageJoyViewController *mobisage;
@property (nonatomic, assign) BOOL isRequesting;                                    //标识是否正在网络请求或刷新数据
@property (nonatomic, strong) NSMutableArray *jifenAry;                               //积分墙数据
@property (nonatomic, strong) NSMutableArray *appAry;                                 //所有app数据（包括未参与，已参与，已完成）


- (void)initWithObjects;
@end
