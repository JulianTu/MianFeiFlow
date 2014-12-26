//
//  LXAppDelegate.m
//  LXWiFi
//
//  Created by keyrun on 14-9-16.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LXAppDelegate.h"
#import "Reachability.h"
#import "UIAlertView+LXAlertView.h"
#import "NSString+emptyStr.h"
#import "sys/utsname.h"
#import "SSKeychain.h"
#import "LXTabViewController.h"
#import "TjNavigationController.h"
#import "MyUserDefault.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "UMSocial.h"
#import "MobClick.h"
#import "NSString+md5Code.h"
#import "AsynURLConnection.h"
#import "LoadingView.h"
#import "UIAlertView+NetPrompt.h"
#import "LLAsynURLConnection.h"
#import "BPush.h"

#import "UMSocialSnsPlatformManager.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialConfig.h"
#define kKeyChainCount       @"LXWiFiToken"
@implementation LXAppDelegate
{
    Reachability *hostReach ;
    int timeOutCount;                               //记录超时次数，如果大于1就弹出对话框
    BOOL enterForward ;
    LXTabViewController *tabViewCtr ;
    NSDictionary *launchDic ;
    int timeErrorCount ;
    int sendBDCount ;
}

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    NSLog(@" 设备 宽 %f  高 %f  Scale %f",kmainScreenWidth ,kmainScreenHeigh,[UIScreen mainScreen].scale);
    //    launchDic =@{@"act":@"http://www.baidu.com/"};     //测试推送跳转
    //        launchDic =@{@"pri":@"8"};
    
    enterForward =YES;
    [self checkDeviceNetWork];
    
    return YES;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendUserLoginRequest) name:LoginAgainNotic object:nil];   //重新登录通知
    
    tabViewCtr =[[LXTabViewController alloc] initWithNibName:nil bundle:nil];
    tabViewCtr.state = 0;
    [tabViewCtr loadTabViewControllers];
    if (kDeviceVersion < 7.0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        UINavigationController *nc =[[UINavigationController alloc] initWithRootViewController:tabViewCtr];
        self.window.rootViewController =nc;
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        TjNavigationController *navCtr =[[TjNavigationController alloc]initWithRootViewController:tabViewCtr];
        self.window.rootViewController = navCtr ;
    }
    
    [self initBaiDuPushWithDic:launchOptions];
    
    [self.window makeKeyAndVisible];
    
    
    [self initBadgeNumber];            //清除状态栏上的推送通知
    
    [self initUmengSDK];               //初始化第三方框架内容
    [self checkDeviceTelecomInfor];
    
    //正常启动（不是点击push消息启动）launchOptions 为空
    
    if (launchOptions != nil) {
        NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary != nil) {    //接收到通知
            NSLog(@" Start Dictionary %@",dictionary);
            launchDic = [[NSDictionary alloc] initWithDictionary:dictionary] ;
            
        }
    }
    
    
    return YES;
}
-(void) initBaiDuPushWithDic:(NSDictionary *)launchOptions{
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    NSString* version = [[[NSBundle mainBundle]infoDictionary]objectForKey:(NSString* )kCFBundleVersionKey];
    [BPush setTags:[NSArray arrayWithObject:version]];     //百度push 标记
    
}
- (void) onMethod:(NSString*)method response:(NSDictionary*)data {
    NSDictionary *res =[[NSDictionary alloc] initWithDictionary:data];
    NSLog(@" 绑定百度推送 == %@",res);
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
        int returnCode =[[res valueForKey:BPushRequestErrorCodeKey] intValue];
        if (returnCode == BPushErrorCode_Success) {
            NSLog(@" 绑定百度推送 ==%@  ",res);
            NSString *userid =[res valueForKey:BPushRequestUserIdKey];
            [[MyUserDefault standardUserDefaults] setBDUserPushId:userid];      //保存百度推送userid
            
            [self sendBaiDuPushId:userid];       // 登陆成功后将百度推送id 发到服务器   模拟器收不到push id 会造成crash
        }
    }else if ([BPushRequestMethod_Unbind isEqualToString:method]){   //没绑定上
        
    }
}

-(void)sendBaiDuPushId:(NSString *)userid{
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,@"ucenter/baidu"];
    NSDictionary *dic =@{@"baidu_id":userid};
    [LLAsynURLConnection requestURLWith:urlStr dataDic:dic andProtocolNum:@"40006" andTimeOut:httpTimeout connectSuccess:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@" 获取发送百度推送id数据 == %@",dataDic);
        });
    } andFail:^(NSError *error) {
        sendBDCount ++;
        if (sendBDCount <3) {
            [self sendBaiDuPushId:userid];
        }
    }];
}

-(void)registRemoteNotification{
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
       
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier =@"action";
        action.title =@"接收";
        action.activationMode = UIUserNotificationActivationModeForeground ;
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action.identifier =@"action2";
        action.title =@"取消";
        action.activationMode = UIUserNotificationActivationModeBackground ;
        action.authenticationRequired = YES;    //是否需要解锁处理
        
        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
        category.identifier =@"alert";
        [category setActions:@[action,action2] forContext:UIUserNotificationActionContextMinimal];
        
        UIUserNotificationSettings *settings =[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |UIUserNotificationTypeBadge |UIUserNotificationTypeSound categories:[NSSet setWithObjects:category, nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound ];
    }
    
}

