//
//  RewardViewController.m
//  TJiphone
//
//  Created by keyrun on 13-9-26.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "RewardViewController.h"
//#import "TJViewController.h"
#import "RewardGoodsView.h"
#import "ExchangeQViewController.h"
#import "ExchangePViewController.h"
#import "GoodsDetailsController.h"
#import "GoodsModel.h"
#import "SDImageView+SDWebCache.h"
#import "LoadingView.h"
#import "MyUserDefault.h"
#import "RewardListViewController.h"
#import "AsynURLConnection.h"
#import "UIAlertView+NetPrompt.h"
#import "HeadToolBar.h"
#import "TMAlertView.h"
#import "JSONKit.h"
#import "ButtonRowView.h"
#import "TablePullToLoadingView.h"
#import "NSDate+nowTime.h"
#import "UIImage+ColorChangeTo.h"
#import "LXTabViewController.h"
#import "LXUserCenterController.h"
#import "LLAsynURLConnection.h"
#define kLogoViewSizeH  54.5
#define kLogoViewSizeW 79.5
#define lLogoSize
@interface RewardViewController ()
{
    int curPage;
    int maxPage;
    int page;
    int localRow;                                               //加载到第几行
    //    HeadView* hv;
    HeadToolBar *headBar;
    
    
    NSMutableArray *temporaryAllGoodsAry;                       //(临时)产品数据数组
    
    UITableView* goodsContent;
    LoadingView* loadView;
    UIView* footView;
    
    NSString* userCoins;
    
    UIImageView* coinImage;
    UIView *view;                                               //加一层画布
    
    
    UILabel *userBeanLab;                                       //用户淘金豆的数量
    
    
    NSNumber *nowTime;                                          //当前显示该页面的时间
    int timeOutCount;                                           //超时次数
    int timeOutCountWithGold;                                   //请求用户金豆数超时次数
    BOOL isFrist;                                               //是否第一次
    
    ButtonRowView *buttonRowView;
}
@end

@implementation RewardViewController

@synthesize isRequesting = _isRequesting;
@synthesize isRequestingWithGold = _isRequestingWithGold;
@synthesize allGoodsAry = _allGoodsAry;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPushRewardGoods) name:@"PushReward" object:nil];
        self.view.backgroundColor = kWitheColor;
    }
    return self;
}

-(void)initWithObjects{
    curPage = 1;
    timeOutCount = 0;
    localRow = 0;
    [self requestForRewardGoods];
    isFrist = YES;
    
}

-(void)showDutyTip{
    
    if (_isFromService) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    _isRequesting = NO;
    _isRequestingWithGold = NO;
    [self initWithObjects];
    
    NSNumber *jdCount;
    if ([[MyUserDefault standardUserDefaults] getUserBeanNum]) {
        jdCount =[[MyUserDefault standardUserDefaults] getUserBeanNum];
    }else{
        jdCount =[NSNumber numberWithInt:0];
    }
    
    NSLog(@" 用户金豆数 %@ ",jdCount);
    
    headBar =[[HeadToolBar alloc] initWithTitle:@"奖品兑换" leftBtnTitle:@"返回" leftBtnImg:GetImageWithName(@"back") leftBtnHighlightedImg:nil rightLabTitle:jdCount backgroundColor:kBlueTextColor];
    [headBar.leftBtn addTarget:self action:@selector(showDutyTip) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    NSArray *imgAry = @[@"cash",@"qcoin",@"phone"];
    NSArray *titleAry = @[@"现金兑换",@"Q币兑换",@"话费兑换"];
    NSArray *colorAry = @[kBlueTextColor, KOrangeColor2_0, KPurpleColor2_0];
    
    buttonRowView = [[ButtonRowView alloc] initWithFrame:CGRectMake(0.0f, headBar.frame.size.height, kmainScreenWidth, 0.0f) imgAry:imgAry titleAry:titleAry colorAry:colorAry btnAction:^(UIButton *button) {
        [self onClickRewardButton:button];
    }];
    [self.view addSubview:buttonRowView];
    [self setRewardGoodsContentView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserBean) name:@"changeUserBean" object:nil];
    
}

