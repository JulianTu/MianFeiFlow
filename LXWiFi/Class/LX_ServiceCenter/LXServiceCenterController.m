//
//  LXServiceCenterController.m
//  乐享WiFi
//
//  Created by keyrun on 14-9-17.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LXServiceCenterController.h"
#import "HeadToolBar.h"
#import "TaoJinLabel.h"
#import "LLScrollView.h"
#import "UnderLineLabel.h"
#import "NSString+emptyStr.h"
#import "UIImage+ColorChangeTo.h"
#import "LoadingView.h"
#import "CodeView.h"
#import "RewardViewController.h"
#import "LXUserCenterController.h"
#import "LLPageControl.h"
#import "MyUserDefault.h"
#import "LLAsynURLConnection.h"
#import "FlowCard.h"
#import "NSDate+nowTime.h"
#import "StatusBar.h"
#import "RewardListViewController.h"
#import "UIAlertView+NetPrompt.h"
#import "DMPagingScrollView.h"

#define kCurrencyLabOffy     20.0f
#define kCurrencyLabH        21.0f
#define kPadding             20.0f
#define kFieldH              50.0f
#define kNumberAdressLabH     25.0f
#define kContentViewH         270.0f
#define kPagePadding          kmainScreenHeigh/568.0f *38.0f
#define kInvaildCardTag        20001

#define kRuleUrl         @"http://www.91taojin.com.cn/index.php?d=admin&c=page&m=detail&id=6"
@interface LXServiceCenterController ()
{
    HeadToolBar *headBar ;
    NSString *userCurrency ;      //用户流量币数
    
    DMPagingScrollView *contentView ;      //流量卡滚动视图
    UIPageControl *pageControl ;          //不使用
    NSString *phoneCity ;     // 城市
    NSString *phoneZone ;     //省份
    NSString *phoneSIM ;      //运营商
    TaoJinLabel *numAdressLab ;
    MScrollVIew *ms;
    UIWebView *ruleWeb ;    // 兑换规则web
    UIView *ruleContentView ;   // 兑换规则视图
    
    NSMutableArray *allPhone ;     // 电话号码开头三位
    UITextField *phoneField;
    UIView *allBgView ;
    TaoJinLabel *phoneDefLab ;
    UIView *garyView ;    //灰色背景
    float pageW ;
    NSMutableArray *_cardsArr ;      //所有的卡
    NSMutableArray *mobileCardArr ;
    NSMutableArray *unicomCardArr ;    // 联通卡
    NSMutableArray *telecomCardArr ;   //电信卡
    LLPageControl *pageControl2;
    
    NSString *ruleUrl ;      //兑换规则网页地址
    TaoJinLabel * userCurrencyLab ;      //顶部用户流量币数
    int  cardFailCount;
    int  phoneFailCount ;
    
    NSArray *mobileArr ;      //移动号码
    NSArray *unicomArr ;      // 联通号码
    NSArray *telecomArr ;      //电信号码
    int phoneIndex ;      //标记查询的号码属于
    NSMutableArray *flowCards ;      //所有流量卡视图
    BOOL isFirst ;
    int locationNum;      //标记idnex
    
    int vaildFailCount;
    NSMutableArray *mobileCardViews ;     //移动卡  视图
    NSMutableArray *unicomCardViews ;     //联通  视图
    NSMutableArray *telecomCardViews ;    // 电信  视图
    BOOL isRightNum ;
    UIAlertView *notEnoughAlert;
    NSTimer *checkTimer ;
    UnderLineLabel *refreshWebLab ;
    
    float cardOffx ;
    CGPoint locationPoint;
    CGSize locationSize;
    NSMutableArray *lastShowedCards;
}
@end