-(void) checkDeviceTelecomInfor{
    CTTelephonyNetworkInfo* netInfo =[[CTTelephonyNetworkInfo alloc]init];
    CTCarrier* ct = [netInfo subscriberCellularProvider];
    NSString *model2 =[NSString stringWithFormat:@"%@",[ct mobileNetworkCode]];
    NSLog(@"---CTCarrier--%@--%@--%@--%@-",model2,[ct carrierName],[ct mobileNetworkCode],[ct mobileCountryCode]);
}
-(void)initUmengSDK{
    
    [MobClick startWithAppkey:kUmengKey reportPolicy:BATCH channelId:@""];
    [MobClick setLogEnabled:YES];
    
    [UMSocialData setAppKey:kUmengKey];
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    
    [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];
    //设置title  qzoneData  wechatSessionData wechatTimelineData
    [UMSocialData defaultData].extConfig.qqData.title = kShareTitle;
    [UMSocialData defaultData].extConfig.qzoneData.title = kShareTitle ;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = kShareTitle;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = kShareTitle ;
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:kWeChatID appSecret:kWeChatKey url:@"http://www.umeng.com/social"];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //打开腾讯微博SSO开关，设置回调地址 只支持32位
    //    [UMSocialTencentWeiboHandler openSSOWithRedirectUrl:@"http://sns.whalecloud.com/tencent2/callback"];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:kQQID appKey:kQQKey url:@"http://www.umeng.com/social"];
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    
    
}
/**
 *  不使用网络来检测设备 信号类型
 *
 *  @return 信号类型
 */
-(NSString *)getNetWorkState{
    UIApplication *app =[UIApplication sharedApplication];
    NSArray *array =[[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NSString *state = [[NSString alloc] init];
    int netType = 0 ;
    for (id child in array) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            netType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            switch (netType) {
                case 0:
                    state = @"无网络";
                    break;
                case 1:
                    state = @"2G" ;
                    break ;
                case 2:
                    state = @"3G" ;
                    break ;
                case 4:
                    state = @"4G" ;
                    break ;
                case 5:
                {
                    state = @"WiFi" ;
                    
                }
                    break ;
                default:
                    break;
            }
        }
    }
    return state ;
}

-(void)checkDeviceNetWork {
    hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [hostReach startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}
-(void)reachabilityChanged:(NSNotification* )notic{
    id curReach = [notic object];
    if ([curReach isKindOfClass:[Reachability class]]) {
        NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
        [self updateInterfaceWithReachability:curReach];
    }
}
-(void)updateInterfaceWithReachability:(Reachability *)curReach{
    NetworkStatus status = [curReach currentReachabilityStatus];
    NSLog(@"网络状态值：%d",status);
    if (status == NotReachable) {
        NSLog(@"网络状态 ：无");
        [[MyUserDefault standardUserDefaults] setNetWork:NotReachable];
        if (![UIAlertView isExistAlertView]) {
            UIAlertView *alertView = [UIAlertView showNetTipAlertView];
            alertView.delegate = self;
            alertView.tag = kNoNetWorkTag;
            [alertView show];
            alertView = nil;
        }
        
    }else if(status == ReachableViaWiFi){
        NSLog(@"网络状态 ：Wifi");
        [[MyUserDefault standardUserDefaults] setNetWork:ReachableViaWiFi];
        
        [self sendUserLoginRequest];
    }else if (status == ReachableVia2G){
        NSLog(@"网络状态 ：WWAN-2G");
        [[MyUserDefault standardUserDefaults] setNetWork:ReachableVia2G];
        [self sendUserLoginRequest];
    }else if (status == ReachableVia3G){
        NSLog(@"网络状态 ：WWAN-3G");
        [[MyUserDefault standardUserDefaults] setNetWork:ReachableVia3G];
        [self sendUserLoginRequest];
    }
}


-(NSString* )getDeviceModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return model;
}

