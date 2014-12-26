//
//  SysMessage.h
//  91淘金
//
//  Created by keyrun on 13-11-25.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    MessageTypeOther =0 ,
    MessageTypeMe =1
    
} MessageType;

@interface SysMessage : NSObject

@property (nonatomic ,assign) int msgId;
@property (nonatomic, strong) NSString* msgCom;
@property (nonatomic, assign) int msgStatus;
@property (nonatomic, strong) NSString* msgTime;
@property (nonatomic ,assign) MessageType type;
@property (nonatomic ,assign) int msgPicNum;       //图片数

@property (nonatomic ,strong) NSString *superLink;

@property (nonatomic ,strong) NSString *msgJumpType ;  //跳转类型
@property (nonatomic ,assign) int msgJumpId;           //跳转id
@property (nonatomic ,strong) NSString *msgJumpUrl ;   //跳转活动页面url
-(id)initSysMessageByDic:(NSDictionary*)dic;
@end
