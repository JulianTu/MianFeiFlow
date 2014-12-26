//
//  ExchangeQViewController.m
//  TJiphone
//
//  Created by keyrun on 13-9-28.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "ExchangeQViewController.h"
#import "RewardListViewController.h"
#import "TaoJinLabel.h"
#import "StatusBar.h"
#import "LoadingView.h"
#import "MyUserDefault.h"
#import "AsynURLConnection.h"
#import "UIAlertView+NetPrompt.h"
#import "HeadToolBar.h"
#import "CButton.h"
#import "UniversalTip.h"
#import "DashLineUI.h"
#import "UIImage+ColorChangeTo.h"
#import "LLAsynURLConnection.h"
#define kCornerRadius    5.0f
#define kChargeBGViewOffy     16.0f
#define kChargeBGViewH         22.0f
#define kTextFiledOffy         32.0f
//Q币支付
@interface ExchangeQViewController ()
{
    //    HeadView *headView;
    HeadToolBar *headBar;
    UIImageView *QQNumber;                          //qq号码输入框背景
    UILabel *Qcount ;
    UITextField *QQText;
    MScrollVIew *ms;
    
    int perRmb;
    
    int QBcount;                                    //q币数值
    
    int timeOutCount;                               //超时次数
    BOOL isFrist;                                   //标示是否第一次访问
    
    UIView *bgView;
    NSMutableArray *allBtns;
    NSArray *chooseArr;                             // Q币选择
    CButton *chagreBtn;                             //兑换按钮
    NSMutableArray *coinCount;
    int selectBtnIndex;                             //标记选中的按钮
    UIView *copyBgView ;                            // 蓝色标记块
    NSArray *hightImgae ;
    
    BOOL isZFB ;     //兑换类型  yes是支付宝 no是财付通
    UniversalTip *tip ;
    NSString *content;
    
    NSMutableArray *zfbNeedFee;
    NSMutableArray *cftNeedFee ;
}
@end

@implementation ExchangeQViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)hidKeyBoard{
    [QQText resignFirstResponder];
}

//初始化变量
-(void)initWithObjects{
    isZFB =YES;
    QBcount = 1;
    perRmb = 0;
    timeOutCount = 0;
    isFrist = YES;
    allBtns =[[NSMutableArray alloc] init];
    chooseArr =@[@"兑现0元",@"兑现0元",GetImageWithName(@"icon_zhifubao_1"),GetImageWithName(@"icon_caifutong_2")];
    hightImgae = @[GetImage(@"icon_zhifubao_2"),GetImage(@"icon_caifutong_1")];
    coinCount =[[NSMutableArray alloc] init];
    zfbNeedFee =[[NSMutableArray alloc] init];
    cftNeedFee = [[NSMutableArray alloc] init];
    selectBtnIndex =0;
}
-(void)loadViewChargeTypeView {
    NSArray *array =@[@"请选择兑换金额",@"请选择账号类型"];
    for (int i=0; i < array.count; i++) {
        CGRect rect = CGRectMake(0, kChargeBGViewOffy +i *90.0f, kmainScreenWidth, kChargeBGViewH);
        TaoJinLabel *label = [[TaoJinLabel alloc] initWithFrame:rect text:[array objectAtIndex:i] font:kFontSize_11 textColor:kGrayLineColor2_0 textAlignment:NSTextAlignmentCenter numberLines:1];
        label.backgroundColor = KLightGrayColor2_0 ;
        DashLineUI *dash = [[DashLineUI alloc] init];
        dash.borderColor = kGrayLineColor2_0 ;
        dash.spacePattern = 2.0;
        dash.borderWidth = 0.7 ;
        dash.dashPattern = 2.0 ;
        dash.cornerRadius = 0.0 ;
        label =(TaoJinLabel *)[dash addDashLineUI:label];
        [ms addSubview:label];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWithObjects];
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSNumber *jdCount =[[MyUserDefault standardUserDefaults] getUserBeanNum];
    
    headBar =[[HeadToolBar alloc] initWithTitle:@"现金兑换" leftBtnTitle:@"返回" leftBtnImg:GetImageWithName(@"back") leftBtnHighlightedImg:nil rightLabTitle:jdCount backgroundColor:kBlueTextColor];
    headBar.leftBtn.tag =1;
    [headBar.leftBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y+headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.size.height - headBar.frame.origin.y) andWithPageCount:1 backgroundImg:nil];
    ms.delegate = self;
    ms.bounces =YES;
    [ms setContentSize:CGSizeMake(kmainScreenWidth, ms.frame.size.height+1)];
    [self.view addSubview:ms];
    
    
    bgView =[[UIView alloc]init];
    bgView.backgroundColor =KOrangeColor2_0;
    copyBgView =[[UIView alloc]init];
    copyBgView.backgroundColor = kBlueTextColor ;
    
    [self loadViewChargeTypeView];
    [self loadViewChooseBtn];
    
    [self loadContentViews];
    
    [self performSelector:@selector(requestForCashRewardInfor) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidKeyBoard) name:@"hidAllKeyBoard" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(qDidPopView) name:@"popview" object:nil];
    if (kmainScreenHeigh <= 568.0f  ) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePosition:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    
}