@implementation LXServiceCenterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)hiddenTheKeyboard {
    [phoneField resignFirstResponder];
}
-(void) initBasicData{
    if ([[MyUserDefault standardUserDefaults]getUserBeanNum]) {
        userCurrency = [[[MyUserDefault standardUserDefaults] getUserBeanNum] stringValue];
    }else{
        userCurrency = @"0" ;
    }
    
    locationNum =0;
    locationPoint =CGPointZero;
    locationSize =CGSizeZero ;
    _cardsArr = [[NSMutableArray alloc] init];
    mobileCardArr = [[NSMutableArray alloc] init];
    unicomCardArr = [[NSMutableArray alloc] init];
    telecomCardArr = [[NSMutableArray alloc] init];
    mobileCardViews = [[NSMutableArray alloc] init];
    unicomCardViews = [[NSMutableArray alloc] init];
    telecomCardViews = [[NSMutableArray alloc] init];
    flowCards = [[NSMutableArray alloc] init];
    if (isFirst ) {
        pageControl2.pageCount =0;
        pageControl2.currentPage =0;
        for (RewardCardView *view in contentView.subviews) {
            [view removeFromSuperview];
            
        }
        [contentView setContentSize:CGSizeZero];
        [self requestForFlowCards];
        
    }
    isFirst =YES;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, CGRectGetHeight(self.view.frame) -kfootViewHeigh ) andWithPageCount:1 backgroundImg:nil];
    
    [ms setContentOffset:CGPointMake(0, 0)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenTheKeyboard)];
    [ms addGestureRecognizer:tap];
    ms.showsVerticalScrollIndicator = NO;
    if (kDeviceVersion <7.0) {
        ms.delaysContentTouches =NO;
        
    }
    ms.backgroundColor =[UIColor clearColor] ;
    [ms setContentSize:CGSizeMake(kmainScreenWidth, ms.frame.size.height+1)];
    ms.bounces =YES;
    ms.delegate = self;
    
    lastShowedCards =[[NSMutableArray alloc] init];
    
    [self initBasicData];
    [self loadBGView];
    [self.view addSubview:ms];
    
    ruleContentView =[self loadRuleContentView];
    UINavigationController *rootVC = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController ;
    [rootVC.view addSubview:ruleContentView];
    
    if (!userCurrencyLab) {
        [self loadHeadContentView];
    }
    
    if (allPhone.count ==0) {
        [self loadCarrierData];
    }
    
}
-(void) viewDidAppear:(BOOL)animated{
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden =YES;
    if (kDeviceVersion >= 7.0) {
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 20)];
        view.backgroundColor = [UIColor blackColor];
        [self.view addSubview:view];
    }
    if (contentView) {
        if (locationPoint.x < contentView.contentSize.width) {
            [contentView setContentOffset:locationPoint];
        }
        
    }
    
}
-(void) loadBGView {
    garyView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 150.0f)];
    garyView.backgroundColor = ColorRGB(247.0, 247.0, 247.0, 1.0);
    [self.view addSubview:garyView];
}
-(void) loadCarrierData{
    allPhone = [[NSMutableArray alloc]init];
    NSLog(@" 号码段 == %@",[[MyUserDefault standardUserDefaults] getSystemPhoneCarrier]);
    NSDictionary *dataDic =[[MyUserDefault standardUserDefaults] getSystemPhoneCarrier];
    if (dataDic) {
        
        mobileArr = [dataDic objectForKey:@"chinamobile"];
        unicomArr = [dataDic objectForKey:@"chinaunicom"];
        telecomArr = [dataDic objectForKey:@"chinatelecom"];
        
        for (NSString *phone in mobileArr) {
            [allPhone addObject:phone];
        }
        for (NSString *phone in unicomArr) {
            [allPhone addObject:phone];
        }
        for (NSString *phone in telecomArr) {
            [allPhone addObject:phone];
        }
        
    }
    
    /*
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     
     NSString *dicPath =[[NSBundle mainBundle] pathForResource:@"PhoneNumList" ofType:@"plist"];
     NSDictionary *dataDic =[NSDictionary dictionaryWithContentsOfFile:dicPath];
     mobileArr = [dataDic objectForKey:@"mobile"];
     unicomArr = [dataDic objectForKey:@"unicom"];
     telecomArr = [dataDic objectForKey:@"telecom"];
     for (NSString *phone in mobileArr) {
     [allPhone addObject:phone];
     }
     for (NSString *phone in unicomArr) {
     [allPhone addObject:phone];
     }
     for (NSString *phone in telecomArr) {
     [allPhone addObject:phone];
     }
     
     NSLog(@" 电话信息 %@ ",dataDic);
     });
     */
}
-(void)loadChargeCardView:(NSMutableArray *)cards{
    [[contentView viewWithTag:kInvaildCardTag] setHidden:YES];
    for (RewardCardView *view in contentView.subviews) {    //清理掉之前的视图
        [view removeFromSuperview];
        
    }
    UIImage *image = GetImage(@"mobilebg");
    float kOffx = 10.0f ;
    float kpadding = kPagePadding;
    float kOffy =CGRectGetHeight(self.view.frame) <568.0? 15.0f:32.0f ;
    
    pageW = image.size.width +kpadding ;
    
    cardOffx =kmainScreenWidth/2 -image.size.width/2 ;
    
    for (int i=0; i <cards.count ; i++) {
        FlowCard *flowcard ;
        flowcard =[[FlowCard alloc]initFlowCardWithDic:[cards objectAtIndex:i]];
        
        OperatorType type ;
        
        if ([flowcard.flowOpreator isEqualToString:@"移动"]) {
            type = OperatorTypeMobile ;
//            if ([cards isEqual:_cardsArr]) {
                //                [mobileCardArr addObject:[cards objectAtIndex:i]];
//            }
        }else if ([flowcard.flowOpreator isEqualToString:@"联通"]){
            type = OperatorTypeUnicom ;
//            if ([cards isEqual:_cardsArr]) {
                //                [unicomCardArr addObject:[cards objectAtIndex:i]];
//            }
        }else if ([flowcard.flowOpreator isEqualToString:@"电信"]){
            type = OperatorTypeTelecom ;
//            if ([cards isEqual:_cardsArr]) {
                //                [telecomCardArr addObject:[cards objectAtIndex:i]];
//            }
        }
        BOOL isEnough = [userCurrency longLongValue] > [flowcard.flowGold longLongValue] ? YES :NO ;
        RewardCardView *card = [[RewardCardView alloc] initWithFrame:CGRectMake(i *image.size.width +(kOffx + kpadding*(i+1) ), kOffy, image.size.width, image.size.height) withOperator:type flowNum:flowcard.flowSize andNeedNum:flowcard.flowGold limitType:flowcard.flowExpire isEnough:isEnough andCardInfo:flowcard.flowname andCardId:flowcard.flowId flowCard:flowcard];
        card.frame =CGRectMake(cardOffx +(image.size.width +kpadding) *i, kOffy, image.size.width, image.size.height);
        card.rcDelegate = self;
        
        [flowCards addObject:card];
        
        [contentView addSubview:card];
        
    }
    pageControl2.hidden= NO;
    [contentView setContentSize:CGSizeMake(cardOffx +(image.size.width +kpadding)* (_cardsArr.count) +kPagePadding  , contentView.frame.size.height)];
    locationSize = contentView.contentSize ;
    
    [contentView setContentOffset:CGPointZero];
    //    [contentView setContentSize:CGSizeMake(kmainScreenWidth * (cards.count-1), contentView.frame.size.height)];
    
    
}
-(void) showInvaildCardView {
    for (UIView *view in flowCards) {
        view.hidden = YES;
    }
    //    float kOffx = 10.0f ;
    //    float kpadding = 38.0f;
    float kOffy = CGRectGetHeight(self.view.frame) <568.0? 15.0f:32.0f ;
    UIImage *invaildImg = GetImageWithName(@"cardviolet");
    
    RewardCardView *invaildCard = [[RewardCardView alloc] initInvalidRewardView:CGRectMake(cardOffx, kOffy, invaildImg.size.width, invaildImg.size.height) withBlock:^{
        UINavigationController *nc = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController ;
        
        RewardViewController *rv = [[RewardViewController alloc] initWithNibName:nil bundle:nil];
        rv.isFromService = YES ;
        [nc pushViewController:rv animated:YES];
        
        //        [[NSNotificationCenter defaultCenter] postNotificationName:PushToRewardViewNotic object:nil userInfo:nil];
    }];
    invaildCard.tag = kInvaildCardTag ;
    [contentView setContentSize:CGSizeMake(kmainScreenWidth, CGRectGetHeight(contentView.frame))];
    pageControl2.hidden = YES;  //当出现不能兑换时  pagecontrol miss
    [contentView addSubview:invaildCard];
    lastShowedCards =[[NSMutableArray alloc] initWithArray:@[invaildCard]];
}
-(void)loadUserCurrencyLab{
    NSMutableAttributedString *attString =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"您共有%@流量币",userCurrency]];
    if (![userCurrency isKindOfClass:[NSString class]]) {
        userCurrency =[NSString stringWithFormat:@"%@",userCurrency];
    }
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0, 3)];
    [attString addAttribute:NSForegroundColorAttributeName value:KOrangeColor2_0 range:NSMakeRange(3, userCurrency.length+3)];
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0] range:NSMakeRange(3, userCurrency.length)];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(3+ userCurrency.length, 3)];
    userCurrencyLab.attributedText = attString ;
}
-(void)loadHeadContentView {
    
    userCurrencyLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0, kPadding +15.0f, kmainScreenWidth, kCurrencyLabH) text:nil font:nil textColor:nil textAlignment:NSTextAlignmentCenter numberLines:1];
    [self loadUserCurrencyLab];
    [ms addSubview:userCurrencyLab];
    if (kDeviceVersion <7.0) {
        userCurrencyLab.frame =CGRectMake(0, 13.0f, kmainScreenWidth, kCurrencyLabH);
        
    }else{
        userCurrencyLab.frame =CGRectMake(0, 10.0f +kPadding, kmainScreenWidth, kCurrencyLabH);
    }
    
    phoneField = [[UITextField alloc] initWithFrame:CGRectMake(kOffX_2_0, userCurrencyLab.frame.origin.y +userCurrencyLab.frame.size.height +kPadding/2, kmainScreenWidth- 2*kOffX_2_0, kFieldH)];
    phoneField.backgroundColor = ColorRGB(227.0, 228.0, 230.0, 1);
    phoneField.layer.masksToBounds =YES;
    phoneField.layer.cornerRadius = 5.0f ;
    phoneField.font = GetBoldFont(25.0) ;
    phoneField.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter ;
    phoneField.textAlignment = NSTextAlignmentCenter ;
    phoneField.placeholder =@"";
    phoneField.textColor = kBlackTextColor ;
    phoneField.delegate = self;
    phoneField.layer.borderWidth =0.5f ;
    phoneField.layer.borderColor = kLineColor2_0.CGColor;
    [phoneField setKeyboardType:UIKeyboardTypeNumberPad];
    [ms addSubview:phoneField];
    
    phoneDefLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0, phoneField.frame.origin.y +(phoneField.frame.size.height/2 -8.0f), kmainScreenWidth, 16.0) text:@"" font:GetFont(16.0) textColor:kContentTextColor textAlignment:NSTextAlignmentCenter numberLines:1];
    phoneDefLab.text =@"请输入移动，联通，电信手机号码";
    phoneDefLab.contentMode = UIViewContentModeCenter;
    [ms addSubview:phoneDefLab];
    
    
    numAdressLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0, phoneField.frame.size.height +phoneField.frame.origin.y, kmainScreenWidth, kNumberAdressLabH) text:@"" font:GetFont(11.0) textColor:kContentTextColor textAlignment:NSTextAlignmentCenter numberLines:1];
    [ms addSubview:numAdressLab];
    
    UIImage *cardImg = GetImage(@"mobilebg");
    float width = kmainScreenWidth -kOffX_2_0 -2*kPagePadding -cardImg.size.width ;
    float contentW = cardImg.size.width -width +kOffX_2_0 +kPagePadding;
    NSLog(@" ContentViewW %f  imageSize %f",contentW,cardImg.size.width);
    //    contentView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, numAdressLab.frame.origin.y +numAdressLab.frame.size.height, cardImg.size.width +kPagePadding, kContentViewH)];
    //    contentView.frame =CGRectMake(0, numAdressLab.frame.origin.y +numAdressLab.frame.size.height, kmainScreenWidth , kContentViewH);
    //    contentView.delegate = self;
    //    contentView.pagingEnabled = YES;
    //    contentView.clipsToBounds = NO;
    //    contentView.backgroundColor = kWitheColor ;
    //    contentView.showsHorizontalScrollIndicator = NO;
    //    [ms addSubview:contentView];
    
    contentView = [[DMPagingScrollView alloc] initWithFrame:CGRectMake(0, numAdressLab.frame.origin.y +numAdressLab.frame.size.height, kmainScreenWidth , kContentViewH)];
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    contentView.pageWidth =cardImg.size.width +kPagePadding;
    
    contentView.pageHeight = kContentViewH;
    contentView.clipsToBounds = NO;
    contentView.backgroundColor = kWitheColor ;
    contentView.showsHorizontalScrollIndicator = NO;
    [ms addSubview:contentView];
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0,contentView.frame.origin.y - LineWidth, kmainScreenWidth, LineWidth)];
    line.backgroundColor = kLineColor2_0;
    //    [ms addSubview:line];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height +contentView.frame.origin.y , kmainScreenWidth, 20.0f)];
    pageControl.numberOfPages =0;
    pageControl.currentPageIndicatorTintColor = ColorRGB(146.0, 146.0, 146.0, 1.0) ;
    pageControl.pageIndicatorTintColor = ColorRGB(200.0, 200.0, 200.0, 1.0) ;
    //    [ms addSubview:pageControl];
    
    pageControl2 =[[LLPageControl alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height +contentView.frame.origin.y , kmainScreenWidth, 5.0f)];
    pageControl2.pageCount = _cardsArr.count;
    pageControl2.currentPage =locationNum;
    
    pageControl2.pageTintColor =ColorRGB(200.0, 200.0, 200.0, 1.0) ;
    pageControl2.currentColor = ColorRGB(146.0, 146.0, 146.0, 1.0) ;
    pageControl2.backgroundColor = [UIColor clearColor];
    [ms addSubview:pageControl2];
    
    
    UnderLineLabel *chargeRule =[[UnderLineLabel alloc] initWithFrame:CGRectMake(0, pageControl.frame.origin.y +pageControl.frame.size.height + 30.0f, kmainScreenWidth, 15.0)];
    chargeRule.font = GetFont(12.0f);
    chargeRule.textColor = ColorRGB(155.0, 155.0, 155.0, 1) ;
    chargeRule.highlightedColor = ColorRGB(230, 230, 230, 1) ;
    chargeRule.shouldUnderline = YES;
    [chargeRule setText:@"查看兑换规则" andCenter:CGPointMake(kmainScreenWidth/2, 30)];
    [chargeRule sizeToFit];
    chargeRule.frame =CGRectMake( kmainScreenWidth/2 -chargeRule.frame.size.width/2, pageControl.frame.origin.y +pageControl.frame.size.height +30.0f, chargeRule.frame.size.width, chargeRule.frame.size.height);
    [chargeRule addTarget:self action:@selector(checkChargeRules)];
    [ms addSubview:chargeRule];
    
    UIView* whiteView =[[UIView alloc] initWithFrame:CGRectMake(0, line.frame.origin.y , kmainScreenWidth,ms.frame.size.height - line.frame.origin.y)];
    whiteView.backgroundColor = kWitheColor;
    [ms insertSubview:whiteView aboveSubview:userCurrencyLab];
    
    
    if (kmainScreenHeigh <568.0) {      //3.5寸屏幕需要调整
        float padding= 13.0f;
        phoneField.frame = CGRectMake(kOffX_2_0, userCurrencyLab.frame.origin.y +userCurrencyLab.frame.size.height +padding, kmainScreenWidth- 2*kOffX_2_0, kFieldH);
        phoneDefLab.frame =CGRectMake(0, phoneField.frame.origin.y +(phoneField.frame.size.height/2 -8.0f), kmainScreenWidth, 16.0);
        numAdressLab.frame = CGRectMake(0, phoneField.frame.size.height +phoneField.frame.origin.y, kmainScreenWidth, kNumberAdressLabH);
        contentView.frame = CGRectMake(0, numAdressLab.frame.origin.y +numAdressLab.frame.size.height, contentView.frame.size.width, 253.0f);
        line.frame = CGRectMake(0,contentView.frame.origin.y - LineWidth, kmainScreenWidth, LineWidth) ;
        pageControl2.frame = CGRectMake(0, contentView.frame.size.height +contentView.frame.origin.y , kmainScreenWidth, 5.0f) ;
        chargeRule.frame = CGRectMake( kmainScreenWidth/2 -chargeRule.frame.size.width/2, pageControl2.frame.origin.y +pageControl2.frame.size.height +8.0f, chargeRule.frame.size.width, chargeRule.frame.size.height);
        whiteView.frame = CGRectMake(0, line.frame.origin.y , kmainScreenWidth,ms.frame.size.height - line.frame.origin.y);
    }else{
        float scaleX = [UIScreen mainScreen].bounds.size.height /568.0f;
        userCurrencyLab .frame = CGRectMake(userCurrencyLab.frame.origin.x, 10.0f + kPadding*scaleX, userCurrencyLab.frame.size.width, userCurrencyLab.frame.size.height);
        phoneField.frame =CGRectMake(phoneField.frame.origin.x, userCurrencyLab.frame.origin.y +userCurrencyLab.frame.size.height +kPadding/2 *scaleX, phoneField.frame.size.width, phoneField.frame.size.height);
        phoneDefLab.frame =CGRectMake(phoneDefLab.frame.origin.x , phoneField.frame.origin.y +(phoneField.frame.size.height/2 -8.0f) , phoneDefLab.frame.size.width, phoneDefLab.frame.size.height);
        numAdressLab.frame =CGRectMake(numAdressLab.frame.origin.x, phoneField.frame.origin.y +phoneField.frame.size.height, numAdressLab.frame.size.width, numAdressLab.frame.size.height*scaleX);
        contentView.frame =CGRectMake(contentView.frame.origin.x, numAdressLab.frame.origin.y +numAdressLab.frame.size.height*scaleX, contentView.frame.size.width, contentView.frame.size.height);
        line.frame =CGRectMake(line.frame.origin.x, line.frame.origin.y *scaleX, line.frame.size.width, line.frame.size.height);
        pageControl2.frame =CGRectMake(pageControl2.frame.origin.x, contentView.frame.size.height +contentView.frame.origin.y , pageControl2.frame.size.width, pageControl2.frame.size.height);
        chargeRule.frame =CGRectMake(chargeRule.frame.origin.x, pageControl2.frame.origin.y +pageControl2.frame.size.height + 30.0f *scaleX, chargeRule.frame.size.width, chargeRule.frame.size.height);
        whiteView.frame =CGRectMake(whiteView.frame.origin.x, whiteView.frame.origin.y *scaleX, whiteView.frame.size.width, whiteView.frame.size.height);
    }
}
/**
 *  兑换流量包
 *
 *  @param flowNum 流量值
 *  @param costNum 花费
 *  @param cid     卡id
 *  @param enough  是否够流量币
 */
