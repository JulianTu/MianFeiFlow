//
//  RewardListCell.m
//  TJiphone
//
//  Created by keyrun on 13-10-16.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "RewardListCell.h"
#import "StatusBar.h"
#import "NSString+emptyStr.h"
#import "UIImage+ColorChangeTo.h"
#define kCellOffx  10.0
#define kCellOffy  12.0
#define kCellButtonSizeW          55.0f
#define kCellButtonSizeH          24.0f
#define kCellVersandW             120.0f
@implementation RewardListCell{
    float secLBHeight;
    float height;
}
@synthesize goods = _goods;
@synthesize bgImage = _bgImage;
@synthesize firstLB = _firstLB;
@synthesize secLB = _secLB;
@synthesize thrLB = _thrLB;
@synthesize fouLB = _fouLB;
@synthesize state = _state;
@synthesize logo = _logo;
@synthesize lineView =_lineView ;
@synthesize haveVersandLab = _haveVersandLab;
@synthesize toCopyBtn = _toCopyBtn;
@synthesize toCopyBtn2 = _toCopyBtn2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backgroundColor = ColorRGB(248.0, 248.0, 248.0, 1.0);
        
        secLBHeight = 0.0f;
        height = 0.0f;
        _lineView =[[UIView alloc]initWithFrame:CGRectZero];
        _lineView.backgroundColor =kGrayLineColor2_0;
        [self.contentView addSubview:_lineView];
        
//        self.bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 310, 110)];
//        [self addSubview:self.bgImage];
        float versandW =kCellVersandW ;
        self.firstLB = [self loadWithLabel:CGRectMake(kCellOffx ,kCellOffy , kmainScreenWidth -versandW -kOffX_2_0 -kCellOffx, 16.0f)];
//        self.firstLB.backgroundColor = [UIColor purpleColor];
        self.firstLB.font = GetFont(16.0);
        self.firstLB.textColor = kBlackTextColor ;
        [self.contentView addSubview:self.firstLB];
        
        self.secLB = [self loadWithLabel:CGRectMake(kCellOffx, self.firstLB.frame.origin.y + self.firstLB.frame.size.height , kmainScreenWidth -2*kCellOffx, 11)];
        self.secLB .hidden = YES;
        [self.contentView addSubview:self.secLB];
        
        self.thrLB = [self loadWithLabel:CGRectMake(kCellOffx, self.secLB.frame.origin.y + self.secLB.frame.size.height, kmainScreenWidth -2*kCellOffx, 11)];
        [self.contentView addSubview:self.thrLB];
        
        self.fouLB = [self loadWithLabel:CGRectMake(kCellOffx, self.thrLB.frame.origin.y + self.thrLB.frame.size.height , kmainScreenWidth -2*kCellOffx, 11)];
        [self.contentView addSubview:self.fouLB];
        
        float cellBtnW = kCellButtonSizeW ;
        self.state = [self loadWithStateLabel:CGRectMake(kCellOffx, 85.0, kmainScreenWidth -kCellOffx -cellBtnW -kOffX_2_0, 14)];
        [self.contentView addSubview:self.state];
        
        self.state2 =[self loadWithStateLabel:CGRectMake(kCellOffx, self.state.frame.origin.y +self.state.frame.size.height +14, kmainScreenWidth -kCellOffx -cellBtnW -kOffX_2_0, 14)];
        [self.contentView addSubview:self.state2];

        self.haveVersandLab = [self loadWithHaveVersandLab:CGRectMake(kmainScreenWidth -kOffX_2_0 -versandW, kCellOffy, kCellVersandW, 16)];
        self.haveVersandLab.textAlignment =NSTextAlignmentRight ;
        self.haveVersandLab.font = GetFont(16.0);
        self.haveVersandLab.hidden = YES;
        [self.contentView addSubview:self.haveVersandLab];
        
        float btnW =kCellButtonSizeW ;
        self.toCopyBtn = [self loadWithCopyButton:CGRectMake(kmainScreenWidth -kOffX_2_0 -btnW, self.state.frame.origin.y - 6, kCellButtonSizeW, kCellButtonSizeH)];
        self.toCopyBtn.tag = 1;
        self.toCopyBtn.hidden = YES;
        [self.contentView addSubview:self.toCopyBtn];
        
        self.toCopyBtn2 = [self loadWithCopyButton:CGRectMake(kmainScreenWidth -kOffX_2_0 -btnW, self.state2.frame.origin.y - 6, kCellButtonSizeW, kCellButtonSizeH)];
        self.toCopyBtn2.tag = 2;
        self.toCopyBtn2.hidden = YES;
        [self.contentView addSubview:self.toCopyBtn2];
    
        
    }
    return self;
}

