//
//  LLRewardListController.h
//  免费流量王
//
//  Created by keyrun on 14-10-15.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLRewardListController : UIViewController <UITableViewDataSource ,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *allGoodsAry;                                //产品数据数组

@end
