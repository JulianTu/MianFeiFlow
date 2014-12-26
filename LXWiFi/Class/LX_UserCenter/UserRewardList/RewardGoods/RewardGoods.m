//
//  RewardGoods.m
//  TJiphone
//
//  Created by keyrun on 13-10-29.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "RewardGoods.h"

@implementation RewardGoods

-(id)initRewardGoodsByDic:(NSDictionary* )dic{
    self =[super init];
    if (self) {
        self.goodTypeStr =[dic objectForKey:@"type"];
        self.goodsType =[[dic objectForKey:@"type1"]integerValue];      
        self.goodsStatus =[[dic objectForKey:@"state"]integerValue];
        self.goodsPs =[dic objectForKey:@"remark"];
        self.goodsOrder =[[dic objectForKey:@"id"]integerValue];
        self.goodsName =[dic objectForKey:@"name"];
        NSString* string =[dic objectForKey:@"time"];
        
        /*
         double dtime=[string doubleValue];
         NSDate *date=[NSDate dateWithTimeIntervalSince1970:dtime];
         NSTimeZone* zone=[NSTimeZone systemTimeZone];
         NSInteger interval=[zone secondsFromGMTForDate:date];
         NSDate* locationDate=[date dateByAddingTimeInterval:interval];
         NSString* timeStr =[locationDate description];
         NSArray* arr =[timeStr componentsSeparatedByString:@" "];
         */
        //        self.goodsTime =[NSString stringWithFormat:@"%@ %@",[arr objectAtIndex:0],[arr objectAtIndex:1]];
        self.goodsTime = string;
        
        
        self.goodsProduce =[dic objectForKey:@"name"];
        
        if ([self.goodTypeStr isEqualToString:@"奖品"] || self.goodsType ==7) {    //实物奖品 有地址 快递号
            self.goodsAddress =[dic objectForKey:@"address"];
            self.goodsUserName =[dic objectForKey:@"name"];
            self.goodsCard = [dic objectForKey:@"codename"];
            self.goodsCode = [dic objectForKey:@"code"];
            self.goodsPs = [self.goodsCard stringByAppendingString:[NSString stringWithFormat:@":%@",self.goodsCode]];
        }
        
        if ([self.goodTypeStr isEqualToString:@"充值卡"] || self.goodsType ==5 ) {    //充值卡 有号码和密码     礼包只有密码
            self.goodsCard =[dic objectForKey:@"codename"];
        }
        if ([self.goodTypeStr isEqualToString:@"充值卡"] || [self.goodTypeStr isEqualToString:@"礼包"] ||self.goodsType ==6) {
            self.goodsCode =[dic objectForKey:@"code"];
        }
        if ([self.goodTypeStr isEqualToString:@"Q币"] || self.goodsType ==1 ) {      //q币
            self.goodsQQ =[dic objectForKey:@"qq"];
        }
        
        if ([self.goodTypeStr isEqualToString:@"流量"] || [self.goodTypeStr isEqualToString:@"话费"] ||self.goodsType == 8 ||self.goodsType ==2) {  //流量和话费 有phone
            self.goodsPhone = [dic objectForKey:@"phone"];
        }
        
        if ([self.goodTypeStr isEqualToString:@"现金"] ||self.goodsType ==3 ||self.goodsType ==4) {    // 现金类型统一使用account
            self.goodsUserAccount =[dic objectForKey:@"account"];
        }
       
    }
    return self;
}


@end
