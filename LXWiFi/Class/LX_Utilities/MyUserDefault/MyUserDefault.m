//
//  MyUserDefault.m
//  91WashGold
//
//  Created by keyrun on 14-4-11.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "MyUserDefault.h"
//#import "OriginData.h"



@implementation MyUserDefault{
    NSUserDefaults *user ;
}

-(id)init{
    user = [NSUserDefaults standardUserDefaults];
    return self;
}
-(BOOL)synchronize{
    return [user synchronize];
}
//使用单例
+(id)standardUserDefaults{
    static MyUserDefault *myUser = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        myUser = [[self alloc] init];
    });
    return myUser;
}

//设置和获取UserNickname
-(void)setUserNickname:(NSString *)userNickname{
    [user setObject:userNickname forKey:@"UserNickname"];
}

-(NSString *)getUserNickname{
    NSString *userName = [user objectForKey:@"UserNickname"];
    if(userName == nil){
        userName = @"";
    }
    return userName;
}

//设置和获取sid
-(void)setSid:(NSString *)sid{
    [user setObject:sid forKey:@"sid"];
    [user synchronize];
}

-(NSString *)getSid{
    return [user objectForKey:@"sid"];
}

//设置和获取Update
-(void)setUpdate:(NSDictionary *)update{
    [user setObject:update forKey:@"Update"];
}

-(NSDictionary *)getUpdate{
    return [user dictionaryForKey:@"Update"];
}

//设置和获取appVersion
-(void)setAppVersion:(NSString *)appVersion{
    [user setObject:appVersion forKey:@"appVersion"];
}
-(NSString *)getAppVersion{
    return [user objectForKey:@"appVersion"];
}

//设置和获取UserLocking
-(void)setUserLocking:(int)userLocking{
    [user setObject:[NSNumber numberWithInt:userLocking] forKey:@"UserLocking"];
}
-(NSNumber *)getUserLocking{
    return [user objectForKey:@"UserLocking"];
}

//设置和获取userBeanNum
-(void)setUserBeanNum:(long)userBeanNum{
    [user setObject:[NSNumber numberWithLong:userBeanNum] forKey:@"userBeanNum"];
}
-(NSNumber *)getUserBeanNum{
    return [user objectForKey:@"userBeanNum"];
}

//设置和获取UserSetNameGold
-(void)setUserSetNameGold:(int)userSetNameGold{
    [user setObject:[NSNumber numberWithInt:userSetNameGold] forKey:@"UserSetNameGold"];
}
-(NSNumber *)getUserSetNameGold{
    return [user objectForKey:@"UserSetNameGold"];
}

//设置和获取UserId
-(void)setUserId:(NSString *)userId{
    [user setObject:userId forKey:@"UserId"];
}
-(NSString *)getUserId{
    return [user objectForKey:@"UserId"];
}

//设置和获取JFQIsCheck
-(void)setJFQIsCheck:(int)JFQIsCheck{
    [user setObject:[NSNumber numberWithInt:JFQIsCheck] forKey:@"JFQIsCheck"];
}
-(NSNumber *)getJFQIsCheck{
    return [user objectForKey:@"JFQIsCheck"];
}

//设置和获取token
-(void)setToken:(NSString *)token{
    [user setObject:token forKey:@"token"];
}
-(NSString *)getToken{
    return [user objectForKey:@"token"];
}

//设置和获取InviteGold
-(void)setInviteGold:(int )inviteGold{
    [user setObject:[NSNumber numberWithInt:inviteGold] forKey:@"UserInviteGold"];
}
-(NSNumber *)getInviteGold{
    return [user objectForKey:@"UserInviteGold"];
}

//设置和获取updateDelayTime
-(void)setUpdateDelayTime:(int )updateDelayTime{
    [user setObject:[NSNumber numberWithInt:updateDelayTime] forKey:@"updateDelayTime"];
}
-(NSNumber *)getUpdateDelayTime{
    return [user objectForKey:@"updateDelayTime"];
}