-(void)sendUserLoginRequest{
    NSString *appVer = [[[NSBundle mainBundle]infoDictionary]objectForKey:(NSString* )kCFBundleVersionKey];
    NSString *openudid = [OpenUDID value];
    NSString *model = [self getDeviceModel];
    NSString *sysVer = [UIDevice currentDevice].systemVersion;
    NSString *macStr =[NSString getMacAdress];
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *vendor = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
    NSString *uuidStr = [NSString stringWithFormat:@"%@",uuid];
    NSArray *array = [uuidStr componentsSeparatedByString:@">"];
    NSString *uuidString = [array objectAtIndex:1];
    
    NSString *baiduPushKey;
    if ([[MyUserDefault standardUserDefaults] getUserDeviceToken]) {
        baiduPushKey = [[MyUserDefault standardUserDefaults] getUserDeviceToken];
    }
    NSString *baiduUid ;
    if ([[MyUserDefault standardUserDefaults]getBDUserPushId]) {
        baiduUid = [[MyUserDefault standardUserDefaults] getBDUserPushId];
    }
    
    NSString *useToken;
    if ([[MyUserDefault standardUserDefaults] getSandBoxUserToken]) {
        useToken =[[MyUserDefault standardUserDefaults] getSandBoxUserToken];
    }else{
        if ([SSKeychain passwordForService:kKeyChainCount account:@"UserToken"]) {
            useToken = [SSKeychain passwordForService:kKeyChainCount account:@"UserToken"];
            [[MyUserDefault standardUserDefaults] setSandBoxUserToken:useToken];
        }else{
            for (int i=0; i < 3; i++) {
                useToken = [SSKeychain passwordForService:kKeyChainCount account:@"UserToken"];
                if (useToken) {
                    break;
                }
            }
        }
    }
    if ([NSString isEmptyString:useToken]) {
        useToken = [self getUserToken];
        NSDictionary * dic= @{@"ver":appVer,@"token" :useToken ,@"uuid":uuidString ,@"udid":openudid,@"sys_ver":sysVer,@"mobel_model":model,@"mac":macStr,@"idfa":idfa ,@"vendor":vendor,@"chanal":@"company",@"ouuid":openudid };
        [self requestForLogin:dic];
    }else{
        NSDictionary *dic;
        if (baiduPushKey && baiduUid) {
            dic= @{@"ver":appVer,@"token" :useToken ,@"uuid":uuidString ,@"udid":openudid,@"sys_ver":sysVer,@"mobel_model":model,@"mac":macStr,@"idfa":idfa ,@"vendor":vendor,@"chanal":@"company",@"ouuid":openudid ,@"baidu_push_id":baiduPushKey,@"baiduid":baiduUid};
        }else{
            dic= @{@"ver":appVer,@"token" :useToken ,@"uuid":uuidString ,@"udid":openudid,@"sys_ver":sysVer,@"mobel_model":model,@"mac":macStr,@"idfa":idfa ,@"vendor":vendor,@"chanal":@"company",@"ouuid":openudid };
        }
        
        [self requestForLogin:dic];
    }
}
-(void) showServiceErrorTip{
    if ([UIAlertView isInit]) {
        [UIAlertView resetNetAlertNil];
    }
    if ([[LoadingView showLoadingView] actViewIsAnimation]) {
        [[LoadingView showLoadingView] actViewStopAnimation];
    }
    UIAlertView *serviceTip = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"服务器正在维护当中，请稍后再试，给您带来不便敬请谅解！" delegate:self cancelButtonTitle:@"我知道了，退出" otherButtonTitles: nil];
    serviceTip.tag = kServiceErrorTag ;
    [serviceTip show];
}
-(void)requestForLogin:(NSDictionary *)dic{
    NSString *urlString =[NSString stringWithFormat:kOnlineWeb,@"login"];
    NSLog(@"流量王请求登陆 URL==%@ Dic==%@",urlString,dic);
    [[LoadingView showLoadingView] actViewStartAnimation];
    [LLAsynURLConnection requestURLWith:urlString dataDic:dic andProtocolNum:@"10001" andTimeOut:httpTimeout connectSuccess:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *datadic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *string =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"获取请求数据 == %@  %@",datadic,string);
            if (datadic ==nil) {  //服务器报错
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showServiceErrorTip];
                    return ;
                });
                
            }
            
            if ([[datadic objectForKey:@"flag"] intValue] ==1) {
                NSDictionary *body =[datadic objectForKey:@"body"];
                if ([[body objectForKey:@"state"] intValue] ==0) {         //正常登陆
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginedNotic object:nil];   //发送登录成功通知
                    
                    NSString *codeKey =[body objectForKey:@"token"];
                    NSString *md5Str = [NSString md5Code:codeKey];
                    md5Str =[md5Str substringWithRange:NSMakeRange(24, 8)];      //加密token 取后8位
                    [[MyUserDefault standardUserDefaults] setRequestCodeKey:md5Str];
                    
                    long usergold =(long)[[body objectForKey:@"balance"] longLongValue];
                    [[MyUserDefault standardUserDefaults] setUserBeanNum:usergold];
                    NSString *userId =[body objectForKey:@"uid"];
                    [[MyUserDefault standardUserDefaults] setUserId:userId];
                    
                    int refreshTime =[[body objectForKey:@"refresh_time"]intValue];
                    [[MyUserDefault standardUserDefaults] setViewFreshTime:[NSNumber numberWithInt:refreshTime]];
                    
                    NSNumber *hongbao = [body objectForKey:@"hongbao"];
                    [[MyUserDefault standardUserDefaults] setUserDidGetHongBao:hongbao]; //是否领取了红包
                    if ([hongbao intValue] == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:ShowHongBao object:nil userInfo:nil];
                        });
                        
                    }
                    
                    NSDictionary *update = [body objectForKey:@"update"];
                    if(update != nil && update.allKeys.count != 0){
                        int type =[[update objectForKey:@"type"] intValue];
                        if (type !=0) {
                            [[MyUserDefault standardUserDefaults] setUpdate:update];
                            int delay = [[update objectForKey:@"delay"] intValue];
                            [[MyUserDefault standardUserDefaults] setUpdateDelayTime:delay];
                        }else{
                            [[MyUserDefault standardUserDefaults] setUpdate:nil];
                        }
                        
                    }else{
                        [[MyUserDefault standardUserDefaults] setUpdate:nil];
                    }
                    
                    NSString *adress =[body objectForKey:@"pic_server"];
                    if (adress) {
                        [[MyUserDefault standardUserDefaults] setPhotoServiceAdress:adress];
                    }
                    NSArray *welcomes =(NSArray *)[body objectForKey:@"welcome"];  //注意欢迎页为空时  数据结构
                    
                    if (welcomes.count ==2) {
                        
                        NSDictionary *welcomeDic =[welcomes objectAtIndex:0];
                        if (welcomeDic.allKeys.count >0) {
                            [[MyUserDefault standardUserDefaults] setWelcomeImgDic:welcomeDic];
                            NSString *picUrl;
                            picUrl=[welcomeDic objectForKey:@"pic1"];
                            if (kmainScreenHeigh == 568.0f) {
                                picUrl =[welcomeDic objectForKey:@"pic2"];
                            }else if (kmainScreenHeigh == 667.0f){
                                picUrl =[welcomeDic objectForKey:@"pic3"];
                            }else if (kmainScreenHeigh == 736.0f){
                                picUrl =[welcomeDic objectForKey:@"pic4"];
                            }
                            [[MyUserDefault standardUserDefaults] setWelcomeImgUrl:picUrl];
                            
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                NSData *picData =[NSData dataWithContentsOfURL:[NSURL URLWithString:picUrl]];
                                NSLog(@" 欢迎页图1 ==%d",picData.length);
                                if (picData) {
                                    [[MyUserDefault standardUserDefaults] setWelcomeImgData:picData];
                                }
                            });
                            
                        }else{
                            NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:nil,@"Welcome", nil];
                            [[MyUserDefault standardUserDefaults] setWelcomeImgDic:dic];
                        }
                        
                        NSDictionary *welcomeDic2 =[welcomes objectAtIndex:1];
                        if (welcomeDic2.allKeys.count >0) {
                            [[MyUserDefault standardUserDefaults] setWelcomeImgDic2:welcomeDic2];
                            NSString *picUrl;
                            picUrl=[welcomeDic2 objectForKey:@"pic1"];
                            if (kmainScreenHeigh == 568.0f) {
                                picUrl =[welcomeDic2 objectForKey:@"pic2"];
                            }else if (kmainScreenHeigh == 667.0f){
                                picUrl =[welcomeDic2 objectForKey:@"pic3"];
                            }else if (kmainScreenHeigh == 736.0f){
                                picUrl =[welcomeDic2 objectForKey:@"pic4"];
                            }
//                            [[MyUserDefault standardUserDefaults] setWelcomeImgUrl:picUrl];
                            
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                NSData *picData =[NSData dataWithContentsOfURL:[NSURL URLWithString:picUrl]];
                                NSLog(@" 欢迎页图2 ==%d",picData.length);
                                if (picData) {
                                    [[MyUserDefault standardUserDefaults] setWelcomeImgData2:picData];
                                }
                            });
                            
                        }else{
                            NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:nil,@"Welcome", nil];
                            [[MyUserDefault standardUserDefaults] setWelcomeImgDic2:dic];
                        }

                    }else if (welcomes.count ==1){
                        NSDictionary *welcomeDic =[welcomes objectAtIndex:0];
                        if (welcomeDic.allKeys.count >0) {
                            [[MyUserDefault standardUserDefaults] setWelcomeImgDic:welcomeDic];
                            NSString *picUrl;
                            picUrl=[welcomeDic objectForKey:@"pic1"];
                            if (kmainScreenHeigh == 568.0f) {
                                picUrl =[welcomeDic objectForKey:@"pic2"];
                            }else if (kmainScreenHeigh == 667.0f){
                                picUrl =[welcomeDic objectForKey:@"pic3"];
                            }else if (kmainScreenHeigh == 736.0f){
                                picUrl =[welcomeDic objectForKey:@"pic4"];
                            }
                            [[MyUserDefault standardUserDefaults] setWelcomeImgUrl:picUrl];
                            
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                NSData *picData =[NSData dataWithContentsOfURL:[NSURL URLWithString:picUrl]];
                                NSLog(@" 欢迎页图1 ==%d",picData.length);
                                if (picData) {
                                    [[MyUserDefault standardUserDefaults] setWelcomeImgData:picData];
                                }
                            });
                            
                        }else{
                            NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:nil,@"Welcome", nil];
                            [[MyUserDefault standardUserDefaults] setWelcomeImgDic:dic];
                        }

                    }else{
                        NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:nil,@"Welcome", nil];
                        [[MyUserDefault standardUserDefaults] setWelcomeImgDic:dic];
                        [[MyUserDefault standardUserDefaults] setWelcomeImgDic2:dic];
                    }
                    
                    NSDictionary *phoneNums =[body objectForKey:@"section_num"];
                    if (phoneNums) {
                        [[MyUserDefault standardUserDefaults] setSystemPhoneCarrier:phoneNums];    //保存号码段
                    }
                    
                    //保存当前时间
                    NSDate *nowDate = [NSDate date];
                    NSTimeInterval timenow = [nowDate timeIntervalSince1970];
                    long long int date = (long long int)timenow;
                    NSNumber *time = [NSNumber numberWithLongLong:date];
                    [[MyUserDefault standardUserDefaults] setLoginTime:time];
                    [[MyUserDefault standardUserDefaults] setLogined:YES];
                    //保存签到的刷新时间
                    [[MyUserDefault standardUserDefaults] setSignFreshTime:[body objectForKey:@"signFreshTime"]];
                    
                    //保存用户的头像地址
                    [[MyUserDefault standardUserDefaults] setUserIconUrlStr:[body objectForKey:@"pic"]];
                    
                    //                    if (!enterForward) {
                    //                        tabViewCtr.state =1;
                    ////                        [tabViewCtr requestWelcomeAndShow];
                    //
                    //                        if (kDeviceVersion >= 7.0) {
                    //                            TjNavigationController* nv = [[TjNavigationController alloc]initWithRootViewController:tabViewCtr];
                    //                            self.window.rootViewController = nv;
                    //                        }else{
                    //                            UINavigationController* nv = [[UINavigationController alloc]initWithRootViewController:tabViewCtr];
                    //                            self.window.rootViewController = nv;
                    //                        }
                    //
                    //                    }
                    
                    if (!enterForward || [[update objectForKey:@"type"]intValue] ==0) {//从后台进前台时也显示  检测是否显示升级信息
                        [tabViewCtr checkUpdate];
                    }
                    //                    [self requestToSendLastTime];
                    [self registRemoteNotification];    // 注册远程通知
                    
                    if (launchDic ) {
                        [self receivePushMessage:launchDic];    //登陆成功 传递接收到的push消息
                        launchDic = nil;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[LoadingView showLoadingView] actViewStopAnimation];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"requestToSpecialMisson" object:nil];
                    });
                    
                }else if ([[body objectForKey:@"state"] intValue] ==1){
                    [[MyUserDefault standardUserDefaults] setLogined:NO];
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    [self showLoackingView];
                }
                
            }
        });
    } andFail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            //连接超时,重新登录
            if(timeOutCount < 2){
                timeOutCount ++;
                [self requestForLogin:dic];
            }else{
                timeOutCount = 0;
                if(![UIAlertView isInit]){
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    UIAlertView *alertView = [UIAlertView showNetAlert];
                    alertView.delegate = self;
                    alertView.tag = kNetViewTag + 1;
                    [alertView show];
                    alertView = nil;
                }
            }
        }
        
    }];
}
/**
 *  / 发送用户登录请求
 */