-(void)changeUserBean{
    headBar.rightLab.text =[NSString stringWithFormat:@"%ld",[[[MyUserDefault standardUserDefaults] getUserBeanNum] longValue]];
}

-(void)isShowDutyView{
    if ([[[MyUserDefault standardUserDefaults] getIsShowDutyView]intValue] !=1) {
        [[MyUserDefault standardUserDefaults] setIsShowDutyView:[NSNumber numberWithInt:1]];
        [self showDutyTip];
        
    }
}
-(void)viewWillAppear:(BOOL)animated{
    
    if ([[[MyUserDefault standardUserDefaults] getIsNeedReloadRV] intValue] ==1) {    //主要针对由兑换记录界面跳过来  需要重新请求奖品数据
        curPage =1;
        [[MyUserDefault standardUserDefaults] setIsNeedReloadRV:[NSNumber numberWithInt:0]];
    }
    
}
/**
 *  请求用户金豆数
 */
-(void)requestForUserBeans{
    _isRequestingWithGold = YES;
    NSString *sid =[[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid, @"Id":@"0"};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"MyCenterUI",@"GetUserInfo"];
    NSLog(@"请求用户金豆数【urlStr】= %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"请求用户金豆数【response】= %@",dataDic);
            if ([[dataDic objectForKey:@"flag"] integerValue]==1) {
                NSDictionary *body =[dataDic objectForKey:@"body"];
                NSNumber *bean =[NSNumber numberWithInt:[[body objectForKey:@"Bean"] intValue]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self initBeanCount:bean];
                    _isRequestingWithGold = NO;
                });
            }
        });
    } fail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            if(timeOutCountWithGold < 2){
                timeOutCountWithGold ++;
                [self requestForUserBeans];
            }else{
                [[LoadingView showLoadingView] actViewStopAnimation];
                _isRequestingWithGold = NO;
            }
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    if (self.isRemotionPush) {       //处理远程通知 跳转到奖品详情
        self.isRemotionPush =NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getPushRewardGoods];
        });
        
    }
    if (kDeviceVersion >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate =self;
        self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = YES;
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [[LoadingView showLoadingView] actViewStopAnimation];
    
}

