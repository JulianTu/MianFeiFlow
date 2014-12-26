//
//  GoodsDetailsController.h
//  TJiphone
//
//  Created by keyrun on 13-10-15.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
#import "RTLabel.h"
//#import "TJViewController.h"
//#import "TjNavigationController.h"
@interface GoodsDetailsController : UIViewController<UIAlertViewDelegate ,RTLabelDelegate>

  //测试数据
@property(nonatomic ,strong) GoodsModel *goodsModel;
@property(nonatomic,strong)NSString* imageName;
@property(nonatomic,strong)NSString* goodsName;

@property(nonatomic,assign)int needBeans;

@property(nonatomic ,assign) BOOL isPush;

@property(nonatomic ,strong) UIViewController *lastVC ;

-(id)initViewWithGoodsModel:(GoodsModel *)goodsModel;
-(void)requestToGoodsDetailedInfo:(int) goodId;
-(void)requestForGoodsDetailsWithId:(int) goodsId ;
@end