-(void)changePosition:(NSNotification *)notic{
    NSDictionary *dic =[notic userInfo];
    CGRect kbSize = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];;
    NSTimeInterval time = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve animationCurve ;
    [[dic objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    UIViewAnimationOptions options = animationCurve << 16 ;
    NSLog(@" keyboard size %@  %@",NSStringFromCGRect(kbSize),NSStringFromCGRect(chagreBtn.bounds));

    [self adjustPositionWithTime:time viewAnimation:options position:kbSize];

    
}
-(void)adjustPositionWithTime:(NSTimeInterval) time viewAnimation:(UIViewAnimationOptions) option position:(CGRect) rect{
    float a = chagreBtn.frame.origin.y +headBar.frame.origin.y +headBar.frame.size.height;
    float b = CGRectGetHeight(self.view.frame) - rect.size.height -chagreBtn.frame.size.height -5.0f;
    float c = b-a;
    c = c < 0? c*-1:c;
    c = rect.origin.y ==kmainScreenHeigh? 0:c ;
    NSLog(@" 高度差  == %f",c);
    float oriH =headBar.frame.origin.y +headBar.frame.size.height ;
    [UIView animateWithDuration:time delay:0.0f options:option animations:^{
        ms.frame = CGRectMake(0, oriH - c, ms.frame.size.width, ms.frame.size.height);
        [self.view insertSubview:ms belowSubview:headBar];

    } completion:^(BOOL finished) {
        NSLog(@" ms frame ==%@  %@",NSStringFromCGRect(ms.frame),NSStringFromCGSize(ms.contentSize));
    }];
}


-(void)loadContentViews{
//    float buttonH = 40.0f ;
    UIView *view = [ms viewWithTag:2];
    QQText =[ [UITextField alloc]initWithFrame:CGRectMake(kOffX_2_0, view.frame.origin.y + view.frame.size.height +kTextFiledOffy, kmainScreenWidth -2* (kOffX_2_0),15)];
    QQText.backgroundColor = [UIColor clearColor];
    QQText.font = [UIFont systemFontOfSize:14];
    QQText.delegate = self;
    [QQText setKeyboardType:UIKeyboardTypeEmailAddress];
    QQText.placeholder = @"请输入您的支付宝账号（邮箱或手机号）";
    QQText.textColor = KBlockColor2_0;
    QQText.text = [[MyUserDefault standardUserDefaults] getUserQNum];
    
    [self loadSperateLineWithFrame:CGRectMake(kOffX_2_0, QQText.frame.origin.y +QQText.frame.size.height+ 15, kmainScreenWidth -kOffX_2_0, 0.5f)];
    
//    float chargeBtnOffx = 80.0f ;
    chagreBtn= [self loadBtnWithFrame:CGRectMake(kmainScreenWidth/2 - SendButtonWidth/2, QQText.frame.origin.y +QQText.frame.size.height +25, SendButtonWidth, SendButtonHeight) withTitle:@"立即兑换" andFont:[UIFont systemFontOfSize:16.0]];
    chagreBtn.tag = 2;
    chagreBtn.layer.masksToBounds = YES;
    chagreBtn.layer.cornerRadius = chagreBtn.frame.size.height /2 ;
    [chagreBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [ms addSubview:chagreBtn];

    [ms addSubview:QQText];
    
//    [self loadUniversalTipWithFrame:CGRectMake(kOffX_2_0, chagreBtn.frame.origin.y +chagreBtn.frame.size.height +10,kmainScreenWidth -2*(kOffX_2_0), 0)];

}
-(CButton *)loadBtnWithFrame:(CGRect)rect withTitle:(NSString *)title andFont:(UIFont*) font{
    CButton *btn =[CButton buttonWithType:UIButtonTypeCustom];
    btn.frame =rect;
    btn.backgroundColor  =kBlueTextColor;
    btn.nomalColor =kBlueTextColor;
    btn.changeColor =kLightBlueTextColor;
    btn.titleLabel.font =font;
    [btn setTitle:title forState:UIControlStateNormal];
    
    
    return btn;
}


-(void)loadSperateLineWithFrame:(CGRect)rect{
    UIView *line =[[UIView alloc]initWithFrame:rect];
    line.backgroundColor =kGrayLineColor2_0;
    [ms addSubview:line];
}

-(void)loadViewChooseBtn{
    float buttonW = (kmainScreenWidth - 3*kOffX_2_0) /2 ;
    for(int i = 0 ; i < 2 ; i ++){
        for(int j = 0 ; j < 2 ; j ++){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(kOffX_2_0 + j * buttonW + j * kOffX_2_0, 90.0 * i + 45.0, buttonW, 45.0);
            button.tag = 2 * i + j;
            button.backgroundColor =[UIColor clearColor];
            button.clipsToBounds = YES;
            if (button.tag == 0) {
                
                bgView.frame =CGRectMake(button.frame.origin.x -0.5f, button.frame.origin.y -0.5f, button.frame.size.width +1, button.frame.size.height +1);
                bgView.layer.cornerRadius = kCornerRadius ;
                [ms addSubview:bgView];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            }else if (button.tag == 2){
                copyBgView.frame =CGRectMake(button.frame.origin.x -0.5f, button.frame.origin.y -0.5f, button.frame.size.width +1, button.frame.size.height +1);
                copyBgView.layer.cornerRadius = kCornerRadius ;
                
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                button.selected =YES;
                [button setBackgroundImage:[UIImage createImageWithColor:kBlueTextColor] forState:UIControlStateNormal];
            }else if (button.tag ==3){
//                button.selected =NO;
//                [button setBackgroundImage:[UIImage createImageWithColor:kBlueTextColor] forState:UIControlStateNormal];
            }
            else{
                [button setTitleColor:KOrangeColor2_0 forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(onClickRewardCoinBtn:) forControlEvents:UIControlEventTouchUpInside];
            id titleBtn = [chooseArr objectAtIndex:button.tag];
            if ([titleBtn isKindOfClass:[NSString class]]) {
                [button setTitle:titleBtn forState:UIControlStateNormal];
                button.titleLabel.font =[UIFont systemFontOfSize:14.0];
            }else if ([titleBtn isKindOfClass:[UIImage class]]){
                
                [button setImage:titleBtn forState:UIControlStateNormal];
//                [button setImage:[hightImgae objectAtIndex:button.tag -2] forState:UIControlStateHighlighted];
            }
            
            DashLineUI *dash =[[DashLineUI alloc] init];
            dash.spacePattern = 2.0;
            dash.borderWidth = 1.0 ;
            dash.dashPattern = 2.0 ;
            if (i == 0) {
                dash.borderColor = KOrangeColor2_0 ;
            }else{
                dash.borderColor = kBlueTextColor ;
            }
            dash.cornerRadius = kCornerRadius ;
            button.adjustsImageWhenHighlighted =NO;
            button =(UIButton *)[dash addDashLineUI:button];

            
            [allBtns addObject:button];
            [ms addSubview:button];
//            [ms insertSubview:copyBgView belowSubview:button];
        }
    }
    
}

-(void)makeDashLine{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIButton *button in allBtns) {
            DashLineUI *dash =[[DashLineUI alloc] init];
            dash.spacePattern = 2.0;
            dash.borderWidth = 1.0 ;
            dash.dashPattern = 2.0 ;
            dash.cornerRadius = kCornerRadius ;
            if (button.tag == 0|| button.tag ==1) {
                dash.borderColor = KOrangeColor2_0 ;
            }else{
                dash.borderColor = kBlueTextColor ;
            }
            [dash addDashLineUI:button];
        }
        
    });
    
}

