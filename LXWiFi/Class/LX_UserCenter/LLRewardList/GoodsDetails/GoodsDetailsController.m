//
//  GoodsDetailsController.m
//  TJiphone
//
//  Created by keyrun on 13-10-15.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "GoodsDetailsController.h"
#import "PostGoodsController.h"
#import "RewardViewController.h"
#import "MScrollVIew.h"
#import "SDImageView+SDWebCache.h"
#import "StatusBar.h"
#import "DidRewardView.h"
#import "LoadingView.h"
#import "RewardListViewController.h"
#import "MyUserDefault.h"
#import "AsynURLConnection.h"
#import "HeadToolBar.h"
#import "CButton.h"
#import "LLAsynURLConnection.h"
#import "UIAlertView+NetPrompt.h"
//【兑奖中心】显示单个物品详细信息
@interface GoodsDetailsController ()
{
    //    HeadView* headView;
    HeadToolBar *headBar;
    MScrollVIew* ms;
    
    GoodsModel *_goodsModel;                                        //礼品对象
    int timeOutCount;
    UIImageView *goodsImage;
    UILabel *goodNameLab;
    CButton *chargeBtn;
    UILabel *jinDouLab ;
    UILabel *goodCountLab;
    RTLabel *infoLab ;
    int failCount ;
    
    int _goodsID;
}
@end

@implementation GoodsDetailsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _goodsModel =self.goodsModel;
        timeOutCount = 0;
    }
    return self;
}

-(id)initViewWithGoodsModel:(GoodsModel *)goodsModel{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    headBar =[[HeadToolBar alloc] initWithTitle:@"礼品详情" leftBtnTitle:@"返回" leftBtnImg:GetImage(@"back") leftBtnHighlightedImg:nil rightLabTitle:nil backgroundColor:kBlueTextColor];
    headBar.leftBtn.tag =1;
    [headBar.leftBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    if (kDeviceVersion >= 7.0) {
        ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y + headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height + 20) andWithPageCount:1 backgroundImg:nil];
    }else{
        ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y + headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height) andWithPageCount:1 backgroundImg:nil];
    }
    
    
    [ms setContentSize:CGSizeMake(kmainScreenWidth, ms.frame.size.height+1)];
    ms.bounces =YES;
    ms.pagingEnabled = NO;
    [self.view addSubview:ms];
    if (!self.isPush) {
        [self initViewContent:self.goodsModel];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pop2View) name:@"popview" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    
    //    [self requestToGoodsDetailedInfo];         新版商品详情不需要单独请求
}

-(void)viewWillDisappear:(BOOL)animated{
    //    [ms removeFromSuperview];
    //    ms = nil;
    //    [headBar removeFromSuperview];
    //    headBar = nil;
    //    _goodsModel = nil;
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"popview" object:nil];
}

