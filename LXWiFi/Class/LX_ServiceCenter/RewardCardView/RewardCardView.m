//
//  RewardCardView.m
//  免费流量王
//
//  Created by keyrun on 14-10-20.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "RewardCardView.h"
#import "UIImage+ColorChangeTo.h"

#define kRBgOffx       48.0f
#define kRBgOffy       42.0f
#define kRIconOffx      13.0f
#define kRIconOffy      10.0f
#define kRfNumH          90.0f
#define kRPadding        7.0f
#define kRLimitPadding      10.0f
#define kRNeedPadding       12.0f
#define kRChargeBtnW        76.0f
#define kRChargeBtnH        28.0f
#define kRMBHeight          21.0f
@implementation RewardCardView
@synthesize bgView = _bgView ;
@synthesize operatorIcon = _operatorIcon ;
@synthesize flowNum = _flowNum ;
@synthesize needNum = _needNum ;
@synthesize chargeBtn = _chargeBtn ;
@synthesize limitLab = _limitLab ;
@synthesize goldImg = _goldImg ;
@synthesize cardId =_cardId ;
@synthesize card =_card ;
@synthesize isEnough =_isEnough ;
-(instancetype)initWithFrame:(CGRect)frame withOperator:(OperatorType )operatorType flowNum:(NSString *)fNum andNeedNum:(NSString *)nNum limitType:(NSString *)limittype isEnough:(BOOL) isEnough andCardInfo:(NSString *)infor andCardId:(int)cardId flowCard:(FlowCard *)card{
    self =[super initWithFrame:frame];
    if (self) {
        _type = operatorType;
        costNum = nNum ;
        flowInfo = infor ;
        _cardId =cardId ;
        _card =card ;
        _isEnough =isEnough ;
        
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _operatorIcon = [[UIImageView alloc] init];
        UIColor *textDrawColor ;
        UIColor *highLightColor ;
        if (operatorType == OperatorTypeMobile) {
            textDrawColor = kBlueTextColor;      //deep blue
            highLightColor = kLightBlueTextColor ;
            UIImage *image = GetImage(@"mobilebg");
            _bgView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            _bgView.image = image ;
            UIImage *iconImg = GetImage(@"mobileicon");
            _operatorIcon.image = iconImg ;
            _operatorIcon.frame = CGRectMake( kRIconOffx,_bgView.frame.origin.y+ kRIconOffy, iconImg.size.width, iconImg.size.height);
        }else if (operatorType == OperatorTypeUnicom){
            textDrawColor =  kLightRedTextColor;     //deep red
            highLightColor =  ColorRGB(177, 18, 19, 1);
            UIImage *image = GetImage(@"unicombg");
            _bgView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            _bgView.image = image ;
            UIImage *iconImg = GetImage(@"unicomicon");
            _operatorIcon.image = iconImg ;
            _operatorIcon.frame = CGRectMake( kRIconOffx,_bgView.frame.origin.y+ kRIconOffy, iconImg.size.width, iconImg.size.height);
        }else if (operatorType == OperatorTypeTelecom){
            textDrawColor = KGreenColor2_0;      //deep green
            highLightColor = KLightGreenColor2_0 ;
            UIImage *image = GetImage(@"telecombg");
            _bgView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            _bgView.image = image ;
            UIImage *iconImg = GetImage(@"telecomicon");
            _operatorIcon.image = iconImg ;
            _operatorIcon.frame = CGRectMake( kRIconOffx,_bgView.frame.origin.y+ kRIconOffy, iconImg.size.width, iconImg.size.height);
        }
//        _flowNum = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0, _operatorIcon.frame.origin.y +_operatorIcon.frame.size.height +kRPadding, _bgView.frame.size.width, kRfNumH) text:fNum font:GetFont(70.0) textColor:kWitheColor textAlignment:NSTextAlignmentCenter numberLines:1];
        _flowNum = [[DrawLabel alloc] initWithFrame:CGRectMake(0, _operatorIcon.frame.origin.y +_operatorIcon.frame.size.height, _bgView.frame.size.width, kRfNumH)];
        _flowNum.text = fNum ;
        _flowNum.textColor =kWitheColor ;
        _flowNum.backgroundColor =[UIColor clearColor];
        _flowNum.font = GetBoldFont(90.0);
        _flowNum.drawColor = textDrawColor ;
        [_flowNum sizeToFit];
        float flowW = _flowNum.frame.size.width ;
        float flowH = _flowNum.frame.size.height;
        
//        TaoJinLabel *mbLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(_flowNum.frame.origin.x +_flowNum.frame.size.width, _flowNum.frame.origin.y +_flowNum.frame.size.height -kRMBHeight, _bgView.frame.size.width, kRMBHeight) text:@"MB" font:GetFont(kRMBHeight) textColor:kWitheColor textAlignment:NSTextAlignmentLeft numberLines:1];
        DrawLabel *mbLab = [[DrawLabel alloc] initWithFrame:CGRectMake(_flowNum.frame.origin.x +_flowNum.frame.size.width, _flowNum.frame.origin.y +_flowNum.frame.size.height -kRMBHeight, _bgView.frame.size.width, kRMBHeight)];
        mbLab.text = @"MB" ;
        mbLab.textColor =kWitheColor ;
        mbLab.font = GetFont(kRMBHeight);
        mbLab.backgroundColor =[UIColor clearColor];
        mbLab.drawColor = textDrawColor ;
        [mbLab sizeToFit];
        
        _flowNum.frame = CGRectMake((_bgView.frame.size.width/2 -flowW/2 -mbLab.frame.size.width/2), _flowNum.frame.origin.y, flowW, flowH);
        mbLab.frame = CGRectMake(_flowNum.frame.origin.x +_flowNum.frame.size.width, _flowNum.frame.origin.y +_flowNum.frame.size.height -2* kRMBHeight, mbLab.frame.size.width, kRMBHeight);
        
        _limitLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(kOffX_2_0 , _flowNum.frame.origin.y +_flowNum.frame.size.height +kRLimitPadding, _bgView.frame.size.width, 14.0) text:[NSString stringWithFormat:@"%@有效",limittype] font:GetFont(14.0) textColor:kBlackTextColor textAlignment:NSTextAlignmentLeft numberLines:1];
//        if (limittype == LimitTypeOnce) {
//            _limitLab.text =@"当月有效";
//        }else{
//            _limitLab.text = @"下月有效" ;
//        }
        TaoJinLabel *tipLab =[[TaoJinLabel alloc] initWithFrame:CGRectMake(kOffX_2_0 , _limitLab.frame.origin.y +_limitLab.frame.size.height +kRNeedPadding, _bgView.frame.size.width, 14.0) text:@"需:" font:GetFont(14.0) textColor:kBlackTextColor textAlignment:NSTextAlignmentLeft numberLines:1];
        [tipLab sizeToFit];
        tipLab.frame = CGRectMake(kOffX_2_0 , _limitLab.frame.origin.y +_limitLab.frame.size.height +kRNeedPadding, tipLab.frame.size.width, tipLab.frame.size.height);
        
        _needNum = [[TaoJinLabel alloc] initWithFrame:CGRectMake(tipLab.frame.size.width + tipLab.frame.origin.x , tipLab.frame.origin.y +2.0f, _bgView.frame.size.width, 15.0) text:[NSString stringWithFormat:@"%@流量币",nNum] font:GetFont(15.0) textColor:KOrangeColor2_0 textAlignment:NSTextAlignmentLeft numberLines:1];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:_needNum.text];
        [attString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.0] range:NSMakeRange(0, nNum.length)];
        [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(nNum.length, 3)];
        [attString addAttribute:NSForegroundColorAttributeName value:KOrangeColor2_0 range:NSMakeRange(0, nNum.length +3)];
        _needNum.attributedText = attString ;
        
        _chargeBtn = [[TaoJinButton alloc] initWithFrame:CGRectMake(_bgView.frame.origin.x + _bgView.frame.size.width -kOffX_2_0- kRChargeBtnW, _needNum.frame.origin.y -((kRChargeBtnH)/2 -_needNum.frame.size.height/2), kRChargeBtnW, kRChargeBtnH) titleStr:nil titleColor:kWitheColor font:GetFont(14.0) logoImg:nil backgroundImg:nil];
        _chargeBtn.layer.masksToBounds = YES;
        _chargeBtn.layer.cornerRadius = 5.0f;
        if (isEnough == YES && card.flowState ==0) {
            [_chargeBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
            [_chargeBtn setBackgroundImage:[UIImage createImageWithColor:textDrawColor] forState:UIControlStateNormal];
            [_chargeBtn setBackgroundImage:[UIImage createImageWithColor:highLightColor] forState:UIControlStateHighlighted];
            [_chargeBtn addTarget:self action:@selector(onClickedChargeFlow) forControlEvents:UIControlEventTouchUpInside];
        }else if(isEnough ==NO && card.flowState == 0){
//            _chargeBtn.userInteractionEnabled = NO;
//            [_chargeBtn setTitle:@"流量币不足" forState:UIControlStateNormal];
//            [_chargeBtn setBackgroundImage:[UIImage createImageWithColor:ColorRGB(200.0, 200.0, 200.0, 1.0)] forState:UIControlStateNormal];
            [_chargeBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
            [_chargeBtn setBackgroundImage:[UIImage createImageWithColor:textDrawColor] forState:UIControlStateNormal];
            [_chargeBtn setBackgroundImage:[UIImage createImageWithColor:highLightColor] forState:UIControlStateHighlighted];
            [_chargeBtn addTarget:self action:@selector(onClickedChargeFlow) forControlEvents:UIControlEventTouchUpInside];
        }else if (card.flowState ==1){
            _chargeBtn.userInteractionEnabled = NO;
            [_chargeBtn setTitle:@"库存不足" forState:UIControlStateNormal];
            [_chargeBtn setBackgroundImage:[UIImage createImageWithColor:ColorRGB(200.0, 200.0, 200.0, 1.0)] forState:UIControlStateNormal];
        }
        UIImage *gold = GetImageWithName(@"gold");
        _goldImg = [[UIImageView alloc] initWithImage:gold];
        _goldImg.frame = CGRectMake(_bgView.frame.origin.x +_bgView.frame.size.width -52.0f, _bgView.frame.origin.y -13.0f, gold.size.width, gold.size.height);
        
        
        [self addSubview:_bgView];
        [self addSubview:_operatorIcon];
        [self addSubview:_flowNum];
        [self addSubview:mbLab];
        [self addSubview:tipLab];
        [self addSubview:_limitLab];
        [self addSubview:_needNum];
        [self addSubview:_chargeBtn];
        [self addSubview:_goldImg];
        
    }
    return self ;
}