-(void)requestForRewardGoods{
    if ([[LoadingView showLoadingView] actViewIsAnimation]) {
        [[LoadingView showLoadingView] actViewStopAnimation];
    }
    if (curPage ==1) {
        [[LoadingView showLoadingView] actViewStartAnimation];
    }
    
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,@"award"];
    urlStr =[urlStr stringByAppendingString:[NSString stringWithFormat:@"/%d",curPage]];
    NSLog(@" 请求奖品列表 == %@",urlStr);
    [LLAsynURLConnection requestForMethodGetWithURL:urlStr dataDic:nil andProtocolNum:@"30002" andTimeOut:httpTimeout successBlock:^(NSData *data) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@" 获取奖品列表 ==%@  err==%@",dataDic,[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            if ([[dataDic objectForKey:@"flag"]intValue] ==1) {
                NSDictionary *body = [dataDic objectForKey:@"body"];
                NSArray *awardAry = [body objectForKey:@"awards"];
                page = [[body objectForKey:@"curpage"]integerValue];
                maxPage = [[body objectForKey:@"maxpage"]integerValue];
                long bean = [[body objectForKey:@"mygold"] longValue];
                
                [[MyUserDefault standardUserDefaults] setUserBeanNum:bean];
                if(curPage == 1){
                    if(_allGoodsAry == nil){
                        _allGoodsAry = [[NSMutableArray alloc] initWithArray:[self reinitGoodsObject:awardAry]];
                    }else{
                        [_allGoodsAry removeAllObjects];
                        [_allGoodsAry insertObjects:[self reinitGoodsObject:awardAry] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, awardAry.count)]];
                    }
                }else{
                    [_allGoodsAry insertObjects:[self reinitGoodsObject:awardAry] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_allGoodsAry.count, awardAry.count)]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    goodsContent.tableFooterView.hidden = YES;
                    [headBar setRightLabText:[NSString stringWithFormat:@"%ld",bean]];
                    if(temporaryAllGoodsAry == nil){
                        //第一次空白加载
                        temporaryAllGoodsAry = [[NSMutableArray alloc] initWithArray:_allGoodsAry];
                        [goodsContent reloadData];
                    }else{
                        if(localRow == 0){
                            //切换加载
                            [temporaryAllGoodsAry removeAllObjects];
                            [temporaryAllGoodsAry insertObjects:_allGoodsAry atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _allGoodsAry.count)]];
                            [goodsContent reloadData];
                        }else{
                            //向下加载
                            NSMutableArray *paths = [[NSMutableArray alloc] init];
                            for (int i = localRow; i < _allGoodsAry.count; i++) {
                                if(i%2 == 1 || i == _allGoodsAry.count - 1){
                                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i/2 inSection:0];
                                    [paths addObject:indexPath];
                                }
                                [temporaryAllGoodsAry insertObject:[_allGoodsAry objectAtIndex:i] atIndex:temporaryAllGoodsAry.count];
                            }
                            [goodsContent insertRowsAtIndexPaths:[NSArray arrayWithArray:paths] withRowAnimation:UITableViewRowAnimationFade];
                            NSIndexPath *localIndexPath = [NSIndexPath indexPathForRow:localRow inSection:0];
                            [UIView animateWithDuration:0.5f animations:^{
                                //   [self scrollToRowAtIndexPath:localIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
                            }];
                        }
                    }
//                    [[MyUserDefault standardUserDefaults] setRewordRefreshTime:[NSNumber numberWithLongLong:[NSDate getNowTime]]];
                    localRow = temporaryAllGoodsAry.count;
                    _isRequesting = NO;
                    curPage ++;
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
                
                
            }else{            
                [[LoadingView showLoadingView] actViewStopAnimation];
            }
        });
        
    } andFailBlock:^(NSError *error) {
        NSLog(@"-----获取产品列表数据【error】 = %@ -----",error);
        if(error.code == timeOutErrorCode){
            if(timeOutCount < 2){
                timeOutCount ++;
                [self requestForRewardGoods];
            }else{
                timeOutCount = 0;
                if(![UIAlertView isInit]){
                    UIAlertView *alertView = [UIAlertView showNetAlert];
                    alertView.delegate = self;
                    alertView.tag = kTimeOutTag;
                    [alertView show];
                    alertView = nil;
                }
                goodsContent.tableFooterView.hidden = YES;
                _isRequesting = YES;
                [[LoadingView showLoadingView] actViewStopAnimation];
            }
        }
        
    }];
}

/**
 *  请求获取产品列表数据
 */