//【返回】按钮事件
-(void)onClickBackBtn:(UIButton *)btn{
    [[LoadingView showLoadingView] actViewStopAnimation];
    if (self.isPush) {
        [self.navigationController popToViewController:self.lastVC animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//【兑换】按钮事件
-(void)onClickExchangeBtn:(UIButton* )btn{
    long userBeanNum = [[[MyUserDefault standardUserDefaults] getUserBeanNum] longValue];
    if (userBeanNum < _goodsModel.needBean) {
        [self showNotEnough];
    }else{
        [[LoadingView showLoadingView] actViewStartAnimation];
        btn.userInteractionEnabled = NO;
        
        //    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
        //    int type = _goodsModel.type + 2;         // 5:虚拟道具   7:炫酷产品   6:充值卡
        NSLog(@" 商品类型 ==%@ ",_goodsModel.typeStr);
        int type ;
        if ([_goodsModel.typeStr isEqualToString:@"游戏道具"]) {
            type =5 ;
        }else if ([_goodsModel.typeStr isEqualToString:@"充值卡"]){
            type =6 ;
        }else if ([_goodsModel.typeStr isEqualToString:@"实物奖品"]){
            type =7;
        }
        NSDictionary *dic = @{@"type": [NSNumber numberWithInt:type], @"num":[NSNumber numberWithInt:1], @"awardid":[NSNumber numberWithInt:_goodsModel.awardId]};
        //    [self requestToGetLimitCount:dic duiHuanBtn:btn];
        [self requestForGoodsLimitWith:dic andButton:btn];
    }
}
-(void) requestForGoodsLimitWith:(NSDictionary *)dic andButton:(UIButton *)btn{
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,@"award/check"];
    [LLAsynURLConnection requestURLWith:urlStr dataDic:dic andProtocolNum:@"30005" andTimeOut:httpTimeout connectSuccess:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求查询限兑的数量【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            NSDictionary *body = [dataDic objectForKey:@"body"];
            NSLog(@"  查询商品限兑 == %@ ",[body objectForKey:@"msg"]);
            if(flag == 1){
                long userBeanNum = [[[MyUserDefault standardUserDefaults] getUserBeanNum] longValue];
                
                NSString *info = [body objectForKey:@"msg"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    btn.userInteractionEnabled = YES;
                    
                    if(info != nil && [@"ok" isEqualToString:info]){
                        //可兑换
                        if(userBeanNum < _goodsModel.needBean){
                            //用户淘金豆不足
                            [self showNotEnough];
                        }else if(_goodsModel.stock == 0){
                            //礼品库存为0
                            [StatusBar showTipMessageWithStatus:@"报告金主,库存不足" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
                        }else{
                            if([_goodsModel.typeStr isEqualToString:@"实物奖品"]){
                                //炫酷奖品
                                PostGoodsController* pc = [[PostGoodsController alloc] initWithNibName:nil bundle:nil];
                                pc.good = self.goodsModel;
                                pc.goodsName =self.goodsModel.introduce;
                                
                                [self.navigationController pushViewController:pc animated:YES];
                            }else{
                                DidRewardView* view = [[DidRewardView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
                                view.needBean = _goodsModel.needBean;
                                view.type = _goodsModel.type;
                                view.goodsName = _goodsModel.introduce;
                                view.isAdress = NO;
                                view.goods = _goodsModel;
                                if ([_goodsModel.typeStr isEqualToString:@"游戏道具"]) {
                                    view.rewardType = 5;
                                    view.type =5;
                                }else if ([_goodsModel.typeStr isEqualToString:@"充值卡"]){
                                    view.rewardType =6;
                                    view.type =5;
                                }
                                //                                view.rewardType = _goodsModel.type + 2;
                                [view setBasicView];
                                [self.view addSubview:view];
                            }
                        }
                    }else if(info != nil && [@"no" isEqualToString:info]){
                        //不可兑换
                        int limit = _goodsModel.limit;
                        
                        if (userBeanNum < _goodsModel.needBean) {
                            [self showNotEnough];
                        }else if (_goodsModel.stock ==0){
                            [StatusBar showTipMessageWithStatus:@"报告金主,库存不足" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
                        }else{
                            [StatusBar showTipMessageWithStatus:[NSString stringWithFormat:@"报告金主，每人限兑%d个",limit] andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
                        }
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    btn.userInteractionEnabled = YES;
                    if ([[body objectForKey:@"msg"] isEqualToString:@"超过本人限兑次数"]) {
                        [StatusBar showTipMessageWithStatus:@"超过限兑次数" andImage:nil andTipIsBottom:NO];
                    }else{
                        [StatusBar showTipMessageWithStatus:[body objectForKey:@"msg"] andImage:nil andTipIsBottom:NO];
                    }
                });
            }
        });
    } andFail:^(NSError *error) {
        NSLog(@"请求查询限兑的数量【erroe】 = %@",error);
        failCount ++ ;
        if (failCount <3) {
            [self requestForGoodsLimitWith:dic andButton:btn];
        }
        if(error.code == timeOutErrorCode){
            //连接超时
            [[LoadingView showLoadingView] actViewStopAnimation];
        }
        
    }];
}
//请求查询限兑的数量（new）
-(void)requestToGetLimitCount:(NSDictionary *)dic duiHuanBtn:(UIButton *)duiHuanBtn{
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"AwardUI",@"GetLimit"];
    NSLog(@"请求查询限兑的数量【urlStr】 = %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求查询限兑的数量【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                long userBeanNum = [[[MyUserDefault standardUserDefaults] getUserBeanNum] longValue];
                NSDictionary *body = [dataDic objectForKey:@"body"];
                NSString *info = [body objectForKey:@"Info"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    duiHuanBtn.userInteractionEnabled = YES;
                    if(info != nil && [@"ok" isEqualToString:info]){
                        //可兑换
                        if(userBeanNum < _goodsModel.needBean){
                            //用户淘金豆不足
                            [self showNotEnough];
                        }else if(_goodsModel.stock == 0){
                            //礼品库存为0
                            [StatusBar showTipMessageWithStatus:@"报告金主,库存不足" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
                        }else{
                            if(_goodsModel.type == 2){
                                //炫酷奖品
                                PostGoodsController* pc = [[PostGoodsController alloc] initWithNibName:nil bundle:nil];
                                pc.good = self.goodsModel;
                                pc.goodsName =self.goodsModel.introduce;
                                
                                [self.navigationController pushViewController:pc animated:YES];
                            }else{
                                DidRewardView* view = [[DidRewardView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
                                view.needBean = _goodsModel.needBean;
                                view.type = _goodsModel.type;
                                view.goodsName = _goodsModel.introduce;
                                view.isAdress = NO;
                                view.goods = _goodsModel;
                                view.rewardType = _goodsModel.type + 2;
                                [view setBasicView];
                                [self.view addSubview:view];
                            }
                        }
                    }else if(info != nil && [@"no" isEqualToString:info]){
                        //不可兑换
                        int limit = _goodsModel.limit;
                        
                        if (userBeanNum < _goodsModel.needBean) {
                            [self showNotEnough];
                        }else if (_goodsModel.stock ==0){
                            [StatusBar showTipMessageWithStatus:@"报告金主,库存不足" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
                        }else{
                            [StatusBar showTipMessageWithStatus:[NSString stringWithFormat:@"报告金主，每人限兑%d个",limit] andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
                        }
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    duiHuanBtn.userInteractionEnabled = YES;
                });
            }
        });
    } fail:^(NSError *error) {
        NSLog(@"请求查询限兑的数量【erroe】 = %@",error);
        if(error.code == timeOutErrorCode){
            //连接超时
            [[LoadingView showLoadingView] actViewStopAnimation];
        }
    }];
}

-(void)pop2View{
    RewardListViewController* re = [[RewardListViewController alloc]initWithNibName:nil bundle:nil];
    NSLog(@"  GOODs VC");
    re.isRootPush =YES;
    [self.navigationController pushViewController:re animated:YES];
}

//请求获取礼品的详细信息
-(void)requestToGoodsDetailedInfo:(int)goodId{
    [[LoadingView showLoadingView] actViewStartAnimation];
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid, @"AwardId":[NSNumber numberWithInt:goodId]};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"AwardUI",@"GetAwardFullInfoById"];
    NSLog(@"请求获取礼品的详细信息【urlStr】 = %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            timeOutCount = 0;
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求获取礼品的详细信息【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    NSDictionary *body = [dataDic objectForKey:@"body"];
                    GoodsModel *goodsModel = [[GoodsModel alloc]initGoodsModelByDictionary:body];
                    self.goodsModel=goodsModel;
                    [self initViewContent:goodsModel];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
            }
        });
    } fail:^(NSError *error) {
        NSLog(@"请求获取礼品的详细信息【error】 = %@",error);
        if(error.code == timeOutErrorCode){
            //连接超时
            if(timeOutCount < 2){
                [self requestToGoodsDetailedInfo:goodId];
            }else{
                timeOutCount = 2;
                
                [[LoadingView showLoadingView] actViewStopAnimation];
            }
        }
    }];
}
-(void)requestForGoodsDetailsWithId:(int) goodsId{
    _goodsID =goodsId ;
    NSString *string =[NSString stringWithFormat:@"award/info/%d",goodsId];
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,string];
    NSLog(@"  请求商品详情 ==%@ ",urlStr);
    [LLAsynURLConnection requestForMethodGetWithURL:urlStr dataDic:nil andProtocolNum:@"30003" andTimeOut:httpTimeout successBlock:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            timeOutCount = 0;
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求获取礼品的详细信息【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    NSDictionary *body = [dataDic objectForKey:@"body"];
                    GoodsModel *goodsModel = [[GoodsModel alloc]initGoodsModelByDictionary:body];
                    self.goodsModel=goodsModel;
                    [self initViewContent:goodsModel];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
            }
        });
        
    } andFailBlock:^(NSError *error) {
        NSLog(@"请求获取礼品的详细信息【error】 = %@",error);
        if(error.code == timeOutErrorCode){
            //连接超时
            timeOutCount ++;
            if(timeOutCount < 3){
                [self requestForGoodsDetailsWithId:goodsId];
            }else{
                timeOutCount = 0;
                if(![UIAlertView isInit]){
                    UIAlertView *alertView = [UIAlertView showNetAlert];
                    alertView.delegate = self;
                    alertView.tag = kTimeOutTag;
                    [alertView show];
                    alertView = nil;
                }
                [[LoadingView showLoadingView] actViewStopAnimation];
            }
        }
        
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == kTimeOutTag){
        if(buttonIndex == 0){
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [UIAlertView resetNetAlertNil];
            [[LoadingView showLoadingView] actViewStartAnimation];
            [self requestForGoodsDetailsWithId:_goodsID];
        }
    }else{
        if (buttonIndex != 0) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter]postNotificationName:GoBackToFlowCenterNotic object:nil userInfo:nil];
        }
    }
}

