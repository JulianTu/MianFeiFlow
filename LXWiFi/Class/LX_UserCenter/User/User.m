//
//  User.m
//  TJiphone
//
//  Created by keyrun on 13-10-28.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithDictionary:(NSDictionary* )dic{
    self = [super init];
    if (self) {
        self.userBean = [[dic objectForKey:@"gold"] intValue];
        self.userHelp = [dic objectForKey:@"Help"];
        self.userLog = [[dic objectForKey:@"gold"] intValue];
        self.userIcon = [dic objectForKey:@"pic"];
        self.userId = [[dic objectForKey:@"uid"] intValue];
        self.userInvite = [[dic objectForKey:@"Invite"] intValue];
        self.userInvitedGold = [[dic objectForKey:@"InviteGold"] intValue];
        self.userMessage = [[dic objectForKey:@"message"] intValue];
        self.userName = [dic objectForKey:@"NickName"];
        self.userIsvite = [[dic objectForKey:@"isInvite"] intValue];
        
        self.giftGold =[[dic objectForKey:@"GiftGold"] intValue];       // 修改头像名字奖励
        self.appStoreAdress =[dic objectForKey:@"GetStarsForAppstore"] ;
    }
    return self;
}

@end
