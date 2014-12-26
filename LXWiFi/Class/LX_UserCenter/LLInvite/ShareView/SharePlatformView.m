//
//  SharePlatformView.m
//  免费流量王
//
//  Created by keyrun on 14-10-20.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "SharePlatformView.h"
#import "ShareItem.h"
#import "TaoJinButton.h"
#import "UMSocialSnsPlatformManager.h"
#import "LLAsynURLConnection.h"
#import "NSDate+nowTime.h"
#import "UMSocialSnsData.h"
#import "StatusBar.h"
#define kShareItemSize    kmainScreenWidth /3
#define kShareHeadH        40.0f
@implementation SharePlatformView
@synthesize shareTypes = _shareTypes ;
@synthesize items =_items ;
-(id)initWithFrame:(CGRect)frame andShareTypes:(NSArray *)types andImages:(NSArray *)icons titles:(NSArray *)titles rewards:(NSArray *)rewards{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor =kWitheColor ;
        _shareTypes = types ;
        _items =[[NSMutableArray alloc] init];
        UIView *headView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kShareHeadH)];
        headView.backgroundColor = kWitheColor ;
//        headView.userInteractionEnabled =NO;
        
        TaoJinLabel *label = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 11.0f) text:@"分享成功后需点击 ”返回免费流量王“ 才能确保获得流量币奖励" font:GetFont(11.0) textColor:kRedTextColor textAlignment:NSTextAlignmentCenter numberLines:1];
        [label sizeToFit];
        label.frame = CGRectMake(0, kShareHeadH/2 -label.frame.size.height/2, kmainScreenWidth, label.frame.size.height);
//        label.userInteractionEnabled =NO;
        [headView addSubview:label];
        
        CALayer *layer =[CALayer layer];
        layer.frame = CGRectMake(0,kShareHeadH - LineWidth, kmainScreenWidth, LineWidth);
        layer.backgroundColor = kLineColor2_0.CGColor ;
        [headView.layer addSublayer:layer];
        
        [self addSubview:headView];
        
        for (int i=0; i <2; i++) {
            for (int j= 0; j< 3; j++) {
                int index = 3*i +j ;
                ShareItem *item = [[ShareItem alloc] initWithFrame:CGRectMake(j* kShareItemSize, i *kShareItemSize +kShareHeadH, kShareItemSize, kShareItemSize) andIconImg:[icons objectAtIndex:index] title:[titles objectAtIndex:index] andReward:[rewards objectAtIndex:index]];
                item.tag = j+3*i + 1100;
                [self addSubview:item ];
                item.userInteractionEnabled =NO;
                [_items addObject:item];
                
                TaoJinButton *button = [[TaoJinButton alloc] initWithFrame:item.frame titleStr:nil titleColor:nil font:nil logoImg:nil backgroundImg:nil];
                button.tag = j + 3*i ;
                [button addTarget:self action:@selector(onClickedShareView:) forControlEvents:UIControlEventTouchUpInside];
                [button addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchDown];
                [button addTarget:self action:@selector(revertColor:) forControlEvents:UIControlEventTouchUpOutside];
                [button addTarget:self action:@selector(revertColor:) forControlEvents:UIControlEventTouchCancel];
                [button addTarget:self action:@selector(revertColor:) forControlEvents:UIControlEventTouchDragOutside];
                [self insertSubview:button belowSubview:item];
            }
        }
        
    }
    return self ;
}
-(void)changeColor:(UIButton* )btn{
    btn.backgroundColor = ColorRGB(246.0, 246.0, 246.0, 1.0);
}
-(void)revertColor:(UIButton* )btn{
    btn.backgroundColor =[UIColor clearColor];
}


