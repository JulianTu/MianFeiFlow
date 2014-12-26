//
//  SysMessage.m
//  91淘金
//
//  Created by keyrun on 13-11-25.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "SysMessage.h"

@implementation SysMessage

-(id)initSysMessageByDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        self.msgId =[[dic objectForKey:@"id"]integerValue];
        self.msgCom =[dic objectForKey:@"content"];
//        self.msgCom =@"<font face=='HelveticaNeue' size=14.0 color=white>阿斯达阿大声道撒打算阿大声道撒打sadzxczad</font> <font face=='HelveticaNeue' size=14.0 color=orange> <u color=orange> <a href='http://www.baidu.com'>活动详情</font></u></a>";

        self.msgStatus =[[dic objectForKey:@"status"]integerValue];
        self.msgTime =[self changeTimeWith:[dic objectForKey:@"time"]];

        if (![[dic objectForKey:@"type"] isKindOfClass:[NSNull class]]) {
            self.type =[[dic objectForKey:@"type"]intValue];   //1 是user  0是 system
        }
        self.msgPicNum =[[dic objectForKey:@"pic_num"] intValue];
        
        self.msgJumpType = [dic objectForKey:@"pm_type"];
        
        self.msgJumpId = [[dic objectForKey:@"pm_type_id"] intValue];
        self.msgJumpUrl = [dic objectForKey:@"url"];
        
        /*
        NSLog(@"  消息pm ==%@ ",[dic objectForKey:@"pm_type"]);
        self.msgJumpType =@"奖品";
        self.msgJumpUrl =@"http://www.baidu.com";
        self.msgJumpId =1 ;
         */
    }
    return self;
}

-(NSString *)changeTimeWith:(NSString *)timestr{      //将时间转成 -月-日 
   /*
    double dtime=[timestr doubleValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:dtime];
    NSDate* nowDate=[NSDate date];

    NSTimeZone* zone=[NSTimeZone systemTimeZone];
    NSInteger interval=[zone secondsFromGMTForDate:nowDate];
    NSDate* date2 =[date dateByAddingTimeInterval:interval];

    NSString* dateStr =[date2 description];
*/
    NSArray* array =[timestr componentsSeparatedByString:@" "];
    NSString* string1 =[array objectAtIndex:0];
    NSArray* array2 =[string1 componentsSeparatedByString:@"-"];
    
    NSString* one =[array2 objectAtIndex:1];
    NSString* two =[array2 objectAtIndex:2];
    NSString* timetext =[NSString stringWithFormat:@"%@月%@日",one,two];
    return timetext;
}
@end