//设置和获取LoginTime
-(void)setLoginTime:(NSNumber *)loginTime{
    [user setObject:loginTime forKey:@"LoginTime"];
}
-(NSNumber *)getLoginTime{
    return [user objectForKey:@"LoginTime"];
}

//设置和获取Logined
-(void)setLogined:(BOOL )Logined{
    [user setObject:[NSNumber numberWithBool:Logined] forKey:@"Logined"];
}
-(NSNumber *)getLogined{
    return [user objectForKey:@"Logined"];
}

//设置和获取AppUseTime
-(void)setAppUseTime:(int )appUseTime{
    [user setObject:[NSNumber numberWithDouble:appUseTime] forKey:@"AppUseTime"];
}
-(NSNumber *)getAppUseTime{
    return [user objectForKey:@"AppUseTime"];
}

//设置和获取NetWork
-(void)setNetWork:(int )netWork{
    [user setObject:[NSNumber numberWithInt:netWork] forKey:@"NetWork"];
}
-(NSNumber *)getNetWork{
    return [user objectForKey:@"NetWork"];
}

//设置和获取Did
-(void)setDid:(int)did{
    [user setObject:[NSNumber numberWithInt:did] forKey:@"Did"];
}
-(NSNumber *)getDid{
    return [user objectForKey:@"Did"];
}

//设置和获取userDeviceToken
-(void)setUserDeviceToken:(NSString *)userDeviceToken{
    [user setObject:userDeviceToken forKey:@"userDeviceToken"];
}
-(NSString *)getUserDeviceToken{
    return [user objectForKey:@"userDeviceToken"];
}

//设置和获取isRegistRemotion
-(void)setIsRegistRemotion:(BOOL )isRegistRemotion{
    [user setObject:[NSNumber numberWithBool:isRegistRemotion] forKey:@"isRegistRemotion"];
}
-(NSNumber *)getIsRegistRemotion{
    return [user objectForKey:@"isRegistRemotion"];
}

//设置和获取RewardContent
-(void)setRewardContent:(NSString *)rewardContent{
    [user setObject:rewardContent forKey:@"RewardContent"];
}
-(NSString *)getRewardContent{
    return [user objectForKey:@"RewardContent"];
}

//设置和获取userQNum
-(void)setUserQNum:(NSString *)userQNum{
    [user setObject:userQNum forKey:@"userQNum"];
}
-(NSString *)getUserQNum{
    return [user objectForKey:@"userQNum"];
}

//设置和获取userZFB
-(void)setUserZFB:(NSString *)userZFB{
    [user setObject:userZFB forKey:@"userZFB"];
}
-(NSString *)getUserZFB{
    return [user objectForKey:@"userZFB"];
}

//设置和获取userCFT
-(void)setUserCFT:(NSString *)userCFT{
    [user setObject:userCFT forKey:@"userCFT"];
}
-(NSString *)getUserCFT{
    return [user objectForKey:@"userCFT"];
}

//设置和获取userPhoneNum
-(void)setUserPhoneNum:(NSString *)userPhoneNum{
    [user setObject:userPhoneNum forKey:@"userPhoneNum"];
}
-(NSString *)getUserPhoneNum{
    return [user objectForKey:@"userPhoneNum"];
}

//设置和获取回复输入框的内容
-(void)setReplyContent:(NSString *)replyContent time:(NSString *)time{
    [user setObject:replyContent forKey:[NSString stringWithFormat:@"replyContent%@",time]];
}
-(NSString *)getReplyContent:(NSString *)time{
    return [user objectForKey:[NSString stringWithFormat:@"replyContent%@",time]];
}