-(void) onClickedShareView:(UIButton *)button{
    [button setBackgroundColor:[UIColor clearColor]];
    NSString *type = [_shareTypes objectAtIndex:button.tag];
    NSString *content = [self.shareContent objectForKey:@"content"];
    int shareID = [[self.shareContent objectForKey:@"id"] intValue];
    NSString *imageUrl =[self.shareContent objectForKey:@"pic"];
    NSString *shareUrl = [self.shareContent objectForKey:@"url"];
    if (shareUrl) {
        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
        [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
    }
    [UMSocialData defaultData].extConfig.qqData.title = @"免费流量王";
    [UMSocialData defaultData].extConfig.qzoneData.title = @"免费流量王";
    [UMSocialData defaultData].extConfig.qqData.qqMessageType =UMSocialQQMessageTypeDefault;
    
    UMSocialUrlResource *urlObj =nil;
    if (imageUrl) {
        urlObj= [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imageUrl];
    }
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:type];
    snsPlatform.displayName =@"免费流量王";
    if ([type isEqualToString:@"wxtimeline"]) {
        [UMSocialData defaultData].extConfig.wechatTimelineData.title =content;
    }
    NSLog(@"snsPlatform  == %@   %@  %@ %@",self.shareContent,type,snsPlatform,[UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray);
    if ([type isEqualToString:@"tencent"] && [type isEqualToString:@"sina"]) {
        [[UMSocialControllerService defaultControllerService] setShareText:content shareImage:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]] socialUIDelegate:self];
        snsPlatform.snsClickHandler(self.presentVC,[UMSocialControllerService defaultControllerService],YES);
    }else{
        NSData *data =nil;
        if ([type isEqualToString:@"tencent"] || [type isEqualToString:@"sina"]) {
            data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            urlObj =nil;
            NSString *string = [type isEqualToString:@"sina"] ? [NSString stringWithFormat:@"正在分享到新浪微博"] :[NSString stringWithFormat:@"正在分享到腾讯微博"];
            [StatusBar showTipMessageWithStatus:string andImage:nil andTipIsBottom:YES];
        }
        
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[type] content:content image:data location:nil urlResource:urlObj presentedController:self.presentVC completion:^(UMSocialResponseEntity * response){
            NSLog(@" 分享反馈  %@",response);
            if (response.responseCode == UMSResponseCodeSuccess) {
                long long time =[NSDate getNowTime];
                NSString *type;
                switch (button.tag) {
                    case 0:
                        type =@"新浪微博";
                        break;
                    case 1:
                        type =@"腾讯微博";
                        break;
                    case 2:
                        type =@"QQ空间";
                        break;
                    case 3:
                        type =@"QQ好友";
                        break;
                    case 4:
                        type =@"微信好友";
                        break;
                    case 5:
                        type =@"微信朋友圈";
                        break;
                        
                    default:
                        break;
                }
                
                NSDictionary *dic =@{@"time":[NSNumber numberWithLongLong:time] ,@"chanal":type,@"sid":[NSNumber numberWithInt:shareID]};
                failCount = 0;
                [self sendShareSuccessRequestWith:dic index:button.tag];
                NSLog(@"  分享成功 ");
            } else if(response.responseCode != UMSResponseCodeCancel) {
                [StatusBar showTipMessageWithStatus:@"分享失败，请重新分享" andImage:nil andTipIsBottom:YES];
                
            }
        }];
    }
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    if (response.responseCode == UMSResponseCodeSuccess) {
        long long time =[NSDate getNowTime];
        NSString *type = [[response.data allKeys] objectAtIndex:0];
        int index;
        if ([type isEqualToString:@"tencent"]) {
            type =@"腾讯微博";
            index =1;
        }else if ([type isEqualToString:@"sina"]){
            type =@"新浪微博";
            index =0 ;
        }else if ([type isEqualToString:@"qq"]){
            type =@"QQ好友";
            index =3;
        }else if ([type isEqualToString:@"qzone"]){
            type =@"QQ空间";
            index =2;
        }
        int shareID = [[self.shareContent objectForKey:@"id"] intValue];
        NSDictionary *dic =@{@"time":[NSNumber numberWithLongLong:time],@"chanal":type,@"sid":[NSNumber numberWithInt:shareID]};
        failCount =0 ;
        [self sendShareSuccessRequestWith:dic index:index];
        NSLog(@" 分享成功回调22 == %@",type);
    }else if(response.responseCode != UMSResponseCodeCancel) {
        [StatusBar showTipMessageWithStatus:@"分享失败，请重新分享" andImage:nil andTipIsBottom:YES];
        
    }
}
- (void) sendShareSuccessRequestWith:(NSDictionary *)dic index:(int)index{
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,@"share/content"];
    [LLAsynURLConnection requestURLWith:urlStr dataDic:dic andProtocolNum:@"70004" andTimeOut:httpTimeout connectSuccess:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@" 获取分享成功统计数据 ==%@",dataDic);
            if ([[dataDic objectForKey:@"flag"] intValue] ==1) {
                NSDictionary *body =[dataDic objectForKey:@"body"];
                int gold =[[body objectForKey:@"gold"] intValue];
                for (ShareItem *item in _items) {
                    if (item.tag == index +1100) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            item.itemShareReward.text =@"今日已分享";
                            item.itemShareReward.textColor = ColorRGB(210.0, 210.0, 211.0, 1.0) ;
                            [StatusBar showTipMessageWithStatus:@"分享成功" andImage:nil andTipIsBottom:YES];
                            NSDictionary *dic =@{IncomeNoticKey :NSStringFromInt(gold)};
                            [[NSNotificationCenter defaultCenter] postNotificationName:ReloadIncomeLog object:nil userInfo:dic];
                            
                        });
                        break;
                    }
                }
            }
        });
    } andFail:^(NSError *error) {
        failCount++;
        if (failCount <3) {
            [self sendShareSuccessRequestWith:dic index:index];
        }
        
    }];
    
}
-(void) loadSharePlatformViewWithArray:(NSArray *)names {
    for (int i=0; i <names.count; i++) {
        
    }
}
@end
