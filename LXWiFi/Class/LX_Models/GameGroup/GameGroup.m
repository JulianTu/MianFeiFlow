//
//  GameGroup.m
//  TJiphone
//
//  Created by keyrun on 13-10-11.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "GameGroup.h"
#import "MyUserDefault.h"
@implementation GameGroup

//测试接口
-(id)initGameAllInfor:(NSDictionary* )gamedic andisOpen:(BOOL)openOrNot index:(int )index{
    if (self = [super init]) {
        self.appIcon = [gamedic objectForKey:@"logo"];
        self.appId = [[gamedic objectForKey:@"appid"] integerValue];
        self.appScore = [[gamedic objectForKey:@"appscore"] integerValue];
        self.appName = [gamedic objectForKey:@"appname"];
        self.appSize = [[gamedic objectForKey:@"size"] integerValue];
        self.appInfor = [gamedic objectForKey:@"talk"];
        self.appUrl = [gamedic objectForKey:@"url"];
        self.isOpen = openOrNot;
        self.giftBeanNum = [[gamedic objectForKey:@"golds"] integerValue];
        self.getBeanNum = [[gamedic objectForKey:@"joingold"] integerValue];
        self.subCells = [[NSMutableArray alloc] init];
        self.appIntroduce = [gamedic objectForKey:@"Introduce"];
        //广告主地址
        self.adUrl = [gamedic objectForKey:@"url_jump"];
        //设备唯一性回调地址
        self.udidUrl = [gamedic objectForKey:@"url_verify"];
        self.signIn = [[gamedic objectForKey:@"sign"] intValue];    //签到奖励数
        self.appdescription = [gamedic objectForKey:@"content"];
        self.schemes = [gamedic objectForKey:@"schemes"];
        self.signInState = [[gamedic objectForKey:@"signstate"] intValue];
        if(self.signIn > 0){
            [[MyUserDefault standardUserDefaults] setAppSchemesStatus:self.signInState appSchemes:self.schemes];
            if(self.signInState == 1){
                [[MyUserDefault standardUserDefaults] setAppSchemesTime:self.schemes time:0];
            }
        }else{
            [[MyUserDefault standardUserDefaults] setAppSchemesStatus:-1 appSchemes:self.schemes];
        }
        self.missionState = index;
        
        self.superLink =[[gamedic objectForKey:@"super_link"] integerValue];
//        self.superLink = 1;
    }
    return self;
}


-(id)initGameAllInfor:(NSDictionary* )gamedic andisOpen:(BOOL)openOrNot{
    if (self = [super init]) {
        self.appIcon = [gamedic objectForKey:@"AppIcon"];
        self.appId = [[gamedic objectForKey:@"AppId"] integerValue];
        self.appScore = [[gamedic objectForKey:@"AppScore"] integerValue];
        self.appName = [gamedic objectForKey:@"AppName"];
        self.appSize = [[gamedic objectForKey:@"AppSize"] integerValue];
        self.appInfor = [gamedic objectForKey:@"AppInfo"];
        self.appUrl = [gamedic objectForKey:@"AppUrl"];
        self.isOpen = openOrNot;
        self.giftBeanNum = [[gamedic objectForKey:@"GiftBeanNum"] integerValue];
        self.getBeanNum = [[gamedic objectForKey:@"GetBeanNum"] integerValue];
        self.subCells = [[NSMutableArray alloc] init];
        self.appIntroduce = [gamedic objectForKey:@"Introduce"];
        //广告主地址
        self.adUrl = [gamedic objectForKey:@"UrlJump"];
        //设备唯一性回调地址
        self.udidUrl = [gamedic objectForKey:@"UrlVerify"];
        self.signIn = [[gamedic objectForKey:@"SignIn"] intValue];
        self.appdescription = [gamedic objectForKey:@"Description"];
        self.schemes = [gamedic objectForKey:@"Schemes"];
        self.signInState = [[gamedic objectForKey:@"SignInState"] intValue];
        if(self.signIn > 0){
            [[MyUserDefault standardUserDefaults] setAppSchemesStatus:self.signInState appSchemes:self.schemes];
            if(self.signInState == 1){
                [[MyUserDefault standardUserDefaults] setAppSchemesTime:self.schemes time:0];
            }
        }else{
            [[MyUserDefault standardUserDefaults] setAppSchemesStatus:-1 appSchemes:self.schemes];
        }
        self.missionState = [[gamedic objectForKey:@"MissionState"] integerValue];
    }
    return self;
}
@end