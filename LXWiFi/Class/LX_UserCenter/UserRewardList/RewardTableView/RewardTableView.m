//
//  RewardTableView.m
//  免费流量王
//
//  Created by keyrun on 14-10-27.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "RewardTableView.h"
#import "TablePullToLoadingView.h"
#import "ViewTip.h"
#import "LoadingView.h"
#import "AsynURLConnection.h"
#import "MyUserDefault.h"
#import "UIAlertView+NetPrompt.h"
#import "RewardListCell.h"
#import "LLAsynURLConnection.h"
@implementation RewardTableView
{
    NSMutableArray *_allLogs;                                //记录获取到用户记录
    
    int page;
    int curPage;
    int maxPage;
    int timeOutCount;                                       //连接超时次数
    
    BOOL isFrist;
    RewardType _type ;

}
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        [self setSeparatorColor:[UIColor clearColor]];
        //解决ios7tableviewcell 分割线的问题
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        
        self.delaysContentTouches =NO;
        TablePullToLoadingView *loadingView = [[TablePullToLoadingView alloc] init];
        self.tableFooterView = loadingView;
        self.tableFooterView.hidden = YES;
        
        self.sectionIndexColor = nil;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedScreen)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(void) onClickedScreen{
    [self.rewardTabDelegate scrollToCloseTypeChoose];
}
-(void)initObjectsWithRewardType:(RewardType)type{
    page = 1;
    curPage = 0;
    maxPage = 0;
    timeOutCount = 0;
    isFrist = true;
    _type =type ;
    [self performSelector:@selector(requestForRewardList) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
    
    
}
-(void) requestForRewardList{
    if (isFrist) {
        if ([[LoadingView showLoadingView] actViewIsAnimation]) {
            [[LoadingView showLoadingView] actViewStopAnimation];
        }
        [[LoadingView showLoadingView] actViewStartAnimation];
        isFrist = NO;
    }
    NSString* name;
    switch (_type) {
        case RewardTypeAll:
            name =@"all";
            break;
        case RewardTypeFlow:
            name =@"liuliang";
            break;
        case RewardTypeCash:
            name = @"xianjin";
             break;
        case RewardTypePhone:
            name =@"huafei";
             break;
        case RewardTypeQCoin:
            name =@"qbi";
             break;
        case RewardTypeGoods:
            name =@"jiangpin";
             break;
        default:
            break;
    }
    NSString *string =[NSString stringWithFormat:kOnlineWeb,@"award/payorder/"];
    NSString *urlStr =[NSString stringWithFormat:@"%@%@/%d",string,name,page];
    [LLAsynURLConnection requestForMethodGetWithURL:urlStr dataDic:nil andProtocolNum:@"30007" andTimeOut:httpTimeout successBlock:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求获取【兑奖中心】列表【response】 = %@",dataDic);
            timeOutCount = 0;
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                if(body != nil){
                    curPage = [[body objectForKey:@"curpage"] intValue];
                    maxPage = [[body objectForKey:@"maxpage"] intValue];
                    int maxNum = [[body objectForKey:@"maxnum"] intValue];
                    if(maxNum == 0){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.tableFooterView.hidden = YES;
                            [[LoadingView showLoadingView] actViewStopAnimation];
                            [self showTipView];
                        });
                    }else{
                        NSArray *orders = [body objectForKey:@"lists"];
                        if(orders != nil && orders.count > 0 && curPage == page){
                            page ++;
                            if(_allLogs == nil){
                                _allLogs = [[NSMutableArray alloc] initWithArray:orders];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.tableFooterView.hidden = YES;
                                    [[LoadingView showLoadingView] actViewStopAnimation];
                                    [self reloadData];
                                });
                            }else{
                                NSMutableArray *paths =[[NSMutableArray alloc] init];
                                for (int i=0; i< orders.count; i++) {
                                    [paths addObject:[NSIndexPath indexPathForRow:_allLogs.count+i inSection:0]];
                                }
                                [_allLogs insertObjects:orders atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_allLogs.count, orders.count)]];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.tableFooterView.hidden = YES;
                                    [self beginUpdates];
                                    [self insertRowsAtIndexPaths:[NSArray arrayWithArray:paths] withRowAnimation:UITableViewRowAnimationNone];
                                    [self endUpdates];
                                    [[LoadingView showLoadingView] actViewStopAnimation];
                                    
                                });
                                
                            }
                        }
                        
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.tableFooterView.hidden = YES;
                        [[LoadingView showLoadingView] actViewStopAnimation];
                        [self reloadData];
                    });
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.tableFooterView.hidden = YES;
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
            }
        });

    } andFailBlock:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            if (timeOutCount < 2) {
                [self requestForRewardList];
            }else{
                self.tableFooterView.hidden = YES;
                [[LoadingView showLoadingView] actViewStopAnimation];
                timeOutCount = 0;
                if(![UIAlertView isInit]){
                    UIAlertView *alertView = [UIAlertView showNetAlert];
                    alertView.tag = kTimeOutTag;
                    alertView.delegate = self;
                    [alertView show];
                }
            }
        }

    }];
}