-(void)onClickedRewardChargeCard:(NSString *)flowNum andCostNum:(NSString *)costNum andCardID:(int)cid isEnough:(BOOL)enough{
    __block int cardID = cid;
    if (phoneField.text.length ==13 && isRightNum ==YES) {
        CodeView *view=[[CodeView alloc] initWithPhoneNum:phoneField.text andCardInfor:flowNum andCostNum:costNum codeViewBlock:^(int cardId, NSString *phoneNum, int activeType) {      // activetype 0是当月 1是下月
            NSLog(@" activeType ==%d ",activeType);
            NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,@"award/payorder"];
            NSDictionary *dic =@{@"type":@"8",@"awardid":[NSString stringWithFormat:@"%d",cardID],@"phone":phoneNum,@"month":[NSNumber numberWithInt:activeType]};
            NSLog(@" 请求兑换流量卡 ==%@",dic);
            // 兑换流量卡
            [LLAsynURLConnection requestURLWith:urlStr dataDic:dic andProtocolNum:@"30006" andTimeOut:httpTimeout connectSuccess:^(NSData *data) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSDictionary *body =[dataDic objectForKey:@"body"];
                    NSString *msg =[body objectForKey:@"msg"];
                    NSLog(@" 获取兑换流量卡信息 == %@  ERROR == %@",dataDic,msg);
                    if ([[dataDic objectForKey:@"flag"] intValue] ==1) {
                        
                        if ([msg isEqualToString:@"ok"]) {
                            long userGold =(long)[[body objectForKey:@"gold"] longLongValue];
                            userCurrency = [[body objectForKey:@"gold"] stringValue];
                            [[MyUserDefault standardUserDefaults] setUserBeanNum:userGold];
                            NSDictionary *dic =@{IncomeNoticKey:costNum};
                            [[NSNotificationCenter defaultCenter] postNotificationName:ReloadIncomeLog object:nil userInfo:dic];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [self loadUserCurrencyLab];
                                [self pushToRewardList];
                                [StatusBar showTipMessageWithStatus:@"恭喜您兑换成功" andImage:nil andTipIsBottom:YES];
                                
                            });
                        }
                        
                    }else{
                        if (msg){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if ([msg hasPrefix:@"该流量卡每月限兑"]) {
                                    [self showChargeLimite:msg];
                                }else{
                                    [StatusBar showTipMessageWithStatus:msg andImage:nil andTipIsBottom:NO];
                                }
                            });
                        }
                        
                    }
                });
                
            } andFail:^(NSError *error) {
                
            }];
        }];
        [view showChargeView];
    }else if (enough ==NO){
        notEnoughAlert =[[UIAlertView alloc] initWithTitle:@"流量币不足" message:@"是否立即做任务赚取更多流量币？" delegate:self cancelButtonTitle:@"算了" otherButtonTitles:@"赚流量币", nil];
        [notEnoughAlert show];
    }
    else{
        [phoneField becomeFirstResponder];
    }
}
-(void)pushToRewardList{
    RewardListViewController *reward =[[RewardListViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nc =(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nc pushViewController:reward animated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    if (buttonIndex ==1 && alertView.tag ==2001) {
        [phoneField becomeFirstResponder];
    }
    if ([alertView isEqual:notEnoughAlert] && buttonIndex ==1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GoBackToFlowCenterNotic object:nil userInfo:nil];
    }
    if(alertView.tag == kTimeOutTag){
        if(buttonIndex == 0){
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [UIAlertView resetNetAlertNil];
            [[LoadingView showLoadingView] actViewStartAnimation];
            [self requestForFlowCards];
        }
    }
}
-(void) showChargeLimite:(NSString *)msg{
    UIAlertView *tipAlert =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更换号码", nil];
    tipAlert.tag =2001;
    [tipAlert show];
}
-(void)refreshWebView{
    [ruleWeb loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:ruleUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10]];
}

int webFailCount;
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    webFailCount ++;
    refreshWebLab.hidden =NO;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    refreshWebLab.hidden =YES;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSURLCache sharedURLCache] setMemoryCapacity: 0];
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    refreshWebLab.hidden =YES;
}
-(void)checkChargeRules {   // 点击查看兑换规则
    float offy =kOriginY ;
    float originY = ruleContentView.frame.origin.y < 0 ? kOriginY : -(kmainScreenHeigh -offy) ;
    originY = kDeviceVersion <7.0 && originY==0 ? 20 :originY ;
    float alpha = allBgView.alpha == 0.0 ? 0.5 :0.0 ;
    [UIView animateWithDuration:0.4f animations:^{
        allBgView.alpha = alpha ;
        if (alpha != 0.0) {
            UINavigationController *rootVC = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController ;
            [rootVC.view insertSubview:allBgView belowSubview:ruleContentView];
        }
        
        ruleContentView.frame = CGRectMake(0, originY , ruleContentView.frame.size.width, ruleContentView.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        if (alpha == 0.0) {
            [allBgView removeFromSuperview];
        }
        NSLog(@" Rule %f  %@",ruleContentView.frame.origin.y ,NSStringFromCGRect(ruleContentView.frame));
    }];
}
-(UIView *) loadRuleContentView {   // 初始化兑换规则
    float originY = kOriginY ;
    allBgView =[[UIView alloc] initWithFrame:CGRectMake(0, originY, kmainScreenWidth, kmainScreenHeigh -originY)];
    allBgView.backgroundColor = ColorRGB(126.0, 126.0, 126.0, 0.5) ;
    allBgView.alpha = 0.0 ;
    
    float bterH = kBatterHeight ;
    UIView *whiteBg =[[UIView alloc] initWithFrame:CGRectMake(0, -(kmainScreenHeigh -kfootViewHeigh -originY-bterH), kmainScreenWidth, kmainScreenHeigh -kfootViewHeigh-originY -bterH)];
    whiteBg.backgroundColor = kWitheColor ;
    
    ruleWeb =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth,whiteBg.frame.size.height -SendViewHeight)];
    
    //    [ruleWeb loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:ruleUrl] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10]];
    ruleWeb.delegate = self;
    ruleWeb.userInteractionEnabled =YES;
    ruleWeb.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    ruleWeb.scalesPageToFit =NO;
    
    refreshWebLab =[[UnderLineLabel alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 15.0)];
    refreshWebLab.font = GetFont(12.0f);
    refreshWebLab.textColor = ColorRGB(155.0, 155.0, 155.0, 1) ;
    refreshWebLab.highlightedColor = ColorRGB(230, 230, 230, 1) ;
    refreshWebLab.shouldUnderline = YES;
    [refreshWebLab setText:@"点击刷新" andCenter:CGPointMake(kmainScreenWidth/2, 30)];
    [refreshWebLab sizeToFit];
    refreshWebLab.frame =CGRectMake( kmainScreenWidth/2 -refreshWebLab.frame.size.width/2, ruleWeb.frame.size.height/2- 7.0f, refreshWebLab.frame.size.width, refreshWebLab.frame.size.height);
    [refreshWebLab addTarget:self action:@selector(refreshWebView)];
    refreshWebLab.hidden =YES;
    [ruleWeb addSubview:refreshWebLab];
    
    
    UIView *btnBGView =[[UIView alloc] initWithFrame:CGRectMake(0, whiteBg.frame.size.height -SendViewHeight, kmainScreenWidth, SendViewHeight)];
    btnBGView.backgroundColor = kWitheColor ;
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = kLineColor2_0.CGColor ;
    layer.frame = CGRectMake(0, LineWidth, btnBGView.frame.size.width, LineWidth);
    [btnBGView.layer addSublayer:layer];
    
    TaoJinButton *msgBtn = [[TaoJinButton alloc]initWithFrame:CGRectMake(kmainScreenWidth/2 -SendButtonWidth/2, SendViewHeight/2- SendButtonHeight/2, SendButtonWidth, SendButtonHeight) titleStr:@"我知道了" titleColor:kWitheColor font:GetFont(16.0) logoImg:nil backgroundImg:[UIImage createImageWithColor:kBlueTextColor]];
    [msgBtn setBackgroundImage:[UIImage createImageWithColor:kLightBlueTextColor] forState:UIControlStateHighlighted];
    msgBtn.layer.masksToBounds = YES;
    msgBtn.layer.cornerRadius = msgBtn.frame.size.height /2 ;
    [msgBtn addTarget:self action:@selector(onClickedDismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [btnBGView addSubview:msgBtn];
    [whiteBg addSubview:ruleWeb];
    [whiteBg addSubview:btnBGView];
    return whiteBg ;
}
/**
 *  请求可用的流量包
 *
 *  @param phoneNum
 */
-(void) requestForVaildCards:(NSString *)phoneNum{
    phoneNum =[phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *string =[NSString stringWithFormat:kOnlineWeb,@"award/liuliang/"];
    NSString *urlStr =[string stringByAppendingString:phoneNum];
    if (![[LoadingView showLoadingView] actViewIsAnimation]) {
        [[LoadingView showLoadingView] actViewStartAnimation];
    }
    [LLAsynURLConnection requestForMethodGetWithURL:urlStr dataDic:nil andProtocolNum:@"30008" andTimeOut:httpTimeout successBlock:^(NSData *data) {
        _isRequesting =NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([[dataDic objectForKey:@"flag"]intValue] ==1) {
                NSDictionary *body =[dataDic objectForKey:@"body"];
                NSArray *cardArray =[body objectForKey:@"liuliang"];
                long userGold =(long)[[body objectForKey:@"mygold"] longLongValue];
                userCurrency = (NSString *)[body objectForKey:@"mygold"];
                [[MyUserDefault standardUserDefaults] setUserBeanNum:userGold];
                NSMutableArray *cards =[[NSMutableArray alloc] init];
                if (cardArray.count >0) {
                    
                    if (phoneIndex >0 && phoneIndex < mobileArr.count +1) {
                        NSLog(@"  移动卡");
                        for (NSDictionary *cardDic in cardArray) {
                            int cardId =[[cardDic objectForKey:@"awardid"] intValue];
                            for (RewardCardView *view in mobileCardViews) {
                                if (view.cardId == cardId) {
                                    [cards addObject:view];
                                }
                            }
                        }
                        
                    }else if (phoneIndex >= mobileArr.count && phoneIndex <unicomArr.count +1 +mobileArr.count){
                        NSLog(@"  联通卡");
                        for (NSDictionary *cardDic in cardArray) {
                            int cardId =[[cardDic objectForKey:@"awardid"] intValue];
                            for (RewardCardView *view in unicomCardViews) {
                                if (view.cardId == cardId) {
                                    [cards addObject:view];
                                }
                            }
                        }
                        
                    }else if(phoneIndex > mobileArr.count + unicomArr.count){
                        NSLog(@"  电信卡");
                        for (NSDictionary *cardDic in cardArray) {
                            int cardId =[[cardDic objectForKey:@"awardid"] intValue];
                            for (RewardCardView *view in telecomCardViews) {
                                if (view.cardId == cardId) {
                                    [cards addObject:view];
                                }
                            }
                        }
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showInvaildCardView];
                        pageControl2.pageCount =1;
                        pageControl2.currentPage =0;
                    });
                    
                }
                NSLog(@" 可兑换视图 ==%@ ",cards);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadUserCurrencyLab];
                    if (cards.count >0) {
                        [self showCardsWithViews:cards];
                        pageControl2.pageCount =cards.count;
                        pageControl2.currentPage =0;
                    }
                    
                });
                
            }
            NSLog(@" 获取可兑换流量卡 == %@",dataDic);
        });
        
        [[LoadingView showLoadingView] actViewStopAnimation];
        
    } andFailBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[LoadingView showLoadingView] actViewStopAnimation];
        });
        _isRequesting =NO;
        vaildFailCount++ ;
        if (vaildFailCount <3) {
            [self requestForVaildCards:phoneNum];
        }
        
    }];
    
}

