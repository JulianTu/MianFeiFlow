//
//  RewardCardView.h
//  免费流量王
//
//  Created by keyrun on 14-10-20.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoJinLabel.h"
#import "TaoJinButton.h"
#import "DrawLabel.h"
#import "FlowCard.h"
typedef enum{
    OperatorTypeMobile =0 ,       // 移动
    OperatorTypeUnicom ,          // 联通
    OperatorTypeTelecom           // 电信
}OperatorType;

typedef enum {
    LimitTypeOnce =0,             // 当月生效
    LimitTypeThrty ,                // 30天
    LimitTypeNinty                 // 90天
}LimitType;
 typedef void(^RewardCardInvaildBlock)();
@protocol RewardCardDelegate <NSObject>

-(void) onClickedRewardChargeCard:(NSString *)flowNum andCostNum:(NSString *)costNum andCardID:(int)cid isEnough:(BOOL)enough;

@end

@interface RewardCardView : UIView
{
    NSString *flowInfo ;
    NSString *costNum ;
//    int _cardId ;
    RewardCardInvaildBlock _copyBlock ;
}
@property (nonatomic ,assign) BOOL isEnough ;
@property (nonatomic, assign) OperatorType type ;
@property (nonatomic ,strong) id <RewardCardDelegate> rcDelegate ;
@property (nonatomic ,strong) UIImageView *bgView;
@property (nonatomic ,strong) UIImageView *operatorIcon ;
@property (nonatomic ,strong) DrawLabel *flowNum ;     // 兑换卡 面值
@property (nonatomic ,strong) TaoJinLabel *limitLab ;
@property (nonatomic ,strong) TaoJinLabel *needNum ;        // 兑换需要的金额
@property (nonatomic ,strong) TaoJinButton *chargeBtn ;     
@property (nonatomic ,strong) UIImageView *goldImg ;       //金币图
@property (nonatomic ,assign) int cardId;
@property (nonatomic ,strong) FlowCard *card ;          //流量卡对象
-(instancetype)initWithFrame:(CGRect)frame withOperator:(OperatorType )operatorType flowNum:(NSString *)fNum andNeedNum:(NSString *)nNum limitType:(NSString *)limittype isEnough:(BOOL) isEnough andCardInfo:(NSString *)infor andCardId:(int)cardId flowCard:(FlowCard *)card;

-(id) initInvalidRewardView:(CGRect)frame withBlock:(RewardCardInvaildBlock) block;

@end
