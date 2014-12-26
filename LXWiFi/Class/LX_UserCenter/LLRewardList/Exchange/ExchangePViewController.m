//
//  ExchangePViewController.m
//  TJiphone
//
//  Created by keyrun on 13-9-28.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "ExchangePViewController.h"
#import "DidRewardView.h"
//#import "TJViewController.h"
#import "StatusBar.h"
#import "LoadingView.h"
#import "RewardListViewController.h"
#import "MyUserDefault.h"
#import "AsynURLConnection.h"
#import "UIAlertView+NetPrompt.h"
#import "HeadToolBar.h"
#import "CButton.h"
#import "UniversalTip.h"
#import "DashLineUI.h"
#import "LLAsynURLConnection.h"
#import "DashLineButton.h"
#define kCornerRadius    5.0f
#define kTextFiledOffy         32.0f
//手机话费,支付宝兑换，财付通兑换
@interface ExchangePViewController ()
{
    MScrollVIew* ms;
    int arg1;
    int arg2;
    int arg3;
    int arg0;
    UIImageView *phoneNumber;
    NSArray* moneys2;
    NSMutableArray* phMoneys2;
    
    
    UIButton* Btn10;
    //    HeadView* headView;
    HeadToolBar *headBar;
    
    NSArray *phoneMoneys;                                           //手机话费
    NSArray *zhiFuBaoMoneys;                                        //支付宝
    NSArray *caiFuTongMoneys;                                       //财付通
    int type;                                                       //标识是哪种支付手段 1：手机话费 2：支付宝 3：财付通
    NSMutableArray *allBtns;                                        //存放当前4个按钮
    int selectBtnIndex;                                             //标识当前选中是哪个按钮
    int timeOutCount;                                               //标识超时的次数
    BOOL isFrist;                                                   //标识是否第一次访问
    
    UIColor *btnTitleClr;                                           // 选择按钮上字体颜色
    UIView *bgView;                                                 //选择状态背景
    CButton *chagreBtn;
    UniversalTip *tip ;
    NSMutableArray *qcount;
    BOOL end ;
    NSString *content ;                                            //兑换说明
}
@end

@implementation ExchangePViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tag:(int )tag{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        type = tag;       // 1 是Q币   2是话费
    }
    return self;
}

-(void)hidKeyBoard{
    [phoneText resignFirstResponder];
}

