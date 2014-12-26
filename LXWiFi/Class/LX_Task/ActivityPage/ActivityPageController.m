//
//  ActivityPageController.m
//  免费流量王
//
//  Created by keyrun on 14-10-25.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "ActivityPageController.h"
#import "TaoJinButton.h"
#import "LoadingView.h"

#define kBottomItemOffx     22.0f
#define kBottomItemOffy     8.0f
#define kBottomItemTag      1200
@interface ActivityPageController ()
{
    UIWebView *pageWebView ;
    float bottomViewH ;
    
    UIView *bottomBgView ;
    int webFailedCount ;
}
@end

@implementation ActivityPageController
-(void)viewWillAppear:(BOOL)animated {
    if (kDeviceVersion >=7.0) {
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 20.0f)];
        view.backgroundColor = [UIColor blackColor];
        [self.view addSubview:view];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    webFailedCount = 0 ;
    [self loadBottomContentView];
}
-(void) loadBottomContentView {
    UIImage *image =GetImage(@"webback");
    bottomViewH = image.size.height +2* kBottomItemOffy ;
    
    float itemOffx =(kmainScreenWidth- 4*image.size.width -2*kBottomItemOffx)/3 ;
    
    bottomBgView =[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-bottomViewH, kmainScreenWidth, bottomViewH)];
    bottomBgView.backgroundColor = ColorRGB(250.0, 250.0, 250.0, 1.0);
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, kmainScreenWidth, LineWidth);
    layer.backgroundColor = kLineColor2_0.CGColor ;
    
    [bottomBgView.layer addSublayer:layer];
    
    NSArray *images =@[GetImage(@"webback"),GetImage(@"webforward"),GetImage(@"webrefresh"),GetImage(@"webclose")];
    for (int i=0; i <images.count; i++) {
        UIImage *img = [images objectAtIndex:i];
        TaoJinButton *btn = [self loadBottomItemWithFrame:CGRectMake(kBottomItemOffx +(img.size.width +itemOffx)*i, kBottomItemOffy,img.size.width, img.size.height) andImgae:img];
        btn.tag = kBottomItemTag +i ;
        btn.alpha = (i==0)||(i==1) ? 0.25f: 1.0f;
        [btn addTarget:self action:@selector(clickedBottomIconBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomBgView addSubview:btn];
    }
    //    self.activityUrl =@"http://www.baidu.com/";

    dispatch_async(dispatch_get_main_queue(), ^{    //针对push通知界面跳转 在main线程中初始化webview 否则会crash
        [self initWebView];
    });
        

    
    [self.view addSubview:bottomBgView];
}
-(void) initWebView {
    float originy = kDeviceVersion <7.0 ? 0.0f :20.0f;
    if (!pageWebView) {
        pageWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, originy, kmainScreenWidth, CGRectGetHeight(self.view.frame)-bottomViewH -originy) ];
        NSURLRequest *request =[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.activityUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        [pageWebView loadRequest:request];
        pageWebView.delegate = self;
        pageWebView.scalesPageToFit = NO;
        pageWebView.userInteractionEnabled =YES;
        pageWebView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:pageWebView];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self checkCanBackAndForward];
    
    if (webView.isLoading ==NO) {
        [bottomBgView viewWithTag:kBottomItemTag +2] ;
    }
    
    if (webView.frame.size.height >1) {
        [[LoadingView showLoadingView] actViewStopAnimation];
        
    }else{
        NSURL *url = [NSURL URLWithString:self.activityUrl];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
        [webView loadRequest:request];
    }
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self doRefreshAnimation];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@" webview adress %@ ",request.URL.absoluteString);
    if ([request.URL.absoluteString hasSuffix:@"#target"]) {     // 连接后面带target 跳转到外部
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }else{
        return YES;
    }
}

-(void)checkCanBackAndForward {
    BOOL canBack = pageWebView.canGoBack ;
    [bottomBgView viewWithTag:kBottomItemTag] .alpha =canBack ? 1.0 :0.25;
    [bottomBgView viewWithTag:kBottomItemTag] .userInteractionEnabled = canBack ? YES: NO;
    
    BOOL canForward = pageWebView.canGoForward ;
    [bottomBgView viewWithTag:kBottomItemTag +1].alpha = canForward? 1.0:0.25;
    [bottomBgView viewWithTag:kBottomItemTag +1] .userInteractionEnabled = canForward ? YES: NO;
    
    BOOL isStop =pageWebView.isLoading ;
    if (!isStop) {
        [[bottomBgView viewWithTag:kBottomItemTag +2].layer removeAnimationForKey:@"refresh"];
    }
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self checkCanBackAndForward];
    if (webFailedCount < 5) {
        webFailedCount ++ ;
        NSURL *url = [NSURL URLWithString:self.activityUrl];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
        [pageWebView loadRequest:request];
    }
}
-(void)clickedBottomIconBtn:(TaoJinButton *)iconBtn {
    switch (iconBtn.tag) {
        case kBottomItemTag:    //返回
        {
            [pageWebView goBack];
        }
            break;
        case kBottomItemTag +1:    //前进
        {
            [pageWebView goForward];
        }
            break;
        case kBottomItemTag +2:    //刷新
        {
            [pageWebView reload];
            
            [self doRefreshAnimation];
        }
            break;
        case kBottomItemTag +3:    //关闭
        {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
            break;
            
        default:
            break;
    }
}
-(void)doRefreshAnimation {
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setFromValue:[NSNumber numberWithFloat: M_PI]];
    [spin setToValue:[NSNumber numberWithFloat:M_PI *-1 ]];
    [spin setDuration:1];
    [spin setRepeatCount:10000];
    [spin setDelegate:self];
    [spin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [[bottomBgView viewWithTag:kBottomItemTag +2].layer addAnimation:spin forKey:@"refresh"];
    
}
-(TaoJinButton *) loadBottomItemWithFrame:(CGRect) frame andImgae:(UIImage *)iconImg {
    TaoJinButton *iconBtn =[[TaoJinButton alloc] initWithFrame:frame titleStr:nil titleColor:nil font:nil logoImg:iconImg backgroundImg:nil];
    return iconBtn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
