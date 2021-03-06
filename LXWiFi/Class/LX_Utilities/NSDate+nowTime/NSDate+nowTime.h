//
//  NSDate+nowTime.h
//  91TaoJin
//
//  Created by keyrun on 14-6-10.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (nowTime)
/**
 *  获取当前的毫秒数
 *
 */
+(long long int)getNowTime;

+(NSString *)changeTimeWith:(NSString *)timestr;

/**
*  时间转时间戳
*
*  @param timestr 时间字符串
*
*  @return 时间戳
*/
+(long long)getTimeLogFromTimeString:(NSString *)timestr;

@end
