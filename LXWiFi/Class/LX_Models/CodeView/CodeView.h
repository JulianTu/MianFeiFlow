//
//  CodeView.h
//  免费流量王
//
//  Created by keyrun on 14-10-22.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoJinLabel.h"
#import "TaoJinButton.h"
 typedef void(^CodeViewBlock)(int cardId ,NSString *phoneNum ,int activeType);
@interface CodeView : UIView
{
    CodeViewBlock _copyBlock ;
    NSString *phoneNumber;
    int activeType ;
}
@property (nonatomic ,strong) UIView *bgView ;
@property (nonatomic ,strong) UIView *whiteBgView ;
@property (nonatomic ,strong) UIImageView *codeImg ;
@property (nonatomic ,strong) TaoJinLabel *descriptorLab ;    //描述
@property (nonatomic ,strong) TaoJinButton *cancelBtn ;      // 取消按钮
@property (nonatomic ,strong) UIImageView *chooseImg ;        //选择图标
-(instancetype)initWithUserCodeImg:(UIImage *)codeImg andDescription:(NSString *)desStr ;

-(id)initWithPhoneNum:(NSString *)phoneNum andCardInfor:(NSString *)cardInfo andCostNum:(NSString *)costNum codeViewBlock:(CodeViewBlock)block;
-(void) showChargeView ;
-(void) showCodeView  ;
@end