//设置和获取
-(void)setTopIdReplyContent:(NSDictionary *)dic topicId:(int)topicId addedReplyCellTag:(int)addedReplyCellTag indexNum:(int)indexNum{
    [user setObject:dic forKey:[NSString stringWithFormat:@"topicId%d%d%d",topicId,addedReplyCellTag,indexNum]];
}
-(NSDictionary *)getTopIdReplyContent:(int)topicId addedReplyCellTag:(int)addedReplyCellTag indexNum:(int)indexNum{
    return [user objectForKey:[NSString stringWithFormat:@"topicId%d%d%d",topicId,addedReplyCellTag,indexNum]];
}

//设置和获取UserTopicText
//-(void)setUserTopicText:(NSString *)userTopicText topicType:(topicTypeEnum)topicType{
//    [user setObject:userTopicText forKey:[NSString stringWithFormat:@"UserTopicText%d",topicType]];
//}
//-(NSString *)getUserTopicText:(topicTypeEnum)topicType{
//    return [user objectForKey:[NSString stringWithFormat:@"UserTopicText%d",topicType]];
//}

//设置和获取lasttime
-(void)setLasttime:(int)lasttime{
    [user setObject:[NSNumber numberWithInt:lasttime] forKey:@"lasttime"];
}
-(NSNumber *)getLasttime{
    return [user objectForKey:@"lasttime"];
}

//设置和获取TopicReplyNumber
-(void)setTopicReplyNumber:(int )topicReplyNumber{
    [user setObject:[NSNumber numberWithInt:topicReplyNumber] forKey:@"TopicReplyNumber"];
}
-(NSNumber *)getTopicReplyNumber{
    return [user objectForKey:@"TopicReplyNumber"];
}

//设置和获取MyCommentNumber
-(void)setMyCommentNumber:(int )commentNumber {
    [user setObject:[NSNumber numberWithInt:commentNumber] forKey:@"MyCommentNumber"];
}
-(NSNumber *)getMyCommentNumber{
    return [user objectForKey:@"MyCommentNumber"];
}

////设置和获取oldReplyNum
//-(void)setOldReplyNum:(int)oldReplyNum tid:(int)tid{
//    [user setObject:[NSNumber numberWithInt:oldReplyNum] forKey:[NSString stringWithFormat:@"%@%d", kRecordMyTopicID, tid]];
//}
//-(NSNumber *)getOldReplyNum:(int)tid{
//    return [user objectForKey:[NSString stringWithFormat:@"%@%d", kRecordMyTopicID, tid]];
//}

//设置和获取userPic
-(void)setUserPic:(NSData *)userPic{
    [user setObject:userPic forKey:@"userPic"];
}
-(NSData *)getUserPic{
    return [user objectForKey:@"userPic"];
}

//设置和获取UserLog
-(void)setUserLog:(int)userLog{
    [user setObject:[NSNumber numberWithInt:userLog] forKey:@"UserLog"];
}
-(NSNumber *)getUserLog{
    return [user objectForKey:@"UserLog"];
}

//设置和获取userInviteCount
-(void)setUserInviteCount:(int)userInviteCount{
    [user setObject:[NSNumber numberWithInt:userInviteCount] forKey:@"userInviteCount"];
}
-(NSNumber *)getUserInviteCount{
    return [user objectForKey:@"userInviteCount"];
}

//设置和获取userMsgNum
-(void)setUserMsgNum:(int)userMsgNum{
    [user setObject:[NSNumber numberWithInt:userMsgNum] forKey:@"userMsgNum"];
}
-(NSNumber *)getUserMsgNum{
    return [user objectForKey:@"userMsgNum"];
}

//设置和获取daTingRefreshTime
-(void)setDaTingRefreshTime:(NSNumber *)daTingRefreshTime{
    [user setObject:daTingRefreshTime forKey:@"daTingRefreshTime"];
}
-(NSNumber *)getDaTingRefreshTime{
    return [user objectForKey:@"daTingRefreshTime"];
}

//设置和获取rewordRefreshTime
-(void)setRewordRefreshTime:(NSNumber *)rewordRefreshTime{
    [user setObject:rewordRefreshTime forKey:@"rewordRefreshTime"];
}
-(NSNumber *)getRewordRefreshTime{
    return [user objectForKey:@"rewordRefreshTime"];
}