//初始化界面的显示文字的Label
-(UILabel *)loadWithGoodsInfo:(CGRect)frame text:(NSString *)text fontSize:(int)fontSize textColor:(UIColor *)textColor{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.userInteractionEnabled = NO;
    [label sizeToFit];
    return label;
}
-(RTLabel *)loadRTLabelWith:(NSString *)text andFrameY:(float) offy{
    RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(0, offy, kmainScreenWidth -2*kOffX_float, 0)];
    label.backgroundColor =[UIColor clearColor];
    label.delegate = self;
    [label setText:text];
    CGSize size = [label optimumSize];
    label.frame = CGRectMake(kOffX_float, offy, size.width, size.height);
    return label ;
}
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url{
    
    [[UIApplication sharedApplication] openURL:url];
}
//加载礼品详细信息的界面
-(void)initViewContent:(GoodsModel *)goodsModel{
    //加载礼品图片
    if (!goodsImage) {
        goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(kOffX_2_0, kOffX_2_0, kmainScreenWidth -2 *kOffX_2_0, 183)];
        [ms addSubview:goodsImage];
    }
    //    [goodsImage setImageWithURL:[NSURL URLWithString:goodsModel.bigImgUrl] refreshCache:NO placeholderImage:GetImage(@"pic_big2")];
    [goodsImage setImageWithURL:[NSURL URLWithString:goodsModel.bigImgUrl] refreshCache:NO needSetViewContentMode:true needBgColor:true placeholderImage:GetImage(@"pic_big2")];
    
    
    //礼品名称
    NSString *text =goodsModel.introduce;
