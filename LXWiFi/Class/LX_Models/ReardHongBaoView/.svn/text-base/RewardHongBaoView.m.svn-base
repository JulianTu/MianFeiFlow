//
//  RewardHongBaoView.m
//  免费流量王
//
//  Created by keyrun on 14-10-23.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "RewardHongBaoView.h"
#import "UIImage+ColorChangeTo.h"
#import "NSString+emptyStr.h"
#import "PhoneCarrierHelper.h"
#import "LLAsynURLConnection.h"
#import "SDImageView+SDWebCache.h"
#import "MyUserDefault.h"
#define kHBbottomViewH       250.0f
#define kHBtitleOffY         42.0f
#define kHBRewardPaddingX    12.0f      //奖励之间的间隔
#define kHBReardPaddingY     32.0f       // 奖励与 title的间距
#define kHBRewardImgPadding    8.0f     // 奖品图与背景的间距
#define kHBRewardLabPadding    5.0f      //奖励名字和背景的间距
#define KHBPhoneTFPadding       14.0f     // 号码tf 与红包图的间距

@implementation RewardHongBaoView
{
    int phoneFailCount;
    NSTimer *checkTimer ;
}
-(instancetype)initWithFrame:(CGRect)frame Images:(NSArray *)images andValus:(NSArray *)valus rewardBlock:(RewardHongBaoBlock)block{
    self =[super initWithFrame:frame];
    if (self) {
        viewsArr = [[NSMutableArray alloc] init];
        
        _block =[block copy];
        float batterH = kBatterHeight ;
        float hbTopViewH = ( kmainScreenHeigh- kfootViewHeigh -batterH)*27/52 ;
        _halfTopView = [[UIView alloc] initWithFrame:CGRectMake(0, kBatterHeight, kmainScreenWidth, hbTopViewH)];
        _halfTopView.backgroundColor = ColorRGB(253.0, 243.0, 234.0, 1.0);
        
        float hbBottomViewH =(kmainScreenHeigh -kfootViewHeigh -batterH)*25/52;
        _halfBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _halfTopView.frame.origin.y +_halfTopView.frame.size.height, kmainScreenWidth, hbBottomViewH)];
        _halfBottomView.backgroundColor = ColorRGB(254.0, 207.0, 105.0, 1.0);
        
        _titleLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0, kHBtitleOffY, kmainScreenWidth, 20.0) text:@"领取流量礼包，您将有机会获得" font:GetFont(20.0) textColor:kHongBaoRedColor textAlignment:NSTextAlignmentCenter numberLines:1];
        [self addSubview:_halfTopView];
        [self addSubview:_halfBottomView];
        [self addSubview:_titleLab];
        
        _tipLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0, _titleLab.frame.origin.y +_titleLab.frame.size.height +16.0f, kmainScreenWidth, 13.0) text:@"可通过流量中心-兑换记录，查看获奖详情" font:GetFont(12.0) textColor:kHongBaoRedColor textAlignment:NSTextAlignmentCenter numberLines:1];
        _tipLab.hidden = YES;
        [self addSubview:_tipLab];
        
        UIImage *hbImg = GetImageWithName(@"hongbao_close");
        _hongBaoView = [[UIImageView alloc]initWithFrame:CGRectMake(kmainScreenWidth/2 -hbImg.size.width/2, _halfBottomView.frame.origin.y -hbImg.size.height/4 *3, hbImg.size.width, hbImg.size.height)];
        _hongBaoView.image = hbImg ;
        _phoneTF = [self loadHongBaoPhoneTf:CGRectMake(kOffX_2_0, _hongBaoView.frame.origin.y + _hongBaoView.frame.size.height +KHBPhoneTFPadding, kmainScreenWidth -2 *kOffX_2_0, 50.0) defaultString:nil];
        _phoneTF.font = GetBoldFont(25.0);
        [self addSubview:_hongBaoView];
        [self addSubview:_phoneTF];
        
        defLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0, _phoneTF.frame.origin.y +(_phoneTF.frame.size.height/2 -8.0f) , kmainScreenWidth, 16.0) text:@"请输入移动、联通、电信手机号码" font:kFontSize_16 textColor:kHongBaoRedColor textAlignment:NSTextAlignmentCenter numberLines:1];
        defLab.userInteractionEnabled =NO;
        [self addSubview:defLab];
        
        _phoneTipLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0, _phoneTF.frame.origin.y +_phoneTF.frame.size.height +KHBPhoneTFPadding, kmainScreenWidth, 11.0) text:nil font:kFontSize_11 textColor:kHongBaoRedColor textAlignment:NSTextAlignmentCenter numberLines:1];
        [self addSubview:_phoneTipLab];
        
        _rewardBtn = [[TaoJinButton alloc] initWithFrame:CGRectMake(kmainScreenWidth/2 -SendButtonWidth/2, _phoneTipLab.frame.origin.y +_phoneTipLab.frame.size.height +KHBPhoneTFPadding, SendButtonWidth, SendButtonHeight) titleStr:@"领取红包" titleColor:kWitheColor font:GetBoldFont(16.0) logoImg:nil backgroundImg:[UIImage createImageWithColor:kHongBaoRedColor]];
        [_rewardBtn addTarget:self action:@selector(clickedGetHongBao) forControlEvents:UIControlEventTouchUpInside];
        _rewardBtn.layer.masksToBounds = YES;
        _rewardBtn.layer.cornerRadius = _rewardBtn.frame.size.height/2 ;
        _rewardBtn.layer.borderColor = kWitheColor.CGColor;
        _rewardBtn.layer.borderWidth = 1.0f;
        [self addSubview:_rewardBtn];
        
        UIImage *closeImg = GetImageWithName(@"button_close");
        _closeBtn = [[TaoJinButton alloc] initWithFrame:CGRectMake(kmainScreenWidth -kOffX_2_0 - closeImg.size.width -5.0f, _halfBottomView.frame.origin.y + _halfBottomView.frame.size.height -kOffX_2_0 -closeImg.size.height -5.0f, closeImg.size.width +10.0f, closeImg.size.height+10.0f) titleStr:@"" titleColor:kWitheColor font:GetBoldFont(16.0) logoImg:closeImg backgroundImg:nil];
        
        [_closeBtn addTarget:self action:@selector(showHongBaoView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
        
        [self loadCarrierData];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh -batterH)];
        _bgView.backgroundColor = [UIColor blackColor] ;
        _bgView.alpha = 0.0 ;
        
        rootVC = [self appRootViewController] ;
        _bgView.frame =CGRectMake(0, 0, kmainScreenWidth, CGRectGetHeight(rootVC.view.frame) );
        [rootVC.view addSubview:_bgView];
        [rootVC.view addSubview:self];
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyboard)];
        
        //        [self.halfBottomView addGestureRecognizer:tap];
        //        [self.halfTopView addGestureRecognizer:tap];
        [_bgView addGestureRecognizer:tap];
        [self addGestureRecognizer:tap];
        
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
        
        oldFrameY = 0.0 ;
        oldBgViewY = 0.0 ;
        doAnimation = YES;
        
    }
    return self;
}
-(void) clickedGetHongBao { // 领取红包按钮
    
    if (_phoneTF.text.length == 13) {
        NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,@"award/libao"];
        NSDictionary *dic =@{@"phone":_phoneTF.text};
        [LLAsynURLConnection requestURLWith:urlStr dataDic:dic andProtocolNum:@"30010" andTimeOut:httpTimeout connectSuccess:^(NSData *data) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([[dataDic objectForKey:@"flag"] intValue] ==1) {
                    NSDictionary *body =[dataDic objectForKey:@"body"];
                    //                    NSArray *lists =[body objectForKey:@"list"];
                    NSString *name =[body objectForKey:@"name"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //领取成功改变图片 提示
                        [[MyUserDefault standardUserDefaults] setUserDidGetHongBao:[NSNumber numberWithInt:2]]; //领取过红包
                        _titleLab.text = [NSString stringWithFormat:@"恭喜获得：%@",name];
                        _hongBaoView.image = GetImageWithName(@"hongbao_open");
                        _tipLab.hidden =NO;
                        _rewardBtn.userInteractionEnabled =NO;
                        [_rewardBtn setTitle:@"领取成功" forState:UIControlStateNormal];
                        [_rewardBtn setTitleColor:kHongBaoRedColor forState:UIControlStateNormal];
                        [_rewardBtn setBackgroundImage:[UIImage createImageWithColor:ColorRGB(254.0, 207.0, 105.0, 1.0)] forState:UIControlStateNormal];
                        _rewardBtn.layer.borderColor =kHongBaoRedColor.CGColor;
                        for (UIView *view in viewsArr) {
                            view.hidden =YES;
                        }
                        [self.rhbDelegate noticToMissHongBao];
                    });
                    
                }else if([[dataDic objectForKey:@"flag"] intValue] ==2){
                    NSDictionary *body =[dataDic objectForKey:@"body"];
                    NSString *msg =[body objectForKey:@"error"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([msg isEqualToString:@"该手机号已领过红包"]) {
                            _phoneTipLab.text = @"该号码已领取过流量礼包";
                        }
                    });
                    
                }
                NSLog(@" 领取流量礼包 == %@",dataDic);
            });
        } andFail:^(NSError *error) {
            
        }];
    }
    
}
-(void) keyboardDidHidden{
    doAnimation =YES;
}
-(void) hiddenKeyboard {
    //    doAnimation =YES ;
    //    [_phoneTF resignFirstResponder];
    _block(YES);
}
-(void)keyboardHidden:(NSNotification *)notic {
    NSDictionary *dic =[notic userInfo];
    
    NSTimeInterval time = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve animationCurve ;
    [[dic objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    UIViewAnimationOptions options = animationCurve << 16 ;
    if (doAnimation ==YES) {
        [UIView animateWithDuration:time delay:0.05f options:options animations:^{
            self.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            _bgView.frame =CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
        
    }
}
-(void)keyboardFrameChange:(NSNotification *)notic{
    
    NSDictionary *dic =[notic userInfo];
    CGRect kbSize = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval time = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve animationCurve ;
    [[dic objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    UIViewAnimationOptions options = animationCurve << 16 ;
    NSLog(@" keyboard size %@",NSStringFromCGRect(kbSize));
    [self viewFrameChange:kbSize andTime:time animation:options];
}
-(void) viewFrameChange:(CGRect) keyboardSize andTime:(NSTimeInterval) time animation:(UIViewAnimationOptions) option{
    [UIView animateWithDuration:time delay:0.05f options:option animations:^{
        self.frame = CGRectMake(0,  -keyboardSize.size.height, kmainScreenWidth, self.frame.size.height);
        _bgView.frame = CGRectMake(0,  -keyboardSize.size.height, kmainScreenWidth, _bgView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}
-(void) showHongBaoView {
    _block(NO) ;
    //    doAnimation =NO;
    //    [_phoneTF resignFirstResponder];
    
    float batter = kBatterHeight ;
    float mainScreenH   = kmainScreenHeigh ;
    float originY = self.frame.origin.y < 0 ? 0 : -(mainScreenH - batter) ;
    float alpha = _bgView.alpha == 0.0 ? 0.4 :0.0 ;
    NSLog(@" Rule %f   %f",self.frame.origin.y ,originY);
    [UIView animateWithDuration:0.4f animations:^{
        _bgView.alpha = alpha ;
        if (alpha != 0.0) {
            //            [rootVC.view insertSubview:_bgView belowSubview:self];
        }
        self.frame = CGRectMake(0, originY, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        if (alpha == 0.0) {
            [_bgView removeFromSuperview];
        }
        if (self.frame.origin.y <0) {
            [self removeFromSuperview];
        }
        
    }];
    
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

-(void) loadCarrierData{
    allPhones = [[NSMutableArray alloc]init];
    if ([[MyUserDefault standardUserDefaults] getSystemPhoneCarrier]) {     //使用服务器提供的号码段
        NSDictionary *dataDic =[[MyUserDefault standardUserDefaults] getSystemPhoneCarrier];
        if (dataDic) {
            
            NSArray *mobileArr = [dataDic objectForKey:@"chinamobile"];
            NSArray *unicomArr = [dataDic objectForKey:@"chinaunicom"];
            NSArray *telecomArr = [dataDic objectForKey:@"chinatelecom"];
            
            for (NSString *phone in mobileArr) {
                [allPhones addObject:phone];
            }
            for (NSString *phone in unicomArr) {
                [allPhones addObject:phone];
            }
            for (NSString *phone in telecomArr) {
                [allPhones addObject:phone];
            }
            
        }
        
    }else{
        NSString *dicPath =[[NSBundle mainBundle] pathForResource:@"PhoneNumList" ofType:@"plist"];
        NSDictionary *dataDic =[NSDictionary dictionaryWithContentsOfFile:dicPath];
        NSArray *mobileArr = [dataDic objectForKey:@"mobile"];
        NSArray *unicomArr = [dataDic objectForKey:@"unicom"];
        NSArray *telecomArr = [dataDic objectForKey:@"telecom"];
        for (NSString *phone in mobileArr) {
            [allPhones addObject:phone];
        }
        for (NSString *phone in unicomArr) {
            [allPhones addObject:phone];
        }
        for (NSString *phone in telecomArr) {
            [allPhones addObject:phone];
        }
    }
    
}

-(UITextField *)loadHongBaoPhoneTf:(CGRect)frame defaultString:(NSString *)defStr{
    UITextField *tf =[[UITextField alloc] initWithFrame:frame];
    tf.placeholder = defStr;
    tf.textColor = kHongBaoRedColor ;
    tf.font  = GetBoldFont(16.0) ;
    tf.backgroundColor = ColorRGB(254.0, 207.0, 105.0, 1.0);
    tf.layer.masksToBounds =YES;
    tf.layer.cornerRadius = 5.0f ;
    tf.textAlignment = NSTextAlignmentCenter ;
    tf.layer.borderColor = kHongBaoRedColor.CGColor;
    tf.layer.borderWidth =1.0f ;
    tf.delegate = self;
    [tf setKeyboardType:UIKeyboardTypeNumberPad];
    return tf;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (![NSString isPureInt:textField.text]) {
        if ([_phoneTF.text rangeOfString:@"-"].location ==NSNotFound) {
            _phoneTF.text =nil;
        }
        
    }
    if (kDeviceVersion >= 8.0) {
        checkTimer =[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(checkTextFiled) userInfo:nil repeats:YES];
    }
    
}
-(void)checkTextFiled {
    if (![NSString isPureInt:_phoneTF.text]) {
        if (_phoneTF.text.length >1) {
//            _phoneTF.text = [_phoneTF.text substringToIndex:_phoneTF.text.length -1];
        }else{
            _phoneTF.text =@"";
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.location > 0 || range.location == 0) {
        if (range.location ==0 && [string isEqualToString:@""] ){
            defLab.hidden =NO;
        }else if (range.location == 0 && ![NSString isPureInt:string]){
            defLab.hidden =NO;
        }
        else{
            defLab.hidden = YES;
        }
    }else{
        defLab.hidden = NO;
    }
    if ([_phoneTipLab.text hasPrefix:@"该手机"]) {
        _phoneTipLab.text =@"";
    }
    if ([_phoneTipLab.text hasPrefix:@"请"] && range.location <=2) {
        _phoneTipLab.text =@"" ;
    }
    if (![_phoneTipLab.text hasPrefix:@"请"] && _phoneTipLab.text.length >0) {
        _phoneTipLab.text=@"";
    }
    if (range.location >=2 && _phoneTF.text.length >=2) {
        BOOL isExist = NO;
        NSString *number =[textField.text stringByAppendingString:string];
        for (NSString *phone in allPhones) {
            
            if ([number hasPrefix:phone] || [number isEqualToString:phone]) {
                isExist = YES;
                break;
            }
        }
        if (!isExist) {
            _phoneTipLab.text =@"请输入正确的手机号码";
        }
        
    }
    
    if (_phoneTF.text.length ==8 && ![string isEqualToString:@""]) {  //输入时增加-
        NSMutableString *mString =[[NSMutableString alloc] initWithString:_phoneTF.text];
        [mString insertString:@"-" atIndex:3];
        [mString insertString:@"-" atIndex:8];
        _phoneTF.text =[NSString stringWithFormat:@"%@",mString];
        
    }
    if (_phoneTF.text.length ==11 && [string isEqualToString:@""]) {  //删除时去掉-
        _phoneTF.text =[_phoneTF.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    NSString *phonenum = _phoneTF.text ;
    NSLog(@" phoneNum  %d  %d",phonenum.length,range.location);
    
    if ([NSString isPureInt:string] || [string isEqualToString:@""]) {
        if (range.location == 12){
            //            [self checkPhoneCarrier:[phoneField.text stringByAppendingString:string]];
            if ([_phoneTF.text stringByAppendingString:string].length ==13 && string.length >0) {
                [self requestForMobileLocation:[_phoneTF.text stringByAppendingString:string]];
            }
            
            
            if (_phoneTF.text.length ==12) {
                if (![_phoneTipLab.text hasPrefix:@"请输入"]) {
                    [self performSelector:@selector(hiddenTheKeyboard) withObject:nil afterDelay:0.5];
                }
                
                //                if ([textField.text isEqualToString:@"1380013800"] && [string isEqualToString:@"0"]) {  //测试显示不支持兑换card
                //
                //                }
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
- (void)requestForMobileLocation:(NSString *)phoneNum{
    phoneNum =[phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *string =[NSString stringWithFormat:@"mobile/%@",phoneNum];
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,string];
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
                        _phoneTipLab.text =[NSString stringWithFormat:@"%@·%@",province,supplier];
                    }else{
                        _phoneTipLab.text =[NSString stringWithFormat:@"%@·%@·%@",province,city,supplier];
                    }
                });
                
                NSLog(@" phone location %@ %@ %@",city,province,supplier);
            }
            
        });
    } andFailBlock:^(NSError *error) {
        phoneFailCount++ ;
        if (phoneFailCount <3) {
            [self requestForMobileLocation:phoneNum];
        }
    }];
}

-(void)hiddenTheKeyboard {
    _block(YES);
}

- (void) requestForHongBao {
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,@"award/libao"];
    [LLAsynURLConnection requestForMethodGetWithURL:urlStr dataDic:nil andProtocolNum:@"30009" andTimeOut:httpTimeout successBlock:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([[dataDic objectForKey:@"flag"] intValue] ==1) {
                NSDictionary *body =[dataDic objectForKey:@"body"];
                NSArray *lists =[body objectForKey:@"list"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadRewardList:lists];

                });
                
            }
            NSLog(@" 获取流量礼包列表 == %@ ",dataDic);
        });
    } andFailBlock:^(NSError *error) {
        
    }];
}
-(void) loadRewardList:(NSArray *)lists{
    float imgBgViewSize = (kmainScreenWidth -2*kOffX_2_0 - 4*kHBRewardPaddingX) /5 ;
    for (int i=0; i <lists.count; i++) {
        NSDictionary *dic = [lists objectAtIndex:i];
        
        UIView *imageBG = [[UIView alloc] init];
        imageBG.frame = CGRectMake(kOffX_2_0 +(imgBgViewSize +kHBRewardPaddingX)*i, _titleLab.frame.origin.y +_titleLab.frame.size.height + kHBReardPaddingY, imgBgViewSize, imgBgViewSize);
        imageBG.backgroundColor = ColorRGB(252.0, 231.0, 223.0, 1.0);
        
        UIImageView *image =[[ UIImageView alloc] init];
        //        image.frame =CGRectMake(imageBG.frame.origin.x +kHBRewardImgPadding, imageBG.frame.origin.y +kHBRewardImgPadding, imageBG.frame.size.width -2*kHBRewardImgPadding, imageBG.frame.size.height -2*kHBRewardImgPadding);
        image.frame =imageBG.frame;
        [image setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"pic"]] refreshCache:false needSetViewContentMode:false needBgColor:false placeholderImage:GetImage(@"deficon")];
        
        TaoJinLabel *label =[[TaoJinLabel alloc] initWithFrame:CGRectMake(imageBG.frame.origin.x -kOffX_2_0, imageBG.frame.origin.y + imageBG.frame.size.height +kHBRewardLabPadding, imageBG.frame.size.width +2*kOffX_2_0, 11.0) text:[dic objectForKey:@"name"] font:kFontSize_11 textColor:kHongBaoRedColor textAlignment:NSTextAlignmentCenter numberLines:1];
        
        //        [self addSubview:imageBG];
        [self addSubview:image];
        [self addSubview:label];
        [viewsArr addObject:imageBG];
        [viewsArr addObject:image];
        [viewsArr addObject:label];
    }
    
}
@end
