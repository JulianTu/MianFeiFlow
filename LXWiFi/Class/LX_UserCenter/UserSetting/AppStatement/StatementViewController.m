//
//  StatementViewController.m
//  免费流量王
//
//  Created by keyrun on 14-10-20.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "StatementViewController.h"
#import "HeadToolBar.h"
#import "MScrollVIew.h"
#import "LoadingView.h"
#import "UnderLineLabel.h"
#import "MyUserDefault.h"
//#define kAppStatementUrl     @"http://www.google.com.hk"
#define kAppStatementUrl       @"http://www.91taojin.com.cn/index.php?d=admin&c=page&m=detail&id=6"
@interface StatementViewController ()
{
    HeadToolBar *headBar ;
    UIScrollView *scrollView ;
    UIWebView *webPage;
    UnderLineLabel *refreshWebLab;
}
@end

@implementation StatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kWitheColor ;
    headBar =[[HeadToolBar alloc] initWithTitle:@"应用声明" leftBtnTitle:@"返回" leftBtnImg:GetImage(@"back") leftBtnHighlightedImg:GetImage(@"") rightLabTitle:nil backgroundColor:kBlueTextColor];
    [headBar.leftBtn addTarget:self action:@selector(onClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    if (!scrollView) {
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, headBar.frame.origin.y +headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height)];
        if (kDeviceVersion < 7.0) {
            scrollView.frame =CGRectMake(kmainScreenWidth, 0, kmainScreenWidth, scrollView.frame.size.height -20);
        }
    }
    scrollView.bounces = YES;
    [scrollView setContentSize:CGSizeMake(kmainScreenWidth, scrollView.frame.size.height +1)];
    [self.view addSubview:scrollView];
    [self initWebView];
}
-(void) initWebView{
    webPage =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, CGRectGetHeight(self.view.frame)-headBar.frame.origin.y -headBar.frame.size.height) ];
    NSString *adress =[[MyUserDefault standardUserDefaults] getAppDeclare];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:adress]];
    [webPage loadRequest:request];
    webPage.delegate = self;

    webPage.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    [(UIScrollView* )[[webPage subviews]objectAtIndex:0]setBounces:NO];
    webPage.scalesPageToFit =NO;
    
    
    refreshWebLab =[[UnderLineLabel alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 15.0)];
    refreshWebLab.font = GetFont(12.0f);
    refreshWebLab.textColor = ColorRGB(155.0, 155.0, 155.0, 1) ;
    refreshWebLab.highlightedColor = ColorRGB(230, 230, 230, 1) ;
    refreshWebLab.shouldUnderline = YES;
    [refreshWebLab setText:@"点击刷新" andCenter:CGPointMake(kmainScreenWidth/2, 30)];
    [refreshWebLab sizeToFit];
    refreshWebLab.frame =CGRectMake( kmainScreenWidth/2 -refreshWebLab.frame.size.width/2, webPage.frame.size.height/2- 7.0f, refreshWebLab.frame.size.width, refreshWebLab.frame.size.height);
    [refreshWebLab addTarget:self action:@selector(refreshWebView)];
    refreshWebLab.hidden =YES;
    [webPage addSubview:refreshWebLab];

    
    [scrollView addSubview:webPage];
}
-(void) refreshWebView{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kAppStatementUrl]];
    [webPage loadRequest:request];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[LoadingView showLoadingView] actViewStopAnimation];
}
-(void)viewDidDisappear:(BOOL)animated{
    [scrollView removeFromSuperview];
    scrollView =nil;
    
    [webPage removeFromSuperview];
    webPage =nil;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [[LoadingView showLoadingView] actViewStartAnimation];
    
    refreshWebLab.hidden =YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[LoadingView showLoadingView] actViewStopAnimation];
    refreshWebLab.hidden =NO;

}
-(void)webViewDidFinishLoad:(UIWebView *)webView{

     [[LoadingView showLoadingView] actViewStopAnimation];
    refreshWebLab.hidden =YES;
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    [scrollView setContentSize:CGSizeMake(kmainScreenWidth, webView.frame.size.height )];

}

-(void)onClickBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
