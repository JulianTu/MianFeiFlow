 //
//  VisitViewController.m
//  TJiphone
//
//  Created by keyrun on 13-9-30.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "VisitViewController.h"
#import "UIImage+ColorChangeTo.h"
#import "MyUserDefault.h"
#import "AsynURLConnection.h"
#import "HeadToolBar.h"
#import "SDImageView+SDWebCache.h"
#import "TaoJinScrollView.h"
#import "UnderLineLabel.h"
#import "LLShareTable.h"
#import "LLRecordTable.h"
#import "LLMethodTable.h"
//邀请奖励
#import "LoadingView.h"
#import "QRCodeGenerator.h"
#import "StatusBar.h"
#import "UniversalTip.h"
#import "SharePlatformView.h"
#import "ShareItem.h"
#import "CodeView.h"
#import "ShareMethodController.h"
#import "UIAlertView+NetPrompt.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
//#import "UMSocialTencentWeiboHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialConfig.h"
#import "LLAsynURLConnection.h"
#define kCellBtnOffx        54.0f
#define kCodeImageSize      150.0f
#define kShareHeadViewH     40.0f
#define kVisitAdress        @"http://www.91taojin.com.cn/index.php?d=admin&c=page&m=detail&id=6"

@interface VisitViewController ()
{
    
    UIImageView* image;
    //    HeadView* headView;
    
    HeadToolBar *headBar;
    UIScrollView* scrollView;

    UIImage *oriCodeImg;
    UIScrollView *visitSV;
    
//    id <ISSShareActionSheetItem> sinaItem;
    
    BOOL webViewReload;
    
    TaoJinScrollView *tjView;
    UIWebView *_webView;
    int webErrorCount;
    
    __block UniversalTip *tipView ;
    
    TaoJinButton *_shareBtn ;    // 分享按钮
    TaoJinButton *_codeImgBtn ;  // 二维码按钮
    
    UnderLineLabel *_lineLabel ;
    
    LLShareTable *shareTab ;
    LLMethodTable *methodTab ;
    LLRecordTable *recordTab ;
    
    SharePlatformView *shareView;
    UIView *shareViewBGView;
    float batterH ;
    NSString *codeUrl ;
    NSMutableArray *allRewards;
    int failCount ;
}
@end

@implementation VisitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor =kWitheColor;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    batterH = kBatterHeight ;
    failCount = 0;
    allRewards =[[NSMutableArray alloc] init];
    
    [[MyUserDefault standardUserDefaults] setUserInviteCount:self.inviteCount];
   
    headBar = [[HeadToolBar alloc] initWithTitle:@"邀请奖励" leftBtnTitle:@"返回" leftBtnImg:GetImage(@"back") leftBtnHighlightedImg:nil rightBtnTitle:nil rightBtnImg:GetImage(@"codeicon") rightBtnHighlightedImg:nil backgroundColor:kBlueTextColor];
    headBar.leftBtn.tag =1;
    [headBar.leftBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headBar.rightBtn addTarget:self action:@selector(onClickedShareButton:) forControlEvents:UIControlEventTouchUpInside];
    headBar.rightBtn.tag = 1001 ;
    [self.view addSubview:headBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCodeUrl:) name:GetCodeUrlNotic object:nil];
    
    [self initShareMethodView];      //分享
    [self initInviteMethodView];           // 攻略   
    [self initVisitHistoryTable];    // 记录
    [self initScrollView];

    [self initShareButton];      //底部按钮
    [self initShareView] ;      //分享视图
    [self requestForShareContent];