/*
 -(void)sendLoginRequest{
 
 NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
 NSString *uuidStr = [NSString stringWithFormat:@"%@",uuid];
 NSArray *array = [uuidStr componentsSeparatedByString:@">"];
 
 NSString *uuidString = [array objectAtIndex:1];
 
 NSString *sysVer = [UIDevice currentDevice].systemVersion;
 //设备类型需要加入运营商参数
 NSString *model2 = [[UIDevice currentDevice] model];
 NSLog(@"model2 = %@",model2);
 if ([model2 isEqualToString:@"iPhone"]) {
 CTTelephonyNetworkInfo* netInfo =[[CTTelephonyNetworkInfo alloc]init];
 CTCarrier* ct = [netInfo subscriberCellularProvider];
 model2 =[NSString stringWithFormat:@"%@%@",model2,[ct mobileNetworkCode]];
 NSLog(@"---CTCarrier--%@--%@--%@--%@-",model2,[ct carrierName],[ct mobileNetworkCode],[ct mobileCountryCode]);
 }
 
 NSString *model = [self getDeviceModel];
 
 NSString *appVer = [[[NSBundle mainBundle]infoDictionary]objectForKey:(NSString* )kCFBundleVersionKey];
 
 NSString *openudid = [OpenUDID value];
 
 NSString *adid = [[[ASIdentifierManager sharedManager]advertisingIdentifier] UUIDString];
 
 NSString *vendor = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
 
 NSString *macAdress = [NSString getMacAdress];
 
 NSString *useToken;
 if ([[MyUserDefault standardUserDefaults] getSandBoxUserToken]) {
 useToken =[[MyUserDefault standardUserDefaults] getSandBoxUserToken];
 }else{
 if ([SSKeychain passwordForService:@"LXWiFiToken" account:@"UserToken"]) {
 useToken = [SSKeychain passwordForService:@"LXWiFiToken" account:@"UserToken"];
 [[MyUserDefault standardUserDefaults] setSandBoxUserToken:useToken];
 }else{
 for (int i=0; i < 3; i++) {
 useToken = [SSKeychain passwordForService:@"LXWiFiToken" account:@"UserToken"];
 if (useToken) {
 break;
 }
 }
 }
 }
 //    useToken = [SSKeychain passwordForService:@"91taojinToken" account:@"userToken"];
 // 2014.04.04 新包首次登陆的接口改变  不发送userToken
 if ([NSString isEmptyString:useToken]) {
 NSString *sign = [NSString stringWithFormat:@"%@%@91taojinToken",adid,model];
 sign = [sign stringByReplacingOccurrencesOfString:@"-" withString:@""];
 sign = [NSString md5Code:sign];
 useToken =[self getUserToken];
 NSDictionary *dic = @{@"Mac": macAdress, @"Version":appVer, @"mobel":model, @"chanal":@"company", @"vindor":vendor,@"sys_ver":sysVer, @"uuid":uuidString, @"idfa":adid, @"ouuid":openudid, @"sign":sign ,@"token" :useToken};
 [self requestToLoginWithToken:dic];
 }else{
 // 加密数据
 NSString* sign = [NSString stringWithFormat:@"%@%@91taojinToken",useToken,model];
 sign = [sign stringByReplacingOccurrencesOfString:@"+" withString:@" "];
 sign = [NSString md5Code:sign];
 NSDictionary *dic = @{@"token": useToken, @"Mac":macAdress, @"Version":appVer, @"mobel":model, @"chanal":@"company", @"vindor":vendor, @"sys_ver":sysVer, @"uuid":uuidString, @"idfa":adid, @"ouuid":openudid, @"sign":sign};
 [self requestToLoginWithToken:dic];
 }
 
 }
 */