-(void)requestToGoodsAry{
    _isRequesting = YES;
    if(isFrist && (_allGoodsAry == nil || _allGoodsAry.count == 0)){
        [[LoadingView showLoadingView] actViewStartAnimation];
        isFrist = NO;
    }
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSString *pageNum = [NSString stringWithFormat:@"%d",curPage];
    NSDictionary *dic = @{@"sid": sid, @"PageNum":pageNum};
    
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"AwardUI",@"GetAwardList"];
    NSLog(@"请求获取产品列表数据【urlStr】 = %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        NSError *error ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        timeOutCount = 0;
        
        NSLog(@"请求获取产品列表数据【response】 = %@  ",dic);
        if (dic != nil) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDictionary *body = [dic objectForKey:@"body"];
                NSArray *awardAry = [body objectForKey:@"Award"];
                page = [[body objectForKey:@"CurPage"]integerValue];
                maxPage = [[body objectForKey:@"MaxPage"]integerValue];
                NSString *beanStr = [body objectForKey:@"Bean"];
                long bean = (long )[beanStr longLongValue];
                
                [[MyUserDefault standardUserDefaults] setUserBeanNum:bean];
                if(curPage == 1){
                    if(_allGoodsAry == nil){
                        _allGoodsAry = [[NSMutableArray alloc] initWithArray:[self reinitGoodsObject:awardAry]];
                    }else{
                        [_allGoodsAry removeAllObjects];
                        [_allGoodsAry insertObjects:[self reinitGoodsObject:awardAry] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, awardAry.count)]];
                    }
                }else{
                    [_allGoodsAry insertObjects:[self reinitGoodsObject:awardAry] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_allGoodsAry.count, awardAry.count)]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    goodsContent.tableFooterView.hidden = YES;
                    [headBar setRightLabText:[NSString stringWithFormat:@"%ld",bean]];
                    if(temporaryAllGoodsAry == nil){
                        //第一次空白加载
                        temporaryAllGoodsAry = [[NSMutableArray alloc] initWithArray:_allGoodsAry];
                        [goodsContent reloadData];
                    }else{
                        if(localRow == 0){
                            //切换加载
                            [temporaryAllGoodsAry removeAllObjects];
                            [temporaryAllGoodsAry insertObjects:_allGoodsAry atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _allGoodsAry.count)]];
                            [goodsContent reloadData];
                        }else{
                            //向下加载
                            NSMutableArray *paths = [[NSMutableArray alloc] init];
                            for (int i = localRow; i < _allGoodsAry.count; i++) {
                                if(i%2 == 1 || i == _allGoodsAry.count - 1){
                                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i/2 inSection:0];
                                    [paths addObject:indexPath];
                                }
                                [temporaryAllGoodsAry insertObject:[_allGoodsAry objectAtIndex:i] atIndex:temporaryAllGoodsAry.count];
                            }
                            [goodsContent insertRowsAtIndexPaths:[NSArray arrayWithArray:paths] withRowAnimation:UITableViewRowAnimationFade];
                            NSIndexPath *localIndexPath = [NSIndexPath indexPathForRow:localRow inSection:0];
                            [UIView animateWithDuration:0.5f animations:^{
                                //                                [self scrollToRowAtIndexPath:localIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
                            }];
                        }
                    }
//                    [[MyUserDefault standardUserDefaults] setRewordRefreshTime:[NSNumber numberWithLongLong:[NSDate getNowTime]]];
                    localRow = temporaryAllGoodsAry.count;
                    _isRequesting = NO;
                    curPage ++;
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
            });
        }
    } fail:^(NSError *error) {
        NSLog(@"-----获取产品列表数据【error】 = %@ -----",error);
        if(error.code == timeOutErrorCode){
            if(timeOutCount < 2){
                timeOutCount ++;
                [self requestToGoodsAry];
            }else{
                timeOutCount = 0;
                if(![UIAlertView isInit]){
                    UIAlertView *alertView = [UIAlertView showNetAlert];
                    alertView.delegate = self;
                    alertView.tag = kTimeOutTag;
                    [alertView show];
                    alertView = nil;
                }
                goodsContent.tableFooterView.hidden = YES;
                _isRequesting = YES;
                [[LoadingView showLoadingView] actViewStopAnimation];
            }
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == kTimeOutTag){
        if(buttonIndex == 0){
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [UIAlertView resetNetAlertNil];
            [[LoadingView showLoadingView] actViewStartAnimation];
            [self requestForRewardGoods];
        }
    }
}

-(UIView *)getSperateLineByFrame:(CGRect )rect{
    UIView *line =[[UIView alloc]initWithFrame:rect];
    line.backgroundColor =kGrayLineColor2_0;
    return line;
}

