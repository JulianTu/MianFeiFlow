//
//  NewIncomeTable.h
//  免费流量王
//
//  Created by keyrun on 14-10-27.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  enum{
    IncomeTypeAll = 0,     //全部收支
    IncomeTypeMission =1 ,    // 任务收支
    IncomeTypeInvite = 2,     //邀请收支
    IncomeTypeActivity = 3 ,    //活动收支
    IncomeTypeExchange  ,     //兑换收支
    IncomeTypeOther ,        //其他收支
}IncomeType;

@protocol NewIncomeTabDelegate <NSObject>

-(void) incomeScrollToCloseChooseView ;

@end

@interface NewIncomeTable : UITableView <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic ,strong) NSMutableArray *allLogs;

@property (nonatomic ,strong) id <NewIncomeTabDelegate> incomeTabDelegate ;

-(void) requestToGetUserAllIncome;
-(void) initObjectsWithIncomeType:(IncomeType) type;
@end