//初始化变量
-(void)initWithObjects{
    phoneMoneys = @[@"话费10元",@"话费20元",@"话费30元",@"话费50元"];
    zhiFuBaoMoneys = @[@"兑换1个",@"兑换10元",@"兑换30个",@"兑换50个"];
    caiFuTongMoneys = @[@"兑换20元",@"兑换30元",@"兑换50元",@"兑换100元"];
    moneys2 =@[@"Q币1个",@"Q币10个",@"Q币30个",@"Q币50个"];
//    phMoneys2 =@[@"10",@"20",@"30",@"50"];
//    qcount =@[@"1",@"10",@"30",@"50"];
    
    qcount =[[NSMutableArray alloc] init];
    phMoneys2 =[[NSMutableArray alloc] init];
    allBtns = [[NSMutableArray alloc] init];
    isFrist = YES;
    selectBtnIndex = 0;
    arg0 =0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kWitheColor ;
    [self initWithObjects];
    
    NSNumber *jdCount =[[MyUserDefault standardUserDefaults] getUserBeanNum];
    if (!self.isRechargeQ) {
        
        headBar =[[HeadToolBar alloc] initWithTitle:@"话费兑换" leftBtnTitle:@"返回" leftBtnImg:GetImageWithName(@"back") leftBtnHighlightedImg:GetImageWithName(@"back_sel.png") rightLabTitle:jdCount backgroundColor:kBlueTextColor];
        btnTitleClr = KPurpleColor2_0 ;
    }else{
        headBar =[[HeadToolBar alloc] initWithTitle:@"Q币兑换" leftBtnTitle:@"返回" leftBtnImg:GetImageWithName(@"back") leftBtnHighlightedImg:GetImageWithName(@"back_sel.png") rightLabTitle:jdCount backgroundColor:kBlueTextColor];
        btnTitleClr = KOrangeColor2_0;
    }
    
    headBar.leftBtn.tag =1;
    [headBar.leftBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y+headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.size.height - headBar.frame.origin.y) andWithPageCount:1 backgroundImg:nil];
    ms.delegate =self;
    ms.bounces =YES;
    [ms setContentSize:CGSizeMake(kmainScreenWidth, ms.frame.size.height+1)];
    
    [self.view addSubview:headBar];
    [self.view addSubview:ms];
    
    [self loadContentViews];
    
    [self performSelector:@selector(makeDashLine) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
    [self requestForCashRewardInfor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidKeyBoard) name:@"hidAllKeyBoard" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didPopView) name:@"popview" object:nil];
    if (kmainScreenHeigh < 568.0) {
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self adjustPositionWithTime:time viewAnimation:options position:kbSize];
    });
    
}
BOOL isAnimaing;
-(void)adjustPositionWithTime:(NSTimeInterval) time viewAnimation:(UIViewAnimationOptions) option position:(CGRect) rect{
    
    float a = chagreBtn.frame.origin.y +headBar.frame.origin.y +headBar.frame.size.height;
    float b = CGRectGetHeight(self.view.frame) - rect.size.height -chagreBtn.frame.size.height -5.0f;
    float c = b-a;
    NSLog(@" 高度差  == %f",c);
    c = c <0? c*-1 :c ;
    c = rect.origin.y ==kmainScreenHeigh? 0:c ;
    isAnimaing = YES;
    [UIView animateWithDuration:time delay:0.0f options:option animations:^{
        ms.frame = CGRectMake(0, headBar.frame.origin.y+headBar.frame.size.height - c, ms.frame.size.width, ms.frame.size.height);
        [self.view insertSubview:ms belowSubview:headBar];
    } completion:^(BOOL finished) {

        NSLog(@" ms frame ==%@  %@",NSStringFromCGRect(ms.frame),NSStringFromCGSize(ms.contentSize));
    }];
}
-(void)loadContentViews{
    if (self.isRechargeQ) {
        btnTitleClr = KOrangeColor2_0;
    }else{
        btnTitleClr = KPurpleColor2_0 ;
    }
    bgView =[[UIView alloc]init];
    bgView.backgroundColor =btnTitleClr;
    
    float buttonW = (kmainScreenWidth - 3*kOffX_2_0) /2 ;
    float buttonH = 40.0f ;
    
    for(int i = 0 ; i < 2 ; i ++){
        for(int j = 0 ; j < 2 ; j ++){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.clipsToBounds =YES;
            button.frame = CGRectMake(kOffX_2_0 + j * buttonW + j * kOffX_2_0, (buttonH + kOffX_2_0) * i + kOffX_2_0, buttonW, buttonH);
            
            button.tag = 2 * i + j;
            if (button.tag == 0) {
                
                bgView.frame = CGRectMake(button.frame.origin.x -0.5f, button.frame.origin.y -0.5f, button.frame.size.width +1, button.frame.size.height +1);
                bgView.layer.cornerRadius = kCornerRadius ;
                [ms addSubview:bgView];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            }else{
                [button setTitleColor:btnTitleClr forState:UIControlStateNormal];
            }
            button.titleLabel.font =[UIFont systemFontOfSize:14.0];
            [button addTarget:self action:@selector(onClickRewardPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
            NSString *titleBtn ;
            if(!self.isRechargeQ){
//                titleBtn = [phoneMoneys objectAtIndex:button.tag];
                titleBtn =@"话费0元";
            }else {
//                titleBtn = [zhiFuBaoMoneys objectAtIndex:button.tag];
                titleBtn =@"Q币0个";
            }
            [button setTitle:titleBtn forState:UIControlStateNormal];
            [allBtns addObject:button];
            [ms addSubview:button];
        }
    }
    
    UIView *view = [ms viewWithTag:2];
    phoneText = [[UITextField alloc]initWithFrame:CGRectMake(kOffX_2_0, view.frame.origin.y + view.frame.size.height +kTextFiledOffy, kmainScreenWidth -2* (kOffX_2_0),15)];
    phoneText.backgroundColor = [UIColor clearColor];
    phoneText.font = [UIFont systemFontOfSize:14];
    phoneText.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter ;
    phoneText.textColor = KBlockColor2_0;
    if(!self.isRechargeQ){
        phoneText.placeholder=@"请输入您的手机号码";
        phoneText.text = [[MyUserDefault standardUserDefaults] getUserPhoneNum];
        [phoneText setKeyboardType:UIKeyboardTypeNumberPad];
    }else{
        phoneText.placeholder=[NSString stringWithFormat:@"请输入您的QQ号码"];
        phoneText.text = [[MyUserDefault standardUserDefaults] getUserQNum];
        [phoneText setKeyboardType:UIKeyboardTypeNumberPad];
        phoneText.returnKeyType =UIReturnKeyDone;
    }
    phoneText.delegate=self;
    
    [self loadSperateLineWithFrame:CGRectMake(kOffX_2_0, phoneText.frame.origin.y +phoneText.frame.size.height+ 15, kmainScreenWidth -2 *kOffX_2_0, 0.5f)];
    
//    float chargeBtnOffx = 80.0f ;
    chagreBtn= [self loadBtnWithFrame:CGRectMake(kmainScreenWidth/2 -SendButtonWidth/2, phoneText.frame.origin.y +phoneText.frame.size.height +25, SendButtonWidth, SendButtonHeight) withTitle:@"立即兑换" andFont:[UIFont systemFontOfSize:16.0]];
    chagreBtn.tag =6;
    chagreBtn.layer.masksToBounds = YES;
    chagreBtn.layer.cornerRadius = chagreBtn.frame.size.height /2 ;
    [chagreBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [ms addSubview:chagreBtn];
    
    [ms addSubview:phoneText];
    
}


-(void)makeDashLine{
  
    NSLog(@" run for new thread ");
    for (UIButton *button in allBtns) {
        DashLineUI *dash =[[DashLineUI alloc] init];
        dash.spacePattern = 2.0;
        dash.borderWidth = 1.0 ;
        dash.dashPattern = 2.0 ;
        dash.cornerRadius = kCornerRadius ;
        dash.borderColor = btnTitleClr ;
        [dash addDashLineUI:button];
    }
    [self performSelectorOnMainThread:@selector(setEnd) withObject:nil waitUntilDone:NO];
    NSLog(@" end");
    
}
-(void)setEnd{
    end =YES;
}
-(void)loadUniversalTipWithFrame:(CGRect)rect {
    /*
    NSNumber *number =[[MyUserDefault standardUserDefaults] getUserBeanNum];
    int count =0;
    int per =0;
    if (arg0 !=0) {
        if (self.isRechargeQ) {
            per =arg0 /20;
        }else{
            per =arg0 /10;
        }
        
        count =[number intValue] /arg0;
    }
    NSString *first;
    NSString *second;
    if (self.isRechargeQ) {
        first =[NSString stringWithFormat:@"1.%d流量币=1Q币，%d流量币=10Q币，%d流量币=30Q币，%d流量币=50Q币；",arg0 ,arg0*10,arg0*30 ,arg0*50];
        second =[NSString stringWithFormat:@"2.您的账户现在有：%@流量币，最多可兑换%dQ币；",number,count];
    }else{
        first =[NSString stringWithFormat:@"1.%d流量币=10元，%d流量币=20元，%d流量币=30元，%d流量币=50元；",arg0,arg0*10,arg0*30,arg0*50];
        second =[NSString stringWithFormat:@"2.您的账户现在有：%@流量币，最多可兑换%d元；",number,count];
    }
    NSString *name;
    NSString *style;
    
    if (!self.isRechargeQ) {
        name =@"话费";
        style =@"手机";
        [second stringByAppendingString:name];
    }
    else {
        style = @"QQ";
    }
    NSString *thrid =[NSString stringWithFormat:@"3.请确保您的%@号码是正确的，否则将无法兑换成功；",style];
    NSString *four =[NSString stringWithFormat:@"4.兑换后需1~2个工作日的审核时间，审核成功后会自动为您的%@号充值，请注意查收；",style];
    NSString *five =[NSString stringWithFormat:@"5.该奖品由91淘金提供，与苹果公司无关。"];
     */
    NSArray *arraytip =[NSArray arrayWithObjects: content,nil];
    if(tip){
        [tip removeFromSuperview];
    }
    tip =[[UniversalTip alloc]initWithFrame:rect andTips:arraytip andTipBackgrundColor:KTipBackground2_0 withTipFont:[UIFont systemFontOfSize:11.0] andTipImage:GetImageWithName(@"") andTipTitle:@"" andTextColor:btnTitleClr];
    [ms addSubview:tip];
    
    /*
    DashLineButton *button =[DashLineButton buttonWithType:UIButtonTypeCustom];
    button.borderColor = KOrangeColor2_0;
    button.frame = CGRectMake(0, tip.frame.origin.y +tip.frame.size.height +50, 100, 40);
    [button setTitle:@"测试" forState:UIControlStateNormal];
    [ms addSubview:button];
     */
}

-(CButton *)loadBtnWithFrame:(CGRect)rect withTitle:(NSString *)title andFont:(UIFont*) font{
    CButton *btn =[CButton buttonWithType:UIButtonTypeCustom];
    btn.frame =rect;
    if ([btnTitleClr isEqual:KOrangeColor2_0]) {
        btn.backgroundColor  =KOrangeColor2_0;
        btn.nomalColor =KOrangeColor2_0;
        btn.changeColor =KLightOrangeColor2_0;
    }else{
        btn.backgroundColor  =KPurpleColor2_0;
        btn.nomalColor =KPurpleColor2_0;
        btn.changeColor =kLightPurpleColor;
    }
    
    btn.titleLabel.font =font;
    [btn setTitle:title forState:UIControlStateNormal];
    
    
    return btn;
}
-(void)loadSperateLineWithFrame:(CGRect)rect{
    UIView *line =[[UIView alloc]initWithFrame:rect];
    line.backgroundColor =kGrayLineColor2_0;
    [ms addSubview:line];
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
    [phoneText removeFromSuperview];
    phoneText = nil;
    [phoneNumber removeFromSuperview];
    phoneNumber = nil;
    [ms removeFromSuperview];
    ms = nil;
    //    [headView removeFromSuperview];
    //    headView = nil;
    [allBtns removeAllObjects];
    allBtns = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hidAllKeyBoard" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"popview" object:nil];
}

//请求获取话费信息（new）
-(void)requestToCallsInfor{
    if(isFrist){
        [[LoadingView showLoadingView] actViewStartAnimation];
        isFrist = NO;
    }
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid, @"Type":[NSNumber numberWithInt:type]};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"AwardUI",@"GetAwardFullInfoByType"];
    NSLog(@"请求获取话费信息【urlStr】 = %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        [[LoadingView showLoadingView] actViewStopAnimation];
        timeOutCount = 0;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求获取话费信息【response】 = %@",dataDic);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                arg0 =[[body objectForKey:@"Arg0"]integerValue];
                arg1 =[[body objectForKey:@"Arg1"]integerValue];
                arg2 =[[body objectForKey:@"Arg2"]integerValue];
                arg3 =[[body objectForKey:@"Arg3"]integerValue];
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
        NSLog(@"请求获取话费信息【error】 = %@",error);
        if(error.code == timeOutErrorCode){
            //连接超时
            if(timeOutCount < 2){
                [self requestToCallsInfor];
            }else{
                timeOutCount = 0;
                [[LoadingView showLoadingView] actViewStopAnimation];
                if(![UIAlertView isInit]){
                    UIAlertView *alertView = [UIAlertView showNetAlert];
                    alertView.delegate = self;
                    alertView.tag = kTimeOutTag;
                    [alertView show];
                }
            }
        }
    }];
}


