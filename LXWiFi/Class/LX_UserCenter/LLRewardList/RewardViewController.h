//
//  RewardViewController.h
//  TJiphone
//
//  Created by keyrun on 13-9-26.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RewardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
-(void)initWithObjects;
-(void)requestForUserBeans;

@property (nonatomic, strong) NSMutableArray *allGoodsAry;                                //产品数据数组
@property (nonatomic, assign) BOOL isRequesting;                                            //标识是否正在请求网络或者刷新界面
@property (nonatomic, assign) BOOL isRequestingWithGold;                                    //标识是否正在请求获取用户金豆数

@property (nonatomic ,assign) BOOL isFromService ;       // 是否从兑换流量界面push过来 

@property (nonatomic ,assign) BOOL isRemotionPush;      //是否是远程通知
@property (nonatomic ,assign) int pushGoodID ;          //推送要展示的商品id
-(void)getPushRewardGoods;

@end
