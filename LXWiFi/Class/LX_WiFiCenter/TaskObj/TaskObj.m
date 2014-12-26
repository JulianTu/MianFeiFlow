//
//  TaskObj.m
//  乐享WiFi
//
//  Created by keyrun on 14-10-13.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "TaskObj.h"

@implementation TaskObj

-(id)initWithDataDictionary:(NSDictionary *)dicData{
    self = [super init];
    if (self) {
        self.taskName = dicData[@"name"];
    
    }
    return self;
}

@end
