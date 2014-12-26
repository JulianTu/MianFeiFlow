//
//  ActivityObj.m
//  免费流量王
//
//  Created by keyrun on 14-11-10.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "ActivityObj.h"

@implementation ActivityObj

-(instancetype)initActivityObjWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.actId = [[dic objectForKey:@"id"] integerValue];
        self.actType = [dic objectForKey:@"type"];
        self.actImgURL = [dic objectForKey:@"pic"];
        self.actWebURL = [dic objectForKey:@"url"];
    }
    return self;
}
@end