//设置和获取hotTopicRefreshTime
-(void)setHotTopicRefreshTime:(NSNumber *)hotTopicRefreshTime{
    [user setObject:hotTopicRefreshTime forKey:@"hotTopicRefreshTime"];
}
-(NSNumber *)getHotTopicRefreshTime{
    return [user objectForKey:@"hotTopicRefreshTime"];
}

//设置和获取newestTopicRefreshTime
-(void)setNewestTopicRefreshTime:(NSNumber *)newestTopicRefreshTime{
    [user setObject:newestTopicRefreshTime forKey:@"newestTopicRefreshTime"];
}
-(NSNumber *)getNewestTopicRefreshTime{
    return [user objectForKey:@"newestTopicRefreshTime"];
}

//设置和获取UserSubmitOpinionText
-(void)setUserSubmitOpinionText:(NSString *)userSubmitOpinionText{
    [user setObject:userSubmitOpinionText forKey:@"UserSubmitOpinionText"];
}
-(NSString *)getUserSubmitOpinionText{
    return [user objectForKey:@"UserSubmitOpinionText"];
}


//设置和获取 userIconUrl
-(void)setUserIconUrlStr:(NSString *)userIconUrl{
    [user setObject:userIconUrl forKey:@"UserIconUrl"];
}
-(NSString *)getUserIconUrl{
    NSString *iconUrl = [user objectForKey:@"UserIconUrl"] ;
    if(iconUrl == nil){
        iconUrl = @"";
    }
    return iconUrl ;
}

//设置和获取 提问内容
-(void) setUserAskStr: (NSDictionary *)userAskStr{
    [user setObject:userAskStr forKey:@"UserAskStr"];
}
-(NSDictionary *) getuserAskStr{
    return  [user objectForKey:@"UserAskStr"];
}

//设置和获取【晒单有奖】是否已经下拉晒单广场
-(void)setIsHavePullShowPosts:(NSNumber *)isHavePullShowPosts{
    [user setObject:isHavePullShowPosts forKey:@"IsHavePullShowPosts"];
}

-(NSNumber *)getIsHavePullShowPosts{
    return [user objectForKey:@"IsHavePullShowPosts"];
}

//设置和获取【晒单有奖】是否已经下拉我的晒单
-(void)setIsHavePullMyPosts:(NSNumber *)isHavePullMyPosts{
    [user setObject:isHavePullMyPosts forKey:@"IsHavePullMyPosts"];
}

-(NSNumber *)getIsHavePullMyPosts{
    return [user objectForKey:@"IsHavePullMyPosts"];
}
//设置和获取【摇一摇】当前是否已经摇过(value的格式为：yyyyMMdd)
-(void)setYaoYiYaoDateStr:(NSString *)dateStr{
    [user setObject:dateStr forKey:@"YaoYiYao"];
}

-(NSString *)getYaoYiYaoDateStr{
    return [user objectForKey:@"YaoYiYao"];
}

//设置和获取 免责声明 是否已经显示
-(void)setIsShowDutyView:(NSNumber *) isShow{
    [user setObject:isShow forKey:@"IsShowDutyView"];
}
-(NSNumber *)getIsShowDutyView{
    return [user objectForKey:@"IsShowDutyView"] ;
}


//设置和获取  由兑换列表返回到兑换中心 重新请求数据
-(void) setIsNeedReloadRV:(NSNumber *)isNeed {
    [user setObject:isNeed forKey:@"IsNeedReload"];
}
-(NSNumber *)getIsNeedReloadRV{
    return [user objectForKey:@"IsNeedReload"];
}

//设置和获取 评论活动成功保存 评论内容
-(void) setPinLunLocationData:( NSDictionary *)dic{
    [user setObject:dic forKey:@"PinLunLocationData"];
}
-(NSDictionary *)getPinLunLocationData{
    return [user objectForKey:@"PinLunLocationData"];
}

