//
//  LLRecordTable.h
//  免费流量王
//
//  Created by keyrun on 14-10-15.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareRecordCell.h"
@interface LLRecordTable : UITableView <UITableViewDataSource ,UITableViewDelegate,UIAlertViewDelegate>


- (void)initRecordBasicData;

@property (nonatomic ,assign) BOOL haveRequest ;

@end