//请求获取【兑奖中心】列表
-(void)requestToGetRewardList{
    if (isFrist) {
        [[LoadingView showLoadingView] actViewStartAnimation];
        isFrist = NO;
    }
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid, @"PageNum":[NSNumber numberWithInt:page]};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"AwardUI",@"GetAwardRecord"];
    NSLog(@"请求获取【兑奖中心】列表【urlStr】 = %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求获取【兑奖中心】列表【response】 = %@",dataDic);
            timeOutCount = 0;
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                if(body != nil){
                    curPage = [[body objectForKey:@"CurPage"] intValue];
                    maxPage = [[body objectForKey:@"MaxPage"] intValue];
                    int maxNum = [[body objectForKey:@"MaxNum"] intValue];
                    if(maxNum == 0){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.tableFooterView.hidden = YES;
                            [[LoadingView showLoadingView] actViewStopAnimation];
                            [self showTipView];
                        });
                    }else{
                        NSArray *orders = [body objectForKey:@"Orders"];
                        if(orders != nil && orders.count > 0 && curPage == page){
                            page ++;
                            if(_allLogs == nil){
                                _allLogs = [[NSMutableArray alloc] initWithArray:orders];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.tableFooterView.hidden = YES;
                                    [[LoadingView showLoadingView] actViewStopAnimation];
                                    [self reloadData];
                                });
                            }else{
                                NSMutableArray *paths =[[NSMutableArray alloc] init];
                                for (int i=0; i< orders.count; i++) {
                                    [paths addObject:[NSIndexPath indexPathForRow:_allLogs.count+i inSection:0]];
                                }
                                [_allLogs insertObjects:orders atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_allLogs.count, orders.count)]];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.tableFooterView.hidden = YES;
                                    [self beginUpdates];
                                    [self insertRowsAtIndexPaths:[NSArray arrayWithArray:paths] withRowAnimation:UITableViewRowAnimationNone];
                                    [self endUpdates];
                                    [[LoadingView showLoadingView] actViewStopAnimation];
                                    
                                });
                                
                            }
                        }
                        
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.tableFooterView.hidden = YES;
                        [[LoadingView showLoadingView] actViewStopAnimation];
                        [self reloadData];
                    });
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.tableFooterView.hidden = YES;
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
            }
        });
    } fail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            if (timeOutCount < 2) {
                [self requestToGetRewardList];
            }else{
                self.tableFooterView.hidden = YES;
                [[LoadingView showLoadingView] actViewStopAnimation];
                timeOutCount = 0;
                if(![UIAlertView isInit]){
                    UIAlertView *alertView = [UIAlertView showNetAlert];
                    alertView.tag = kTimeOutTag;
                    alertView.delegate = self;
                    [alertView show];
                }
            }
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == kTimeOutTag){
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [UIAlertView resetNetAlertNil];
        [[LoadingView showLoadingView] actViewStopAnimation];
        [self requestToGetRewardList];
    }
}

-(void)showTipView{
    ViewTip *tip = [[ViewTip alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
    [tip setViewTipByImage:[UIImage imageNamed:@"tipview"]];
    [tip setViewTipByStringOne:@"暂无该兑换记录"];
    [self addSubview:tip];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RewardListCell *cell = (RewardListCell* )[self tableView:tableView cellForRowAtIndexPath:indexPath];
    float height = [cell getCellHeight];
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allLogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *string = @"RewardListCell";
    RewardListCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[RewardListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
//    else{
//        while ([cell.contentView.subviews lastObject] !=nil) {
//            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
//        }
        //>>>>>>> .r3566
//    }
//    NSDictionary *dic = [_allLogs objectAtIndex:indexPath.row];
//    NSLog(@"   奖品列表 %@ ",[dic objectForKey:@"type"]);13
    RewardGoods *goods = [[RewardGoods alloc]initRewardGoodsByDic:[_allLogs objectAtIndex:indexPath.row]];
    [cell initCellContentWith:goods];
    for (UIView *currentView in cell.subviews)
    {
        if([currentView isKindOfClass:[UIScrollView class]])
        {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    float y_float = self.contentOffset.y;
    if (y_float < 0)
        return;
    
    if (_allLogs.count != 0 && curPage != maxPage) {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
//        float reload_distance = 2 * kTableLoadingViewHeight2_0;
        if(y > h -1) {
            self.tableFooterView.hidden = NO;
            [self requestForRewardList];
        }else{
            self.tableFooterView.hidden = YES;
        }
    }else{
        self.tableFooterView.hidden =YES;
    }

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.rewardTabDelegate scrollToCloseTypeChoose];
}
@end
