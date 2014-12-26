//
//  LLShareTable.h
//  免费流量王
//
//  Created by keyrun on 14-10-15.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLShareTable : UITableView <UITableViewDataSource ,UITableViewDelegate ,UIAlertViewDelegate>

@property (nonatomic ,strong) NSArray *dataArr ;
@property (nonatomic ,assign) BOOL haveRequest ;
-(void)initBasicData ;
@end