-(void)onClickRewardCoinBtn:(UIButton *)btn{
    if (btn.tag < 2) {
        bgView.frame =CGRectMake(btn.frame.origin.x -0.5f, btn.frame.origin.y -0.5f, btn.frame.size.width +1, btn.frame.size.height +1);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        selectBtnIndex =btn.tag;
        for (UIButton *button in allBtns) {
            if (button.tag != btn.tag) {
                [button setTitleColor:KOrangeColor2_0 forState:UIControlStateNormal];
                
            }
        }

    }else if (btn.tag == 2){
        [btn setBackgroundImage:[UIImage createImageWithColor:kBlueTextColor] forState:UIControlStateNormal];
        [btn setImage:[chooseArr objectAtIndex:2] forState:UIControlStateNormal];
        [[allBtns objectAtIndex:3] setImage:[chooseArr objectAtIndex:3] forState:UIControlStateNormal];
        [[allBtns objectAtIndex:3] setBackgroundImage:nil forState:UIControlStateNormal];
        isZFB =YES;
        [QQText resignFirstResponder];
        QQText.placeholder = @"请输入您的支付宝账号（邮箱或手机号）";
        [QQText setKeyboardType:UIKeyboardTypeEmailAddress];
        [QQText becomeFirstResponder];
    }else if (btn.tag ==3){
        isZFB = NO;
        [btn setBackgroundImage:[UIImage createImageWithColor:kBlueTextColor] forState:UIControlStateNormal];
        [btn setImage:[hightImgae objectAtIndex:1] forState:UIControlStateNormal];
        [[allBtns objectAtIndex:2] setImage:[hightImgae objectAtIndex:0] forState:UIControlStateNormal];
        [[allBtns objectAtIndex:2] setBackgroundImage:nil forState:UIControlStateNormal];
        [QQText resignFirstResponder];
        QQText.placeholder = @"请输入您的财付通账号（QQ号）";
        [QQText setKeyboardType:UIKeyboardTypeNumberPad];
        [QQText becomeFirstResponder];
    }
}
-(void)cancelHighlightButton:(UIButton *)button {
    [button setHighlighted:NO];
}
-(void) highlightButton:(UIButton *)button{
    [button setHighlighted:YES];
}
// 按钮四边线
-(void)addLineForUi:(UIView *)obj withRed:(float)red withGreen:(float)green withBlue:(float)blue{
    CGFloat r = red/255.0;
    CGFloat g = green/255.0;
    CGFloat b = blue/255.0;;
    CGFloat a = 1;
    CGFloat com[4] = {r,g,b,a};
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = (__bridge CGColorRef)(__bridge id)CGColorCreate(colorspace, com);
    [obj.layer setBorderColor:color];
    [obj.layer setBorderWidth:.5f];
    CGColorRelease(color);
    CGColorSpaceRelease(colorspace);
    
}

