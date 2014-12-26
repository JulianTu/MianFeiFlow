//
//  LXTabViewController.m
//  乐享WiFi
//
//  Created by keyrun on 14-9-16.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LXTabViewController.h"
#import "LXUserCenterController.h"
#import "LXServiceCenterController.h"
#import "LXWiFiCenterController.h"
#import "TaskViewController.h"
#import "NSDate+nowTime.h"
#import "MyUserDefault.h"
#import "AsynURLConnection.h"
#import "LLAsynURLConnection.h"
#import "UIAlertView+NetPrompt.h"
#define klogowidth           25.0f
#define klogoheigh           25.0f
#define klogoOffy            7.0f
#define knamewidth           kmainScreenWidth/3
#define knameheigh           14.0f
#define kNameOffy            34.0f             //文字y坐标

typedef enum{
    TaskType = 1,
    ActivityType,
    RewardType,
    NewUser,
}TaojinTypeEnum;
@interface LXTabViewController ()
{
    UIImageView* one ;
    UIImageView* two ;
    UIImageView* three ;
    UIImageView* four ;
    UILabel *Lone ;
    UILabel* Ltwo ;
    UILabel* Lthree ;
    UILabel* Lfour ;
    
    int freshTime;
    TaojinTypeEnum taojintype;
    
    TaskViewController *wifiCenter ;
    LXServiceCenterController *serviceCenter ;
    LXUserCenterController *userCenter ;
    
    float  timeCount ;                                         //记录欢迎页已展示时间
    NSTimer *timer ;
    float welcomeStay ;                                        // 欢迎页停留时间
    
    NSString* ver;                                           // 再次登录不提示的版本号
    int updatetype;                                          // 升级类型
    UIAlertView* updateTip;                                  // 提示框
    NSString *updateUrl;                                     // 升级目标地址
    int timeOutCount ;
}
@end

@implementation LXTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        /*
         NSArray *arrayFilter = [NSArray arrayWithObjects: @"abc2",@"asd", nil];
         
         NSMutableArray *arrayContent = [NSMutableArray arrayWithObjects:@"a1", @"abc1", @"abc4", @"abc2", nil];
         
         NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", arrayFilter];
         
         [arrayContent filterUsingPredicate:thePredicate];
         NSLog(@"  arrayContent == %@",arrayContent);
         */
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor clearColor];
    timeCount = 0.0f;
    [self updateTabbarView];
    if (self.state == 0) {      // 是否需要展示欢迎图
        [self isNeedShowWelcome];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onCLickedUserCenter) name:GoBackToUserCenterNotic object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onCLickedFlowCenter) name:GoBackToFlowCenterNotic object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoginedNotic) name:UserLoginedNotic object:nil];
}
-(void)getLoginedNotic{
    
    [timer invalidate];
    NSLog(@" get notic %f %f",timeCount,welcomeStay);
    if (timeCount < welcomeStay) {
        float time = welcomeStay - timeCount ;
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(missWelcome) userInfo:nil repeats:NO];
        });
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self missWelcome];
        });
        
    }
}

