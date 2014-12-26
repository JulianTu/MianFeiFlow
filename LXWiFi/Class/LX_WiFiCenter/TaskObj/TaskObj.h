//
//  TaskObj.h
//  乐享WiFi
//
//  Created by keyrun on 14-10-13.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskObj : NSObject

@property (nonatomic ,strong) NSString *taskName ;
@property (nonatomic ,strong) NSString *taskIntro ;

@property (nonatomic ,assign) int taskReward ;       //任务奖金
@property (nonatomic ,strong) NSString *taskImageUrl ;    //任务头像地址
@property (nonatomic ,assign) int taskSize ;

-(id)initWithDataDictionary:(NSDictionary *)dicData;

@end