-(void)viewDisappear:(BOOL)animated{
    [QQText removeFromSuperview];
    QQText = nil;
    [QQNumber removeFromSuperview];
    QQNumber = nil;
    [Qcount removeFromSuperview];
    Qcount = nil;
    [ms removeFromSuperview];
    ms = nil;
    //    [headView removeFromSuperview];
    //    headView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hidAllKeyBoard" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"popview" object:nil];
}

-(void)initContentText:(NSString *)content{
    [self loadUniversalTipWithFrame:CGRectMake(kOffX_float, chagreBtn.frame.origin.y +chagreBtn.frame.size.height +10,320 -2*(kOffX_float), 0)];
}

-(void)loadUniversalTipWithFrame:(CGRect)rect {
    /*
    NSNumber *number = [[MyUserDefault standardUserDefaults] getUserBeanNum];
    int count =0;
    if (perRmb !=0) {
        count =[number intValue] /perRmb;
    }
    NSString *first =[NSString stringWithFormat:@"1.%d流量币=50元，%d流量币=100元，兑换100元将额外获赠5元",perRmb*5,perRmb*100];
    NSString *second;
    long userGold= [number longValue];
    if (userGold < perRmb*50 ||perRmb ==0) {
       second=[NSString stringWithFormat:@"2.您的账户现在有：%@流量币，暂时无法兑换",number];
    }else if(perRmb !=0){
        second =[NSString stringWithFormat:@"2.您的账户现在有：%@流量币，可以兑换",number];
    }
*/

    NSArray *arraytip =[NSArray arrayWithObjects:content,nil];
    if (tip) {
        [tip removeFromSuperview];
    }
    tip =[[UniversalTip alloc]initWithFrame:rect andTips:arraytip andTipBackgrundColor:KTipBackground2_0 withTipFont:[UIFont systemFontOfSize:11.0] andTipImage:GetImageWithName(@"") andTipTitle:@"" andTextColor:kBlueTextColor];
    [ms addSubview:tip];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    [[LoadingView showLoadingView] actViewStopAnimation];
}

