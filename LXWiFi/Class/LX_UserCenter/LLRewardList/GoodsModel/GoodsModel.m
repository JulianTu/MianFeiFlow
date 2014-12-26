//
//  GoodsModel.m
//  TJiphone
//
//  Created by keyrun on 13-10-24.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel
-(id)initGoodsModelByDictionary:(NSDictionary* )dic{
    self = [super init];
    if (self) {
        self.awardId =[[dic objectForKey:@"awardid"]integerValue];
        self.stock =[[dic objectForKey:@"amount"]integerValue];    //库存
        self.needBean =[[dic objectForKey:@"gold"]integerValue];
        self.type =[[dic objectForKey:@"type"]integerValue];
        self.awardName =[dic objectForKey:@"name"];
//        self.limit =[[dic objectForKey:@"Limit"]integerValue];
        self.awardImg =[dic objectForKey:@"icon"];
        self.introduce =[dic objectForKey:@"name"];     //名字
        self.picString =[dic objectForKey:@"icon"];
        self.typeStr = [dic objectForKey:@"type"];
        if ([[dic objectForKey:@"perman"]intValue]) {
            self.perman=[[dic objectForKey:@"perman"]intValue];
        }
        if ([dic objectForKey:@"Limit"]) {
            self.limit =[[dic objectForKey:@"Limit"]intValue];
        }
        self.bigImgUrl =[dic objectForKey:@"pic"];
        self.detail =[dic objectForKey:@"content"];
    }
    return self;
}
@end
