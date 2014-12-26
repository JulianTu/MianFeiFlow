//
//  LXWiFiCenterController.m
//  乐享WiFi
//
//  Created by keyrun on 14-9-17.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LXWiFiCenterController.h"
#import "TTTAttributedLabel.h"
#import "RTLabel.h"
#import "LLScrollView.h"
#import "HeadToolBar.h"



@interface LXWiFiCenterController ()
{
    HeadToolBar *headBar;
}
@end

@implementation LXWiFiCenterController

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
    self.navigationController.navigationBar.hidden =YES;
    
    headBar =[[HeadToolBar alloc]initWithTitle:FlowCenterName backgroundColor:kBlueTextColor];
    [self.view addSubview:headBar];
    
    [self loadTaskCenterHeadView];
    [self loadActivityView];
    [self loadContentView];

}
-(void)loadActivityView {
    
}
-(void)loadTaskCenterHeadView{
    
}
-(void)loadContentView {
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
