//
//  DidRewardView.m
//  TJiphone
//
//  Created by keyrun on 13-9-29.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "DidRewardView.h"
//#import "TJViewController.h"
#import "StatusBar.h"
#import "LoadingView.h"
//#import "RewardListViewController.h"
#import "MyUserDefault.h"
#import "AsynURLConnection.h"
#import "LLAsynURLConnection.h"
@implementation DidRewardView
{
    UILabel* QNumberText;
    UILabel* loseJDText;
    UITextView* postAdress;
    UIImageView* title;
    UIButton* ok_btn;
    UIButton* cancle_btn;
    LoadingView* loadView;
    LoadingView* loadView2;
    NSString* showCoin;
    UIAlertView *alert;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setBasicView{
    alert = [[UIAlertView alloc]init];
    alert.title = @"兑换确认";
    alert.delegate = self;
    [alert addButtonWithTitle:@"取消"];
    [alert addButtonWithTitle:@"确定"];
    if (self.isAdress) {
        [self setView];
    }else{
        [self setViewByType];
    }
 
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self removeFromSuperview];
    }
    else if(buttonIndex==1)
    {
        [self requestToSendInfo:self.isAdress];
    }
}

-(void)setViewContent{
    NSString *name = self.goods.awardName;
    int dou = self.goods.needBean;
    alert.message = [NSString stringWithFormat:@"您确认用%d流量币兑换“%@”奖品么？",dou,name];
    [alert show];
}

-(void)setView{
    NSString *awardName = self.goods.introduce;

    showCoin =[NSString stringWithFormat:@"-%d",self.goods.needBean];
    NSString *userName =self.name;
    NSString *userAdress =self.adress;
    userAdress =[self.area stringByAppendingString:self.adress];
    NSString *userPhone =self.phoneNumber;
    alert.message = [NSString stringWithFormat:@"奖品名称：%@\n收货人：%@\n邮寄地址：%@\n手机号码：%@",awardName,userName,userAdress,userPhone];
    [alert show];
}

-(void)setViewByType{
    gift = [[UILabel alloc]initWithFrame:CGRectMake(52, title.frame.origin.y+10+title.frame.size.height+30, 240, 14)];
    gift.backgroundColor = [UIColor clearColor];
    gift.textColor = [UIColor colorWithRed:167.0/255.0 green:125.0/255.0 blue:75.0/255.0 alpha:1];
    gift.font = [UIFont systemFontOfSize:14.0];

    QNumberText = [[UILabel alloc]initWithFrame:CGRectMake(52, gift.frame.origin.y+gift.frame.size.height+10, 240, 14)];
    QNumberText.font = [UIFont systemFontOfSize:14.0];
    QNumberText.numberOfLines = 0;
    QNumberText.text = [NSString stringWithFormat:@"充值手机号:%@",self.phoneNumber];
    QNumberText.backgroundColor = [UIColor clearColor];
    QNumberText.textColor = [UIColor colorWithRed:167.0/255.0 green:125.0/255.0 blue:75.0/255.0 alpha:1];
    
    loseJDText = [[UILabel alloc]initWithFrame:CGRectMake(52, QNumberText.frame.origin.y+QNumberText.frame.size.height+10, 240, 14)];
    loseJDText.font = [UIFont systemFontOfSize:14.0];
    loseJDText.backgroundColor = [UIColor clearColor];
    loseJDText.textColor = [UIColor colorWithRed:167.0/255.0 green:125.0/255.0 blue:75.0/255.0 alpha:1];

    NSString *message;
    switch (self.type) {
        case 101:
        {

            showCoin =[NSString stringWithFormat:@"-%d",self.arg0];
            message =[NSString stringWithFormat:@"“%@”",self.chargeStyle];
            alert.message=[NSString stringWithFormat:@"兑换%@\nQQ号：%@",message,self.QNumber];
            [alert show];
            
        }
            break;
            
        case 102:{
            if (self.isRecharge) {
                NSString *string = self.rechargeType;
                int dou = self.arg0;
                showCoin = [NSString stringWithFormat:@"-%d",dou];
                message =[NSString stringWithFormat:@"“%@”",self.chargeStyle];
                alert.message = [NSString stringWithFormat:@"兑换%@\n%@号：%@",message,string,_phoneNumber];
                [alert show];
            }else{
                int dou = self.arg0;
                showCoin = [NSString stringWithFormat:@"-%d",dou];
                message =[NSString stringWithFormat:@"“%@”",self.chargeStyle];
                alert.message = [NSString stringWithFormat:@"兑换%@\n手机号：%@",message,_phoneNumber];
                [alert show];
            }
        }
            break;
        case 103:{

        }
            break;
         
        case 1:{
            showCoin =[NSString stringWithFormat:@"-%d",self.needBean];
            alert.message=[NSString stringWithFormat:@"您确认用%d流量币兑换“%@”奖品么？",self.needBean,self.goodsName];
            [alert show];
        }
            break;
    
        case 3:{
            showCoin =[NSString stringWithFormat:@"-%d",self.needBean];
            alert.message=[NSString stringWithFormat:@"您确认用%d流量币兑换“%@”奖品么？",self.needBean,self.goodsName];
            [alert show];
        }
            break;
        case 5:{
            showCoin =[NSString stringWithFormat:@"-%d",self.needBean];
            alert.message=[NSString stringWithFormat:@"您确认用%d流量币兑换“%@”奖品么？",self.needBean,self.goodsName];
            [alert show];
        }
            break;
        default:
            break;
    }
    

}