//    [self initSharePlatform];
    
}
/**
*  请求分享内容
*/
-(void)requestForShareContent{
    if ([[LoadingView showLoadingView] actViewIsAnimation]) {
        [[LoadingView showLoadingView] actViewStopAnimation];
    }
    [[LoadingView showLoadingView] actViewStartAnimation];
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,@"share/content"];
    [LLAsynURLConnection requestForMethodGetWithURL:urlStr dataDic:nil andProtocolNum:@"70002" andTimeOut:httpTimeout successBlock:^(NSData *data) {
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           NSLog(@" 获取分享内容 ==%@ ",dataDic);
           if ([[dataDic objectForKey:@"flag"] intValue] ==1) {
               NSDictionary *body =[dataDic objectForKey:@"body"];
               NSArray *array =[body objectForKey:@"chanal"];
               NSDictionary *shareContent =[body objectForKey:@"share"];
               shareView.shareContent =shareContent ;
               if ([shareContent objectForKey:@"url"]) {
                   NSString *urlString =[shareContent objectForKey:@"url"];     //设置微信，qq  分享链接
                   [UMSocialData defaultData].extConfig.wechatSessionData.url = urlString;
                   [UMSocialData defaultData].extConfig.wechatTimelineData.url =urlString;
//                   [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
                   [UMSocialData defaultData].extConfig.qqData.url = urlString;
                   [UMSocialData defaultData].extConfig.qzoneData.url = urlString;

               }
               
               dispatch_async(dispatch_get_main_queue(), ^{
                   if (shareView) {
                       int i=0;
                       for (ShareItem *item in shareView.items) {
                           NSDictionary *share = [array objectAtIndex:i];
                           if ([[share objectForKey:@"shared"] intValue] ==0) {
                               item.itemShareReward.text = [NSString stringWithFormat:@"+%d",[[share objectForKey:@"gold"] intValue]];
                           }else{
                               item.itemShareReward.text =@"今日已分享";
                               item.itemShareReward.textColor = ColorRGB(210.0, 210.0, 211.0, 1.0);
                           }
                            i++ ;
                       }
                   }
               });
           }
       });
    } andFailBlock:^(NSError *error) {
        failCount ++;
        if(error.code == timeOutErrorCode){
            if(failCount < 3){
                failCount ++;
                [self requestForShareContent];
            }else{
                [[LoadingView showLoadingView] actViewStopAnimation];
                failCount = 0;

                if(![UIAlertView isInit]){
                    UIAlertView *alertView = [UIAlertView showNetAlert];
                    alertView.tag = kTimeOutTag;
                    alertView.delegate = self;
                    [alertView show];
                }
            }
        }else{
            [[LoadingView showLoadingView] actViewStopAnimation];

        }

    }];
}
-(void) initShareView{
    if (!shareView) {
        NSArray *titles =@[@"新浪微博",@"腾讯微博",@"QQ空间",@"QQ好友",@"微信好友",@"朋友圈"];
        NSArray *images =@[GetImage(@"sinaWb"),GetImage(@"tencentWb"),GetImage(@"qqzone"),GetImage(@"qqfriend"),GetImage(@"wechat"),GetImage(@"timeline")];
        NSArray *rewards =@[@"0",@"0",@"0",@"0",@"0",@"0"];
        NSArray *types =@[UMShareToSina,UMShareToTencent,UMShareToQzone,UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline];
        if (allRewards.count ==0) {
            shareView =[[SharePlatformView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) , kmainScreenWidth, kmainScreenWidth/3 *2 +kShareHeadViewH) andShareTypes:types andImages:images titles:titles rewards:rewards];
        }else{
            shareView =[[SharePlatformView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) , kmainScreenWidth, kmainScreenWidth/3 *2 +kShareHeadViewH) andShareTypes:types andImages:images titles:titles rewards:allRewards];
        }
        shareView.presentVC = self;
        [self.view addSubview:shareView];
    }

    
    if (!shareViewBGView) {
        shareViewBGView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showShareViewWithAnimation)];
        shareViewBGView.backgroundColor =[UIColor blackColor];
        shareViewBGView.alpha = 0.0;
        [shareViewBGView addGestureRecognizer:tap];
        UIPanGestureRecognizer *swipe =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(showShareViewWithAnimation2:)];
        
        [shareViewBGView addGestureRecognizer:swipe];
        [self.view insertSubview:shareViewBGView belowSubview:shareView];
    }

}

