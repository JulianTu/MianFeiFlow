//
//  RewardListViewController.m
//  TJiphone
//
//  Created by keyrun on 13-9-30.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "RewardListViewController.h"
#import "MScrollVIew.h"
#import "RewardListCell.h"
#import "LoadingView.h"
#import "ViewTip.h"
#import "RewardViewController.h"
#import "MyUserDefault.h"
#import "AsynURLConnection.h"
#import "UIAlertView+NetPrompt.h"
#import "HeadToolBar.h"
#import "TablePullToLoadingView.h"

@interface RewardListViewController ()
{
    
    
    LLRecordTypeTable *recordTypeTable ;
    NSMutableArray *allLogs;
    UITableView *tableView0;
    BOOL isAnimationing ;
    HeadToolBar *headBar ;
    int page;
    int curPage;
    int maxPage;
    int timeOutCount;                                                   //连接超时次数
    
    BOOL isFrist;                                                       //标识是否第一次请求数据
    
    RewardTableView *allTable ;
    RewardTableView *flowTable ;
    RewardTableView *cashTable ;
    RewardTableView *qCoinTable ;
    RewardTableView *phoneTable ;
    RewardTableView *otherTable ;
    NSMutableArray *allTablesArr ;
    MScrollVIew *ms ;
}
@end

@implementation RewardListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

//初始化变量
-(void)initWithObjects{
    page = 1;
    curPage =0;
    maxPage =0;
    isFrist = YES;
    isAnimationing =NO;
    allTablesArr = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initWithObjects];
    
    headBar =[[HeadToolBar alloc]initWithTitle:@"兑换记录" leftBtnTitle:@"返回" leftBtnImg:GetImageWithName(@"back") leftBtnHighlightedImg:nil rightBtnTitle:nil rightBtnImg:GetImage(@"closebtn") rightBtnHighlightedImg:nil backgroundColor:kBlueTextColor];
    [headBar.leftBtn addTarget:self action:@selector(onClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [headBar.rightBtn addTarget:self action:@selector(showRecordType) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    if (kDeviceVersion >= 7.0) {
        ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y + headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height ) andWithPageCount:1 backgroundImg:nil];
    }else{
        ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y + headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height) andWithPageCount:1 backgroundImg:nil];
    }
    ms.bounces = NO;
    ms.delaysContentTouches =NO;
    [ms setContentSize:CGSizeMake(kmainScreenWidth,ms.frame.size.height)];
    
    [self.view addSubview:ms];
    NSLog(@"  isPush =%d",self.isRootPush);
    [self loadRecordTypeTableView];
    [self loadAllRecordTableView];
    //    [self performSelector:@selector(requestToGetRewardList) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
    
}
-(void) onClickedScreen{
    if (recordTypeTable.hidden ==NO) {
        [self showRecordType];
    }
    
}
-(void) loadAllRecordTableView {
    if (!allTable) {
        allTable = [[RewardTableView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, ms.frame.size.height ) style:UITableViewStylePlain];
        [allTable initObjectsWithRewardType:RewardTypeAll];
        allTable.tag = 0;
        allTable.rewardTabDelegate =self;
        [allTablesArr addObject:allTable];
    }
    [ms insertSubview:allTable belowSubview:recordTypeTable];
}
-(void) loadFlowRecordTableView {
    if (!flowTable) {
        flowTable = [[RewardTableView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, ms.frame.size.height) style:UITableViewStylePlain];
        [flowTable initObjectsWithRewardType:RewardTypeFlow];
        flowTable.tag =1 ;
        flowTable.rewardTabDelegate =self;
        [allTablesArr addObject:flowTable];
    }
    [ms insertSubview:flowTable belowSubview:recordTypeTable];
}
-(void) loadCashRecordTableView {
    if (!cashTable) {
        cashTable = [[RewardTableView alloc] initWithFrame:CGRectMake(0,0, kmainScreenWidth, ms.frame.size.height ) style:UITableViewStylePlain];
        [cashTable initObjectsWithRewardType:RewardTypeCash];
        cashTable.tag =2 ;
        cashTable.rewardTabDelegate =self;
        [allTablesArr addObject:cashTable];
    }
    [ms insertSubview:cashTable belowSubview:recordTypeTable];
}
-(void) loadQCoinRecordTableView {
    if (!qCoinTable) {
        qCoinTable = [[RewardTableView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, ms.frame.size.height) style:UITableViewStylePlain];
        [qCoinTable initObjectsWithRewardType:RewardTypeQCoin];
        qCoinTable.tag =3;
        qCoinTable.rewardTabDelegate =self;
        [allTablesArr addObject:qCoinTable];
    }
    [ms insertSubview:qCoinTable belowSubview:recordTypeTable];
}
-(void) loadPhoneRecordTableView {
    if (!phoneTable) {
        phoneTable = [[RewardTableView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth,ms.frame.size.height ) style:UITableViewStylePlain];
        [phoneTable initObjectsWithRewardType:RewardTypePhone];
        phoneTable.tag =4 ;
        phoneTable.rewardTabDelegate =self;
        [allTablesArr addObject:phoneTable];
    }
    [ms insertSubview:phoneTable belowSubview:recordTypeTable];
}
-(void)scrollToCloseTypeChoose{
    [self onClickedScreen];
}
-(void) loadOtherRecordTableView {
    if (!otherTable) {
        otherTable = [[RewardTableView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y -headBar.frame.size.height) style:UITableViewStylePlain];
        [otherTable initObjectsWithRewardType:RewardTypeGoods];
        otherTable.rewardTabDelegate =self;
        [allTablesArr addObject:otherTable];
        otherTable.tag = 5;
    }
    [ms insertSubview:otherTable belowSubview:recordTypeTable];
}
-(void)loadRecordTypeTableView{
    NSArray *types = @[@"全部",@"流量",@"现金",@"Q币",@"话费",@"奖品"];
    recordTypeTable =[[LLRecordTypeTable alloc] initWithFrame:CGRectMake(kmainScreenWidth -kRecordTabWidth, headBar.frame.origin.y +headBar.frame.size.height, kRecordTabWidth, types.count *(kRecordTabCellHeigh +1)) style:UITableViewStylePlain withDataArr:types];
    recordTypeTable.typeDelegate =self ;
    recordTypeTable.types = types ;
    recordTypeTable.hidden =YES;
    [self.view addSubview:recordTypeTable];
}
-(void)didSelectedRowIndex:(int)row{   //点击类型
    [self showRecordType];
    for (RewardTableView *table in allTablesArr) {
        if (table.tag == row) {
            table.hidden = NO;
        }else {
            table.hidden = YES ;
        }
    }
    switch (row) {
        case 0:
            [self loadAllRecordTableView];
            break;
        case 1:
            [self loadFlowRecordTableView];
            break;
        case 2:
            [self loadCashRecordTableView];
            break;
        case 3:
            [self loadQCoinRecordTableView];
            break;
        case 4:
            [self loadPhoneRecordTableView];
            break;
        case 5:
            [self loadOtherRecordTableView];
            break;
        default:
            break;
    }
    
}

