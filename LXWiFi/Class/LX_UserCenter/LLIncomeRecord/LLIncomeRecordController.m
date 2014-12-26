//
//  LLIncomeRecordController.m
//  乐享WiFi
//
//  Created by keyrun on 14-10-14.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LLIncomeRecordController.h"
#import "HeadToolBar.h"
#import "LLRecordTypeTable.h"
#define kIncomeRecord   @"流量币明细"

@interface LLIncomeRecordController ()
{
    HeadToolBar *headBar;
    LLRecordTypeTable *recordTypeTable;
}
@end

@implementation LLIncomeRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWitheColor;
    
    headBar =[[HeadToolBar alloc]initWithTitle:kIncomeRecord leftBtnTitle:@"" leftBtnImg:GetImageWithName(@"back") leftBtnHighlightedImg:nil rightBtnTitle:nil rightBtnImg:nil rightBtnHighlightedImg:nil backgroundColor:kBlueTextColor];
    [headBar.leftBtn addTarget:self action:@selector(goBackVC) forControlEvents:UIControlEventTouchUpInside];
    [headBar.rightBtn addTarget:self action:@selector(showRecordType) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    [self loadContentView];
    [self loadRecordTypeTableView];
    
}
-(void)loadContentView{
 
    UITableView *incomeTable =[[UITableView alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y +headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh) style:UITableViewStylePlain];
    [self.view addSubview:incomeTable];
}
-(void)loadRecordTypeTableView{
    NSArray *types = @[@"全部",@"任务收入",@"邀请收入",@"活动收入",@"兑换支出",@"其他"];
    recordTypeTable =[[LLRecordTypeTable alloc] initWithFrame:CGRectMake(kmainScreenWidth -kRecordTabWidth, headBar.frame.origin.y +headBar.frame.size.height, kRecordTabWidth, types.count *(kRecordTabCellHeigh +1)) style:UITableViewStylePlain withDataArr:types];
    [self.view addSubview:recordTypeTable];
}
-(void)goBackVC{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showRecordType{
   
    [UIView animateWithDuration:1.0f animations:^{
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
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