-(void)loadSperateLines{
    UIView *bottomLine = [self getSperateLineByFrame:CGRectMake(0, kLogoViewSizeH +headBar.frame.origin.y+headBar.frame.size.height , kmainScreenWidth, LineWidth)];
    [self.view addSubview:bottomLine];
    
    for (int i=1; i<4; i++) {
        UIView *line =[self getSperateLineByFrame:CGRectMake((kLogoViewSizeW ) *i , headBar.frame.origin.y +headBar.frame.size.height, LineWidth, kLogoViewSizeH)];
        [self.view addSubview:line];
    }
}
-(void)onClickRewardButton:(UIButton* )btn{
    UINavigationController* nc=(UINavigationController* )[UIApplication sharedApplication].keyWindow.rootViewController;
    switch (btn.tag) {
            //兑换成现金
        case 1:
        {
            ExchangeQViewController *exQ = [[ExchangeQViewController alloc]initWithNibName:nil bundle:nil];
            [nc pushViewController:exQ animated:YES];
        }
            break;
            //兑换成Q币
        case 2:
        {
            ExchangePViewController *exP = [[ExchangePViewController alloc] initWithNibName:nil bundle:nil tag:1];
            exP.isRechargeQ = YES;
            //            [exP makeDashLine];
            [nc pushViewController:exP animated:YES];
        }
            break;
        case 3:   //兑换话费
        {
            ExchangePViewController *exP = [[ExchangePViewController alloc] initWithNibName:nil bundle:nil tag:2];
            exP.isRechargeQ = NO;
            [nc pushViewController:exP animated:YES];
        }
            break;
            
        default:
            break;
    }
}

