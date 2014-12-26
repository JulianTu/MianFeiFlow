//
//  FlowCard.m
//  免费流量王
//
//  Created by keyrun on 14-11-4.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "FlowCard.h"

@implementation FlowCard

-(id)initFlowCardWithDic:(NSDictionary *)dic {
    self= [super init];
    if (self) {
        self.flowId = [[dic objectForKey:@"awardid"] intValue];
        self.flowname = [dic objectForKey:@"name"] ;
        self.flowGold = [dic objectForKey:@"gold"] ;
        self.flowExpire = [dic objectForKey:@"expire"];
        self.flowOpreator = [dic objectForKey:@"supplier"];
        self.flowSize = [dic objectForKey:@"size"] ;
        self.flowState = [[dic objectForKey:@"state"] intValue];
    }
    return self;
}

@end
