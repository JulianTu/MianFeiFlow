//
//  LLUserCenterCell.h
//  乐享WiFi
//
//  Created by keyrun on 14-10-14.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoJinLabel.h"

 typedef void(^UserHeadCellBlock)();
@protocol UserCenterCellDelegate <NSObject>

-(void)onClickBtn:(UIButton *)btn andIndexRow:(int)indexRow;

@end

@interface LLUserCenterCell : UITableViewCell
{
    UserHeadCellBlock _copyBlock ;
}
@property (nonatomic ,strong) id <UserCenterCellDelegate> delegate;

@property (nonatomic ,strong) UIImageView *headImage ;
@property (nonatomic ,strong) UIImageView *itemHotImg ;
@property (nonatomic ,strong) TaoJinLabel *flowNumLab ;

@property (nonatomic ,strong) TaoJinLabel *flowCountLab ;

@property (nonatomic ,strong) UILabel *msgLab; 

@property (nonatomic ,strong) UILabel *nameOne;
@property (nonatomic ,strong) UILabel *nameTwo;
@property (nonatomic ,strong) UILabel *nameThree;

@property (nonatomic ,strong) UILabel *oneLab ;
@property (nonatomic ,strong) UILabel *twoLab ;
@property (nonatomic ,strong) UILabel *threeLab ;

@property (nonatomic ,strong) UIImageView *oneImg ;
@property (nonatomic ,strong) UIImageView *twoImg ;
@property (nonatomic ,strong) UIImageView *threeImg ;

@property (nonatomic ,strong) UIButton *oneBtn ;
@property (nonatomic ,strong) UIButton *twoBtn ;
@property (nonatomic ,strong) UIButton *threeBtn ;

@property (nonatomic ,assign) int indexRow;

-(void)loadCellHeadViewWith:(NSString *)userFlows andFlowNum:(NSString *)number withBlock:(UserHeadCellBlock)block;
-(void)loadSubCellWithTitle:(NSArray *)titles andImgae:(NSArray *)images ;
-(void)loadSubcellWithTitles:(NSArray *)titles andImages:(NSArray *)images andType:(int) type ;

/**
*  更新流量币
*
*  @param coins 流量币
*/
-(void) changeUserCoin:(NSString *)coins ;
/**
*  更新用户号
*
*  @param number ID号
*/
-(void) changeUserNumber:(NSString *)number ;
/**
*  更新头像
*
*  @param iconUrl 头像地址
*/
-(void) changeUserIcon:(NSString *)iconUrl ;
/**
*  改变消息中心提示数字
*
*  @param msgCount 消息数
*/
-(void) changeMsgLab:(NSString *)msgCount ;

/**
*  改变收支明细提示数字
*
*  @param incomeCount 收支数
   @param type   增加还是减少    1增加  2减少
*/
-(void) changeIncomeLab:(NSString *)incomeCount type:(int )type;

@end
