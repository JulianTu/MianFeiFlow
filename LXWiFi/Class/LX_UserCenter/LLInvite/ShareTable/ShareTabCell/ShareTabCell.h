//
//  ShareTabCell.h
//  免费流量王
//
//  Created by keyrun on 14-10-15.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoJinLabel.h"
#import "TaoJinButton.h"
#import "UnderLineLabel.h"
#import "DashLine.h"
@interface ShareTabCell : UITableViewCell
{
    NSString *superLinker;
}
@property (nonatomic,strong) TaoJinLabel *title ;
@property (nonatomic ,strong) TaoJinLabel *content ;
@property (nonatomic ,strong) TaoJinLabel *reward ;
@property (nonatomic ,strong) TaoJinLabel *textLab ;
@property (nonatomic ,assign) BOOL isHeadCell ;
@property (nonatomic ,assign) BOOL isBottomCell ;

@property (nonatomic ,strong) DashLine *dashLine ;

@property (nonatomic ,strong) TaoJinButton *shareBtn ;    // 分享按钮
@property (nonatomic ,strong) TaoJinButton *codeImgBtn ;  // 二维码按钮

@property (nonatomic ,strong) UnderLineLabel *lineLabel ;
@property (nonatomic ,strong) UIView *lineLabBG; 

-(void)loadCellHeadVie:(NSString *)content ;
-(float) getShareCellHeigth ;
-(void)loadShareTabCellViewWithTitle:(NSString *)title Content:(NSString *)content rewardNum:(NSString *)rewardNum ;
-(void) loadCellBottomViewWithURL:(NSString *)urlStr ;


@end