-(void)requestForCashRewardInfor{
    if(isFrist){
        [[LoadingView showLoadingView] actViewStartAnimation];
        isFrist = NO;
    }
    chagreBtn.userInteractionEnabled =NO;
    NSString *string =[NSString stringWithFormat:@"award/info/xianjin"];
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,string];
    NSLog(@"获取兑换现金详细信息【urlStr】 = %@",urlStr);
    [LLAsynURLConnection requestForMethodGetWithURL:urlStr dataDic:nil andProtocolNum:@"30004" andTimeOut:httpTimeout successBlock:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            timeOutCount = 0;
            NSLog(@"获取四种支付手段的详细信息【response】 = %@ err= %@",dataDic,[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                NSArray *cftArr = [body objectForKey:@"caifutong"];
                NSArray *zfbArr = [body objectForKey:@"zhifubao"];
                NSDictionary *cftDic =[cftArr objectAtIndex:0];
                int gold = [[cftDic objectForKey:@"gold"] intValue];
                int num =[[cftDic objectForKey:@"num"] intValue];
                perRmb = gold/num ;
                long bean =(long)[[body objectForKey:@"usergold"] longLongValue];
                content = [body objectForKey:@"content"];
                [[MyUserDefault standardUserDefaults] setUserBeanNum:bean];
                for (NSDictionary *dictionary in zfbArr) {
                    NSString *string =(NSString *)[dictionary objectForKey:@"gold"];
                    [zfbNeedFee addObject:string];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    chagreBtn.userInteractionEnabled =YES;
                    [self loadUniversalTipWithFrame:CGRectMake(kOffX_float, chagreBtn.frame.origin.y +chagreBtn.frame.size.height +10,kmainScreenWidth -2*(kOffX_float), 0)];
                    int i=0 ;
                    for (UIButton *btn in [allBtns subarrayWithRange:NSMakeRange(0, 2)]) {
                        NSDictionary *dic =[cftArr objectAtIndex:i];
                        NSString *fee =(NSString *)[dic  objectForKey:@"fee"];
                        NSString *string =(NSString *)[dic objectForKey:@"gold"];
                        [btn setTitle:[NSString stringWithFormat:@"兑现%@元",fee] forState:UIControlStateNormal];
                        i++;
                        [coinCount addObject:fee];
                        [cftNeedFee addObject:string];
                        
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    chagreBtn.userInteractionEnabled =YES;
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
            }

        });
    } andFailBlock:^(NSError *error) {
        chagreBtn.userInteractionEnabled = YES;
        NSLog(@"获取四种支付手段的详细信息【erroe】 = %@",error);
        if(error.code == timeOutErrorCode){
            //连接超时
            if(timeOutCount < 2){
                [self requestForCashRewardInfor];
            }else{
                timeOutCount = 0;
                [[LoadingView showLoadingView] actViewStopAnimation];
                if(![UIAlertView isInit]){
                    UIAlertView *alertView = [UIAlertView showNetAlert];
                    alertView.delegate = self;
                    alertView.tag = kTimeOutTag;
                    alertView = nil;
                }
            }
        }
    }];
}

