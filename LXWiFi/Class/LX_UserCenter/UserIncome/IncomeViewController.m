//
//  IncomeViewController.m
//  TJiphone
//
//  Created by keyrun on 13-9-30.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "IncomeViewController.h"
#import "IncomeCell.h"
#import "OutTable.h"
#import "IncomeTable.h"
#import "AllTable.h"
#import "MyUserDefault.h"
#import "HeadToolBar.h"
#import "TaoJinScrollView.h"
#import "LoadingView.h"

@interface IncomeViewController (){
    AllTable *allTableview;                                             //【全部】页面
    IncomeTable *incomeTableView;                                       //【收入】页面
    OutTable *outTableView;                                             //【支出】页面
    
    LLRecordTypeTable *recordTypeTable ;
    BOOL isAnimationing ;
    MScrollVIew *ms;
    HeadToolBar *headBar;
    UIImageView *image;
    
    NewIncomeTable *allIncomeTable;
    NewIncomeTable *missionIncomeTable;
    NewIncomeTable *inviteIncomeTable;
    NewIncomeTable *activityIncomeTable ;
    NewIncomeTable *exchangeIncomeTable;
    NewIncomeTable *otherIncomeTable ;
    NSMutableArray *allTables ;    //所有tableview
    float y;
}
@end