-(NSString *)getUserToken{
    NSDate* nowDate=[NSDate date];
    NSTimeZone* zone=[NSTimeZone systemTimeZone];
    NSInteger interval=[zone secondsFromGMTForDate:nowDate];
    NSDate* locationDate=[nowDate dateByAddingTimeInterval:interval];
    int rand =arc4random()%10000000;
    NSString * useToken=[NSString stringWithFormat:@"%@%d",locationDate,rand];
    //将生成的用户标记  存入钥匙串内
    [SSKeychain setPassword:useToken forService:kKeyChainCount account:@"UserToken"];
    [[MyUserDefault standardUserDefaults] setSandBoxUserToken:useToken];
    return useToken;
}
//请求token登录（new）
-(void)requestToLoginWithToken:(NSDictionary *)dic {
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"LoginUI",@"Login"];
    //    [self requestToLogin:dic urlStr:urlStr];
}

//请求登录（new）
/*
 -(void)requestToLogin:(NSDictionary *)dic urlStr:(NSString *)urlStr{
 NSLog(@"请求登录【urlStr】 = %@",urlStr);
 NSLog(@"请求登录【request】 = %@",dic);
 [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
 NSString *err =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
 NSLog(@" err = %@",err);
 timeOutCount = 0;               //超时次数清空
 NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
 NSString *loginStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
 NSLog(@"请求登录【response】 = %@  %@",dataDic ,loginStr);
 int flag = [[dataDic objectForKey:@"flag"] integerValue];
 if (flag == 1) {
 //登录成功
 NSDictionary *body = [dataDic objectForKey:@"body"];
 if([[body objectForKey:@"flag"] intValue] == 1 || [[body objectForKey:@"flag"] intValue] == 0){
 NSString *sid = [body objectForKey:@"sid"];
 [[MyUserDefault standardUserDefaults] setSid:sid];
 [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginedNotic" object:nil];   //发送登录成功通知
 
 if ([body objectForKey:@"Token"]) {                                 // 记录服务器返回的用户标示
 NSString* passWord = [body objectForKey:@"Token"];
 [SSKeychain setPassword:passWord forService:@"91taojinToken" account:@"userToken"];
 }
 NSString *nickName = [body objectForKey:@"UserNickname"];
 [[MyUserDefault standardUserDefaults] setUserNickname:nickName];
 if([NSString isEmptyString:nickName]){
 [[NSNotificationCenter defaultCenter] postNotificationName:@"makeAnickname" object:nil userInfo:nil];
 }
 
 //保存取名奖励和邀请奖励金豆数
 int inviteGold = [[body objectForKey:@"InviteGold"] intValue];
 [[MyUserDefault standardUserDefaults] setInviteGold:inviteGold];
 int gold = [[body objectForKey:@"SetNameGold"] intValue];
 [[MyUserDefault standardUserDefaults] setUserSetNameGold:gold];
 
 //保存用户ID
 NSString *userId = [body objectForKey:@"UserId"];
 [[MyUserDefault standardUserDefaults] setUserId:userId];
 
 NSString *userInvcode =[body objectForKey:@"invcode"];
 [[MyUserDefault standardUserDefaults] setUserInvcode:userInvcode];
 
 
 NSString *codeKey =[body objectForKey:@"token"];
 NSString *md5Str = [NSString md5Code:codeKey];
 md5Str =[md5Str substringWithRange:NSMakeRange(24, 8)];      //加密token 取后8位
 [[MyUserDefault standardUserDefaults] setRequestCodeKey:md5Str];
 
 NSDictionary *update = [body objectForKey:@"Update"];
 if(update != nil && update.allKeys.count != 0){
 [[MyUserDefault standardUserDefaults] setUpdate:update];
 int delay = [[update objectForKey:@"Delay"] intValue];
 [[MyUserDefault standardUserDefaults] setUpdateDelayTime:delay];
 }else{
 [[MyUserDefault standardUserDefaults] setUpdate:nil];
 }
 //保存当前时间
 NSDate *nowDate = [NSDate date];
 NSTimeInterval timenow = [nowDate timeIntervalSince1970];
 long long int date = (long long int)timenow;
 NSNumber *time = [NSNumber numberWithLongLong:date];
 [[MyUserDefault standardUserDefaults] setLoginTime:time];
 [[MyUserDefault standardUserDefaults] setLogined:YES];
 //保存签到的刷新时间
 [[MyUserDefault standardUserDefaults] setSignFreshTime:[body objectForKey:@"signFreshTime"]];
 [[MyUserDefault standardUserDefaults] setViewFreshTime:[body objectForKey:@"viewFreshTime"]];
 //保存用户的头像地址
 [[MyUserDefault standardUserDefaults] setUserIconUrlStr:[body objectForKey:@"userIconUrl"]];
 
 if (enterForward) {
 tabViewCtr.state =1;
 [tabViewCtr requestWelcomeAndShow];
 
 if (kDeviceVersion >= 7.0) {
 TjNavigationController* nv = [[TjNavigationController alloc]initWithRootViewController:tabViewCtr];
 self.window.rootViewController = nv;
 }else{
 UINavigationController* nv = [[UINavigationController alloc]initWithRootViewController:tabViewCtr];
 self.window.rootViewController = nv;
 }
 
 }
 
 if (!enterForward || [[update objectForKey:@"Type"]intValue] ==0) {//强制升级的话  从后台进前台时也显示
 [tabViewCtr checkUpdate];
 }
 [self requestToSendLastTime];
 [self registRemoteNotification];    // 注册远程通知
 
 if (launchDic && enterForward == YES) {
 [self receivePushMessage:launchDic];    //登陆成功 传递接收到的push消息
 launchDic = nil;
 }
 
 //判断是否需要显示有米广告
 int youMiAd = [[body objectForKey:@"BannerAD"] intValue];
 if(youMiAd == 1){
 //测试
 [[NSNotificationCenter defaultCenter] postNotificationName:@"YouMiAd" object:nil];
 }
 dispatch_async(dispatch_get_main_queue(), ^{
 //                    [[LoadingView showLoadingView] actViewStopAnimation];
 });
 }else{
 [[MyUserDefault standardUserDefaults] setLogined:NO];
 [[LoadingView showLoadingView] actViewStopAnimation];
 [self showLoackingView];
 }
 }else if(flag == 2){
 //登录失败，账号被锁
 [[MyUserDefault standardUserDefaults] setLogined:NO];
 [[LoadingView showLoadingView] actViewStopAnimation];
 //            [self showLoackingView];
 }else if (flag == 3){
 [[MyUserDefault standardUserDefaults] setLogined:NO];
 [[LoadingView showLoadingView] actViewStopAnimation];
 if ( timeErrorCount < 2) {
 timeErrorCount ++ ;
 [self requestToLogin:dic urlStr:urlStr];
 }
 
 }
 }fail:^(NSError *error) {
 NSLog(@"-----请求登录【error】 = %@ -----",error);
 if(error.code == timeOutErrorCode){
 //连接超时,重新登录
 if(timeOutCount < 2){
 timeOutCount ++;
 [self requestToLoginWithToken:dic];
 }else{
 timeOutCount = 0;
 if(![UIAlertView isInit]){
 [[LoadingView showLoadingView] actViewStopAnimation];
 UIAlertView *alertView = [UIAlertView showNetAlert];
 alertView.delegate = self;
 alertView.tag = kNetViewTag + 1;
 [alertView show];
 alertView = nil;
 }
 }
 }
 }];
 }
 */