//请求获取四种支付手段的详细信息（new）
-(void)requestToGoodsInfo{
    if(isFrist){
        [[LoadingView showLoadingView] actViewStartAnimation];
        isFrist = NO;
    }
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid, @"Type":@"0"};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"AwardUI",@"GetAwardFullInfoByType"];
    NSLog(@"获取四种支付手段的详细信息【urlStr】 = %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        [[LoadingView showLoadingView] actViewStopAnimation];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            timeOutCount = 0;
            NSLog(@"获取四种支付手段的详细信息【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                perRmb = [[body objectForKey:@"Arg0"] intValue];
                long bean =[[body objectForKey:@"Residue"] longValue];
                [[MyUserDefault standardUserDefaults] setUserBeanNum:bean];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadUniversalTipWithFrame:CGRectMake(kOffX_float, chagreBtn.frame.origin.y +chagreBtn.frame.size.height +10,320 -2*(kOffX_float), 0)];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
            }
        });
    } fail:^(NSError *error) {
        NSLog(@"获取四种支付手段的详细信息【erroe】 = %@",error);
        if(error.code == timeOutErrorCode){
            //连接超时
            if(timeOutCount < 2){
                [self requestToGoodsInfo];
            }else{
                timeOutCount = 0;
                [[LoadingView showLoadingView] actViewStopAnimation];
                if(![UIAlertView isInit]){
                    UIAlertView *alertView = [UIAlertView showNetAlert];
                    alertView.delegate = self;
                    alertView.tag = kTimeOutTag;
                    alertView = nil;
                }
            }
        }
    }];
}

