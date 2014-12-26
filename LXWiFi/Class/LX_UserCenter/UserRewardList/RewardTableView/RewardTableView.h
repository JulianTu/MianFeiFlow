//
//  RewardTableView.h
//  免费流量王
//
//  Created by keyrun on 14-10-27.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RewardTypeAll = 0,     //全部兑换
    RewardTypeFlow  =1 ,     // 流量
    RewardTypeCash  ,        //现金
    RewardTypeQCoin ,        // Q币
    RewardTypePhone  ,       // 话费
    RewardTypeGoods          //奖品
}RewardType;

@protocol RewardTabDelegate <NSObject>

-(void) scrollToCloseTypeChoose;

@end

@interface RewardTableView : UITableView  <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic ,strong) NSMutableArray *allLogs;
@property (nonatomic ,strong) id<RewardTabDelegate> rewardTabDelegate ;
-(void) requestToGetRewardList;
-(void) initObjectsWithRewardType:(RewardType) type;


@end