-(void)onClickedChargeFlow {
    [self.rcDelegate onClickedRewardChargeCard:flowInfo andCostNum:costNum andCardID:_cardId isEnough:_isEnough];
}

-(id) initInvalidRewardView:(CGRect)frame withBlock:(RewardCardInvaildBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
        _copyBlock = [block copy];
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _bgView.image = GetImageWithName(@"cardviolet");

        UIImage *operator =GetImageWithName(@"jie");
        _operatorIcon = [[UIImageView alloc] initWithImage:operator];
        float iconOffx = _bgView.image.size.width - operator.size.width ;
        _operatorIcon.frame = CGRectMake(iconOffx, 0, operator.size.width, operator.size.height);
        
        float invaildOffx = 50.0f ;
        float invaildOffy = 85.0f ;
        TaoJinLabel *invaildTip = [[TaoJinLabel alloc] initWithFrame:CGRectMake(invaildOffx, invaildOffy, frame.size.width -invaildOffx -kOffX_2_0, 0) text:@"您的号码所在地暂不支持兑换流量包，请到奖品中心兑换其他奖品" font:GetFont(11.0) textColor:kWitheColor textAlignment:NSTextAlignmentLeft numberLines:0];
        [invaildTip sizeToFit];
        invaildTip.frame = CGRectMake(invaildOffx, invaildTip.frame.origin.y, invaildTip.frame.size.width, invaildTip.frame.size.height);
        
        float chargeBtnOffx = 30.0f ;
        float chargePadding  = 15.0f;
        float chargeBtnH  = 40.0f;
        _chargeBtn = [[TaoJinButton alloc] initWithFrame:CGRectMake(chargeBtnOffx, frame.size.height -chargeBtnH -chargePadding, frame.size.width - 2*chargeBtnOffx, chargeBtnH) titleStr:@"兑换奖品" titleColor:kWitheColor font:GetFont(14.0) logoImg:nil backgroundImg:[UIImage createImageWithColor:KOrangeColor2_0]];
        [_chargeBtn setBackgroundImage:[UIImage createImageWithColor:KLightOrangeColor2_0] forState:UIControlStateHighlighted];
        [_chargeBtn addTarget:self action:@selector(pushToRewardGoods) forControlEvents:UIControlEventTouchUpInside];
        _chargeBtn.layer.masksToBounds = YES ;
        _chargeBtn.layer.cornerRadius = _chargeBtn.frame.size.height/2 ;
        [self addSubview:_bgView];
        [self addSubview:_operatorIcon];
        [self addSubview:invaildTip];
        [self addSubview:_chargeBtn];
    }
    return self;
}
-(void) pushToRewardGoods {
    _copyBlock();
}

@end