-(void)onCLickedFlowCenter {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag =0 ;
    [self clickBtn:button];
}
-(void)onCLickedUserCenter {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag =2 ;
    [self clickBtn:button];
}
//初始化tabbar的按钮
- (UIButton *)loadWithTabbarButton:(CGRect)frame tag:(int)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor =[UIColor clearColor];
    button.frame = frame;
    button.tag = tag;
    [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
//初始化tabbar的图片
-(UIImageView *)loadWithTabbarImage:(CGRect)frame defaultImage:(UIImage *)defaultImage highlightedImage:(UIImage *)highImage isHighlighted:(BOOL)isHighlighted{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:defaultImage highlightedImage:highImage];
    imageView.frame = frame;
    [imageView setHighlighted:isHighlighted];
    return imageView;
}
//初始化tabbar的label
-(UILabel *)loadWithTabbarLabel:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor tag:(int)tag{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;
    label.text = text;
    label.textColor = textColor;
    return label;
}
-(void)updateTabbarView{
    
    UIView* footView = [[UIView alloc] initWithFrame:CGRectMake(0, kmainScreenHeigh - kfootViewHeigh, kmainScreenWidth, kfootViewHeigh)];
    footView.backgroundColor =ColorRGB(246.0, 246.0, 246.0, 1.0) ;
    CALayer *layer =[CALayer layer];
    layer.backgroundColor = kLineColor2_0.CGColor ;
    layer.frame = CGRectMake(0, 0, kmainScreenWidth, LineWidth);
    [footView.layer addSublayer:layer];
    
    //    UIView *lineImg = [[UIView alloc] initWithFrame:CGRectMake(0, kmainScreenHeigh - kfootViewHeigh, kmainScreenWidth, 0.5)];
    //    lineImg.backgroundColor = kLineColor2_0;
    //    [self.view addSubview:lineImg];
    
    
    UIButton *btnTJ = [self loadWithTabbarButton:CGRectMake(0,kmainScreenHeigh - kfootViewHeigh, kmainScreenWidth/3, kfootViewHeigh) tag:0];
    
    UIButton *btnRW = [self loadWithTabbarButton:CGRectMake(kmainScreenWidth/3,kmainScreenHeigh-kfootViewHeigh, kmainScreenWidth/3, kfootViewHeigh) tag:1];
    
    
    UIButton *btnUser = [self loadWithTabbarButton:CGRectMake(kmainScreenWidth/3*2,kmainScreenHeigh-kfootViewHeigh, kmainScreenWidth/3, kfootViewHeigh) tag:2];
    UIImage *image = GetImageWithName(@"taskdef");
    one = [self loadWithTabbarImage:CGRectMake(kmainScreenWidth/6 -image.size.width/2, klogoOffy, image.size.width, image.size.height) defaultImage:GetImageWithName(@"taskdef") highlightedImage:GetImageWithName(@"tasksel") isHighlighted:YES];
    [one setBackgroundColor:[UIColor clearColor]];
    
    two = [self loadWithTabbarImage:CGRectMake(kmainScreenWidth/2 -image.size.width/2 , klogoOffy, klogowidth, klogoheigh) defaultImage:GetImageWithName(@"flowdef") highlightedImage:GetImageWithName(@"flowsel") isHighlighted:NO];
    
    three = [self loadWithTabbarImage:CGRectMake(kmainScreenWidth/6 *5 -image.size.width/2, klogoOffy, klogowidth,klogoheigh) defaultImage:GetImageWithName(@"usercenterdef") highlightedImage:GetImageWithName(@"usercentersel") isHighlighted:NO];
    
    
    Lone = [self loadWithTabbarLabel:CGRectMake(0.0f, kNameOffy, knamewidth, knameheigh) text:FlowCenterName font:GetBoldFont(11.0) textColor:tabbarHighlightedTextColor tag:0];
    
    Ltwo = [self loadWithTabbarLabel:CGRectMake(kmainScreenWidth/3, kNameOffy, knamewidth, knameheigh) text:ServiceCenterName font:GetBoldFont(11.0) textColor:tabbarDefaultTextColor tag:1];
    
    Lthree = [self loadWithTabbarLabel:CGRectMake(kmainScreenWidth/3 *2, kNameOffy, knamewidth, knameheigh) text:UserCenterName font:GetBoldFont(11.0) textColor:tabbarDefaultTextColor tag:2];
    
    
    [footView addSubview:one];
    [footView addSubview:two];
    [footView addSubview:three];
    [footView addSubview:Lone];
    [footView addSubview:Ltwo];
    [footView addSubview:Lthree];
    
    [self.view addSubview:footView];
    [self.view addSubview:btnTJ];
    [self.view addSubview:btnRW];
    [self.view addSubview:btnUser];
    
}
-(void)clickBtn:(UIButton*)btn {
    switch (btn.tag) {
        case 0:
        {
            [self changeButtonHighlighted:YES twoIsHighlighted:NO threeIsHighlighted:NO fourIsHighlighted:NO];
            [self showTaskView];
            
        }
            break;
        case 1:
        {
            [self changeButtonHighlighted:NO twoIsHighlighted:YES threeIsHighlighted:NO fourIsHighlighted:NO];
            [self showActivityCenter];
            
        }
            break;
        case 2:
        {
            [self changeButtonHighlighted:NO twoIsHighlighted:NO threeIsHighlighted:YES fourIsHighlighted:NO];
            [self showUserCenter];
        }
            break;
        case 3:
        {
            [self changeButtonHighlighted:NO twoIsHighlighted:NO threeIsHighlighted:NO fourIsHighlighted:YES];
            
        }
            break;
        default:
            break;
    }
    self.selectedViewController = [self.viewControllers objectAtIndex:btn.tag];
}