//设置和获取appstore 地址
-(void) setAppStoreAdress :(NSString *)adress{
    [user setObject:adress forKey:@"AppStoreAdress"];
}
-(NSString *)getAppStoreAdress {
    return [user objectForKey:@"AppStoreAdress"];
}

//设置和获取是否需要显示【免责声明】
-(void)setIsNeedDutyView:(NSNumber *)isNeed{
    [user setObject:isNeed forKey:@"IsNeedDutyView"];
}

-(NSNumber *)getIsNeedDutyView{
    return [user objectForKey:@"IsNeedDutyView"];
}

//设置和获取 活动中心免责显示
-(void) setActiveCenterDutyShow :(NSNumber *) show{
    [user setObject:show forKey:@"ActiveCenterDutyShow"];

}
-(NSNumber *)getActiveCenterDutyShow{
    return [user objectForKey:@"ActiveCenterDutyShow"];
}

//设置和获取晒单有奖 免责显示
-(void) setShaiDanCenterDutyShow :(NSNumber *) show{
    [user setObject:show forKey:@"ShaiDanCenterDutyShow"];
}
-(NSNumber *)getShaiDanCenterDutyShow{
    return [user objectForKey:@"ShaiDanCenterDutyShow"];
}

//设置和获取 分享有奖 免责显示
-(void) setShareCenterDutyShow :(NSNumber *) show{
    [user setObject:show forKey:@"ShareCenterDutyShow"];
}
-(NSNumber *)getShareCenterDutyShow{
    return [user objectForKey:@"ShareCenterDutyShow"];
}

//设置和获取 md5userDeveiceToken
-(void) setUserMd5DeveiceToken :(NSString *)token{
    [user setObject:token forKey:@"UserMd5DeveiceToken"];
}
-(NSString *)getUserMd5DeveiceToken {
    return [user objectForKey:@"UserMd5DeveiceToken"];
}

//设置和获取 百度push id
-(void) setBDUserPushId:(NSString *)pushid{
    [user setObject:pushid forKey:@"BDUserPushId"];
}
-(NSString *)getBDUserPushId {
    return [user objectForKey:@"BDUserPushId"];
}

//设置和获取 当前进入app的schemes
-(void)setAppSchemes:(NSString *)schemes{
    [user setObject:schemes forKey:@"APP_SCHEMES"];
}
-(NSString *)getAppSchemes{
    return [user objectForKey:@"APP_SCHEMES"];
}

//设置和获取 schemes对应的appId
-(void)setAppSchemesAppId:(NSString *)appId schemes:(NSString *)schemes{
    [user setObject:appId forKey:[NSString stringWithFormat:@"APPID_%@",schemes]];
}
-(NSString *)getAppAppIdWithSchemes:(NSString *)schemes{
    return [user objectForKey:[NSString stringWithFormat:@"APPID_%@",schemes]];
}

//设置和获取 某一个app的后台签到时间长度
-(void) setAppSchemesTime:(NSString *)schemes time:(NSNumber *)time{
    [user setObject:time forKey:[NSString stringWithFormat:@"APP_%@",schemes]];
}
-(NSNumber *)getAppSchemesTime:(NSString *)schemes{
    return [user objectForKey:[NSString stringWithFormat:@"APP_%@",schemes]];
}

//设置和获取 某一个app是否已经签到
-(void) setAppSchemesStatus:(int)status appSchemes:(NSString *)appSchemes{
    [user setObject:[NSNumber numberWithInt:status] forKey:[NSString stringWithFormat:@"APP%@_Status",appSchemes]];
}

-(NSNumber *)getAppSchemesStatus:(NSString *)appSchemes{
    return [user objectForKey:[NSString stringWithFormat:@"APP%@_Status",appSchemes]];
}

