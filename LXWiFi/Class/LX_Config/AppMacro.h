//
//  AppMacro.h
//  乐享WiFi
//
//  Created by keyrun on 14-9-16.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#ifndef __WiFi_AppMacro_h
#define __WiFi_AppMacro_h

// 设备相关的常量
#define kmainScreenWidth                            [[UIScreen mainScreen]bounds].size.width
#define kmainScreenHeigh                            [[UIScreen mainScreen]bounds].size.height


#define kDeviceVersion                              [[[UIDevice currentDevice] systemVersion] floatValue]


#define AppVersion                                  [[[NSBundle mainBundle]infoDictionary]objectForKey:(NSString* )kCFBundleVersionKey]
#define kBatterHeight                               ([[[UIDevice currentDevice]systemVersion]floatValue]) < (7.0) ? (20.0):(0.0)

//  服务器相关
//#define kUrlPre                                     @"%@?d=api&c=%@&m=%@&IOS=ios"
#define kUrlPre                                     @"%@?d=api2&c=%@&m=%@&IOS=ios"
#define kTestWeb                                    @"http://10.1.1.19:882/index.php"

#define kOnlineWeb                                   @"http://api.mianfei6.cn/api/ios/v1/%@"
//#define kOnlineWeb                                  @"http://10.1.1.139:805/api/ios/v1/%@"



#define httpTimeout                                 10
#define timeOutErrorCode                            300

/**
*  提示框 alertView Tag
*/
#define kNoNetWorkTag     10001
#define kNetTimeOutTag    10002
#define kExitAppTag       10003

#define kNetLoadingView                             90100
#define kTimeOutTag                                 200001
#define kNetViewTag                                 300001
#define kAlertViewTag                               400001
#define kLockTag                                    500001
#define kServiceErrorTag                            4004


/**
*   颜色相关的常量
*/
#define ColorRGB(a,b,c,p)                           [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:p]
#define tabbarDefaultTextColor                      [UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]
#define tabbarHighlightedTextColor                  [UIColor colorWithRed:109.0/255.0 green:179.0/255.0 blue:227.0/255.0 alpha:1.0]
#define KRedColor2_0                                [UIColor colorWithRed:239.0/255.0 green:86.0/255.0 blue:104.0/255.0 alpha:1]
#define KPurpleColor2_0                             [UIColor colorWithRed:150.0/255.0 green:110.0/255.0 blue:220.0/255.0 alpha:1]
#define KLightGrayColor2_0                          [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1]
#define KGrayColor2_0                               [UIColor colorWithRed:137.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1]
#define kLineColor2_0                               [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1]
#define kJFQSelctColor2_0                           [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]
#define KGreenColor2_0                              [UIColor colorWithRed:180.0/255.0 green:215.0/255.0 blue:60.0/255.0 alpha:1]
#define KBlockColor2_0                              [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1]
#define kSilverColor                                [UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1]
#define kGrayLineColor2_0                           [UIColor colorWithRed:195.0/255.0 green:197.0/255.0 blue:199.0/255.0 alpha:1]
#define KOrangeColor2_0                             [UIColor colorWithRed:255.0/255.0 green:187.0/255.0 blue:51.0/255.0 alpha:1]
#define kSelectYellow                               [UIColor colorWithRed:250.0/255.0 green:195.0/255.0 blue:65.0/255.0 alpha:1]
#define kOrangeColor                                [UIColor colorWithRed:255.0/255.0 green:170.0/255.0 blue:25.0/255.0 alpha:1]
#define kSelectGreen                                [UIColor colorWithRed:139.0/255.0 green:183.0/255.0 blue:76.0/255.0 alpha:1]
#define kImageBackgound2_0                          [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]
#define kBlockBackground2_0                         [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]
#define KTipBackground2_0                           [UIColor colorWithRed:254.0/255.0 green:250.0/255.0 blue:230.0/255.0 alpha:1]
#define KLightGreenColor2_0                         [UIColor colorWithRed:160.0/255.0 green:210.0/255.0 blue:0.0/255.0 alpha:1]
#define KLightOrangeColor2_0                        [UIColor colorWithRed:255.0/255.0 green:170.0/255.0 blue:0.0/255.0 alpha:1]

#define kNewGrayColor                               ColorRGB(145.0,145.0,145.0,1.0)
#define kBlueTextColor2_0                           ColorRGB(51.0,181.0,229.0,1.0)
#define kContentTextColor                           ColorRGB(146.0,146.0,146.0,1.0)
#define kBlackTextColor                             ColorRGB(0.0,0.0,0.0,1.0)
#define kDefaulTextColor                            ColorRGB(200.0,200.0,200.0,1.0)
#define kRedTextColor                               ColorRGB(255.0,68.0,68.0,1.0)
#define kLightRedTextColor                          ColorRGB(255.0,40.0,40.0,1.0)
#define kBlueTextColor                              ColorRGB(60.0,182.0,227.0,1.0)
#define kLightBlueTextColor                         ColorRGB(5.0,170.0,230.0,1.0)
#define kWitheColor                                 [UIColor whiteColor]
#define kGobackColor                                ColorRGB(0.0,153.0,204.0,1.0)
#define kHongBaoRedColor                            ColorRGB(252.0,70.0,74.0,1.0)
#define kAppInforTextColor                          ColorRGB(106.0,110.0,110.0,1.0)
#define kLightPurpleColor                           ColorRGB(120.0,70.0,220.0,1.0)
/**
*  UI视图相关
*/
#define kfootViewHeigh                              50.0f
#define kOriginY                                    ([[[UIDevice currentDevice]systemVersion]floatValue]) >= (7.0) ? (20.0f):(0.0f)
#define kHeadViewHeigh                              44.0f
#define Spacing2_0                                  10.0
#define kOffX_float                                  7.0f
#define kOffX_2_0                                   10.0f
#define kRecordTabWidth                             120.0f
#define kRecordTabCellHeigh                          40.0f
#define LineWidth                                   0.5f
#define kTableLoadingViewHeight2_0                  40.0f
#define kButtonHeigh                                 45.0f              


#define SendViewHeight                                          50.0f                       //输入框的高度
#define SendButtonHeight                                        40.0f                       //发送按钮的高度
#define SendButtonWidth                                         150.0f                       //发送按钮的宽度
#define ImageButtonWidth                                        41.0f                       //选取图片按钮高度
#define ImageButtonOffX                                         10.0f                       //选图按钮 x偏移度

/**
*  字体相关
*/
#define GetFont(a)          [UIFont systemFontOfSize:a]
#define GetBoldFont(a)      [UIFont fontWithName:@"HelveticaNeue-Bold" size:a]
#define tabbarFont          [UIFont systemFontOfSize:11]
#define kFontSize_11        GetFont(11)
#define kFontSize_16        GetFont(16)
#define kFontSize_14        GetFont(14)

/**
*  文字相关
*/
#define FlowCenterName   @"赚流量币"
#define ServiceCenterName  @"兑换流量"
#define UserCenterName   @"流量中心"

#define BackTitle       @"返回"



#endif