@implementation IncomeViewController
@synthesize user =_user ;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = kWitheColor ;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isAnimationing = NO;
    headBar =[[HeadToolBar alloc]initWithTitle:@"流量币明细" leftBtnTitle:@"返回" leftBtnImg:GetImageWithName(@"back") leftBtnHighlightedImg:nil rightBtnTitle:nil rightBtnImg:GetImage(@"closebtn") rightBtnHighlightedImg:nil backgroundColor:kBlueTextColor];
    [headBar.leftBtn addTarget:self action:@selector(goBackVC) forControlEvents:UIControlEventTouchUpInside];
    [headBar.rightBtn addTarget:self action:@selector(showRecordType) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];

    NSLog(@" userlog %d",_userLog);
    if(_user.userLog){
        [[MyUserDefault standardUserDefaults] setUserLog:_user.userLog];
    }
    allTables = [[NSMutableArray alloc] init];
    
    [self loadRecordTypeTableView];
    [self loadAllIncomeContentView];
    
   
}
-(void) onClickedScreen{
    if (recordTypeTable.hidden ==NO) {
        [self showRecordType];
    }
    
}
-(void) saveUserLog:(long) log{
    [[MyUserDefault standardUserDefaults] setUserLog:log];
}
-(void)viewDidAppear:(BOOL)animated {
    if (kDeviceVersion >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = YES;
    }
}
-(void)loadAllIncomeContentView{  //全部收入
    if (!allIncomeTable) {
        
        allIncomeTable =[[NewIncomeTable alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y +headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y -headBar.frame.size.height ) style:UITableViewStylePlain];
        [allIncomeTable initObjectsWithIncomeType:IncomeTypeAll];
        allIncomeTable.tag = 0 ;
        allIncomeTable.incomeTabDelegate = self;
        [allTables addObject:allIncomeTable];
    }
    [self.view insertSubview:allIncomeTable belowSubview:recordTypeTable];
}
-(void)loadMissionIncomeContentView{   //任务收入
    if (!missionIncomeTable) {
        missionIncomeTable =[[NewIncomeTable alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y +headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y -headBar.frame.size.height ) style:UITableViewStylePlain];
        missionIncomeTable.tag = 1 ;
        missionIncomeTable.incomeTabDelegate = self;
        [missionIncomeTable initObjectsWithIncomeType:IncomeTypeMission];
        [allTables addObject:missionIncomeTable];
    }
    [self.view insertSubview:missionIncomeTable belowSubview:recordTypeTable];
}
-(void)loadInviteIncomeContentView{     //邀请收入
    if (!inviteIncomeTable) {
        inviteIncomeTable =[[NewIncomeTable alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y +headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y -headBar.frame.size.height ) style:UITableViewStylePlain];
        inviteIncomeTable.tag = 2 ;
        inviteIncomeTable.incomeTabDelegate = self;
        [inviteIncomeTable initObjectsWithIncomeType:IncomeTypeInvite];
        [allTables addObject:inviteIncomeTable];
        
    }
     [self.view insertSubview:inviteIncomeTable belowSubview:recordTypeTable];
    
}
-(void)loadActivityIncomeContentView{     //活动收入
    if (!activityIncomeTable) {
        activityIncomeTable =[[NewIncomeTable alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y +headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y -headBar.frame.size.height ) style:UITableViewStylePlain];
        activityIncomeTable.tag = 3 ;
        activityIncomeTable.incomeTabDelegate = self;
        [activityIncomeTable initObjectsWithIncomeType:IncomeTypeActivity];
        [allTables addObject:activityIncomeTable];
    }
     [self.view insertSubview:activityIncomeTable belowSubview:recordTypeTable];
}
-(void)loadExchangeIncomeContentView{     //兑换收入
    if (!exchangeIncomeTable) {
        exchangeIncomeTable =[[NewIncomeTable alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y +headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y -headBar.frame.size.height ) style:UITableViewStylePlain];
        exchangeIncomeTable.tag = 4 ;
        exchangeIncomeTable.incomeTabDelegate = self;
        [exchangeIncomeTable initObjectsWithIncomeType:IncomeTypeExchange];
        [allTables addObject:exchangeIncomeTable];
    }
     [self.view insertSubview:exchangeIncomeTable belowSubview:recordTypeTable];
}
-(void)loadOtherIncomeContentView{     //其他收入
    if (!otherIncomeTable) {
        otherIncomeTable =[[NewIncomeTable alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y +headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y -headBar.frame.size.height ) style:UITableViewStylePlain];
        otherIncomeTable.tag = 5 ;
        otherIncomeTable.incomeTabDelegate = self;
        [otherIncomeTable initObjectsWithIncomeType:IncomeTypeOther];
        [allTables addObject:otherIncomeTable];
    }
    [self.view insertSubview:otherIncomeTable belowSubview:recordTypeTable];
}
-(void)incomeScrollToCloseChooseView{
    if (recordTypeTable.hidden == NO) {
        [self showRecordType];
    }
}
-(void)goBackVC{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadRecordTypeTableView{
    NSArray *types = @[@"全部",@"任务收入",@"邀请收入",@"活动收入",@"兑换支出",@"其他"];
    recordTypeTable =[[LLRecordTypeTable alloc] initWithFrame:CGRectMake(kmainScreenWidth -kRecordTabWidth, headBar.frame.origin.y +headBar.frame.size.height, kRecordTabWidth, types.count *(kRecordTabCellHeigh +1)) style:UITableViewStylePlain withDataArr:types];
    recordTypeTable.typeDelegate = self;
    recordTypeTable.types = types ;
    recordTypeTable.delaysContentTouches = NO;
    recordTypeTable.hidden = YES;
    [self.view addSubview:recordTypeTable];
}
-(void)didSelectedRowIndex:(int)row{   //点击查看各类型的收支
    [self showRecordType];

    for (NewIncomeTable *table in allTables) {
        if (table.tag == row) {
            table.hidden = NO;
        }else {
            table.hidden = YES ;
        }
    }
    switch (row) {
        case 0:
            [self loadAllIncomeContentView];
            break;
        case 1:
            [self loadMissionIncomeContentView];
            break;
        case 2:
            [self loadInviteIncomeContentView];
            break;
        case 3:
            [self loadActivityIncomeContentView];
            break;
        case 4:
            [self loadExchangeIncomeContentView];
            break;
        case 5:
            [self loadOtherIncomeContentView];
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
                headBar.rightBtn.transform =CGAffineTransformMakeRotation(M_PI *1);
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
-(void) loadContentView{
    allTableview = [[AllTable alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y +headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh)];
    allTableview.tag = 200;
    [allTableview initObjects];
    [self.view addSubview:allTableview];
}

/*
 -(void)loadContentView{
 //【全部】界面
 allTableview = [[AllTable alloc] initWithFrame:CGRectZero];
 allTableview.tag = 200;
 [allTableview initObjects];
 
 //【收入】界面
 incomeTableView = [[IncomeTable alloc]initWithFrame:CGRectZero];
 incomeTableView.backgroundView=nil;
 
 
 //【支出】界面
 outTableView = [[OutTable alloc]initWithFrame:CGRectZero];
 outTableView.backgroundView = nil;
 
 NSArray *array =[[NSArray alloc] initWithObjects:@"全部",@"收入",@"支出", nil];
 NSArray *arrayView =[[NSArray alloc] initWithObjects:allTableview,incomeTableView, outTableView,nil];
 TaoJinScrollView *tjScroll =[[TaoJinScrollView alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y +headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y -headBar.frame.size.height) btnAry:array btnAction:^(UIButton *button) {
 switch (button.tag) {
 case 1:
 {
 if (allTableview.allLogs.count ==0) {
 [allTableview initObjects];
 }
 }
 break;
 
 case 2:
 {
 if (incomeTableView.allLogs.count ==0) {
 [incomeTableView initObjects];
 }
 }
 break;
 
 case 3:
 {
 if (outTableView.allLogs .count ==0) {
 [outTableView initObjects];
 }
 }
 break;
 
 }
 } slidColor:KOrangeColor2_0 viewAry:arrayView];
 [self.view addSubview:tjScroll];
 
 
 }
 */
-(void)viewDidDisappear:(BOOL)animated{
    [ms removeFromSuperview];
    ms = nil;
    [allIncomeTable removeFromSuperview];
    allIncomeTable = nil;
    [missionIncomeTable removeFromSuperview];
    missionIncomeTable = nil;
    [inviteIncomeTable removeFromSuperview];
    inviteIncomeTable =nil;
    [activityIncomeTable removeFromSuperview];
    activityIncomeTable = nil;
    [exchangeIncomeTable removeFromSuperview];
    exchangeIncomeTable =nil;
    [otherIncomeTable removeFromSuperview];
    otherIncomeTable =nil;
    [recordTypeTable removeFromSuperview];
    recordTypeTable =nil;
}
-(void)viewDisappear:(BOOL)animated{
    
    
    [[LoadingView showLoadingView] actViewStopAnimation];
    [allTableview removeFromSuperview];
    allTableview = nil;
    [incomeTableView removeFromSuperview];
    incomeTableView = nil;
    [outTableView removeFromSuperview];
    outTableView = nil;
    [ms removeFromSuperview];
    ms = nil;
    [image removeFromSuperview];
    image = nil;
    if (kDeviceVersion >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


-(void)onClickBackBtn:(UIButton* )btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