/**
 *  请求所有流量卡
 */
-(void)requestForFlowCards{
    self.isRequesting = YES ;
    if ([[LoadingView showLoadingView] actViewIsAnimation]) {
        [[LoadingView showLoadingView] actViewStopAnimation];
    }
    [[LoadingView showLoadingView] actViewStartAnimation];
    NSString *urlStr=[NSString stringWithFormat:kOnlineWeb,@"award/liuliang"];
    [LLAsynURLConnection requestForMethodGetWithURL:urlStr dataDic:nil andProtocolNum:@"30008" andTimeOut:httpTimeout successBlock:^(NSData *data) {
        _isRequesting =NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([[dataDic objectForKey:@"flag"]intValue] ==1) {
                NSDictionary *body =[dataDic objectForKey:@"body"];
                ruleUrl = [body objectForKey:@"rule_url"];
                _cardsArr =[body objectForKey:@"liuliang"];
                long userGold =(long)[[body objectForKey:@"mygold"] longLongValue];
                userCurrency = (NSString *)[body objectForKey:@"mygold"];
                [[MyUserDefault standardUserDefaults] setUserBeanNum:userGold];
                
    
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self loadChargeCardView:_cardsArr];
                    pageControl2.pageCount =_cardsArr.count ;
                    pageControl2.currentPage =0;
                    [self loadUserCurrencyLab];
                    
                    if (lastShowedCards.count!=0 && [phoneField.text length]>=3) {
                        [self showCardsWithViews:lastShowedCards];
                    }
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
                [ruleWeb loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:ruleUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10]];
                [[MyUserDefault standardUserDefaults] setRewordRefreshTime:[NSNumber numberWithLongLong:[NSDate getNowTime]]];  //记录下刷新时间
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
            }
            
            NSLog(@" 获取流量卡 == %@",dataDic);
        });
        
        
    } andFailBlock:^(NSError *error) {
        _isRequesting =NO;
        cardFailCount++ ;
        if (cardFailCount <3) {
            [self requestForFlowCards];
        }else{
            cardFailCount =0;
            if(![UIAlertView isInit]){
                UIAlertView *alertView = [UIAlertView showNetAlert];
                alertView.delegate = self;
                alertView.tag = kTimeOutTag;
                [alertView show];
                alertView = nil;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[LoadingView showLoadingView] actViewStopAnimation];
        });
    }];
}