//设置和获取 是否需要显示【活动中心】的4个按钮
-(void) setIsNeedActivityView:(NSNumber *)isNeed{
    [user setObject:isNeed forKey:@"IsNeedActivityView"];
}
-(NSNumber *) getIsNeedActivityView{
    return [user objectForKey:@"IsNeedActivityView"];
}

//设置和获取 保存晒单详情评论的输入框内容
-(void) setShowPostsComment:(NSString *)comment{
    [user setObject:comment forKey:@"ShowPostsComment"];
}
-(NSString *)getShowPostsComment{
    return [user objectForKey:@"ShowPostsComment"];
}
//设置和获取 筛选好的相片
-(void) setUserSortedPhoto:(NSMutableArray *)array{
    [user setObject:array forKey:@"UserSortedPhoto"];
}
-(NSMutableArray *)getUserSortedPhoto{
    return [user objectForKey:@"UserSortedPhoto"];
}

// 设置和获取 用户邀请码
-(void) setUserInvcode:(NSString *)userInvcode{
    [user setObject:userInvcode forKey:@"UserInvcode"];
}
-(NSString *)getUserInvcode{
    return [user objectForKey:@"UserInvcode"];
}

// 设置和获取 当前晒单活动是显示【我的晒单】还是【晒单广场】
-(void) setShowPostsType:(int)type{
    [user setObject:[NSNumber numberWithInt:type] forKey:@"PostType"];
}

-(NSNumber *) getShowPostsType{
    NSNumber *type = [user objectForKey:@"PostType"];
    return type;
}

// 设置和获取 签到时间
-(void) setSignFreshTime:(NSNumber *)signFreshTime{
    [user setObject:signFreshTime forKey:@"SignFreshTime"];
}

-(NSNumber *) getSignFreshTime{
    return [user objectForKey:@"SignFreshTime"];
}

// 设置和获取 主界面切换的刷新间隔时间
-(void) setViewFreshTime:(NSNumber *)viewFreshTime{
    [user setObject:viewFreshTime forKey:@"ViewFreshTime"];
}

-(NSNumber *) getViewFreshTime{
    return [user objectForKey:@"ViewFreshTime"];
}

// 设置和获取 是否点击【安装/打开】按钮
-(void) setIsOpenApp:(BOOL) isOpenApp{
    [user setObject:[NSNumber numberWithBool:isOpenApp] forKey:@"IsOpenApp"];
}
-(BOOL) getIsOpenApp{
    return [[user objectForKey:@"IsOpenApp"] boolValue];
}


// 设置和获取 乐透竞彩 所有图片对象
-(void) setLotteryImgsObj:(NSMutableArray *)array{
    [user setObject:array forKey:@"LotteryImgsObj"];
}
-(NSMutableArray *)getLotteryImgsObj{
    return [user objectForKey:@"LotteryImgsObj"];
}

// 设置和获取 乐透竞猜 图片数据
-(void) setLotteryImgsData:(NSMutableArray *)datas{
    [user setObject:datas forKey:@"LotteryImgsData"];
}
-(NSMutableArray *) getLotteryImgsData{
    return [user objectForKey:@"LotteryImgsData"];
}

// 设置获取cookieSid
-(void) setCookieSid:(NSString *)cookieSid{
    [user setObject:cookieSid forKey:@"CookieSid"];
    [user synchronize];
}
-(NSString *) getCookieSid {
    return [user objectForKey:@"CookieSid"];
}

//设置和获取 上次自动链接的时间
-(void)setLastSuperLinkTime:(NSNumber *)time{
    [user setObject:time forKey:@"LastSuperLink"];
}
-(NSNumber *)getLastSuperLinkTime{
    return [user objectForKey:@"LastSuperLink"];
}

// 设置和获取 欢迎页图片数据
-(void) setWelcomeImgData:(NSData *)data{
    [user setObject:data forKey:@"WelcomeImg"];
    [user synchronize];
}
-(NSData *)getWelcomeImgData {
    return [user objectForKey:@"WelcomeImg"];
}
// 设置和获取 欢迎页图片数据2
-(void) setWelcomeImgData2:(NSData *)data{
    [user setObject:data forKey:@"WelcomeImg2"];
    [user synchronize];
}
-(NSData *)getWelcomeImgData2 {
    return [user objectForKey:@"WelcomeImg2"];
}