-(void)showTaskView{          //赚流量
    NSNumber *refrshTime = [[MyUserDefault standardUserDefaults] getDaTingRefreshTime];
    long long int nowTime = [NSDate getNowTime];
    
    //    if(!task.isRequesting && taojintype != TaskType ){
    //        [task initWithObjects];
    //        taojintype = TaskType;
    //    }
    NSNumber *freshTimeNum = [[MyUserDefault standardUserDefaults] getViewFreshTime];
    if(freshTimeNum == nil){
        freshTime = 300;
    }else{
        freshTime = [freshTimeNum intValue];
    }
    if(wifiCenter.jifenAry.count == 0 || wifiCenter.appAry.count == 0 || (taojintype != TaskType && wifiCenter.isRequesting == NO && (refrshTime == nil || nowTime - [refrshTime longLongValue] >= freshTime))){
        [wifiCenter initWithObjects];
    }else if(wifiCenter.jifenAry.count == 0 || wifiCenter.appAry.count == 0 || (nowTime - [refrshTime longLongValue] >= freshTime && wifiCenter.isRequesting == YES)){
        wifiCenter.isRequesting = NO;
        [wifiCenter initWithObjects];
    }
    
    taojintype = TaskType;
    
}
-(void)showActivityCenter{    //兑换中心
    
    NSNumber *refrshTime = [[MyUserDefault standardUserDefaults]getRewordRefreshTime];
    long long int nowTime = [NSDate getNowTime];
    NSNumber *freshTimeNum = [[MyUserDefault standardUserDefaults] getViewFreshTime];
    if (freshTimeNum == nil) {
        freshTime = MAXFLOAT;
    }else{
        freshTime =[freshTimeNum intValue];
    }
    if (serviceCenter.cardsArr.count == 0 || (serviceCenter.isRequesting ==NO && (refrshTime ==nil || (nowTime -[refrshTime longLongValue] >= freshTime)))) {
        [serviceCenter initBasicData];
    }else if (serviceCenter.cardsArr.count == 0 || ((nowTime -[refrshTime longLongValue] >= freshTime) || serviceCenter.isRequesting ==YES) ){
        serviceCenter.isRequesting = NO;
        [serviceCenter initBasicData];
    }
    
    //    if (serviceCenter.isRequesting ==NO) {
    //        [serviceCenter initBasicData];
    //    }
    taojintype = RewardType ;
}
-(void)showUserCenter{
    if (!userCenter.isRequesting) {
        [userCenter initDataSource];
    }
}
//当点击tabbar底部的按钮时，切换按钮和label的显示效果
-(void)changeButtonHighlighted:(BOOL)oneIsHighlighted twoIsHighlighted:(BOOL)twoIsHighlighted threeIsHighlighted:(BOOL)threeIsHighlighted fourIsHighlighted:(BOOL)fourIsHighlighted{
    if(one.highlighted != oneIsHighlighted){
        one.highlighted = oneIsHighlighted;
        if(one.highlighted)
            Lone.textColor = tabbarHighlightedTextColor;
        else
            Lone.textColor = tabbarDefaultTextColor;
    }
    if(two.highlighted != twoIsHighlighted){
        two.highlighted = twoIsHighlighted;
        if(two.highlighted)
            Ltwo.textColor = tabbarHighlightedTextColor;
        else
            Ltwo.textColor = tabbarDefaultTextColor;
    }
    if(three.highlighted != threeIsHighlighted){
        three.highlighted = threeIsHighlighted;
        if(three.highlighted)
            Lthree.textColor = tabbarHighlightedTextColor;
        else
            Lthree.textColor = tabbarDefaultTextColor;
    }
    if(four.highlighted != fourIsHighlighted){
        four.highlighted = fourIsHighlighted;
        if(four.highlighted)
            Lfour.textColor = tabbarHighlightedTextColor;
        else
            Lfour.textColor = tabbarDefaultTextColor;
    }
}
-(void)loadTabViewControllers{
    // wifi中心
    UINavigationController *wifiNC ;
    if (wifiCenter == nil) {
        wifiCenter = [[TaskViewController alloc]initWithNibName:nil bundle:nil];
        wifiNC =[[UINavigationController alloc] initWithRootViewController:wifiCenter];
        wifiNC.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }else{
        wifiNC = [self.viewControllers objectAtIndex:0];
    }
    
    // 增值中心
    UINavigationController *serviceNC ;
    if (serviceCenter == nil) {
        serviceCenter = [[LXServiceCenterController alloc] initWithNibName:nil bundle:nil];
        serviceNC =[[UINavigationController alloc] initWithRootViewController:serviceCenter];
        serviceNC.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }else{
        serviceNC = [self.viewControllers objectAtIndex:1];
    }
    
    // 用户中心
    UINavigationController *userNC ;
    if (userCenter == nil) {
        userCenter = [[LXUserCenterController alloc] initWithNibName:nil bundle:nil];
        userNC =[[UINavigationController alloc] initWithRootViewController:userCenter];
        userNC.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }else{
        userNC = [self.viewControllers objectAtIndex:2];
    }
    self.viewControllers = @[wifiNC ,serviceNC ,userNC];
    
}
-(void)checkUpdate{
    
    [self showUpdateOrUserLockingTip];
    
}
// 升级提示
-(void)showUpdateOrUserLockingTip{
    NSDictionary* di =[[MyUserDefault standardUserDefaults]getUpdate];
    if (di.allKeys.count !=0 ) {
        NSDictionary* dic =[[MyUserDefault standardUserDefaults]getUpdate];
        ver =[[MyUserDefault standardUserDefaults] getAppVersion];     //提示过但点击取消的版本 再次登录时不提示
        updatetype =[[di objectForKey:@"type"]integerValue];
        //不提示升级
        if (updatetype ==3) {
            
        }else{
            
            NSString* content =[dic objectForKey:@"content"];
            updateUrl =[dic objectForKey:@"url"];
            if (updatetype ==2) {
                if (!updateTip) {
                    updateTip =[[UIAlertView alloc]initWithTitle:@"又有新版本啦" message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即更新", nil];
                    
                }
                
            }else if (updatetype ==1){
                if (!updateTip) {
                    updateTip =[[UIAlertView alloc]initWithTitle:@"重要升级" message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"立即更新", nil];
                }
                
            }
            
            double delay =[[dic objectForKey:@"delay"]doubleValue];
            [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(showUpdateTip) userInfo:nil repeats:NO];
        }
    }
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendUpdateTipStatistic:@"1" andTipState:@"0"];
    });
    */
}
/**
 *  发送升级弹窗统计
 *
 *  @param type  类型    0强制   1提示   2不提示
 *  @param state 状态    0弹窗   1点击升级
 */