//提示账户锁住弹窗
-(void)showLoackingView{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"非常抱歉，您的账号已被锁定" delegate:self cancelButtonTitle:@"退出" otherButtonTitles: nil];
    alertView.delegate = self;
    alertView.tag = kExitAppTag;
    [alertView show];
}
-(void)receivePushMessage:(NSDictionary* )infor{
    NSLog(@"  pushInfo %@ ",infor);
    NSString *act;
    if ([infor objectForKey:@"pri"]){    // 奖品
        [[NSNotificationCenter defaultCenter] postNotificationName:PushToReward object:nil userInfo:infor];
        act =[NSString stringWithFormat:@"pri="];
        act =[act stringByAppendingString:[infor objectForKey:@"pri"]];
        
        //        [self sendAPushMakerToService:act];
    }else if ([infor objectForKey:@"act"]){   // 活动
        [[NSNotificationCenter defaultCenter] postNotificationName:PushToActivity object:nil userInfo:infor];
        act =[NSString stringWithFormat:@"act="];
        act =[act stringByAppendingString:[infor objectForKey:@"act"]];
        
        //        [self sendAPushMakerToService:act];
    }else if ([infor objectForKey:@"msg"]){ // 消息
        [[NSNotificationCenter defaultCenter] postNotificationName:PushToMessage object:nil userInfo:infor];
        act =[NSString stringWithFormat:@"msg="];
        act =[act stringByAppendingString:[infor objectForKey:@"msg"]];
        
        //        [self sendAPushMakerToService:act];
        
    }
    
    
}
-(void)sendAPushMakerToService:(NSString *)pushAct{
    
    NSString *urlString = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"OtherUI",@"BaiduPush"];
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:pushAct,@"Act",[NSNumber numberWithInt:1],@"Num",@"click",@"Operate", nil];
    NSLog(@" PUSH 统计 = %@",dic);
    [AsynURLConnection requestWithURL:urlString dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@" BDpush %@ ",dataDic);
            dispatch_async(dispatch_get_main_queue(), ^{
                //              [[LoadingView showLoadingView] actViewStopAnimation];
            });
        });
    } fail:^(NSError *error) {
        
    }];
}