//设置和获取 欢迎页所以数据
-(void) setWelcomeImgDic:(NSDictionary *)dic{
    [user setObject:dic forKey:@"WelcomeImgDic"];
    [user synchronize];
}
-(NSDictionary *) getWelcomImgDic{
    return [user objectForKey:@"WelcomeImgDic"];
}

//设置和获取 欢迎页所以数据2
-(void) setWelcomeImgDic2:(NSDictionary *)dic{
    [user setObject:dic forKey:@"WelcomeImgDic2"];
    [user synchronize];
}
-(NSDictionary *) getWelcomImgDic2{
    return [user objectForKey:@"WelcomeImgDic2"];
}

//设置和获取 欢迎页图片地址
-(void) setWelcomeImgUrl:(NSString *)url{
    [user setObject:url forKey:@"WelcomeImgUrl"];
    [user synchronize];
}
-(NSString *) getWelcomeImgUrl{
    return [user objectForKey:@"WelcomeImgUrl"];
}

//设置和获取 执行过超链接的app 数组
-(void) setHaveDoneSuperLinked:(NSMutableArray *)array{
    [user setObject:array forKey:@"HaveDoneSuperLinked"];
}
-(NSMutableArray *) getHaveDoneSuperLinked{
    return [user objectForKey:@"HaveDoneSuperLinked"];
}

-(void) setRequestCodeKey:(NSString *)key {
    [user setObject:key forKey:@"CodeKey"];
}
-(NSString *)getRequestCodeKey{
    return [user objectForKey:@"CodeKey"];
}
//设置和获取  是否已经展示欢迎页
-(void) setIsShowedWelcome:(NSNumber *) isShowed{
    [user setObject:isShowed forKey:@"WelcomeIsShowed"];
}
-(NSNumber *)getIsShowWelcome{
    return [user objectForKey:@"WelcomeIsShowed"];
}

//设置和获取 sandbox里面的用户标示
-(void) setSandBoxUserToken:(NSString *)userToken{
    [user setObject:userToken forKey:@"SandBoxToken"];
    [user synchronize];
}
-(NSString *)getSandBoxUserToken{
    return [user objectForKey:@"SandBoxToken"];
}

//设置和获取 用户是否已经领取红包
-(void) setUserDidGetHongBao:(NSNumber *) getted {
    [user setObject:getted forKey:@"DidGetHongBao"];
}
-(NSNumber *)getUserDidGetHongBao{
    return [user objectForKey:@"DidGetHongBao"];
}

//设置和获取 号码段
-(void) setSystemPhoneCarrier:(NSDictionary *)array{
    [user setObject:array forKey:@"PhoneCarrier"];
}
-(NSDictionary *) getSystemPhoneCarrier{
     return [user objectForKey:@"PhoneCarrier"];
}

//设置和获取 图片服务器地址
-(void) setPhotoServiceAdress:(NSString *)adressStr{
    [user setObject:adressStr forKey:@"ServicePhotoAdress"];
}
-(NSString *) getPhotoServiceAdress{
    return [user objectForKey:@"ServicePhotoAdress"];
}

//设置和获取 app声明地址
- (void)setAppDeclareURL:(NSString *)appDeclare {
    [user setObject:appDeclare forKey:@"AppDeclare"];
}
-(NSString *)getAppDeclare {
    return [user objectForKey:@"AppDeclare"];
}

//设置和获取 app常见问题地址
-(void)setAppCommentQuestionURL:(NSString *)questionUrl{
    [user setObject:questionUrl forKey:@"AppCommentQuestion"];
}
-(NSString *)getAppCommentQuestion{
    return [user objectForKey:@"AppCommentQuestion"];
}
@end











