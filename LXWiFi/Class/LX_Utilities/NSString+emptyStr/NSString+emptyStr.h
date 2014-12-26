//
//  NSString+emptyStr.h
//  乐享WiFi
//
//  Created by keyrun on 14-9-16.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (emptyStr)

+(BOOL)isEmptyString:(NSString *)string;

/**
 *  判断是否包含emoji表情
 *
 *  @param text 原文
 *
 */
+(BOOL)isContainsEmoji:(NSString *)text;


/**
 *  禁止输入Emoji表情符号
 *
 *  @param text         原文
 *
 */
+(NSString *)disable_emoji:(NSString *)text;

+(NSString *)toBinarySystemWithDecimalSystem:(NSString *)decimal;

//是否是纯数字
+(BOOL)isPureInt:(NSString*)string ;



@end