-(void)setRewardGoodsContentView{
    goodsContent = [[UITableView alloc]initWithFrame:CGRectMake(0, buttonRowView.frame.origin.y + buttonRowView.frame.size.height ,kmainScreenWidth , kmainScreenHeigh- buttonRowView.frame.origin.y - buttonRowView.frame.size.height - (kBatterHeight)) style:UITableViewStylePlain];
    [goodsContent setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    goodsContent.delegate = self;
    goodsContent.dataSource = self;
    goodsContent.backgroundColor = [UIColor clearColor];
    
    TablePullToLoadingView *loadingView = [[TablePullToLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, kTableLoadingViewHeight2_0)];
    goodsContent.tableFooterView = loadingView;
    goodsContent.tableFooterView.hidden = YES;
    
    
    [self.view addSubview:goodsContent];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 146.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (temporaryAllGoodsAry.count%2 == 1)
        return temporaryAllGoodsAry.count/2+1;
    
    return temporaryAllGoodsAry.count/2;
}

//初始化奖品列表
-(void)initWithCell:(RewardGoodsView *)cell allGoods:(NSArray *)allGoods indexPath:(NSIndexPath *)indexPath{
    int leftTag = indexPath.row * 2;
    cell.leftGoods = [allGoods objectAtIndex:leftTag];
    NSURL *leftUrl = [NSURL URLWithString:cell.leftGoods.picString];
    [cell.leftImage setImageWithURL:leftUrl refreshCache:YES placeholderImage:GetImageWithName(@"picsmall2")];
    
    if(allGoods.count % 2 == 0 || (allGoods.count % 2 == 1 && indexPath.row < allGoods.count/2)){
        cell.rightGoods = [allGoods objectAtIndex:leftTag + 1];
        cell.rightView.hidden = NO;
        NSURL *rightUrl = [NSURL URLWithString:cell.rightGoods.picString];
        [cell.rightImage setImageWithURL:rightUrl refreshCache:YES placeholderImage:GetImageWithName(@"picsmall2")];
    }else {
        cell.rightView.hidden = YES;
    }
    
    [cell initCellContent];
    cell.leftBtn.tag = leftTag;
    [cell.leftBtn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.rightBtn.tag = leftTag + 1;
    [cell.rightBtn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IDENTIFIER = @"RewardGoodsCell";
    RewardGoodsView *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (cell == nil) {
        cell = [[RewardGoodsView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [self initWithCell:cell allGoods:temporaryAllGoodsAry indexPath:indexPath];
    
    //    for (UIView *currentView in cell.subviews)
    //    {
    //        if([currentView isKindOfClass:[UIScrollView class]])
    //        {
    //            ((UIScrollView *)currentView).delaysContentTouches = NO;
    //            break;
    //        }
    //    }
    
    return cell;
}

//点击商品，通过tag来区分点击的是左边还是右边商品,将这个对象传递过去
-(void)onClicked:(UIButton* )obj{
    UINavigationController *nc = (UINavigationController* )[UIApplication sharedApplication].keyWindow.rootViewController;
    GoodsModel *goodsModel = [temporaryAllGoodsAry objectAtIndex:obj.tag];
    GoodsDetailsController *gd = [[GoodsDetailsController alloc] initWithNibName:nil bundle:nil];
    gd.goodsModel = goodsModel;
    [gd requestForGoodsDetailsWithId:goodsModel.awardId];
    [nc pushViewController:gd animated:YES];
}

//淘金豆的显示
-(void)initBeanCount:(NSNumber *)number{
    if (userBeanLab == nil) {
        userBeanLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 0, 14)];
        userBeanLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        userBeanLab.numberOfLines = 1;
        userBeanLab.lineBreakMode = NSLineBreakByWordWrapping;
        userBeanLab.backgroundColor = [UIColor clearColor];
        userBeanLab.text = [NSString stringWithFormat:@"%@",number];
        [userBeanLab sizeToFit];
        userBeanLab.frame = CGRectMake(10, 14, userBeanLab.frame.size.width, 14);
        userBeanLab.textColor = [UIColor whiteColor];
        //        [headBar addSubview:userBeanLab];
    }else{
        [userBeanLab setText:[NSString stringWithFormat:@"%ld",[number longValue]]];
    }
    if(coinImage == nil){
        coinImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beans_2.png"]];
        coinImage.frame = CGRectMake(userBeanLab.frame.origin.x + userBeanLab.frame.size.width+5,11 , 19, 19);
        //        [headBar addSubview:coinImage];
    }else{
        coinImage.frame = CGRectMake(userBeanLab.frame.origin.x + userBeanLab.frame.size.width+5,11 , 19, 19);
    }
}

/**
 *  转换服务器的数据为本地对象数据
 *
 *  @param arr 服务器的数据
 */
-(NSMutableArray *)reinitGoodsObject:(NSArray *)arr{
    NSMutableArray *goodsAry = [[NSMutableArray alloc] init];
    for(int i = 0 ; i < arr.count; i ++){
        GoodsModel *goodsModel = [[GoodsModel alloc] initGoodsModelByDictionary:[arr objectAtIndex:i]];
        [goodsAry addObject:goodsModel];
    }
    return goodsAry;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float y_float = goodsContent.contentOffset.y;
    if (y_float < 0)
        return;
    
    if(_allGoodsAry.count != 0 && page != maxPage && goodsContent.tableFooterView.hidden == YES){
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        if(y > h - 1) {
            goodsContent.tableFooterView.hidden = NO;
            [self requestForRewardGoods];
        }else{
            goodsContent.tableFooterView.hidden = YES;
        }
    }else{
        goodsContent.tableFooterView.hidden =YES;
    }
}



-(void)getPushRewardGoods{  //接收推送
    UINavigationController* navCtl = (UINavigationController* )[UIApplication sharedApplication].keyWindow.rootViewController;
    GoodsDetailsController* gd = [[GoodsDetailsController alloc]initWithNibName:nil bundle:nil];
    gd.isPush =YES;
    int goodId =self.pushGoodID;
    gd.lastVC =self;
    [gd requestForGoodsDetailsWithId:goodId];
    [navCtl pushViewController:gd animated:NO];
    
}

@end








