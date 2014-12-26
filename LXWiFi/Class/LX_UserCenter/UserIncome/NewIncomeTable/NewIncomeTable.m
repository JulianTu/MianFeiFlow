//
//  NewIncomeTable.m
//  免费流量王
//
//  Created by keyrun on 14-10-27.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "NewIncomeTable.h"
#import "TablePullToLoadingView.h"
#import "IncomeCell.h"
#import "MyUserDefault.h"
#import "LoadingView.h"
#import "AsynURLConnection.h"
#import "UIAlertView+NetPrompt.h"
#import "ViewTip.h"
#import "UserLog.h"
#import "LLAsynURLConnection.h"
@implementation NewIncomeTable
{
    NSMutableArray *_allLogs;                                //记录获取到用户记录
    
    int page;
    int curPage;
    int maxPage;
    int timeOutCount;                                       //连接超时次数
    
    BOOL isFrist;
    IncomeType _type ;
}
@synthesize allLogs =_allLogs;
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
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedScreen)];
        [self addGestureRecognizer:tap];
        
        self.sectionIndexColor = nil;
        
    }
    return self;
}
-(void) onClickedScreen{
    [self.incomeTabDelegate incomeScrollToCloseChooseView];
}
-(void) initObjectsWithIncomeType:(IncomeType)type{
    page = 1;
    curPage = 0;
    maxPage = 0;
    timeOutCount = 0;
    isFrist = true;
    _type =type ;
    [self performSelector:@selector(requestForUserIncomeLog) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _allLogs.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    IncomeCell* cell = (IncomeCell* )[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell getIncomeCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *string = @"AllcomeCell";
    IncomeCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[IncomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    cell.userlog = [[UserLog alloc] initWithDictionary:[_allLogs objectAtIndex:indexPath.row]];
    [cell initIncomeCell];
    return cell;
}
-(void) requestForUserIncomeLog{
    if(isFrist){
        [[LoadingView showLoadingView] actViewStartAnimation];
        isFrist = NO;
    }
    NSString *string =[NSString stringWithFormat:kOnlineWeb,@"ucenter/userlog/"];
    NSString *typeStr ;
    switch (_type) {
        case IncomeTypeAll:
            typeStr =@"all";
            break;
        case IncomeTypeMission:
            typeStr =@"mission";
            break;
        case IncomeTypeInvite:
            typeStr =@"invite";
            break;
        case IncomeTypeActivity:
            typeStr =@"activity";
            break;
        case IncomeTypeExchange:
            typeStr =@"buy";
            break;
        case IncomeTypeOther:
            typeStr =@"other";
            break;
        default:
            break;
    }
    NSString *urlStr =[NSString stringWithFormat:@"%@%@/%d",string,typeStr,page];
    [LLAsynURLConnection requestForMethodGetWithURL:urlStr dataDic:nil andProtocolNum:@"40005" andTimeOut:httpTimeout successBlock:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            timeOutCount = 0;
            NSLog(@"请求获取用户的全部收入【response】= %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                if(body != nil){
                    curPage = [[body objectForKey:@"curpage"] intValue];
                    maxPage = [[body objectForKey:@"maxpage"] intValue];
                    int maxCount =[[body objectForKey:@"maxnum"] integerValue];
                    if (maxCount ==0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showTip];
                            self.tableFooterView.hidden = YES;
                            [[LoadingView showLoadingView] actViewStopAnimation];
                        });
                    }else{
                        NSArray *userLogs = [body objectForKey:@"lists"];
                        
                        if(userLogs != nil && userLogs.count > 0 && curPage == page){
                            page ++;
                            if(_allLogs == nil){
                                _allLogs = [[NSMutableArray alloc] initWithArray:userLogs];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.tableFooterView.hidden = YES;
                                    [self reloadData];
                                    [[LoadingView showLoadingView] actViewStopAnimation];
                                    
                                });
                            }else{
                                NSMutableArray *paths =[[NSMutableArray alloc] init];
                                for (int i=0; i <userLogs.count; i++) {
                                    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:_allLogs.count+i  inSection:0];
                                    [paths addObject:indexPath];
                                }
                                [_allLogs insertObjects:userLogs atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_allLogs.count, userLogs.count)]];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self beginUpdates];
                                    [self insertRowsAtIndexPaths:[NSArray arrayWithArray:paths] withRowAnimation:UITableViewRowAnimationNone];
                                    [self endUpdates];
                                    [[LoadingView showLoadingView] actViewStopAnimation];
                                    self.tableFooterView.hidden = YES;
                                });
                            }
                            
                        }
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[LoadingView showLoadingView] actViewStopAnimation];
                        self.tableFooterView.hidden = YES;
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
            if(timeOutCount < 2){
                timeOutCount ++;
                [self requestForUserIncomeLog];
            }else{
                [[LoadingView showLoadingView] actViewStopAnimation];
                timeOutCount = 0;
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

//请求获取用户收入
-(void)requestToGetUserAllIncome{
    if(isFrist){
        [[LoadingView showLoadingView] actViewStartAnimation];
        isFrist = NO;
    }
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid, @"PageNum":[NSNumber numberWithInt:page], @"Type":[NSString stringWithFormat:@"%d",_type]};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"MyCenterUI",@"GetUserLog"];
    NSLog(@"请求获取用户的全部收入【urlStr】= %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            timeOutCount = 0;
            NSLog(@"请求获取用户的全部收入【response】= %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                if(body != nil){
                    curPage = [[body objectForKey:@"CurPage"] intValue];
                    maxPage = [[body objectForKey:@"MaxPage"] intValue];
                    int maxCount =[[body objectForKey:@"MaxNum"] integerValue];
                    if (maxCount ==0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showTip];
                            self.tableFooterView.hidden = YES;
                            [[LoadingView showLoadingView] actViewStopAnimation];
                        });
                    }else{
                        NSArray *userLogs = [body objectForKey:@"UserLog"];
                        
                        if(userLogs != nil && userLogs.count > 0 && curPage == page){
                            page ++;
                            if(_allLogs == nil){
                                _allLogs = [[NSMutableArray alloc] initWithArray:userLogs];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.tableFooterView.hidden = YES;
                                    [self reloadData];
                                    [[LoadingView showLoadingView] actViewStopAnimation];
                                    
                                });
                            }else{
                                NSMutableArray *paths =[[NSMutableArray alloc] init];
                                for (int i=0; i <userLogs.count; i++) {
                                    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:_allLogs.count+i  inSection:0];
                                    [paths addObject:indexPath];
                                }
                                [_allLogs insertObjects:userLogs atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_allLogs.count, userLogs.count)]];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self beginUpdates];
                                    [self insertRowsAtIndexPaths:[NSArray arrayWithArray:paths] withRowAnimation:UITableViewRowAnimationNone];
                                    [self endUpdates];
                                    [[LoadingView showLoadingView] actViewStopAnimation];
                                    self.tableFooterView.hidden = YES;
                                });
                            }
                            
                        }
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[LoadingView showLoadingView] actViewStopAnimation];
                        self.tableFooterView.hidden = YES;
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
            if(timeOutCount < 2){
                timeOutCount ++;
                [self requestToGetUserAllIncome];
            }else{
                [[LoadingView showLoadingView] actViewStopAnimation];
                timeOutCount = 0;
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == kTimeOutTag){
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [UIAlertView resetNetAlertNil];
        [[LoadingView showLoadingView] actViewStartAnimation];
        [self requestToGetUserAllIncome];
    }
}
-(void)showTip{
    ViewTip* tip = [[ViewTip alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
    [tip setViewTipByImage:[UIImage imageNamed:@"tipview"]];
    [tip setViewTipByContent:@"暂无该流量币明细"];
    [self addSubview:tip];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.incomeTabDelegate incomeScrollToCloseChooseView];
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
        if(y > h - 1) {
            self.tableFooterView.hidden = NO;
            [self requestForUserIncomeLog];
        }else{
            self.tableFooterView.hidden = YES;
        }
    }else{
        self.tableFooterView.hidden =YES;
    }
}

@end