//    if (self.isPush) {
//        text =goodsModel.awardName;
//    }
    if (!goodNameLab) {
        
        goodNameLab= [self loadWithGoodsInfo:CGRectMake(kOffX_2_0, goodsImage.frame.origin.y + goodsImage.frame.size.height + kOffX_2_0, 0, 16) text:text fontSize:16 textColor:kBlackTextColor];
        [ms addSubview:goodNameLab];
    }
    goodNameLab.text =text;
    //库存数量
    NSString *countStr ;
    if (goodsModel.stock != -1) {
        countStr = [NSString stringWithFormat:@"库存:%d       ",goodsModel.stock];
    }else{
        countStr = [NSString stringWithFormat:@"库存充足        "];
    }
    int  limitText =goodsModel.perman;
    if (self.isPush) {
        limitText  =goodsModel.perman;
    }
    if (limitText == -1) {
        countStr = [countStr stringByAppendingString:@"限兑:无限制"];
    }else{
        countStr = [countStr stringByAppendingString:[NSString stringWithFormat:@"每人限兑%d个",limitText]];
    }
    
    if (!goodCountLab) {
        goodCountLab= [self loadWithGoodsInfo:CGRectMake(kOffX_2_0, goodNameLab.frame.origin.y + goodNameLab.frame.size.height + 6.0f, 0, 11) text:countStr fontSize:11 textColor:KGrayColor2_0];
        [ms addSubview:goodCountLab];
    }
    goodCountLab.text =countStr;
    
    
    //淘金豆所需数量
    if (!jinDouLab) {
        jinDouLab= [self loadWithGoodsInfo:CGRectMake(0, goodNameLab.frame.origin.y +2.0f , 0, 15) text:[NSString stringWithFormat:@"价格:%d流量币",goodsModel.needBean] fontSize:14 textColor:kBlueTextColor];
        
        jinDouLab.frame = CGRectMake(kmainScreenWidth - jinDouLab.frame.size.width - kOffX_2_0, jinDouLab.frame.origin.y , jinDouLab.frame.size.width, 15);
        NSMutableAttributedString *attStr =[[NSMutableAttributedString alloc] initWithString:jinDouLab.text];
        [attStr addAttribute:NSForegroundColorAttributeName value:kBlackTextColor range:NSMakeRange(0, 3)];
        [attStr addAttribute:NSForegroundColorAttributeName value:KOrangeColor2_0 range:NSMakeRange(3, jinDouLab.text.length -3)];
        [attStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:14] range:NSMakeRange(3, jinDouLab.text.length-3)];
        jinDouLab.attributedText =attStr;
        [ms addSubview:jinDouLab];
    }
    
    //兑换按钮
    
    if (!chargeBtn) {
        
        chargeBtn=[self loadBtnWithFrame:CGRectMake(kmainScreenWidth/2 -SendButtonWidth/2, goodCountLab.frame.origin.y +goodCountLab.frame.size.height +10.0f, SendButtonWidth, SendButtonHeight) withTitle:@"立即兑换" andFont:[UIFont systemFontOfSize:16.0]];
        chargeBtn.tag =6;
        chargeBtn.layer.masksToBounds = YES;
        chargeBtn.layer.cornerRadius = chargeBtn.frame.size.height/2 ;
        [chargeBtn addTarget:self action:@selector(onClickExchangeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [ms addSubview:chargeBtn];
    }
    //礼品详细信息
    NSString *infoText = goodsModel.detail;
    
    if (!infoLab) {
        infoLab= [[RTLabel alloc] initWithFrame:CGRectMake(kOffX_2_0, chargeBtn.frame.origin.y + chargeBtn.frame.size.height +kOffX_2_0, kmainScreenWidth -2*kOffX_2_0, 0)];
        infoLab.hidden =NO;
        infoLab.delegate =self;
        infoLab.font = GetFont(11.0f);
        infoLab.textColor= KGrayColor2_0;
        infoLab.backgroundColor =[UIColor clearColor];
        [ms addSubview:infoLab];
    }
    [infoLab setText:infoText];
    CGSize size = [infoLab optimumSize];
    infoLab.frame = CGRectMake(kOffX_2_0, chargeBtn.frame.origin.y + chargeBtn.frame.size.height +kOffX_2_0, kmainScreenWidth -2*kOffX_2_0, size.height);
    NSLog(@" InforLab == %@",infoLab);
    if (infoLab.frame.size.height + infoLab.frame.origin.y  > ms.frame.size.height) {
        [ms setContentSize:CGSizeMake(kmainScreenWidth, infoLab.frame.size.height + infoLab.frame.origin.y + headBar.frame.origin.y + headBar.frame.size.height + 1)];
    }
    
    
}
-(CButton *)loadBtnWithFrame:(CGRect)frame withTitle:(NSString *)title andFont:(UIFont*) font{
    CButton * btn =[CButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor =btn.nomalColor =kBlueTextColor;
    btn.changeColor =kLightBlueTextColor;
    btn.frame =frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font =font;
    return btn;
}
-(void)showNotEnough{
    UIAlertView* alertView =[[UIAlertView alloc]initWithTitle:@"流量币不足" message:@"您的流量币余额不足，可通过下应用做任务、邀请好友、参与活动等方式赚取流量币" delegate:self cancelButtonTitle:@"算了" otherButtonTitles:@"赚流量币", nil];
    alertView.tag =3100;
    [alertView show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
