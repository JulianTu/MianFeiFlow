//
//  CodeView.m
//  免费流量王
//
//  Created by keyrun on 14-10-22.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "CodeView.h"
#import "UIImage+ColorChangeTo.h"
#define kCodeViewOffx      25.0f
#define kCodeViewSizeW     kmainScreenWidth -2*kCodeViewOffx
#define kCodeViewSizeH     250.0f
#define kCodeImgSize       150.0f
#define kCodeImgOffy       7.0f
#define kDesLabOffy        5.0f

#define kCodeTitleOffy       21.0f
#define kCodePadding         5.0f
#define kCodeBtnH            44.0f
#define kCodeChargeH         275.0f
@implementation CodeView
@synthesize bgView = _bgView ;
@synthesize codeImg = _codeImg ;
@synthesize descriptorLab = _descriptorLab ;
@synthesize cancelBtn =_cancelBtn ;
@synthesize whiteBgView = _whiteBgView ;
@synthesize chooseImg = _chooseImg ;
-(instancetype)initWithUserCodeImg:(UIImage *)codeImg andDescription:(NSString *)desStr{
    self = [super init];
    if (self) {
        UIColor *blue = ColorRGB(21.0, 126.0, 251.0, 1.0);
        _whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCodeViewSizeW, kCodeViewSizeH)];
        _whiteBgView.clipsToBounds = YES;
        _whiteBgView.backgroundColor = kWitheColor;
        _whiteBgView.layer.cornerRadius = 5.0f ;
        _whiteBgView.alpha = 0.95 ;
        _codeImg = [[UIImageView alloc] initWithImage:codeImg];
        _codeImg.frame =CGRectMake(_whiteBgView.frame.size.width/2 -kCodeImgSize/2, kCodeImgOffy, kCodeImgSize, kCodeImgSize);
        
        _descriptorLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0, _codeImg.frame.size.height +_codeImg.frame.origin.y +kDesLabOffy, kCodeViewSizeW, 0) text:desStr font:GetFont(11.0) textColor:kBlackTextColor textAlignment:NSTextAlignmentCenter numberLines:0];
        [_descriptorLab sizeToFit];
        _descriptorLab.frame =CGRectMake(0, _descriptorLab.frame.origin.y, kCodeViewSizeW, _descriptorLab.frame.size.height);
        
        CALayer *lineLayer =[CALayer layer];
        lineLayer.backgroundColor  = kLineColor2_0.CGColor ;
        
        
        _cancelBtn =[[TaoJinButton alloc] initWithFrame:CGRectMake(0, kCodeViewSizeH -45.0, _whiteBgView.frame.size.width, 45.0) titleStr:@"关闭" titleColor:blue font:GetBoldFont(16) logoImg:nil backgroundImg:nil];
        [_cancelBtn setBackgroundImage:[UIImage createImageWithColor:KLightGrayColor2_0] forState:UIControlStateHighlighted];
        [_cancelBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.clipsToBounds = YES;
        
        
        lineLayer.frame = CGRectMake(0, _cancelBtn.frame.origin.y-LineWidth, _whiteBgView.frame.size.width, LineWidth);
        
        [self addSubview:_whiteBgView];
        [_whiteBgView addSubview:_codeImg];
        [_whiteBgView addSubview:_descriptorLab];
        [_whiteBgView addSubview:_cancelBtn];
        [self.layer addSublayer:lineLayer];
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        self.clipsToBounds = YES;
    }
    return self;
}