-(void)getCodeUrl:(NSNotification *)notic{
    NSDictionary *dic =notic.userInfo ;
    codeUrl = [dic objectForKey:@"code"];
}
-(void)viewDidAppear:(BOOL)animated{
    if (kDeviceVersion >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    if (kDeviceVersion >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
-(void)initShareButton {     //底部分享视图
    
    UIView *btnBGView =[[UIView alloc] initWithFrame:CGRectMake(0, tjView.scrollView.frame.size.height- SendViewHeight, kmainScreenWidth, SendViewHeight)];
    btnBGView.backgroundColor = kWitheColor ;
    
    CALayer *layer =[CALayer layer];
    layer.backgroundColor = kLineColor2_0.CGColor ;
    layer.frame = CGRectMake(0, LineWidth, btnBGView.frame.size.width, LineWidth);
    [btnBGView.layer addSublayer:layer];
    
    TaoJinButton *msgBtn = [[TaoJinButton alloc]initWithFrame:CGRectMake(kmainScreenWidth/2 -SendButtonWidth/2, SendViewHeight/2- SendButtonHeight/2, SendButtonWidth, SendButtonHeight) titleStr:@"立即分享" titleColor:kWitheColor font:GetFont(16.0) logoImg:GetImageWithName(@"shareicon") backgroundImg:[UIImage createImageWithColor:kBlueTextColor]];
    [msgBtn setBackgroundImage:[UIImage createImageWithColor:kLightBlueTextColor] forState:UIControlStateHighlighted];
    [msgBtn setImageEdgeInsets:UIEdgeInsetsMake(7.0f, 30.0f, 7.0f, 90.0f)];
    msgBtn.adjustsImageWhenHighlighted = NO;
    [msgBtn setBackgroundImage:[UIImage createImageWithColor:kLightBlueTextColor] forState:UIControlStateHighlighted];
    msgBtn.layer.masksToBounds = YES;
    msgBtn.layer.cornerRadius = msgBtn.frame.size.height /2 ;
    msgBtn.tag = 1002 ;
    [msgBtn addTarget:self action:@selector(onClickedShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [tjView.scrollView addSubview:btnBGView];
    [btnBGView addSubview:msgBtn];
    
}

-(void)initSharePlatform {
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
    [UMSocialQQHandler setQQWithAppId:kQQID appKey:kQQKey url:@"http://baidu.com"];
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];

}
-(void)dismissShareView {
    [shareView removeFromSuperview];
    [shareViewBGView removeFromSuperview];
}
-(void)onClickedShareButton:(TaoJinButton *)btn{
    switch (btn.tag) {
        case 1002:       // 分享按钮
        {
            /*
            if (!shareView) {
                NSArray *titles =@[@"新浪微博",@"腾讯微博",@"QQ空间",@"QQ好友",@"微信好友",@"朋友圈"];
                NSArray *images =@[GetImage(@"sinaWb"),GetImage(@"tencentWb"),GetImage(@"qqzone"),GetImage(@"qqfriend"),GetImage(@"wechat"),GetImage(@"timeline")];
                NSArray *rewards =@[@"0",@"0",@"0",@"0",@"0",@"0"];
                NSArray *types =@[UMShareToSina,UMShareToTencent,UMShareToQzone,UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline];
                if (allRewards.count ==0) {
                    shareView =[[SharePlatformView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) , kmainScreenWidth, kmainScreenWidth/3 *2 +kShareHeadViewH) andShareTypes:types andImages:images titles:titles rewards:rewards];
                }else{
                    shareView =[[SharePlatformView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) , kmainScreenWidth, kmainScreenWidth/3 *2 +kShareHeadViewH) andShareTypes:types andImages:images titles:titles rewards:allRewards];
                }
                shareView.presentVC = self;
                [self.view addSubview:shareView];
            }
            
            if (!shareViewBGView) {
                shareViewBGView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showShareViewWithAnimation)];
                shareViewBGView.backgroundColor =[UIColor blackColor];
                shareViewBGView.alpha = 0.0;
                [shareViewBGView addGestureRecognizer:tap];
                UIPanGestureRecognizer *swipe =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(showShareViewWithAnimation2:)];

                [shareViewBGView addGestureRecognizer:swipe];
                [self.view insertSubview:shareViewBGView belowSubview:shareView];
            }
            */
            [self showShareViewWithAnimation];
            
        }
            break;
        case 1001:       // 二维码按钮
        {
            UIImage *img = [QRCodeGenerator qrImageForString:codeUrl imageSize:kCodeImageSize];
            CodeView *codeView =[[CodeView alloc] initWithUserCodeImg:img andDescription:@"扫描上方二维码\n邀请小伙伴享用免费流量"];
            [codeView showCodeView];
        }
            break;
   
        default:
            break;
    }
}
-(void) showShareViewWithAnimation2:(UIPanGestureRecognizer *)swipe{
    if (swipe.state == UIGestureRecognizerStateEnded) {
        [self showShareViewWithAnimation];
    }
        
}
-(void) showShareViewWithAnimation{
    float alpha = shareViewBGView.alpha == 0.0? 0.4f: 0.0f;
    float a = shareView.frame.origin.y > (CGRectGetHeight(self.view.frame)-1) ? 1 :0 ;
    [UIView animateWithDuration:0.4f animations:^{
        shareView.frame =CGRectMake(0, CGRectGetHeight(self.view.frame) -a*((kmainScreenWidth/3 *2)+kShareHeadViewH), kmainScreenWidth, kmainScreenWidth/3 *2 +kShareHeadViewH);
        shareViewBGView.alpha = alpha ;

    }];

}
-(void)onClickedLinelabel{
}

-(void)initShareMethodView {
     shareTab =[[LLShareTable alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y -headBar.frame.size.height -41.0f-SendViewHeight -batterH) style:UITableViewStylePlain];
    [shareTab initBasicData];
}
-(void)initInviteMethodView {
    methodTab = [[LLMethodTable alloc] initWithFrame:CGRectMake(kmainScreenWidth, 0, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y -headBar.frame.size.height -40.0f -batterH) style:UITableViewStylePlain];
    methodTab.methodDelegate = self;
    methodTab.haveRequest =NO;
//    [methodTab initShareMethodData];

}
-(void)selectedMethodTableIndex:(int)index andUrl:(NSString *)methodUrl andName:(NSString *)name{
    ShareMethodController *shareMethod =[[ShareMethodController alloc] initWithNibName:nil bundle:nil];
    shareMethod.Title = name;
    shareMethod.methodUrl = methodUrl;
    [self.navigationController pushViewController:shareMethod animated:YES];
}
-(void)initVisitHistoryTable{
    recordTab = [[LLRecordTable alloc] initWithFrame:CGRectMake(kmainScreenWidth *2, 0, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y -headBar.frame.size.height -40.0f -batterH) style:UITableViewStylePlain];
    recordTab.haveRequest =NO;
//    [recordTab initRecordBasicData];
}


-(void)initScrollView{
    NSArray *array =[[NSArray alloc] initWithObjects:@"分享",@"攻略",@"记录", nil];
    NSArray *arrayView =[[NSArray alloc] initWithObjects:shareTab,methodTab,recordTab, nil];
    float bterH = kBatterHeight ;
    tjView =[[TaoJinScrollView alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y +headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y -headBar.frame.size.height -bterH) btnAry:array btnAction:^(UISegmentedControl *segment) {
        switch (segment.selectedSegmentIndex) {
            case 1:
                 if (methodTab.haveRequest ==NO) {
                    [methodTab initShareMethodData];
                }
                
                break;
            case 2:
               if (recordTab.haveRequest == NO) {
                    [recordTab initRecordBasicData];
                }
                break;
            case 0:
                
            default:
                break;
        }
        
    } slidColor:kBlueTextColor viewAry:arrayView];
    tjView.scrollView.delaysContentTouches =NO;

    [self.view addSubview:tjView];
    
}
//请求发送分享统计
-(void)requestToSetInviteShare:(NSString *)typeStr shareState:(int)shareState {
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    int time = arc4random()/1000000;
    NSNumber *arcNum = [NSNumber numberWithInteger:time];
    NSDictionary *dic = @{@"sid": sid, @"Type":typeStr, @"ShareState":[NSNumber numberWithInteger:shareState], @"arcNum":arcNum};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"MyCenterUI",@"SetInviteShare"];
    NSLog(@"请求发送分享统计【urlStr】 = %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求发送分享统计【response】 = %@",dic);
    } fail:^(NSError *error) {
        
    }];
}

//初始化【邀请攻略】
-(void)initInviteView{
    if (!scrollView) {
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(kmainScreenWidth, 0, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height)];
        if (kDeviceVersion < 7.0) {
            scrollView.frame =CGRectMake(kmainScreenWidth, 0, kmainScreenWidth, scrollView.frame.size.height -20);
        }
    }
    
}

-(void)onClickBackBtn:(UIButton *)btn{
    if (btn.tag ==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{    // 生成并显示2维码
        NSString *codeStr =nil;
        oriCodeImg =[QRCodeGenerator qrImageForString:codeStr imageSize:kCodeImageSize];
        TMAlertView *alertView =[[TMAlertView alloc] initWithTitle:@"我的二维码" andUserPic:[[MyUserDefault standardUserDefaults] getUserPic] andProduceImg:oriCodeImg andIntroduce:@"扫描上方二维码，进入91淘金官网，即可下载专属安装包" okBtnTitle:@"保存" cancleTitle:@"取消"];
        alertView.TMAlertDelegate =self;
        [alertView showCodeView];
    }
}
-(UIImage *)getResultImageFrom:(UIImageView *)imageView {
    UIGraphicsBeginImageContext(CGSizeMake(imageView.bounds.size.width , imageView.bounds.size.height ));
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *result =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data =UIImagePNGRepresentation(result);
    result =[UIImage imageWithData:data];
    return result;
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error != NULL) {
        NSLog(@"  save fail ");
    }else{
        [StatusBar showTipMessageWithStatus:@"已成功保存到相册" andImage:GetImage(@"icon_yes.png") andTipIsBottom:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