-(void)onClickAddQCoinBtn:(UIButton* )btn{
    btn.highlighted = YES;
    switch (btn.tag) {
            //Q币数减少
        case 3:
        {
            if (QBcount==1) {
                return;
            }else{
                QBcount--;
                Qcount.text = [NSString stringWithFormat:@"%dQ币",QBcount];
            }
        }
            break;
            //Q币数增加
        case 4:
        {
            QBcount++;
            Qcount.text = [NSString stringWithFormat:@"%dQ币",QBcount];
        }
            break;
        default:
            break;
    }
}
-(void)onClickBackBtn:(UIButton* )btn{
    switch (btn.tag) {
            //返回按钮
        case 1:
        {
            [[LoadingView showLoadingView] actViewStopAnimation];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            // 兑换确认
        case 2:
        {
            [QQText resignFirstResponder];
            DidRewardView* view = [[DidRewardView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
            view.drDelegate = self;
            view.type =102 ;
            view.rechargeType = isZFB ==YES ? @"支付宝":@"财付通";
            view.rewardType = isZFB ==YES ? 3:4;
            view.phoneNumber = QQText.text;
            UIButton *btn =[allBtns objectAtIndex:selectBtnIndex];
            view.chargeStyle =btn.titleLabel.text;
            view.isRecharge =YES;

            int getcoin = [[coinCount objectAtIndex:selectBtnIndex]intValue];
            int dou = getcoin * perRmb;      //perRmb 兑换汇率
            view.arg0 =dou;
            view.getHF = [coinCount objectAtIndex:selectBtnIndex];
            long num = [[[MyUserDefault standardUserDefaults] getUserBeanNum] longValue];
            
            BOOL isQNum =  [self isPureInt:QQText.text] && QQText.text.length >4 && QQText.text.length <12 ;
            BOOL isPhoneNum = [self isPureInt:QQText.text] && QQText.text.length ==11;
            BOOL isEmailNum = [self isEmailAdress:QQText.text];
            if (isZFB) {
                dou = [[zfbNeedFee objectAtIndex:selectBtnIndex] intValue];
                if (isEmailNum || isPhoneNum ) {
                    if (num < dou) {
                        [self showNotEnough];
                    }else{
                        
                        [view setBasicView];
                        [self.view addSubview:view];
                    }
                }else{
                    [StatusBar showTipMessageWithStatus:@"请输入正确的支付宝号码" andImage:nil andTipIsBottom:YES];
                }
    
            }else{
                dou = [[cftNeedFee objectAtIndex:selectBtnIndex] intValue];
                if (isQNum) {
                    if (num < dou) {
                        [self showNotEnough];
                    }else{
                        [view setBasicView];
                        [self.view addSubview:view];
                    }
                }else{
                    [StatusBar showTipMessageWithStatus:@"请输入正确的财付通号码" andImage:nil andTipIsBottom:YES];
                }
  
            }
                }
            break;
        default:
            break;
    }
    
}

-(void)qDidPopView{
    if (isZFB) {
        [[MyUserDefault standardUserDefaults] setUserZFB:QQText.text];
    }else{
        [[MyUserDefault standardUserDefaults] setUserCFT:QQText.text];
    }
    RewardListViewController *re = [[RewardListViewController alloc]initWithNibName:nil bundle:nil];
    re.isRootPush =YES;
    [self.navigationController pushViewController:re animated:YES];
}
-(BOOL)isEmailAdress:(NSString*)email{
    if((0 != [email rangeOfString:@"@"].length) && (0 != [email rangeOfString:@"."].length)){
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet]; NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy]; [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        //使用compare option 来设定比较规则,如 //NSCaseInsensitiveSearch是不区分大小写
        //NSLiteralSearch 进行完全比较,区分大小写
        //NSNumericSearch 只比较定符串的个数,而不比较字符串的字面值
        NSRange range1 = [email rangeOfString:@"@"options:NSCaseInsensitiveSearch];
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray = [userNameString componentsSeparatedByString:@"."];
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                return NO;
        }
        NSString *domainString = [email substringFromIndex:range1.location+1]; NSArray *domainArray = [domainString componentsSeparatedByString:@"."];
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet]; if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        return YES;
    }else // no ''@'' or ''.''present
        return NO;
}

-(BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if ([self isPureInt:string]) {
//        return YES;
//    }else{
//        return NO;
//    }
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [QQText resignFirstResponder];
}

//滑动收起键盘
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
     [QQText resignFirstResponder];
}


-(void)showNotEnough{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"流量币不足" message:@"您的流量币不足，是否现在做任务赚取流量币？" delegate:self cancelButtonTitle:@"算了" otherButtonTitles:@"赚流量币", nil];
    alertView.tag = 1;
    [alertView show];
    alertView = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == kTimeOutTag){
        if(buttonIndex == 0){
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [UIAlertView resetNetAlertNil];
            [[LoadingView showLoadingView] actViewStartAnimation];
            [self requestForCashRewardInfor];
        }
    }else if(alertView.tag == 1){
        if (buttonIndex == 0) {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }else{
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter]postNotificationName:GoBackToFlowCenterNotic object:nil userInfo:nil];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
