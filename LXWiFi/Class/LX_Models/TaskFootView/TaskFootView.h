//
//  TaskFootView.h
//  免费流量王
//
//  Created by keyrun on 14-11-13.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnderLineLabel.h"
 typedef void(^TaskFootViewBlock)();

@interface TaskFootView : UIView
{
    TaskFootViewBlock _copyBlock ;
}
@property(nonatomic ,strong) UnderLineLabel *taskTip ;     //活动说明

-(instancetype)initWithFrame:(CGRect)frame WithBlock:(TaskFootViewBlock) block;
@end
