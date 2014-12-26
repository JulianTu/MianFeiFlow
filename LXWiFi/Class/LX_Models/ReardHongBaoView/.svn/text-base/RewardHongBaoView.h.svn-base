//
//  RewardHongBaoView.h
//  免费流量王
//
//  Created by keyrun on 14-10-23.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoJinButton.h"
#import "TaoJinLabel.h"

typedef  void(^RewardHongBaoBlock)(BOOL doOrnot);

@protocol RewardHongBaoViewDelegate <NSObject>

-(void)noticToMissHongBao;

@end
@interface RewardHongBaoView : UIView <UITextFieldDelegate>
{
    TaoJinLabel *defLab;
    NSMutableArray *allPhones;
    UIViewController *rootVC ;
    RewardHongBaoBlock _block ;
    float oldFrameY;
    float oldBgViewY;
    BOOL doAnimation ;
    NSMutableArray *viewsArr;
}
//@property (nonatomic ,strong) TaoJinLabel *rewardedTip ;

@property (nonatomic, strong) id <RewardHongBaoViewDelegate> rhbDelegate ;
@property (nonatomic ,strong) UIView *halfTopView ;
@property (nonatomic ,strong) UIView *halfBottomView;
@property (nonatomic ,strong) UIView *bgView ;   // 半透明底部
@property (nonatomic ,strong) TaoJinLabel *titleLab ;
@property (nonatomic ,strong) TaoJinLabel *tipLab  ; // 领取成功后的说明
@property (nonatomic ,strong) UIImageView *hongBaoView ;
@property (nonatomic ,strong) UITextField *phoneTF;
@property (nonatomic ,strong) TaoJinLabel *phoneTipLab ;
@property (nonatomic ,strong) TaoJinButton *rewardBtn ;     //领取按钮
@property (nonatomic ,strong) TaoJinButton *closeBtn ;       //关闭按钮
-(instancetype)initWithFrame:(CGRect)frame Images:(NSArray *)images andValus:(NSArray *)valus rewardBlock:(RewardHongBaoBlock)block;
- (void) requestForHongBao ;
-(void) showHongBaoView ;
@end
