//
//  IncomeViewController.h
//  TJiphone
//
//  Created by keyrun on 13-9-30.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MScrollVIew.h"
#import "LLRecordTypeTable.h"
#import "User.h"
#import "NewIncomeTable.h"
@interface IncomeViewController : UIViewController<MScrollVIewDelegate,UIGestureRecognizerDelegate ,LLRecordTypeTableDelegate ,NewIncomeTabDelegate>

//收支差
@property(nonatomic,assign) int userLog;
@property (nonatomic ,strong) User *user;
-(void) saveUserLog:(long) log;
@end
