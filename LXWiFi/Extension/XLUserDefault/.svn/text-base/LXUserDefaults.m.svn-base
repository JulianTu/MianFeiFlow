//
//  LXUserDefaults.m
//  乐享WiFi
//
//  Created by keyrun on 14-9-16.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LXUserDefaults.h"

@implementation LXUserDefaults
{
    NSUserDefaults *userDef ;
}
+(id)standardUserDefaults{
    static LXUserDefaults *userDefault ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userDefault = [[self alloc] init];
    });
    return userDefault ;
}
-(id)init{
    userDef =[NSUserDefaults standardUserDefaults];
    return self;
}
@end