-(void)sendUpdateTipStatistic:(NSString *)type andTipState:(NSString *)state{
    NSDictionary *dic =@{@"type":type ,@"state":state};
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,@"ucenter/updatelog"];
    NSLog(@"发送升级弹窗统计 ==%@  %@",dic,urlStr);
    [LLAsynURLConnection requestURLWith:urlStr dataDic:dic andProtocolNum:@"40011" andTimeOut:httpTimeout connectSuccess:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dicData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@" 升级弹窗统计 ==%@",dicData);
        });
    } andFail:^(NSError *error) {
        NSLog(@" 升级弹窗统计错误 ==%@",error);
        if(error.code == timeOutErrorCode){
            if(timeOutCount < 2){
                timeOutCount ++;
                [self sendUpdateTipStatistic:type andTipState:state];
            }else{
                timeOutCount = 0;
                if(![UIAlertView isInit]){
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //  升级提示
    if(alertView == updateTip)
    {
        if(buttonIndex==0)
        {
            //重要升级
            if (updatetype ==0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
            }
            //普通升级
            else if (updatetype ==1){
                [updateTip dismissWithClickedButtonIndex:0 animated:YES];
                NSDictionary* updateDic =[[MyUserDefault standardUserDefaults]getUpdate];
                if (updateDic) {
                    NSString* appVersion =[updateDic objectForKey:@"ver"];
                    [[MyUserDefault standardUserDefaults] setAppVersion:appVersion];   //点击取消 记录下版本号 下次登录不提示
                }
            }
        }
        else if(buttonIndex==1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
            
        }
    }
    
}

-(void)showUpdateTip{
    //不提示升级不显示  type=2
    
    NSDictionary* dic =[[MyUserDefault standardUserDefaults]getUpdate];
    NSString* ver2 =[dic objectForKey:@"ver"];
    NSString* version = [[[NSBundle mainBundle]infoDictionary]objectForKey:(NSString* )kCFBundleVersionKey];
    if (updatetype !=2) {
        if (updatetype ==0) {   //强制升级
            if (![ver2 isEqualToString:version]) {
                [updateTip show];
            }
        }else if (updatetype ==1){  //提示升级
            if (![ver isEqualToString:ver2]) {
                [updateTip show];
            }
        }
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendUpdateTipStatistic:NSStringFromInt(updatetype) andTipState:@"0"];
    });
}
-(void)requestWelcomeAndShow{
    if (self.state == 1 ) {
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(requestForWelCome) userInfo:nil repeats:NO];
        self.state = 0;
    }
}
-(void)isNeedShowWelcome{
//    NSDictionary *oldDic =[[MyUserDefault standardUserDefaults] getWelcomImgDic];
    NSDictionary *oldDic ;
    NSDictionary *welcome1 =[[MyUserDefault standardUserDefaults] getWelcomImgDic];
    NSDictionary *welcome2 =[[MyUserDefault standardUserDefaults] getWelcomImgDic2];
    BOOL welcome1Exsit = welcome1.allKeys.count > 0 ?YES :NO;
    BOOL welcome2Exsit = welcome2.allKeys.count > 0 ?YES :NO;
    if (welcome1Exsit ==YES && welcome2Exsit ==YES) {
        long long int nowTime =[NSDate getNowTime] ;
        long long beginStr1 = [[welcome1 objectForKey:@"begintime"] longLongValue];
//        long long int beginTime1 = [NSDate getTimeLogFromTimeString:beginStr1] ;
        long long endStr1 =[[welcome1 objectForKey:@"endtime"] longLongValue];
//        long long int endTime1 = [NSDate getTimeLogFromTimeString:endStr1];
        BOOL isInTime1 = nowTime >= beginStr1 && nowTime <=endStr1 ? YES : NO ;
        
        long long beginStr2 = [[welcome2 objectForKey:@"begintime"] longLongValue];
//        long long int beginTime2 = [NSDate getTimeLogFromTimeString:beginStr2] ;
        long long endStr2 =[[welcome2 objectForKey:@"endtime"] longLongValue];
//        long long int endTime2 = [NSDate getTimeLogFromTimeString:endStr2];
        BOOL isInTime2 = nowTime >= beginStr2 && nowTime <=endStr2 ? YES : NO ;
        
        if (isInTime1 ==YES  && isInTime2 ==YES) {      //当有2张冲突时取第一个
            [self showWelcomeView:welcome2 andIndex:1];
        }else if (isInTime1 ==YES && isInTime2 ==NO){
            [self showWelcomeView:welcome1 andIndex:1];
        }else if (isInTime2 ==YES && isInTime1 ==NO){
            [self showWelcomeView:welcome2 andIndex:2];
        }else{
            [self showWelcomeView:oldDic andIndex:0];
        }
    } else if(welcome1Exsit ==YES && welcome2Exsit ==NO){
        [self showWelcomeView:welcome1 andIndex:1];
    }else if (welcome2Exsit ==YES && welcome1Exsit ==NO){
        [self showWelcomeView:welcome2 andIndex:2];
    }else{
        [self showWelcomeView:oldDic andIndex:0];
    }
    
    
    
}
-(void)showWelcomeView:(NSDictionary *)oldDic andIndex:(int)index{

    if (oldDic.allKeys.count >0) {
        long long int nowTime =[NSDate getNowTime] ;
        long long beginStr = [[oldDic objectForKey:@"begintime"] longLongValue];
//        long long int beginTime = [NSDate getTimeLogFromTimeString:beginStr] ;
        long long endStr = [[oldDic objectForKey:@"endtime"] longLongValue];
//        long long int endTime = [NSDate getTimeLogFromTimeString:endStr];
        BOOL isInTime = nowTime >= beginStr && nowTime <=endStr ? YES : NO ;           //对比欢迎页展示的时间
        int state = [[oldDic objectForKey:@"State"] intValue] ;
        state = 0;
        welcomeStay = [[oldDic objectForKey:@"stay"] floatValue];
        NSLog(@"BT=%lld  NT=%lld  ET=%lld %d",beginStr ,nowTime ,endStr,isInTime);
        NSData *picData = index ==1 ? [[MyUserDefault standardUserDefaults] getWelcomeImgData] :[[MyUserDefault standardUserDefaults] getWelcomeImgData2];
        if (picData && isInTime == YES && state == 0) {
            UIImageView *welcome =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
            welcome.tag = 90001;
            UIImage *image =[UIImage imageWithData:picData];
            welcome.image = image;
            [self.view addSubview:welcome];
            timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
            
            
        }else{
            [self showDefaultImage];
            
        }
        
    }else{
        [self showDefaultImage];
        
    }
    [[MyUserDefault standardUserDefaults] setIsShowedWelcome:[NSNumber numberWithInt:1]];
}
/**
 *  没有后台欢迎页展示默认图
 */
