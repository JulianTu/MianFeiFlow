//
//  SettingViewController.m
//  TJiphone
//
//  Created by keyrun on 13-9-30.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutUs.h"
#import "StatusBar.h"
#import "MScrollVIew.h"
#import "HeadToolBar.h"
#import "NewUserTableCell.h"
#import "MyUserDefault.h"
#import "UIImage+ColorChangeTo.h"
#import "SettingCell.h"
#import "StatementViewController.h"
#import "LLAsynURLConnection.h"
#import "UIAlertView+NetPrompt.h"
#define kCellHeight     52.0f
#define kCellHeadH       36.0f
@interface SettingViewController ()
{
    UIImageView* showImage ;
    NSString* appUrl;
    NSMutableArray* array;
    HeadToolBar *headBar;
   
    MScrollVIew *ms ;
    UIAlertView* alert ;         //升级提示窗
    NSArray *sectionOne ;
    NSArray *sectionTwo ;
    
    AboutUs *au;
    UITableView *settingTab;
    
    UIImageView *imageView;
    UILabel *show;
    int  timeOutCount;
    NSString *updateType ;        //升级类型
}
@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    headBar =[[HeadToolBar alloc] initWithTitle:@"更多" leftBtnTitle:@"返回" leftBtnImg:GetImage(@"back.png") leftBtnHighlightedImg:GetImage(@"back_sel.png") rightLabTitle:nil backgroundColor:kBlueTextColor];
    [headBar.leftBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    ms=[[MScrollVIew alloc]initWithFrame:CGRectMake(0, headBar.frame.origin.y+headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh-headBar.frame.size.height-headBar.frame.origin.y) andWithPageCount:1 backgroundImg:nil];
    [ms setContentSize:CGSizeMake(kmainScreenWidth, ms.frame.size.height+1)];
    ms.bounces =YES;
    [self.view addSubview:ms];

    self.view.backgroundColor = ColorRGB(239.0, 244.0, 244.0, 1.0);
    [self initBasciData];
    [self initViews];
    
}
-(void)initBasciData{
    sectionOne = @[@"接收状态栏消息",@"WiFi状态下接收任务推荐"];
    sectionTwo = @[@"检测新版本",@"应用声明",@"关于免费流量通"];
}
-(void)viewDidAppear:(BOOL)animated{
    [self checkNewVersionIsClicked:NO];
}
-(void)receiveNewMessage:(id )sender{
    UISwitch* switchButton =(UISwitch* )sender;
    BOOL isOn =switchButton.on;
    NSUserDefaults* ud =[NSUserDefaults standardUserDefaults];
    NSNumber* num =[NSNumber numberWithBool:isOn];
    //接受新消息通知
    if (isOn ==YES) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge| UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeSound)];
    }else{
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    [ud setObject:num forKey:@"isRecesiveMessage"];
}