-(void)onClickedDismiss {
    [self checkChargeRules];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[DMPagingScrollView class]]) {
        float contentX = scrollView.contentOffset.x;
        
        int currentNum  = (contentX +kPagePadding *locationNum) /((int )contentView.pageWidth) ;
        pageControl2.currentPage = currentNum ;
        locationNum =currentNum;
        locationPoint =scrollView.contentOffset ;
        //        NSLog(@" locationPoint =%@ ",NSStringFromCGPoint(scrollView.contentOffset));
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:ms]) {
        garyView.frame = CGRectMake(garyView.frame.origin.x, garyView.frame.origin.y, garyView.frame.size.width, -1*scrollView.contentOffset.y +150.0f);
        [self hiddenTheKeyboard];
    }
    //    if ([scrollView isKindOfClass:[DMPagingScrollView class]]) {
    //        NSLog(@" 滑动距离2 ==%f  contentOffx =%f pageW =%f  ",scrollView.contentOffset.x +kPagePadding *locationNum,scrollView.contentOffset.x,contentView.pageWidth);
    //        float contentX = scrollView.contentOffset.x;
    //
    //        int currentNum  = (contentX +kPagePadding *locationNum) /((int )contentView.pageWidth) ;
    //        pageControl2.currentPage = currentNum ;
    //        locationNum =currentNum;
    //        locationPoint =scrollView.contentOffset ;
    //        NSLog(@" locationPoint =%@ ",NSStringFromCGPoint(scrollView.contentOffset));
    //    }
}
/**
 *  查询号码归属地
 *
 *  @param phoneNum 电话号码
 */