-(void)initContentText:(NSString *)content{
    UIWebView *web = [[UIWebView alloc]init];

    web.delegate = self;
    web.frame = CGRectMake(5, phoneNumber.frame.origin.y + phoneNumber.frame.size .height + 5, 310,0);
    web.backgroundColor = [UIColor clearColor];
    web.scrollView.backgroundColor= [UIColor clearColor];
    [web setScalesPageToFit:NO];
    web.userInteractionEnabled =NO;
    [ms addSubview:web];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    [[LoadingView showLoadingView] actViewStopAnimation];
}

- (void)highlightButton:(UIButton *)btn {
    [btn setHighlighted:YES];
}

-(void)onClickRewardPhoneBtn:(UIButton* )btn{
    bgView.frame = CGRectMake(btn.frame.origin.x -0.5f, btn.frame.origin.y -0.5f, btn.frame.size.width +1, btn.frame.size.height +1);;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    selectBtnIndex =btn.tag;
    for (UIButton *button in allBtns) {
        if (button.tag != btn.tag) {
            
            [button setTitleColor:btnTitleClr forState:UIControlStateNormal];
            
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([self isPureInt:string] || [string isEqualToString:@""]) {
        if([textField.text stringByAppendingString:string].length>11 && self.isRechargeQ==NO){
            return NO;
        }else{
            return YES;
        }
//        return YES;
    }else{
        return NO;
    }
}
-(void)onClickBackBtn:(UIButton* )btn{
    
    switch (btn.tag) {
        case 1:
        {
            [[LoadingView showLoadingView] actViewStopAnimation];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 6:
        {
            //获取当前账号的淘金豆
            long userBeanNum = [[[MyUserDefault standardUserDefaults] getUserBeanNum] longValue];
            
            [phoneText resignFirstResponder];
            
            DidRewardView *view = [[DidRewardView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
            view.phoneNumber = phoneText.text;
            view.type = 102;

            /*
             if (self.isRechargeQ== NO) {
             view.isRecharge=YES;
             view.getHfInt =[[phMoneys2 objectAtIndex:selectBtnIndex]integerValue];
             if ([self.rechargeType isEqualToString:@"支付宝"]) {
             view.rechargeType=self.rechargeType;
             view.rewardType =6;
             view.arg0= arg0;
             view.phoneNumber =phoneText.text;
             view.getHfInt =[[moneys2 objectAtIndex:selectBtnIndex]integerValue];
             view.chargeStyle =[zhiFuBaoMoneys objectAtIndex:selectBtnIndex];
             switch (selectBtnIndex) {
             case 0:
             view.arg0 =arg0;
             break;
             
             case 1:
             view.arg0 =arg1;
             break;
             
             case 2:
             view.arg0 =arg2;
             break;
             
             case 3:
             view.arg0 =arg3;
             break;
             }
             //[Sun] 2014.03.15 支付宝可以为手机号
             BOOL isPhoneNum = [self isPureInt:phoneText.text] && phoneText.text.length ==11;
             if ([self isEmailAdress:phoneText.text] || isPhoneNum ==YES) {
             if (userBeanNum < view.arg0) {
             [self showNotEnough];
             }else{
             [view setBasicView];
             [self.view addSubview:view];
             }
             }else{
             [StatusBar showTipMessageWithStatus:@"请输入正确的支付宝账号" andImage:[UIImage imageNamed:@"icon_no.png"]andTipIsBottom:YES];
             }
             }else if ([self.rechargeType isEqualToString:@"财付通"]){
             view.rechargeType=self.rechargeType;
             view.rewardType =7;
             view.arg0 =arg0;
             view.phoneNumber =phoneText.text;
             view.getHfInt=[[moneys2 objectAtIndex:selectBtnIndex]integerValue];
             view.chargeStyle =[caiFuTongMoneys objectAtIndex:selectBtnIndex];
             switch (selectBtnIndex) {
             case 0:
             view.arg0 =arg0;
             break;
             
             case 1:
             view.arg0 =arg1;
             break;
             
             case 2:
             view.arg0 =arg2;
             break;
             
             case 3:
             view.arg0 =arg3;
             break;
             }
             
             if ([self isPureInt:phoneText.text] && phoneText.text.length >4 && phoneText.text.length <12) {
             if (userBeanNum <view.arg0) {
             [self showNotEnough];
             }else{
             [view setBasicView];
             [self.view addSubview:view];
             }
             }else{
             [StatusBar showTipMessageWithStatus:@"请输入正确的财付通号码" andImage:[UIImage imageNamed:@"icon_no.png"]andTipIsBottom:YES];
             }
             
             }
             
             }else{
             */
            if (!self.isRechargeQ) {
                view.getHfInt =[[phMoneys2 objectAtIndex:selectBtnIndex]integerValue];
            }
            UIButton *btn =[allBtns objectAtIndex:selectBtnIndex];
            view.getHF =btn.titleLabel.text;
            view.chargeStyle =btn.titleLabel.text;
            
            if (self.isRechargeQ == NO) {
                
                view.arg0 =arg0 *[[phMoneys2 objectAtIndex:selectBtnIndex]integerValue];
                
                view.rewardType = 2;
                if ([self isPureInt:phoneText.text] && phoneText.text.length ==11 ) {
                    if (userBeanNum < view.arg0) {
                        [self showNotEnough];
                    }else{
                        [view setBasicView];
                        [self.view addSubview:view];
                    }
                }else{
                    [StatusBar showTipMessageWithStatus:@"请输入正确的手机号码" andImage:[UIImage imageNamed:@"icon_no.png"]andTipIsBottom:YES];
                }
            }else{
                view.arg0 = arg0 *[[qcount objectAtIndex:selectBtnIndex]intValue];
                view.QCount =[[qcount objectAtIndex:selectBtnIndex]intValue];
                view.QNumber = phoneText.text;
                view.chargeStyle = [btn titleLabel].text;
                view.type = 101;
                view.rewardType = 1;
                if ([self isPureInt:phoneText.text] && phoneText.text.length > 4 && phoneText.text.length < 12 ) {
                    if (userBeanNum < view.arg0) {
                        [self showNotEnough];
                    }else{
                        [view setBasicView];
                        [self.view addSubview:view];
                    }
                }else{
                    [StatusBar showTipMessageWithStatus:@"请输入正确的QQ号码" andImage:[UIImage imageNamed:@"icon_no.png"]andTipIsBottom:YES];
                }
                
            }
        }
            break;
            
    }
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
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [phoneText resignFirstResponder];
}

-(void)didPopView{
    if(!self.isRechargeQ){
        //话费充值
        [[MyUserDefault standardUserDefaults] setUserPhoneNum:phoneText.text];
    }else{
        [[MyUserDefault standardUserDefaults] setUserQNum:phoneText.text];
    }
    RewardListViewController *re = [[RewardListViewController alloc] initWithNibName:nil bundle:nil];
    re.isRootPush =YES;
    [self.navigationController pushViewController:re animated:YES];
    
}
//滑动收起键盘

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [phoneText resignFirstResponder];
}


// [Sun] 2014.03.18 修改金豆不足提示
-(void)showNotEnough{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"流量币不足" message:@"您的流量币不足，是否现在做任务赚取流量币？" delegate:self cancelButtonTitle:@"算了" otherButtonTitles:@"赚流量币", nil];
    alertView.tag = 1;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == kTimeOutTag){
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [UIAlertView resetNetAlertNil];
        [[LoadingView showLoadingView] actViewStartAnimation];
        [self requestForCashRewardInfor];
    }else if(alertView.tag == 1){
        if (buttonIndex ==0) {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }else{
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter]postNotificationName:GoBackToFlowCenterNotic object:nil userInfo:nil];
        }
    }
}
-(void)requestForCashRewardInfor{
    if(isFrist){
        [[LoadingView showLoadingView] actViewStartAnimation];
        isFrist = NO;
    }
    chagreBtn.userInteractionEnabled =NO;
    NSString *string;
    string=self.isRechargeQ ==YES ? [NSString stringWithFormat:@"award/info/qb"] :[NSString stringWithFormat:@"award/info/huafei"];
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
                NSArray *cftArr = [body objectForKey:@"arg"];
                NSDictionary *cftDic =[cftArr objectAtIndex:0];
                int gold = [[cftDic objectForKey:@"gold"] intValue];
                int num =[[cftDic objectForKey:@"num"] intValue];
                arg0 = gold/num ;
                long bean =(long)[[body objectForKey:@"usergold"] longLongValue];
                content =[body objectForKey:@"content"];
                [[MyUserDefault standardUserDefaults] setUserBeanNum:bean];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    chagreBtn.userInteractionEnabled =YES;
                    [self loadUniversalTipWithFrame:CGRectMake(kOffX_float, chagreBtn.frame.origin.y +chagreBtn.frame.size.height +10,kmainScreenWidth -2*(kOffX_float), 0)];
                    int i=0 ;
                    for (UIButton *btn in allBtns) {
                        NSDictionary *dic =[cftArr objectAtIndex:i];
                        NSString *fee =(NSString *)[dic objectForKey:@"fee"];
                        i++;
                        if (self.isRechargeQ) {
                            [btn setTitle:[NSString stringWithFormat:@"Q币%@个",fee] forState:UIControlStateNormal];
                            [qcount addObject:fee];
                        }else{
                            [btn setTitle:[NSString stringWithFormat:@"话费%@元",fee] forState:UIControlStateNormal];
                            [phMoneys2 addObject:fee];
                        }
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
        chagreBtn.userInteractionEnabled =YES;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