-(void)showDefaultImage{
    UIImageView *welcome =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, CGRectGetHeight(self.view.frame))];
    welcome.tag = 90001;
    int scale= [UIScreen mainScreen].scale;
    NSString *name =[NSString stringWithFormat:@"%dX%d",(int)kmainScreenWidth*scale,(int)kmainScreenHeigh*scale];
    UIImage *image = [UIImage imageNamed:name];
    welcome.image = image;
    [self.view addSubview:welcome];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    
}
/**
 *   欢迎页展示后开始计时
 */
-(void)countTime{
    timeCount += 0.5 ;
}
-(void)missWelcome{
    [[MyUserDefault standardUserDefaults] setIsShowedWelcome:[NSNumber numberWithInt:0]];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view viewWithTag:90001].alpha = 0;
        NSLog(@" 欢迎 %@",[self.view viewWithTag:90001]);
    } completion:^(BOOL finished) {
        [[self.view viewWithTag:90001] removeFromSuperview];
        
    }];
}
-(void)requestForWelCome{
    NSString *sid =[[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:sid,@"sid", nil];
    NSString *url =[NSString stringWithFormat:kUrlPre,kOnlineWeb,@"GoldWashingUI",@"GetWelcomeLogo"];
    [AsynURLConnection requestWithURL:url dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *body =[dic objectForKey:@"body"];
            NSLog(@"请求欢迎页 = %@",dic);
            if ([[dic objectForKey:@"flag"] intValue] ==1) {
                NSArray *arr =[body objectForKey:@"Welcome"];
                if (arr.count >0) {
                    NSDictionary *welDic =[arr objectAtIndex:0];
                    if (welDic.allKeys.count >0) {
                        [[MyUserDefault standardUserDefaults] setWelcomeImgDic:welDic];
                        NSString * pic =[welDic objectForKey:@"Pic1"];
                        if (kmainScreenHeigh <= 480) {
                            pic =[welDic objectForKey:@"Pic"];
                        }
                        //                        NSString *oldPicUrl =[[MyUserDefault standardUserDefaults] getWelcomeImgUrl];
                        //                        if (![pic isEqualToString:oldPicUrl] && [[MyUserDefault standardUserDefaults] getWelcomeImgData]) {
                        [[MyUserDefault standardUserDefaults] setWelcomeImgUrl:pic];
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            NSData *picData =[NSData dataWithContentsOfURL:[NSURL URLWithString:pic]];
                            if (picData) {
                                NSLog(@" GET WelCome %ld",(unsigned long)picData.length);
                                [[MyUserDefault standardUserDefaults] setWelcomeImgData:picData];
                            }
                        });
                        //                        }
                    }
                }else{
                    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:nil,@"Welcome", nil];
                    [[MyUserDefault standardUserDefaults] setWelcomeImgDic:dic];
                }
            }
        });
    } fail:^(NSError *error) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];       //会出现动画警告log
    [self.navigationController.navigationBar setHidden:YES];
    [self.selectedViewController beginAppearanceTransition:YES animated: animated];
}
-(void) viewDidAppear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
    
}
-(void) viewWillDisappear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
