//
//  RewardListViewController.h
//  TJiphone
//
//  Created by keyrun on 13-9-30.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLRecordTypeTable.h"
#import "RewardTableView.h"
@interface RewardListViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,LLRecordTypeTableDelegate,RewardTabDelegate>

@property(nonatomic,assign) BOOL isRootPush;

@end