-(id)initWithPhoneNum:(NSString *)phoneNum andCardInfor:(NSString *)cardInfo andCostNum:(NSString *)costNum codeViewBlock:(CodeViewBlock)block{
    self = [super init];
    if (self) {
        _copyBlock = [block copy];
        _whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCodeViewSizeW, kCodeChargeH)];
        _whiteBgView.clipsToBounds = YES;
        _whiteBgView.backgroundColor =kWitheColor;
        _whiteBgView.layer.cornerRadius = 5.0f ;
        _whiteBgView.alpha =0.95;
        phoneNumber = phoneNum ;
        TaoJinLabel *title =[[TaoJinLabel alloc] initWithFrame:CGRectMake(0, _whiteBgView.frame.origin.y +kCodeTitleOffy, _whiteBgView.frame.size.width, 17.0) text:@"兑换信息确认" font:GetBoldFont(16.0) textColor:kBlackTextColor textAlignment:NSTextAlignmentCenter numberLines:1];
        [_whiteBgView addSubview:title];
        
        TaoJinLabel *phoneLab =[[TaoJinLabel alloc] initWithFrame:CGRectMake(0, title.frame.origin.y +title.frame.size.height+kCodePadding, _whiteBgView.frame.size.width, 14.0) text:[NSString stringWithFormat:@"手机号码：%@",phoneNum] font:kFontSize_14 textColor:kBlackTextColor textAlignment:NSTextAlignmentCenter numberLines:1];
        [_whiteBgView addSubview:phoneLab];
        
        TaoJinLabel *chargeLab =[[TaoJinLabel alloc] initWithFrame:CGRectMake(0, phoneLab.frame.origin.y+phoneLab.frame.size.height +kCodePadding, _whiteBgView.frame.size.width, 14.0) text:[NSString stringWithFormat:@"兑换：%@",cardInfo] font:kFontSize_14 textColor:kBlackTextColor textAlignment:NSTextAlignmentCenter numberLines:1];
        [_whiteBgView addSubview:chargeLab];
        
        TaoJinLabel *costLab =[[TaoJinLabel alloc] initWithFrame:CGRectMake(0, chargeLab.frame.origin.y+chargeLab.frame.size.height +kCodePadding, _whiteBgView.frame.size.width, 14.0) text:[NSString stringWithFormat:@"需流量币：%@",costNum] font:kFontSize_14 textColor:kBlackTextColor textAlignment:NSTextAlignmentCenter numberLines:1];
        [_whiteBgView addSubview:costLab];
        
        NSArray *array =@[@"立即生效",@"下月1日生效"];
        UIImage *choose = GetImageWithName(@"check");
        _chooseImg = [[UIImageView alloc] initWithImage:choose];
        
        for (int i=0; i< 2; i++) {
            TaoJinButton *btn = [[TaoJinButton alloc] initWithFrame:CGRectMake(0, costLab.frame.origin.y +costLab.frame.size.height +2 *kOffX_2_0 +i*(kCodeBtnH -LineWidth), _whiteBgView.frame.size.width, kCodeBtnH) titleStr:nil titleColor:nil font:nil logoImg:nil backgroundImg:nil];
            [btn setBackgroundColor:kWitheColor];
            TaoJinLabel *label =[[TaoJinLabel alloc] initWithFrame:CGRectMake(kOffX_2_0, btn.frame.origin.y +(kCodeBtnH/2 -8.0), _whiteBgView.frame.size.width, 16.0) text:[array objectAtIndex:i] font:kFontSize_16 textColor:kBlackTextColor textAlignment:NSTextAlignmentLeft numberLines:1];
            btn.tag = i;
            [btn addTarget:self action:@selector(chooseCardDate:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                _chooseImg.frame = CGRectMake(_whiteBgView.frame.size.width -choose.size.width -kOffX_2_0, label.frame.origin.y, choose.size.width, choose.size.height);
            }
            [_whiteBgView addSubview:btn];
            [_whiteBgView addSubview:label];
            
        }
        for (int i=0; i< 3; i++) {
            CALayer *layer =[CALayer layer];
            layer.backgroundColor = kLineColor2_0.CGColor;
            layer.frame = CGRectMake(0, costLab.frame.origin.y +costLab.frame.size.height +2 *kOffX_2_0 +kCodeBtnH *i, _whiteBgView.frame.size.width, LineWidth);
            if (i == 1) {
                layer.frame =CGRectMake(kOffX_2_0, layer.frame.origin.y, _whiteBgView.frame.size.width -kOffX_2_0, LineWidth);
            }
            [_whiteBgView.layer addSublayer:layer];
        }

        TaoJinLabel *tipLab =[[TaoJinLabel alloc] initWithFrame:CGRectMake(0, costLab.frame.origin.y +costLab.frame.size.height +2 *kOffX_2_0 +kCodeBtnH *2 +kCodePadding*2, _whiteBgView.frame.size.width, 11.0) text:[NSString stringWithFormat:@"提示：流量需在当月使用完毕"] font:kFontSize_11 textColor:kNewGrayColor textAlignment:NSTextAlignmentCenter numberLines:1];
        [_whiteBgView addSubview:tipLab];
        
        CALayer *bottom = [CALayer layer];
        bottom.backgroundColor = kLineColor2_0.CGColor ;
        bottom.frame =CGRectMake(0, tipLab.frame.origin.y +tipLab.frame.size.height +kCodePadding*2, _whiteBgView.frame.size.width, LineWidth);
        [_whiteBgView.layer addSublayer:bottom];
        
        NSArray *titles =@[@"取消",@"确认"];
        UIColor *blue = ColorRGB(21.0, 126.0, 251.0, 1.0);
        for (int j=0; j <2; j++) {
            TaoJinButton *btn =[[TaoJinButton alloc] initWithFrame:CGRectMake(_whiteBgView.frame.size.width/2 *j, bottom.frame.origin.y +bottom.frame.size.height, _whiteBgView.frame.size.width/2, kCodeBtnH) titleStr:[titles objectAtIndex:j] titleColor:blue font:GetBoldFont(16.0) logoImg:nil backgroundImg:nil];
            btn.tag = j;
            [btn addTarget:self action:@selector(clickedCanelOrnot:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:[UIImage createImageWithColor:KLightGrayColor2_0] forState:UIControlStateHighlighted];
            btn.clipsToBounds = YES;
            [_whiteBgView addSubview:btn];
            
            if (j ==1) {
            CALayer *line = [CALayer layer];
            line.backgroundColor = kLineColor2_0.CGColor ;
            line.frame =CGRectMake(_whiteBgView.frame.size.width/2 *j, bottom.frame.origin.y +bottom.frame.size.height , LineWidth, kCodeBtnH);
            [_whiteBgView.layer addSublayer:line];
            }
        }
        [_whiteBgView addSubview:_chooseImg];
        [self addSubview:_whiteBgView];
        
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        self.clipsToBounds = YES;
    }
    return self ;
}
-(void)clickedCanelOrnot:(TaoJinButton *)btn {
    switch (btn.tag) {
        case 0:
        {
            [self dismissView];
        }
            break;
        case 1:   // 点击确认
        {
            _copyBlock(1,phoneNumber,activeType);
            [self dismissView];
        }
        default:
            break;
    }
}
-(void)chooseCardDate:(TaoJinButton *)btn{
    _chooseImg.frame = CGRectMake(_chooseImg.frame.origin.x, btn.frame.origin.y +(kCodeBtnH/2 -8.0), _chooseImg.frame.size.width, _chooseImg.frame.size.height);
    switch (btn.tag) {
        case 0:     //选择立即生效
            activeType = 0;
            break;
        case 1:     // 选择下月生效
            activeType = 1;
            break;
        default:
            break;
    }
}
-(void)dismissView {
    [self.bgView removeFromSuperview];
    self.bgView =nil;
    [self removeFromSuperview];

}
-(void) showChargeView {
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake(kCodeViewOffx, (CGRectGetHeight(topVC.view.bounds) - kCodeChargeH) * 0.5, kCodeViewSizeW, kCodeChargeH);
    
    [topVC.view addSubview:self];
}
-(void) showCodeView {
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake(kCodeViewOffx, (CGRectGetHeight(topVC.view.bounds) - kCodeViewSizeH) * 0.5, kCodeViewSizeW, kCodeViewSizeH);
    
    [topVC.view addSubview:self];
}
- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.bgView) {
        self.bgView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.bgView.backgroundColor = [UIColor blackColor];
        self.bgView.alpha = 0.3f;
        self.bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:self.bgView];
    
    [UIView animateWithDuration:0.17 animations:^{
        self.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.12 animations:^{
            self.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.layer.transform = CATransform3DIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

@end