//请求发送最后一次时间
-(void)requestToSendLastTime{
    
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"LoginUI",@"Scene"];
    NSLog(@"请求发送最后一次时间[urlStr] = %@",urlStr);
    /*
     NSNumber *timelong = [[MyUserDefault standardUserDefaults] getAppUseTime] ;
     if(timelong == nil){
     timelong = [NSNumber numberWithInt:0];
     }
     NSNumber *netWork = [[MyUserDefault standardUserDefaults] getNetWork];
     NSNumber *loginTime = [[MyUserDefault standardUserDefaults] getLoginTime];
     NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
     NSDictionary *dic = @{@"timelong": timelong, @"network":netWork, @"logintime":loginTime, @"sid":sid};
     
     
     [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data){
     NSLog(@"发送最后一次时间【request】 = %@",dic);
     
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
     NSLog(@"发送最后一次时间【reponse】 = %@",dicData);
     dispatch_async(dispatch_get_main_queue(), ^{
     
     });
     });
     }fail:^(NSError *error){
     NSLog(@"-----请求发送最后一次时间【error】 = %@ -----",error);
     }];
     */
}



//弹窗的按钮事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == kNoNetWorkTag) {
        //检测网络发现无网络下的弹窗
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
        [UIAlertView resetNetTipAlertView];
        
        [self onClickNetCheckBtn];
    }else if(alertView.tag == kNetViewTag +1){
        //请求登录超时
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
        [UIAlertView resetNetTipAlertView];
        
        [self sendUserLoginRequest];
    }else if(alertView.tag == kExitAppTag){
        //退出程序弹窗
        [self exitApplication];
    }else if (alertView.tag == kServiceErrorTag){
        //服务器报错
        [self exitApplication];
    }
}
-(void)onClickNetCheckBtn{
    [hostReach stopNotifier];
    hostReach = nil;
    [self performSelector:@selector(checkDeviceNetWork) withObject:nil afterDelay:10.0];
}
-(void)initBadgeNumber{
    //重置图标上的消息数量
    NSLog(@"   重置消息数");
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}

