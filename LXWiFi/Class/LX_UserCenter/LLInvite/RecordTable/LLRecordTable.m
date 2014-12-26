//
//  LLRecordTable.m
//  免费流量王
//
//  Created by keyrun on 14-10-15.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LLRecordTable.h"
#import "RecordProgressCell.h"
#import "LLAsynURLConnection.h"
#import "NSDate+nowTime.h"
#import "UIImage+ColorChangeTo.h"
#import "LoadingView.h"
#import "UIAlertView+NetPrompt.h"
#define kMissionCellH      55.0f
@implementation LLRecordTable
{
    NSArray *titles ;
    NSArray *missions;
    NSArray *records ;
    int maxCount;
    int failCount ;
    NSArray *colors ;
    CGSize maxSize ;
    NSString *maxString ;    //最长的字符
}
@synthesize haveRequest =_haveRequest;
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone ;
        self.delegate =self;
        self.dataSource =self;
//        titles = @[@"安装使用",@"领取红包",@"赚流量币",@"邀请好友",@"兑流量卡"];
        colors =@[ColorRGB(249.0, 183.0, 66.0, 1.0),ColorRGB(60.0, 182.0, 227.0, 1.0),ColorRGB(250.0, 70.0, 74.0, 1.0),ColorRGB(178.0, 212.0, 80.0, 1.0),ColorRGB(150.0, 113.0, 217.0, 1.0),ColorRGB(0.0, 214.0, 202.0, 1.0),ColorRGB(101.0, 140.0, 220.0, 1.0)];
        
        if (kmainScreenHeigh < 568.0f) {
            UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 30.0f)];
            self.tableFooterView =view ;
        }
    }
    return self;
}
-(void)initRecordBasicData{
    failCount = 0;
    missions=[[NSArray alloc] init];
    records=[[NSArray alloc] init];
    maxString =@"";
    [self performSelector:@selector(requestForRecord) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
}
/**
*  请求邀请记录
*/
-(void)requestForRecord{
    if (![[LoadingView showLoadingView] actViewIsAnimation]) {
        [[LoadingView showLoadingView] actViewStartAnimation];
    }

    NSString *UrlStr =[NSString stringWithFormat:kOnlineWeb,@"share/invite"];
    [LLAsynURLConnection requestForMethodGetWithURL:UrlStr dataDic:nil andProtocolNum:@"70005" andTimeOut:httpTimeout successBlock:^(NSData *data) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@" 获取分享记录数据 == %@ ",dataDic);
            if ([[dataDic objectForKey:@"flag"] intValue] ==1) {
                _haveRequest =YES;
                NSDictionary *body =[dataDic objectForKey:@"body"];
                missions = [body objectForKey:@"addition_mission"];
                records = [body objectForKey:@"record"];
                maxCount = [[body objectForKey:@"record_part"] intValue];
                for (NSDictionary *dic in records) {
                    NSString *string =[dic objectForKey:@"name"];
                    maxString =string.length >maxString.length ? string :maxString ;
                }
                maxSize = [maxString sizeWithFont:GetFont(14.0f) constrainedToSize:CGSizeMake(kmainScreenWidth, 15.0f)];
                NSLog(@" maxSize = %@",NSStringFromCGSize(maxSize));
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData];
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
            }
        });
      
    } andFailBlock:^(NSError *error) {
        _haveRequest =NO;
        if(error.code == timeOutErrorCode){
            if(failCount < 2){
                failCount ++;
                [self requestForRecord];
            }else{
                [[LoadingView showLoadingView] actViewStopAnimation];
                failCount = 0;
                self.tableFooterView.hidden = YES;
                if(![UIAlertView isInit]){
                    UIAlertView *alertView = [UIAlertView showNetAlert];
                    alertView.tag = kTimeOutTag;
                    alertView.delegate = self;
                    [alertView show];
                }
            }
        }else{
            [[LoadingView showLoadingView] actViewStopAnimation];
            self.tableFooterView.hidden = YES;
        }
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == kTimeOutTag){
        if(buttonIndex == 0){
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [UIAlertView resetNetAlertNil];
            [[LoadingView showLoadingView] actViewStartAnimation];
            [self requestForRecord];
        }
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return records.count + missions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 5) {
        static NSString *string = @"cellID";
        RecordProgressCell *cell =[tableView dequeueReusableCellWithIdentifier:string];
        if (!cell) {
            cell = [[RecordProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        NSDictionary *record =[records objectAtIndex:indexPath.row];
        int currentNum =[[record objectForKey:@"num"] intValue];
        NSString *title =[record objectForKey:@"name"];
        cell.lineLayer.frame = CGRectMake(kmainScreenWidth -kOffX_2_0 -10.0f -maxSize.width, cell.lineLayer.frame.origin.y, cell.lineLayer.frame.size.width, cell.lineLayer.frame.size.height);
        [cell loadProgressCellViewWith:title andColor:[colors objectAtIndex:indexPath.row] currentNum:currentNum andMaxNum:maxCount];
        
        for (UIView *currentView in cell.subviews)
        {
            if([currentView isKindOfClass:[UIScrollView class]])
            {
                ((UIScrollView *)currentView).delaysContentTouches = NO;
                break;
            }
        }
        
        return cell ;

    }else {
        static NSString *string =@"record";
        ShareRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (!cell) {
            cell = [[ShareRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        if (indexPath.row == records.count) {
            cell.isFirstOne =YES;
        }
        if (indexPath.row == missions.count +records.count -1) {
            cell.isLastOne = YES;
        }
        NSDictionary *dic =[missions objectAtIndex:indexPath.row -records.count ];
        NSString *name =[dic objectForKey:@"name"];
        int state =[[dic objectForKey:@"record"] intValue];     //是否领取
        NSString *gold = [dic objectForKey:@"gold"];
        NSString *num =[dic objectForKey:@"num"];
        cell.invisiteNum =num;
        cell.indexTag = indexPath.row ;
        [cell loadMissionCellViewWith:name andMissionState:state rewardNum:gold block:^(NSString *number,int index,NSString *rewardNum) {
            [self onClickedDoneBtn:number andCellIndex:index andReward:rewardNum];
        }];

        for (UIView *currentView in cell.subviews)
        {
            if([currentView isKindOfClass:[UIScrollView class]])
            {
                ((UIScrollView *)currentView).delaysContentTouches = NO;
                break;
            }
        }

        return cell ;
    }
}
-(void)onClickedDoneBtn:(NSString *)number andCellIndex:(int) index andReward:(NSString *)rewardNum{
    NSLog(@" 点击领取流量币  %@  %d", number,index);
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,@"share/invite"];
    long long time =[NSDate getNowTime];
    NSNumber *timeNum = [NSNumber numberWithLongLong:time];
    NSDictionary *dic =@{@"time":timeNum ,@"num":number};
    [[LoadingView showLoadingView] actViewStartAnimation];
    [LLAsynURLConnection requestURLWith:urlStr dataDic:dic andProtocolNum:@"70006" andTimeOut:httpTimeout connectSuccess:^(NSData *data) {
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           NSLog(@" 点击领取流量比奖励== %@",dataDic);
           if ([[dataDic objectForKey:@"flag"] intValue] ==1) {
               dispatch_async(dispatch_get_main_queue(), ^{
                   [[LoadingView showLoadingView] actViewStopAnimation];
                   NSIndexPath *path= [NSIndexPath indexPathForRow:index inSection:0];
                   ShareRecordCell *cell = (ShareRecordCell *)[self cellForRowAtIndexPath:path];
//                   UIButton *btn =(UIButton *)[cell viewWithTag:5300];
//                   cell.doneBtn.userInteractionEnabled =NO;
//                   [cell.doneBtn setBackgroundImage:[UIImage createImageWithColor:kLineColor2_0] forState:UIControlStateNormal];
                   cell.doneBtn.userInteractionEnabled =NO;
                   [cell.doneBtn setTitle:[NSString stringWithFormat:@"已领取"] forState:UIControlStateNormal];
                   [cell.doneBtn setTitleColor:kLineColor2_0 forState:UIControlStateNormal];
                   [cell.doneBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                   cell.doneBtn.layer.borderWidth =1.0f;
                   cell.doneBtn.layer.borderColor = kLineColor2_0.CGColor ;
                   
                   NSDictionary *dic =@{IncomeNoticKey: rewardNum};     //更新收支明细
                   [[NSNotificationCenter defaultCenter] postNotificationName:ReloadIncomeLog object:nil userInfo:dic];
               });
           }else{
               [[LoadingView showLoadingView] actViewStopAnimation];
               NSDictionary *body =[dataDic objectForKey:@"body"];
               NSLog(@" 错误信息 ==%@",[body objectForKey:@"msg"]);
           }
       });
    } andFail:^(NSError *error) {
        [[LoadingView showLoadingView] actViewStopAnimation];
    }];
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        return kMissionCellH +kOffX_2_0 ;
    }else{
        return kMissionCellH ;
    }
}


@end
