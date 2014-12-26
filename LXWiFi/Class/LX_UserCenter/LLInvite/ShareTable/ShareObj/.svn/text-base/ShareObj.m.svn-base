//
//  ShareObj.m
//  免费流量王
//
//  Created by keyrun on 14-11-11.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "ShareObj.h"

@implementation ShareObj

-(id)initShareObjWithDictionary:(NSDictionary *)dic{
    self =[super init];
    if (self) {
        self.share_content = [dic objectForKey:@"content"];
        self.share_title = [dic objectForKey:@"name"];
        self.share_gold = [[dic objectForKey:@"gold"] intValue];
    }
    return self;
    
}
@end