-(void)loadSeparatorLine{
    
}

//初始化各项Label
-(UILabel *)loadWithLabel:(CGRect )frame{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = KGrayColor2_0;
    label.font = [UIFont systemFontOfSize:11.0];
    return label;
}

//初始化状态
-(UILabel *)loadWithStateLabel:(CGRect )frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = KOrangeColor2_0;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

//初始化已发货
-(UILabel *)loadWithHaveVersandLab:(CGRect )frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:11.0];
    label.textColor = kBlueTextColor;
    label.backgroundColor = [UIColor clearColor];
//    label.transform = CGAffineTransformMakeRotation(0.75);
    return label;
}

//初始化【复制】按钮
-(UIButton *)loadWithCopyButton:(CGRect )frame{
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"复制" forState:UIControlStateNormal];
    button.titleLabel.font =[UIFont systemFontOfSize:14.0];
    button.frame = frame;
    [button setBackgroundImage:[UIImage createImageWithColor:KOrangeColor2_0] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage createImageWithColor:kSelectYellow] forState:UIControlStateHighlighted];
    button.layer.masksToBounds = YES ;
    button.layer.cornerRadius = 5.0f;
    //    button.frame =CGRectMake(250, state.frame.origin.y-3, 60, 20);
    [button addTarget:self action:@selector(copyGoodsOrder:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/**
*  1Q币 2话费 3支付宝 4财付通 5游戏道具(礼包) 6充值卡 7实物奖品 8流量包
*/
-(void)initCellContentWith:(RewardGoods *)goods{
    _goods =goods; 
    _lineView.frame = CGRectMake(5.0f, [self getCellHeight] -0.5f, kmainScreenWidth-5.0f, 0.5f);
//    NSLog(@" RewardGood %@",self.goods.goodTypeStr);
    
    _firstLB.text = [NSString stringWithFormat:@"%@",self.goods.goodsName];
    [_firstLB sizeToFit];
    float versandW = kCellVersandW ;
    _firstLB.frame = CGRectMake(kCellOffx, kCellOffy,kmainScreenWidth -versandW -kOffX_2_0 -kCellOffx, _firstLB.frame.size.height);

    
    if ([self.goods.goodTypeStr isEqualToString:@"Q币"] || self.goods.goodsType ==1 ) {
        NSString* name = self.goods.goodsQQ;
        _secLB.text =[NSString stringWithFormat:@"QQ号 : %@",name];
    }else if ([self.goods.goodTypeStr isEqualToString:@"话费"] || self.goods.goodsType ==2){
        NSString* name = self.goods.goodsPhone;
        _secLB.text =[NSString stringWithFormat:@"充值手机号 : %@",name];
    }
    else if(self.goods.goodsType ==5 ){
//        NSString* name = self.goods.goodsCode;
//        _secLB.text =[NSString stringWithFormat:@"游戏道具 : %@",name];
    }
    else if (self.goods.goodsType == 7){
        NSString* name = self.goods.goodsAddress;
        _secLB.text =[NSString stringWithFormat:@"邮寄地址 : %@",name];
    }
    else if (self.goods.goodsType ==6){
//        NSString* name = self.goods.goodsCode;
//        _secLB.text =[NSString stringWithFormat:@"邮寄地址 : %@",name];
    }
    else if ([self.goods.goodTypeStr isEqualToString:@"支付宝"] || self.goods.goodsType ==3){
        NSString* name = self.goods.goodsUserAccount;
        _secLB.text =[NSString stringWithFormat:@"支付宝号 : %@",name];
    }else if ([self.goods.goodTypeStr isEqualToString:@"财付通"] || self.goods.goodsType ==4){
        NSString* name = self.goods.goodsUserAccount;
        _secLB.text =[NSString stringWithFormat:@"财付通号 : %@",name];
    }else if ([self.goods.goodTypeStr isEqualToString:@"流量"] || self.goods.goodsType ==8){
        NSString *name =self.goods.goodsPhone ;
        _secLB.text =[NSString stringWithFormat:@"号码 : %@",name];
    }
    
    if(![NSString isEmptyString:_secLB.text]){
        [_secLB sizeToFit];
        _secLB.frame = CGRectMake(_secLB.frame.origin.x, _firstLB.frame.origin.y + _firstLB.frame.size.height + 2, kmainScreenWidth - 20.0f, _secLB.frame.size.height);
//        if(_secLB.hidden != NO){
            _secLB.hidden = NO;
            height = _secLB.frame.size.height;
            secLBHeight = height + 2.0f;
//        }
    }else{
        if(_secLB.hidden != YES){
            _secLB.hidden = YES;
            secLBHeight = 0.0;
        }else{
            secLBHeight = 0.0;
        }
    }
    
    _thrLB.text = [NSString stringWithFormat:@"兑换时间 : %@",self.goods.goodsTime];
    [_thrLB sizeToFit];
    _thrLB.frame = CGRectMake(_thrLB.frame.origin.x, _firstLB.frame.origin.y + _firstLB.frame.size.height + secLBHeight + 2, kmainScreenWidth - 20.0f, _thrLB.frame.size.height);
    
    _fouLB.text = [NSString stringWithFormat:@"兑换单号 : %d",self.goods.goodsOrder];
    [_fouLB sizeToFit];
    _fouLB.frame = CGRectMake(_fouLB.frame.origin.x, _thrLB.frame.origin.y + _thrLB.frame.size.height + 2, kmainScreenWidth - 20.0f, _fouLB.frame.size.height);


    if (self.goods.goodsType == 5) {
        _state.frame = CGRectMake(_bgImage.frame.origin.x + 8, 70.0f, CGRectGetWidth(_state.frame), 15);
    }else if (self.goods.goodsType == 6) {
        _state.frame = CGRectMake(_bgImage.frame.origin.x + 8, 70.0f, CGRectGetWidth(_state.frame), 15);
        _toCopyBtn.frame =CGRectMake(_toCopyBtn.frame.origin.x, _state.frame.origin.y -5, _toCopyBtn.frame.size.width, _toCopyBtn.frame.size.height);
        _state2.frame =CGRectMake(_state.frame.origin.x, 100, CGRectGetWidth(_state2.frame), 15);
        _toCopyBtn2.frame =CGRectMake(_toCopyBtn2.frame.origin.x, _state2.frame.origin.y -2, _toCopyBtn2.frame.size.width, _toCopyBtn2.frame.size.height);
    }
    
    _logo.hidden = YES;
    _haveVersandLab.hidden = YES;
    _toCopyBtn.hidden = YES;
    _toCopyBtn2.hidden = YES;

    if (self.goods.goodsType == 5 && self.goods.goodsStatus == 1) {
         _toCopyBtn.hidden = NO;
    }
    if (self.goods.goodsType == 6 && self.goods.goodsStatus == 1) {
        _toCopyBtn.hidden = NO;
        _toCopyBtn2.hidden = NO;
    }
    if (self.goods.goodsType == 7 && self.goods.goodsStatus == 1) {
        _toCopyBtn.hidden = NO;
    }
    switch (self.goods.goodsStatus) {
        case 0:
        {
            _haveVersandLab.text = @"待发货";
            _haveVersandLab.hidden = NO;
            _haveVersandLab.textColor = kBlueTextColor ;
        }
            break;
            
        case 1:
        {
            _logo.frame = CGRectMake(283, 0, 32, 32);
            _haveVersandLab.text = @"已发货";
            _haveVersandLab.textColor =KOrangeColor2_0 ;
            _haveVersandLab.hidden = NO;
            if (self.goods.goodsType == 7) {
                _state.text = self.goods.goodsPs;
            }else if (self.goods.goodsType == 5) {
                _state.text = [NSString stringWithFormat:@"礼包:%@",self.goods.goodsCode];
            }else if (self.goods.goodsType == 6) {

                _state.text = [NSString stringWithFormat:@"卡号:%@",self.goods.goodsCard];
                _state2.text = [NSString stringWithFormat:@"密码:%@",self.goods.goodsCode];
    
            }else{
               _state.text = self.goods.goodsPs;
            }
        }
            break;
        case 2:{   //取消发货
            _haveVersandLab.text = @"取消兑换";
            _haveVersandLab.hidden = NO;
            _haveVersandLab.textColor = KGrayColor2_0 ;
        }
            break ;
        case 3:{   //订单失败
            _haveVersandLab.text = @"兑换失败";
            _haveVersandLab.hidden = NO;
            _haveVersandLab.textColor = KGrayColor2_0 ;
        }
            break ;

        case 4:{   //下月1号发货
            _haveVersandLab.text = @"下月1号发货";
            _haveVersandLab.hidden = NO;
            _haveVersandLab.textColor = kBlueTextColor ;
        }
            break ;

        default:
            break;
    }
    if(![NSString isEmptyString:_state.text]){
        [_state sizeToFit];
        _state.frame = CGRectMake(_state.frame.origin.x, _state.frame.origin.y, CGRectGetWidth(_state.frame), _state.frame.size.height);
    }
    if(_toCopyBtn.hidden == NO){
        _toCopyBtn.frame = CGRectMake(_toCopyBtn.frame.origin.x, self.state.frame.origin.y - 3, _toCopyBtn.frame.size.width, _toCopyBtn.frame.size.height);
    }
    if(_toCopyBtn2.hidden == NO){
        _toCopyBtn.frame = CGRectMake(_toCopyBtn2.frame.origin.x, self.state.frame.origin.y - 2, _toCopyBtn2.frame.size.width, _toCopyBtn2.frame.size.height);
    }
}
-(void)copyGoodsOrder:(UIButton* )btn{
    NSString* string;
    UIPasteboard* pasteboard =[UIPasteboard generalPasteboard];
    if (self.goods.goodsType==5) {
        string = _state.text;
        
    }
    if (self.goods.goodsType ==7) {
        string = _state.text;
    }
    if (self.goods.goodsType ==6) {
        switch (btn.tag) {
            case 1:
                string= _state.text;
                break;
            case 2:
                string= _state2.text;
                break;
        }
    }
    NSArray* array =[string componentsSeparatedByString:@":"];
    NSString* copyString;
    if (array.count >1) {
        copyString =[array objectAtIndex:1];
        [copyString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }else{
        copyString = string;
    }
    [pasteboard setValue:copyString forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
    if (self.goods.goodsType ==6) {
        if (btn.tag ==1) {
            [StatusBar showTipMessageWithStatus:@"卡号复制成功" andImage:[UIImage imageNamed:@"icon_yes.png"] andTipIsBottom:YES];
        }else if (btn.tag ==2){
            [StatusBar showTipMessageWithStatus:@"密码复制成功" andImage:[UIImage imageNamed:@"icon_yes.png"] andTipIsBottom:YES];
        }
    }else if(self.goods.goodsType ==7){
        [StatusBar showTipMessageWithStatus:@"快递号复制成功" andImage:[UIImage imageNamed:@"icon_yes.png"] andTipIsBottom:YES];
    }else if(self.goods.goodsType ==5){
        [StatusBar showTipMessageWithStatus:@"礼包号复制成功" andImage:[UIImage imageNamed:@"icon_yes.png"] andTipIsBottom:YES];
    }else{
        [StatusBar showTipMessageWithStatus:@"复制成功" andImage:[UIImage imageNamed:@"icon_yes.png"] andTipIsBottom:YES];
    }
}
-(float)getCellHeight{      // 新版 注意区分 待发货和 已发货 不同高度
    float cellHeight = 0;
    if (self.goods.goodsType == 6) {  //充值卡
        if (self.goods.goodsStatus ==1 ) {
            cellHeight = 132.0f;
        }else{
            cellHeight = 69.0f ;
        }
        
    }else if([self.goods.goodTypeStr isEqualToString:@"礼包"] ||  self.goods.goodsType == 5){ // 游戏道具
        if (self.goods.goodsStatus ==1 ) {
            cellHeight = 102.0f;
        }else{
            cellHeight = 69.0f ;
        }
    }else if([self.goods.goodTypeStr isEqualToString:@"Q币"] || self.goods.goodsType == 1 ){   //Q币
        cellHeight = 84.0f;
    }else if ([self.goods.goodTypeStr isEqualToString:@"话费"] || self.goods.goodsType == 2){     //话费
        cellHeight = 84.0f;
    }else if ([self.goods.goodTypeStr isEqualToString:@"奖品"] || self.goods.goodsType == 7){   //实物
        if (self.goods.goodsStatus == 1) {
            cellHeight = 115.0f;
        }else{
            cellHeight = 84.0f;
        }
    }else if ([self.goods.goodTypeStr isEqualToString:@"流量"] || self.goods.goodsType == 8){
        cellHeight =84.0f;
    }
    
    return cellHeight;
}

-(void)prepareForReuse{
//    NSLog(@" prepare");
    self.goods =nil;
//    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (UIView *label in self.contentView.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            UILabel *lab =(UILabel *)label ;
            lab.text =nil;
        }
    }

    [super prepareForReuse];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