//关闭应用程序动画
- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.window.transform = CGAffineTransformIdentity;
    self.window.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [UIView commitAnimations];
    
}
//app启动时 在此方法接收push消息
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [self initBadgeNumber];
    //app在前台
    if(application.applicationState == 0) {
        
    }else if(application.applicationState == 1){   //app在后台
        if (userInfo) {
            [self receivePushMessage:userInfo];
        }
    }
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@" 注册远程通知成功 ");
    //获取令牌
    NSString* userDeviceToken = [NSString stringWithFormat:@"%@",deviceToken];
    userDeviceToken = [[userDeviceToken substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)];
    userDeviceToken = [userDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    //保存
    [[MyUserDefault standardUserDefaults] setUserDeviceToken:userDeviceToken];
    
    // 将push的token 保存在钥匙串里
    NSString *pushToken2 = [NSString md5Code:userDeviceToken];
    [[MyUserDefault standardUserDefaults] setUserMd5DeveiceToken:pushToken2];
    [SSKeychain setPassword:userDeviceToken forService:kKeyChainCount account:@"pushToken"];
    [SSKeychain setPassword:pushToken2 forService:kKeyChainCount account:@"md5Token"];
    
    if (![[self getDeviceModel] isEqualToString:@"x86_64"]) {
        [BPush registerDeviceToken:deviceToken];
        [BPush bindChannel];
    }
    
}
-(void)sendBDPushIdToService{
    NSString *userDeviceToken =[[MyUserDefault standardUserDefaults] getUserDeviceToken];
    NSString *pushToken2 =[[MyUserDefault standardUserDefaults] getUserMd5DeveiceToken];
    NSString *pushid =[[MyUserDefault standardUserDefaults] getBDUserPushId];
    [self sendTokenToService:userDeviceToken andMd5Token:pushToken2 andUserPushId:pushid];
}
//发送token到服务器成功后 记录下注册成功
-(void)sendTokenToService:(NSString* )token andMd5Token:(NSString* )mdToken andUserPushId:(NSString *)pushId{
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid, @"token":token, @"91token":mdToken ,@"bPushId" :pushId ,@"chanal" :@"company"};
    [self requestToSetToken:dic];
}

//请求设置Token（new）
-(void)requestToSetToken:(NSDictionary *)dic{
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"LoginUI",@"setToken"];
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data){
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *body = [dataDic objectForKey:@"body"];
        if([[body objectForKey:@"State"] integerValue] == 0){
            [[MyUserDefault standardUserDefaults] setIsRegistRemotion:YES];
        }else{
            [[MyUserDefault standardUserDefaults] setIsRegistRemotion:NO];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [[LoadingView showLoadingView] actViewStopAnimation];
        });
    }fail:^(NSError *error) {
        NSLog(@"-----请求设置Token【error】 = %@ -----",error);
    }];
}
//关闭应用程序
- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSDate* nowDate=[NSDate date];
    NSTimeInterval time =[nowDate timeIntervalSince1970];
    long long int date =(long long int)time;
    NSUserDefaults* ud =[NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:@"LoginTime"]) {
        long long oldtime =[[ud objectForKey:@"LoginTime"]integerValue];
        double betweentime = date- oldtime;
        NSNumber *timeNum =[NSNumber numberWithDouble:betweentime];
        [ud setValue:timeNum  forKey:@"AppUseTime"];
    }
    
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    
    /*
     UIApplicationState state = [[UIApplication sharedApplication] applicationState];
     if (state == UIApplicationStateInactive) {
     NSLog(@"Sent to background by locking screen");
     } else if (state == UIApplicationStateBackground) {
     if (![[NSUserDefaults standardUserDefaults] boolForKey:@"kDisplayStatusLocked"]) {
     NSLog(@"Sent to background by home button/switching to other app");
     } else {      //当app 在前台运行 直接按锁屏按钮 才会触发
     NSLog(@"Sent to background by locking screen");
     }
     }
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    enterForward =NO;
    [self sendUserLoginRequest];
    [self initBadgeNumber];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}
//-(BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier{
//    return NO;
//}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)checkTime{
    NSLog(@" backgroundtimeremain == %f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
    if ([[UIApplication sharedApplication] backgroundTimeRemaining] < 61.0) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        NSLog(@" play no voice radio ");
        //        [self playNoVoiceSound];
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            NSLog(@"  begin background task  22 ");
        }];
    }
}
-(void)playNoVoiceSound{
    NSString *path =[[NSBundle mainBundle]pathForResource:@"win" ofType:@"wav"];
    SystemSoundID soundID ;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound(soundID);
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如新浪微博SDK等
    }
    return result;
}


@end