-(void)showRecordType{
    
    if (isAnimationing ==NO) {
        isAnimationing = YES;
        [UIView animateWithDuration:0.3f animations:^{
            if (recordTypeTable.hidden == YES) {
                headBar.rightBtn.transform =CGAffineTransformMakeRotation(M_PI *0);
            }else {
                headBar.rightBtn.transform =CGAffineTransformMakeRotation(M_PI * 1);
            }
        } completion:^(BOOL finished) {
            
        }];
        [UIView animateWithDuration:0.3f animations:^{
            if (recordTypeTable.hidden == YES) {
                recordTypeTable.hidden = NO;
                recordTypeTable.alpha = 1.0 ;
            }else{
                recordTypeTable.alpha = 0.0 ;
                
            }
        } completion:^(BOOL finished) {
            if (recordTypeTable.alpha == 0.0) {
                recordTypeTable.hidden = YES;
            }
            isAnimationing =NO ;
        }];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    if (kDeviceVersion >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    if (self.isRootPush ) {
        if (kDeviceVersion >= 7.0) {
            self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan =YES;
        }
        [[MyUserDefault standardUserDefaults] setIsNeedReloadRV:[NSNumber numberWithInt:1]];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [allLogs removeAllObjects];
    allLogs = nil;
    [tableView0 removeFromSuperview];
    tableView0 = nil;
    [allTable removeFromSuperview];
    allTable =nil;
    [flowTable removeFromSuperview];
    flowTable =nil;
    [cashTable removeFromSuperview];
    cashTable =nil;
    [qCoinTable removeFromSuperview];
    qCoinTable =nil;
    [otherTable removeFromSuperview];
    otherTable =nil;
    [phoneTable removeFromSuperview];
    phoneTable =nil;
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]] && ![otherGestureRecognizer.view isKindOfClass:[UITableView class]] ) {
            if (self.isRootPush ) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            return YES;
        }
    }
    
    return YES;
}
/*
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
 tableView0.tableFooterView.hidden = YES;
 [[LoadingView showLoadingView] actViewStopAnimation];
 [self showTipView];
 });
 }else{
 NSArray *orders = [body objectForKey:@"Orders"];
 if(orders != nil && orders.count > 0 && curPage == page){
 page ++;
 if(allLogs == nil){
 allLogs = [[NSMutableArray alloc] initWithArray:orders];
 dispatch_async(dispatch_get_main_queue(), ^{
 tableView0.tableFooterView.hidden = YES;
 [[LoadingView showLoadingView] actViewStopAnimation];
 [tableView0 reloadData];
 });
 }else{
 NSMutableArray *paths =[[NSMutableArray alloc] init];
 for (int i=0; i< orders.count; i++) {
 [paths addObject:[NSIndexPath indexPathForRow:allLogs.count+i inSection:0]];
 }
 [allLogs insertObjects:orders atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(allLogs.count, orders.count)]];
 dispatch_async(dispatch_get_main_queue(), ^{
 tableView0.tableFooterView.hidden = YES;
 [tableView0 beginUpdates];
 [tableView0 insertRowsAtIndexPaths:[NSArray arrayWithArray:paths] withRowAnimation:UITableViewRowAnimationNone];
 [tableView0 endUpdates];
 [[LoadingView showLoadingView] actViewStopAnimation];
 
 });
 
 }
 }
 
 }
 }else{
 dispatch_async(dispatch_get_main_queue(), ^{
 tableView0.tableFooterView.hidden = YES;
 [[LoadingView showLoadingView] actViewStopAnimation];
 [tableView0 reloadData];
 });
 }
 }else{
 dispatch_async(dispatch_get_main_queue(), ^{
 tableView0.tableFooterView.hidden = YES;
 [[LoadingView showLoadingView] actViewStopAnimation];
 });
 }
 });
 } fail:^(NSError *error) {
 if(error.code == timeOutErrorCode){
 if (timeOutCount < 2) {
 [self requestToGetRewardList];
 }else{
 tableView0.tableFooterView.hidden = YES;
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
 [tip setViewTipByImage:[UIImage imageNamed:@"a3.png"]];
 [tip setViewTipByStringOne:@"您还没有兑换任何奖品"];
 [tableView0 addSubview:tip];
 }
 
 -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 RewardListCell *cell = (RewardListCell* )[self tableView:tableView cellForRowAtIndexPath:indexPath];
 float height = [cell getCellHeight];
 
 return height;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 return allLogs.count;
 }
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 static NSString *string = @"RewardListCell";
 RewardListCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
 if (cell == nil) {
 //<<<<<<< .mine
 //        NSLog(@"Cell");
 //        cell = [[RewardListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
 //=======
 
 cell = [[RewardListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
 }else{
 while ([cell.contentView.subviews lastObject] !=nil) {
 [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
 }
 //>>>>>>> .r3566
 }
 cell.goods = [[RewardGoods alloc]initRewardGoodsByDic:[allLogs objectAtIndex:indexPath.row]];
 [cell initCellContent];
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
 
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
 float y_float = tableView0.contentOffset.y;
 if (y_float < 0)
 return;
 
 if (allLogs.count != 0 && curPage != maxPage) {
 CGPoint offset = scrollView.contentOffset;
 CGRect bounds = scrollView.bounds;
 CGSize size = scrollView.contentSize;
 UIEdgeInsets inset = scrollView.contentInset;
 float y = offset.y + bounds.size.height - inset.bottom;
 float h = size.height;
 float reload_distance = 2 * kTableLoadingViewHeight2_0;
 if(y > h + reload_distance) {
 tableView0.tableFooterView.hidden = NO;
 [self requestToGetRewardList];
 }else{
 tableView0.tableFooterView.hidden = YES;
 }
 }else{
 tableView0.tableFooterView.hidden =YES;
 }
 }
 */
-(void)onClickBackBtn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