- (void)requestForMobileLocation:(NSString *)phoneNum{
    phoneNum =[phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *string =[NSString stringWithFormat:@"mobile/%@",phoneNum];
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,string];
    if (![[LoadingView showLoadingView] actViewIsAnimation]) {
        [[LoadingView showLoadingView] actViewStartAnimation];
    }
    [LLAsynURLConnection requestForMethodGetWithURL:urlStr dataDic:nil andProtocolNum:@"30001" andTimeOut:httpTimeout successBlock:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@" 获取手机号码归属地 == %@",dataDic);
            if ([[dataDic objectForKey:@"flag"] intValue] ==1) {
                NSDictionary *body =[dataDic objectForKey:@"body"];
                NSString *city =[body objectForKey:@"city"];
                NSString *province =[body objectForKey:@"province"];
                NSString *supplier =[body objectForKey:@"supplier"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([city isEqualToString:@""]) {
                        numAdressLab.text =[NSString stringWithFormat:@"%@·%@",province,supplier];
                    }else{
                        numAdressLab.text =[NSString stringWithFormat:@"%@·%@·%@",province,city,supplier];
                    }
                });
                
                NSLog(@" phone location %@ %@ %@",city,province,supplier);
            }
            
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [[LoadingView showLoadingView] actViewStopAnimation];
        });
    } andFailBlock:^(NSError *error) {
        phoneFailCount++ ;
        if (phoneFailCount <3) {
            [self requestForMobileLocation:phoneNum];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[LoadingView showLoadingView] actViewStopAnimation];
        });
    }];
}
-(void) showCardsWithViews:(NSMutableArray *)array{
    [[contentView viewWithTag:kInvaildCardTag] setHidden:YES];
    for (RewardCardView *view in contentView.subviews) {    //清理掉之前的视图
        [view setHidden:YES];
    }
    int i=0;
    float kpadding = kPagePadding;
    UIImage *image = GetImage(@"mobilebg");
    
    for (RewardCardView *view in array) {
        view.hidden =NO;
        view.frame =CGRectMake(cardOffx +(image.size.width +kpadding) *i, view.frame.origin.y, image.size.width, image.size.height);
        i++;
        if (![view superview]) {
            [contentView addSubview:view];
        }
    }
    pageControl2.pageCount =array.count;
    pageControl2.currentPage =0;
    pageControl2.hidden=NO;
    [contentView setContentSize:CGSizeMake(cardOffx +(image.size.width +kpadding) *array.count +kPagePadding, contentView.frame.size.height)];
    [contentView setContentOffset:CGPointMake(0, 0)];
    locationPoint =CGPointMake(0, 0);
    //    NSLog(@" subview %@",contentView.subviews);
    lastShowedCards =[[NSMutableArray alloc] initWithArray:array];
}
-(void)reShowCardViews{     //过滤掉不同的卡
    // 处理卡片的消失和显示
    NSMutableArray *mobiles =[[NSMutableArray alloc] init];
    
    if (phoneIndex >0 && phoneIndex < mobileArr.count +1) {
        NSLog(@"  移动卡");
        for (RewardCardView*view in flowCards) {
            NSLog(@" viewtype %d",view.type);
            if (view.type == OperatorTypeMobile) {
                [mobiles addObject:view];
            }
            
        }
        mobileCardViews =[[NSMutableArray alloc]initWithArray:mobiles];
    }else if (phoneIndex >= mobileArr.count && phoneIndex <unicomArr.count +1 +mobileArr.count){
        NSLog(@"  联通卡");
        
        for (RewardCardView*view in flowCards) {
            if (view.type == OperatorTypeUnicom) {
                [mobiles addObject:view];
            }
        }
        unicomCardViews = [[NSMutableArray alloc] initWithArray:mobiles];
    }else if(phoneIndex > mobileArr.count + unicomArr.count){
        NSLog(@"  电信卡");
        for (RewardCardView*view in flowCards) {
            if (view.type == OperatorTypeTelecom) {
                [mobiles addObject:view];
            }
        }
        telecomCardViews = [[NSMutableArray alloc] initWithArray:mobiles];
    }
    NSLog(@" 视图数 ==%d ",mobiles.count);
    [self showCardsWithViews:mobiles];
    pageControl2.pageCount =mobiles.count;
    pageControl2.currentPage =0;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (![NSString isPureInt:textField.text]) {
        if ([phoneField.text rangeOfString:@"-"].location ==NSNotFound) {
            phoneField.text =nil;
        }
        
    }
    if (kDeviceVersion >= 8.0) {
        checkTimer =[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(checkTextFiled) userInfo:nil repeats:YES];
    }
    
}
-(void)checkTextFiled {
    
    if (![NSString isPureInt:phoneField.text]) {
        if (phoneField.text.length >1) {
        }else{
            
            phoneField.text =@"";
            //                    NSLog(@" 清理 ");
            
        }
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (checkTimer) {
        [checkTimer invalidate];
        checkTimer =nil;
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    if (checkTimer) {
        [checkTimer invalidate];
        checkTimer =nil;
    }
    [[LoadingView showLoadingView] actViewStopAnimation];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    isRightNum =NO;
    phoneIndex= 0;
    if (range.location > 0 || range.location == 0) {
        if (range.location ==0 && [string isEqualToString:@""] ){
            phoneDefLab.hidden =NO;
        }else if (range.location == 0 && ![NSString isPureInt:string]){
            phoneDefLab.hidden =NO;
        }
        else{
            phoneDefLab.hidden = YES;
        }
    }else{
        phoneDefLab.hidden = NO;
    }
    if ([numAdressLab.text hasPrefix:@"请"] && range.location <=2) {
        numAdressLab.text =@"" ;
    }
    if (![numAdressLab.text hasPrefix:@"请"] && numAdressLab.text.length >0) {
        if ([phoneField.text stringByAppendingString:string].length ==13 && [string isEqualToString:@""]) {
            numAdressLab.text=@"";
        }
        
    }
    if (range.location >=2 && phoneField.text.length >=2) {
        BOOL isExist = NO;
        NSString *number =[textField.text stringByAppendingString:string];
        for (NSString *phone in allPhone) {
            phoneIndex++ ;
            if ([number hasPrefix:phone] || [number isEqualToString:phone]) {
                isExist = YES;
                break;
            }
        }
        if (!isExist) {
            numAdressLab.text =@"请输入正确的手机号码";
        }
        if (isExist ==YES) {
            
            [self reShowCardViews];
        }
    }
    if ( (range.location <=2 && [string isEqualToString:@""]) ) {
        [self showCardsWithViews:flowCards];
    }
    NSLog(@" phoneNum  %d  %d %@",phoneIndex,range.location,[phoneField.text stringByAppendingString:string]);
    if (phoneField.text.length ==8 && ![string isEqualToString:@""]) {
        NSMutableString *mString =[[NSMutableString alloc] initWithString:phoneField.text];
        [mString insertString:@"-" atIndex:3];
        [mString insertString:@"-" atIndex:8];
        phoneField.text =[NSString stringWithFormat:@"%@",mString];
        
        NSLog(@" mString == %@  ",mString);
    }
    if (phoneField.text.length ==11 && [string isEqualToString:@""]) {
        phoneField.text =[phoneField.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    [[contentView viewWithTag:kInvaildCardTag] setHidden:YES];
    
    if ([NSString isPureInt:string] || [string isEqualToString:@""]) {
        if (range.location == 12){
            //            [self checkPhoneCarrier:[phoneField.text stringByAppendingString:string]];
            if ([phoneField.text stringByAppendingString:string].length ==13 && string.length >0) {
                isRightNum =YES;
                [self requestForMobileLocation:[phoneField.text stringByAppendingString:string]];
                [self requestForVaildCards:[phoneField.text stringByAppendingString:string]];
            }
            
            
            if (phoneField.text.length ==12) {
                if (![numAdressLab.text hasPrefix:@"请输入"]) {
                    [self performSelector:@selector(hiddenTheKeyboard) withObject:nil afterDelay:0.5];
                }
                
                //                if ([textField.text isEqualToString:@"1380013800"] && [string isEqualToString:@"0"]) {  //测试显示不支持兑换card
                //                    [self showInvaildCardView];
                //                }
            }else{
                //                for (RewardCardView *view in flowCards) {
                //                    view.hidden =NO;
                //                }
                //                float kOffx =10.0f;
                //                pageControl2.hidden =NO;
                //                [contentView setContentSize:CGSizeMake(pageW *_cardsArr.count +kOffx, contentView.frame.size.height)];
            }
            
            return YES;
        }
        else if (range.location >12){
            return NO ;
        }
    }else{
        return NO;
    }
    return YES;
}

-(void)checkPhoneCarrier:(NSString *)phoneNum{
    NSString *findPhonenumber = @"";
    NSString *findPhoneNumberMobile = @"";
    NSString *findPhoneNumberIsACall = @"";
    NSString *findPhoneNumberIsMobile = @"";
    
    NSInteger phonenumberlength = [phoneNum length];
    NSLog(@"%d",[phoneNum length]);
    if (phonenumberlength == 3 ||
        phonenumberlength == 4 ||
        phonenumberlength == 5 ||
        phonenumberlength == 7 ||
        phonenumberlength == 10||
        phonenumberlength == 11||
        phonenumberlength == 12||
        phonenumberlength == 13||
        phonenumberlength == 14||
        phonenumberlength == 16||
        phonenumberlength == 17)
    {
        NSString *tempstring = phoneNum;
        if ((phonenumberlength == 14) && ([tempstring characterAtIndex:0] == '+') &&([tempstring characterAtIndex:1] == '8')&&([tempstring characterAtIndex:2] == '6')&&([tempstring characterAtIndex:3] == '1'))
        {
            NSMutableString *tempstring02 = [NSMutableString stringWithString:tempstring];
            NSRange range;
            range.location = 0;
            range.length = 3;
            [tempstring02 deleteCharactersInRange:range];
            NSString *tempstring03 = [tempstring02 stringByPaddingToLength:7 withString:nil startingAtIndex:0];
            NSString *findPhonenumberFull = [tempstring02 stringByPaddingToLength:11 withString:nil startingAtIndex:0];
            
            findPhoneNumberMobile = [tempstring02 stringByPaddingToLength:3 withString:nil startingAtIndex:0];
            findPhonenumber = tempstring03;
        }else if ((phonenumberlength == 13) && ([tempstring characterAtIndex:0] == '8') &&([tempstring characterAtIndex:1] == '6')&&([tempstring characterAtIndex:2] == '1')) {
            NSMutableString *tempstring02 = [NSMutableString stringWithString:tempstring];
            NSRange range;
            range.location = 0;
            range.length = 2;
            [tempstring02 deleteCharactersInRange:range];
            NSString *tempstring03 = [tempstring02 stringByPaddingToLength:7 withString:nil startingAtIndex:0];
            NSString *findPhonenumberFull = [tempstring02 stringByPaddingToLength:11 withString:nil startingAtIndex:0];
            findPhoneNumberMobile = [tempstring02 stringByPaddingToLength:3 withString:nil startingAtIndex:0];
            
            findPhonenumber = tempstring03;
        }else if (((phonenumberlength == 12) && ([tempstring characterAtIndex:0] == '0'))||((phonenumberlength == 4) && ([tempstring characterAtIndex:0] == '0'))) {
            NSMutableString *tempstring02 = [NSMutableString stringWithString:tempstring];
            
            NSMutableString *tempstring03 = [[NSMutableString alloc] initWithCapacity:1];
            [tempstring03 appendString:[tempstring02 stringByPaddingToLength:4 withString:nil startingAtIndex:0]];
            
            NSRange range;
            range.location = 0;
            range.length = 1;
            [tempstring03 deleteCharactersInRange:range];
            findPhoneNumberIsACall = tempstring03;
        }else if (((phonenumberlength == 11) && ([tempstring characterAtIndex:0] == '1'))||((phonenumberlength == 7) && ([tempstring characterAtIndex:0] == '1'))) {
            
            NSMutableString *tempstring02 = [NSMutableString stringWithString:tempstring];
            findPhonenumber = [tempstring02 stringByPaddingToLength:7 withString:nil startingAtIndex:0];
            findPhoneNumberMobile = [tempstring02 stringByPaddingToLength:3 withString:nil startingAtIndex:0];
        }else if (((phonenumberlength == 16) && ([tempstring characterAtIndex:0] == '1')) && ([tempstring characterAtIndex:1] == ' ') && ([tempstring characterAtIndex:2] == '(') && ([tempstring characterAtIndex:6] == ')') && ([tempstring characterAtIndex:7] == ' ') && ([tempstring characterAtIndex:11] == '-')) {
            NSMutableString *tempstring02 = [NSMutableString stringWithString:tempstring];
            NSRange range;
            range.location = 11;
            range.length = 1;
            [tempstring02 deleteCharactersInRange:range];
            range.location = 6;
            range.length = 2;
            [tempstring02 deleteCharactersInRange:range];
            range.location = 1;
            range.length = 2;
            [tempstring02 deleteCharactersInRange:range];
            NSString *tempstring03 = [tempstring02 stringByPaddingToLength:7 withString:nil startingAtIndex:0];
            NSString *findPhonenumberFull = [tempstring02 stringByPaddingToLength:11 withString:nil startingAtIndex:0];
            findPhoneNumberMobile = [tempstring02 stringByPaddingToLength:3 withString:nil startingAtIndex:0];
            
            findPhonenumber = tempstring03;
        }else if (((phonenumberlength == 17) && ([tempstring characterAtIndex:0] == '+')) && ([tempstring characterAtIndex:1] == '8') && ([tempstring characterAtIndex:2] == '6') && ([tempstring characterAtIndex:3] == ' ') && ([tempstring characterAtIndex:7] == '-') && ([tempstring characterAtIndex:12] == '-')) {
            
            NSLog(@"1717171717171771");
            NSMutableString *tempstring02 = [NSMutableString stringWithString:tempstring];
            NSRange range;
            range.location = 12;
            range.length = 1;
            [tempstring02 deleteCharactersInRange:range];
            range.location = 7;
            range.length = 1;
            [tempstring02 deleteCharactersInRange:range];
            range.location = 0;
            range.length = 4;
            [tempstring02 deleteCharactersInRange:range];
            NSString *tempstring03 = [tempstring02 stringByPaddingToLength:7 withString:nil startingAtIndex:0];
            NSString *findPhonenumberFull = [tempstring02 stringByPaddingToLength:11 withString:nil startingAtIndex:0];
            findPhoneNumberMobile = [tempstring02 stringByPaddingToLength:3 withString:nil startingAtIndex:0];
            
            findPhonenumber = tempstring03;
        }else if (((phonenumberlength == 11) && ([tempstring characterAtIndex:0] == '0')) || ((phonenumberlength == 3) && ([tempstring characterAtIndex:0] == '0'))) {
            NSMutableString *tempstring02 = [NSMutableString stringWithString:tempstring];
            
            NSString *tempstring03 = [tempstring02 stringByPaddingToLength:3 withString:nil startingAtIndex:0];
            
            NSRange range;
            range.location = 0;
            range.length = 1;
            findPhoneNumberIsACall = tempstring03;
        }else if ((phonenumberlength == 5) &&([tempstring characterAtIndex:0] == '1')) {
            
            findPhoneNumberIsMobile = tempstring;
        }else {
            [self PhoneNumberError];
        }
    }else {
        [self PhoneNumberError];
    }
    if ([findPhonenumber length] ==7 && [findPhoneNumberMobile length] ==3)
    {
        [self SelectInfoByPhone:findPhonenumber WithMobile:findPhoneNumberMobile];
    }else if ([findPhoneNumberIsACall length] == 3||[findPhoneNumberIsACall length] == 4)
    {
        [self SelectInfoByCall:findPhoneNumberIsACall];
        
    }else if ([findPhoneNumberIsMobile length] == 5)
    {
        NSInteger findPhoneNumberIsMobileInt = [findPhoneNumberIsMobile intValue];
        [self SelectInfoByPhoneNumberIsMobile:findPhoneNumberIsMobileInt];
    }
    if (![NSString isEmptyString:phoneCity]) {
        [numAdressLab setText:[NSString stringWithFormat:@"%@*%@",phoneCity,phoneSIM]];
    }
    
}
-(void)SelectInfoByPhone:(NSString *)phonenumber WithMobile:(NSString *)phonemobile
{
    NSString *SelectWhatMobile = @"SELECT mobile FROM numbermobile where uid=";
    NSString *SelectWhatMobileFull = [SelectWhatMobile stringByAppendingFormat:phonemobile];
    sqlite3 *database;
    if (sqlite3_open([[self FindDatabase] UTF8String], &database)
        != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, [SelectWhatMobileFull UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int mobilenumber = sqlite3_column_int(stmt, 0);
            if (mobilenumber) {
                NSString *mobileNumberString = [NSString stringWithFormat:@"%d",mobilenumber];
                NSString *SelectWhatMobileName = @"SELECT mobile FROM mobilenumber WHERE uid=";
                NSString *SelectWhatMobileNameFull = [SelectWhatMobileName stringByAppendingFormat:mobileNumberString];
                sqlite3_stmt *stmt2;
                if (sqlite3_prepare_v2(database, [SelectWhatMobileNameFull UTF8String], -1, &stmt2, nil) == SQLITE_OK) {
                    while (sqlite3_step(stmt2) == SQLITE_ROW) {
                        char *mobilename = (char *)sqlite3_column_text(stmt2, 0);
                        NSString *mobilenamestring = [[NSString alloc] initWithUTF8String:mobilename];
                        if (mobilenamestring!= NULL) {
                            phoneSIM = [mobilenamestring substringFromIndex:2];
                            NSLog(@"mobile %@ %@ ",mobilenamestring,phoneSIM);
                        }
                    }
                }sqlite3_finalize(stmt2);
                
            }
        }
        sqlite3_finalize(stmt);
    }
    sqlite3_stmt *stmt3;
    NSString *SelectCityNumberByPhoneNumber = @"SELECT city FROM phonenumberwithcity WHERE uid=";
    NSString *SelectCityNumberByPhoneNumberFull = [SelectCityNumberByPhoneNumber stringByAppendingFormat:phonenumber];
    if (sqlite3_prepare_v2(database, [SelectCityNumberByPhoneNumberFull UTF8String], -1, &stmt3, nil) == SQLITE_OK) {
        if (sqlite3_step(stmt3) == SQLITE_ROW) {
            int citynumber = sqlite3_column_int(stmt3, 0);
            NSString *citynumberNSString = [NSString stringWithFormat:@"%d",citynumber];
            if (citynumberNSString != nil) {
                NSString *SelectCityNameAndCtiyZoneByCityBumber = @"SELECT city,zone FROM citywithnumber WHERE uid=";
                NSString *SelectCityNameAndCtiyZoneByCityBumberFull = [SelectCityNameAndCtiyZoneByCityBumber stringByAppendingFormat:citynumberNSString];
                sqlite3_stmt *stmt4;
                if (sqlite3_prepare_v2(database, [SelectCityNameAndCtiyZoneByCityBumberFull UTF8String], -1, &stmt4, nil) == SQLITE_OK) {
                    if (sqlite3_step(stmt4) == SQLITE_ROW) {
                        char *cityname = (char *)sqlite3_column_text(stmt4, 0);
                        int cityzonecode = sqlite3_column_int(stmt4, 1);
                        NSString *cityNameNSString = [[NSString alloc] initWithUTF8String:cityname];
                        NSString *cityzonecodeNnumber = [@"0" stringByAppendingFormat:@"%d",cityzonecode];
                        if (cityNameNSString != nil && cityzonecodeNnumber != nil) {
                            //                            mylabellocation.text = cityNameNSString;
                            //                            mylabelzonecode.text = cityzonecodeNnumber;
                            phoneCity = cityNameNSString;
                            NSLog(@"city %@  zone %@ ",cityNameNSString,cityzonecodeNnumber);
                        }
                    }else {
                        [self PhoneNumberError];
                    }
                    sqlite3_finalize(stmt4);
                }
            }
        }else {
            [self PhoneNumberError];
        }
        sqlite3_finalize(stmt3);
    }
    
    sqlite3_close(database);
    
    
    
}
-(NSString *)FindDatabase{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"location_Numbercity_citynumber" ofType:@"db"];
    return path;
}

-(void)SelectInfoByCall:(NSString *) callnumber
{
    NSString *SelectCityNameByCityZoneCode = @"SELECT city FROM citywithnumber WHERE zone=";
    NSString *SelectCityNameByCityZoneCodeFull = [SelectCityNameByCityZoneCode stringByAppendingString:callnumber ];
    sqlite3 *database;
    if (sqlite3_open([[self FindDatabase] UTF8String], &database)
        != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, [SelectCityNameByCityZoneCodeFull UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            char *cityname = (char *)sqlite3_column_text(stmt, 0);
            NSString *cityNameNSString = [[NSString alloc] initWithUTF8String:cityname];
            if (cityname != nil) {
                //                mylabellocation.text = cityNameNSString;
                NSLog(@"城市名字 %@",cityNameNSString);
            }
        }else {
            [self PhoneNumberError];
        }
        sqlite3_finalize(stmt);
    }
    sqlite3_close(database);
    
}
-(void)SelectInfoByPhoneNumberIsMobile:(NSInteger)PhoneNumberIsMobile
{
    if(PhoneNumberIsMobile == 10000){
        NSLog( @"中国电信客服");
    }else if(PhoneNumberIsMobile == 10001){
        //        mylabelmobile.text = @"中国电信自助服务热线";
        //    }else if(PhoneNumberIsMobile == 10010){
        //        mylabelmobile.text = @"中国联通客服";
    }else if(PhoneNumberIsMobile == 10011){
        //        mylabelmobile.text = @"中国联通充值";
    }else if(PhoneNumberIsMobile == 10086){
        //        mylabelmobile.text = @"中国移动客服";
    }else{
        NSLog( @"输入号码不正确" );
    }
}


-(void)PhoneNumberError{
    
    NSLog( @"您输入的电话号码无效" );
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