-(void)initViews{

    settingTab =[[UITableView alloc] initWithFrame:CGRectMake(0,kCellHeadH, kmainScreenWidth, ms.frame.size.height) style:UITableViewStylePlain];
    settingTab.dataSource =self;
    settingTab.delegate =self;
    settingTab.backgroundColor =[UIColor clearColor];
    settingTab.separatorStyle =UITableViewCellSeparatorStyleNone;
    [ms addSubview:settingTab];
    

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return sectionTwo.count ;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID =@"settingCell";
    NewUserTableCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell =[[NewUserTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    cell.backgroundColor = kWitheColor ;
    cell.isBottom = indexPath.row == sectionTwo.count-1 ? YES : NO;
    cell.isHead = indexPath.row == 0 ? YES:NO;
    [cell setCellViewByType:1 andWithImage:nil andCellTitle:[sectionTwo objectAtIndex:indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return kCellHeight +0.5f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if (indexPath.section ==0) {
        switch (indexPath.row) {
            case 0: // 检测新版本
            {
                [self checkNewVersionIsClicked:YES];
            }
                break;
                
            case 2:    // 关于我们
            {
                au = [[AboutUs alloc]initWithNibName:nil bundle:nil];
                [self.navigationController pushViewController:au animated:YES];
            }
                break;
            case 1:     // 应用声明
            {
                StatementViewController *statement = [[StatementViewController alloc] initWithNibName:nil bundle:nil];
                [self.navigationController pushViewController:statement animated:YES];
                
                
            }
                break;
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([alertView isEqual:alert]) {
        BOOL isUpdateing = buttonIndex ==0 ? NO :YES;
        if (isUpdateing) {
            [self sendUpdateTipStatistic:updateType andTipState:@"1"];   //发送点击升级状态
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:appUrl]];
        }else{
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
    
}

-(void)checkNewVersionIsClicked:(BOOL) isClicked{

    if ([[MyUserDefault standardUserDefaults]getUpdate] == nil) {
        if (isClicked) {
            [StatusBar showTipMessageWithStatus:@"您已经是最新版本了" andImage:nil andTipIsBottom:YES];
        }else {
            [self showUpdateTip:@"已是最新版本" haveUpdate:NO];

        }
        
    }else{
        NSDictionary* dic =[[MyUserDefault standardUserDefaults]getUpdate];
        NSString* content =[dic objectForKey:@"content"];
        appUrl =[dic objectForKey:@"url"];
        NSString* ver =[dic objectForKey:@"ver"];
        updateType =[dic objectForKey:@"type"];
        NSString* version = [[[NSBundle mainBundle]infoDictionary]objectForKey:(NSString* )kCFBundleVersionKey];
        if ([ver isEqualToString:version]) {
            if (isClicked) {
                [StatusBar showTipMessageWithStatus:@"您已经是最新版本了" andImage:nil andTipIsBottom:YES];
            }
        }else{
            if (isClicked) {
                 alert =[[UIAlertView alloc]initWithTitle:@"新版本" message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即更新", nil];
                [alert show];
                [self sendUpdateTipStatistic:updateType andTipState:@"0"];
            }else{
                [self showUpdateTip:@"有新版本" haveUpdate:YES];
            }
        }
    }
    
}
/**
 *  发送升级弹窗统计
 *
 *  @param type  类型    0强制   1提示   2不提示
 *  @param state 状态    0弹窗   1点击升级
 */
-(void)sendUpdateTipStatistic:(NSString *)type andTipState:(NSString *)state{
    NSDictionary *dic =@{@"type":type ,@"state":state};
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,@"ucenter/updatelog"];
    NSLog(@"发送升级弹窗统计 ==%@  %@",dic,urlStr);
    [LLAsynURLConnection requestURLWith:urlStr dataDic:dic andProtocolNum:@"40011" andTimeOut:httpTimeout connectSuccess:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dicData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@" 升级弹窗统计 ==%@",dicData);
        });
    } andFail:^(NSError *error) {
        NSLog(@" 升级弹窗统计错误 ==%@",error);
        if(error.code == timeOutErrorCode){
            if(timeOutCount < 2){
                timeOutCount ++;
                [self sendUpdateTipStatistic:type andTipState:state];
            }else{
                timeOutCount = 0;
                if(![UIAlertView isInit]){
                    UIAlertView *alertView = [UIAlertView showNetAlert];
                    alertView.delegate = self;
                    alertView.tag = kNetViewTag + 1;
                    [alertView show];
                    alertView = nil;
                }
            }
        }
        
    }];
}

-(void)showUpdateTip:(NSString *)tipString haveUpdate:(BOOL) isnewest{
   
    float showLabOffX = kOffX_2_0 +20.0f ;
    float showLabH  = 15.0f ;
    float showLabW = isnewest==YES ? 55.0f: 70.0f ;
    if (!show) {
        show =[[UILabel alloc]initWithFrame:CGRectMake( kmainScreenWidth - showLabW -showLabOffX, (kCellHeight-showLabH) /2, showLabW, showLabH)];
    }
    imageView.frame =show.frame;
    show.textAlignment =NSTextAlignmentCenter;
    show.text =tipString;
    show.textColor = isnewest ==YES ? kWitheColor :kContentTextColor;
    show.font =[UIFont systemFontOfSize:11.0];
    show.backgroundColor = isnewest ==YES ? kRedTextColor:[UIColor clearColor];
    show.layer.masksToBounds =YES;
    show.layer.cornerRadius = show.frame.size.height/2 ;
    
    show.frame = CGRectMake(kmainScreenWidth -showLabOffX -show.frame.size.width, (kCellHeight-showLabH) /2, show.frame.size.width, show.frame.size.height);
    NewUserTableCell *cell = (NewUserTableCell *)[settingTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    [cell.contentView addSubview:show];
}
-(void)onClickNextBtn:(UIButton* )btn{
    
    
    switch (btn.tag) {
            //检测新版本
        case 1:
        {
            [self checkNewVersionIsClicked:YES];
        }
            break;
            //关于我们
        case 2:
        {
        }
            break;
            //意见反馈
            /*
             case 3:
             {
             OpinionBack *ob = [[OpinionBack alloc]initWithNibName:nil bundle:nil];
             [nc presentViewController:ob animated:YES completion:^{
             
             }];
             }
             break;
             */
            //给我评分
        case 3:
        {


        }
            break;
            //输入邀请码  已弃用
        case 5:
        {
            
        }
            break;
    }
}

-(void)showImagehid{
    showImage.highlighted =NO;
}

-(void)onClickBackBtn:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