-(void)onClickBtn:(UIButton* )btn{
    self.imageView.highlighted = NO;
    btn.highlighted=YES;
    switch (btn.tag) {
        case 1:
        {
            [self requestToSendInfo:self.isAdress];
        }
            break;
        case 2:
        {
            [self removeFromSuperview];
        }
            break;
    }
}

//请求确认订单
-(void)requestToSendInfo:(BOOL)isHadAddress{
    [[LoadingView showLoadingView] actViewStartAnimation];

    NSDictionary *dic;
    if(isHadAddress){
        dic = @{ @"type":@"7", @"awardid":[NSString stringWithFormat:@"%d",self.goods.awardId], @"phone":self.phoneNumber, @"name":self.name, @"area":self.area, @"address":self.adress};
    }else{
        NSNumber *rewordTypeNum = [NSNumber numberWithInt:self.rewardType];
        switch (self.rewardType) {
            case 1:    //Q币
                dic = @{@"type":rewordTypeNum, @"qq":self.QNumber, @"num":[NSNumber numberWithInt:self.QCount],@"awardid":@"0"};
                break;
            case 2:    // 话费
                dic = @{ @"type":rewordTypeNum, @"phone":self.phoneNumber, @"num":[NSNumber numberWithInt:self.getHfInt],@"awardid":@"0" };
                break;
            case 3:      //支付宝
                dic = @{ @"type":rewordTypeNum, @"num":self.getHF ,@"account":_phoneNumber,@"awardid":@"0"};
                break;
            case 4:      //财付通
                dic = @{ @"type":rewordTypeNum, @"num":self.getHF,@"account":_phoneNumber,@"awardid":@"0"};
            case 5:      //道具
                dic = @{ @"type":rewordTypeNum, @"awardid":[NSNumber numberWithInt:self.goods.awardId],@"num":@"1"};
                break;
            case 6:      // 充值卡
                dic = @{ @"type":rewordTypeNum, @"awardid":[NSNumber numberWithInt:self.goods.awardId], @"Num":@"1"};
                break;
           
            default:
                break;
        }
    }
    NSLog(@" 请求兑换数据 == %@",dic);
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,@"award/payorder"];
    [LLAsynURLConnection requestURLWith:urlStr dataDic:dic andProtocolNum:@"30006" andTimeOut:httpTimeout connectSuccess:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@" 获取兑换请求 == %@ ",dic);
            int flag = [[dic objectForKey:@"flag"] intValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[LoadingView showLoadingView] actViewStopAnimation];
                if(flag == 1){
                    [StatusBar showTipMessageWithStatus:@"恭喜您兑换成功" andImage:nil andTipIsBottom:YES];
                    NSDictionary *dic =@{IncomeNoticKey:showCoin};
                    [[NSNotificationCenter defaultCenter] postNotificationName:ReloadIncomeLog object:nil userInfo:dic];
                    int bean=[showCoin intValue];
                    if ([showCoin intValue] < 0) {
                        bean =[showCoin intValue] *-1;
                    }
//                    long userBean = [[[MyUserDefault standardUserDefaults] getUserBeanNum] longValue] -bean;
                    NSDictionary *body =[dic objectForKey:@"body"];
                    long userBean = (long)[[body objectForKey:@"gold"] longLongValue];
                    [[MyUserDefault standardUserDefaults] setUserBeanNum:userBean];
                    
                    
                    
                    
                    [self removeFromSuperview];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeUserBean" object:nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"popview" object:nil];
                    
                }else if(flag == 2){
                    NSDictionary *body =[dic objectForKey:@"body"];
                    NSString *msg =[body objectForKey:@"msg"];
                    if ([msg isEqualToString:@"no award"]) {
                        [StatusBar showTipMessageWithStatus:@"奖品库存不足" andImage:nil andTipIsBottom:NO];
                    }else if ([msg isEqualToString:@"no orderform"]){
                        [StatusBar showTipMessageWithStatus:@"订单生成失败" andImage:nil andTipIsBottom:NO];
                    }else{
                        [StatusBar showTipMessageWithStatus:msg andImage:nil andTipIsBottom:NO];
                    }
                    [self removeFromSuperview];
                }
            });
        });
    } andFail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            [[LoadingView showLoadingView] actViewStopAnimation];
            [StatusBar showTipMessageWithStatus:@"连接超时，请稍后再试" andImage:[UIImage imageNamed:@"laba.png"] andTipIsBottom:YES];
        }
    }];
    
    
    
   /*
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"AwardUI",@"PayOrder"];
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            int flag = [[dic objectForKey:@"flag"] intValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[LoadingView showLoadingView] actViewStopAnimation];
                if(flag == 1){
                    [StatusBar showTipMessageWithStatus:@"恭喜您兑换成功" andImage:[UIImage imageNamed:@"icon_yes.png"] andCoin:showCoin andSecImage:[UIImage imageNamed:@"tipBean.png"]andTipIsBottom:YES];

                    int bean=[showCoin intValue];
                    if ([showCoin intValue] < 0) {
                        bean =[showCoin intValue] *-1;
                    }
                    long userBean = [[[MyUserDefault standardUserDefaults] getUserBeanNum] longValue] -bean;
                    [[MyUserDefault standardUserDefaults] setUserBeanNum:userBean];
                    [self removeFromSuperview];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeUserBean" object:nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"popview" object:nil];
                     
                }else if(flag == 2){
                    int message = [[dic objectForKey:@"message"] intValue];
                    switch (message) {
                        case -20006001:
                        {
                            //[StatusBar showTipMessageWithStatus:@"信息错误" andImage:nil];
                        }
                            break;
                        case -20006002:
                        {
                            [StatusBar showTipMessageWithStatus:@"报告金主,金豆不足" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
                        }
                            break;
                        case -20006003:
                        {
                            [StatusBar showTipMessageWithStatus:@"报告金主,库存不足" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
                        }
                            break;
                        case -20006004:
                        {
                            [StatusBar showTipMessageWithStatus:@"报告金主,奖品限兑" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
                        }
                            break;
                        case -20006005:
                        {
                            [StatusBar showTipMessageWithStatus:@"报告金主,奖品下架" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
                        }
                            break;
                        case -20006006:
                        {
                            [StatusBar showTipMessageWithStatus:@"报告金主,生成订单失败" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
                        }
                            break;
                        case -20006007:
                        {
                            [StatusBar showTipMessageWithStatus:@"报告金主,生成消费记录失败" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
                        }
                            break;
                    }
                    [self removeFromSuperview];
                }
            });
        });
    } fail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            [[LoadingView showLoadingView] actViewStopAnimation];
            [StatusBar showTipMessageWithStatus:@"连接超时，请稍后再试" andImage:[UIImage imageNamed:@"laba.png"] andTipIsBottom:YES];
        }
    }];
    */
}
@end
