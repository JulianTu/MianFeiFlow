//
//  MessageViewController.m
//  TJiphone
//
//  Created by keyrun on 13-9-30.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "MessageViewController.h"
#import "LoadingView.h"
#import "MScrollVIew.h"
#import "SysMessage.h"
#import "ViewTip.h"
#import "StatusBar.h"
#import "MyUserDefault.h"
#import "AsynURLConnection.h"
#import "UIAlertView+NetPrompt.h"
#import "HeadToolBar.h"
#import "MessageFrame.h"
#import "TaoJinLabel.h"
#import "CButton.h"
#import "TaoJinScrollView.h"
#import "QuestTable.h"
#import "UIImage+ColorChangeTo.h"
#import "TablePullToLoadingView.h"
#import "LXTabViewController.h"
#import "TaoJinButton.h"
#import "CompressImage.h"
#import "NSString+emptyStr.h"
#import "UIImage+ColorChangeTo.h"
#import "CommentViewController.h"
#import "LLAsynURLConnection.h"
#import "UnderLineLabel.h"
#define ImgaePickerTag                       40001          // 选图 actionsheet
#define DeleteTag                            40002          // 删除信息 actionsheet
#define kCommonQuestAdress                 @"http://www.91taojin.com.cn/index.php?d=admin&c=page&m=detail&id=6"

@interface MessageViewController (){
    UITableView* tableView0;
    
    UIView* footView;
    
    UILabel *footLabel;
    
    ViewTip *tip;
    //    HeadView *headView;
    
    NSMutableArray *allLogs;                                                    //存放消息中心数据
    
    BOOL isFristToGetMessage;                                                   //表示是否第一次请求获取消息中心
    
    int timeOutCount;                                                           //连接超时次数
    
    int index;
    int page;
    int maxPage;
    int curPage;
    HeadToolBar *headBar;
    int deleteMsgID;
    
    UIView *containView;
    HPGrowingTextView *textView ;
    TaoJinLabel *messageLab ;
    TaoJinButton *sendBtn ;
    CGSize kbSize;                                      //键盘高度
    CGFloat normalKeyboardHeight;
    UIViewAnimationOptions animationOptions ;
    UIView *lineView;
    TaoJinButton *imgBtn ;
    UIImage *getImage;
    QuestTable *questView;
    
    TaoJinScrollView *tjScrollView;
    UIWebView *questwebView ;
    UIScrollView *questSV ;
    UIAlertView* alertTip ;
    UIScrollView *msgScroll ;
    
    UnderLineLabel *refreshWebLab;
}
@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//初始化变量
-(void)initWithObjects{
    page = 1;
    index = 0;
    maxPage = 0;
    curPage = 0;
    allLogs =[[NSMutableArray alloc] init];
  /*
    SysMessage *message1 =[[SysMessage alloc]init];
    message1.msgId = 12549;
    message1.msgStatus =0 ;
    message1.msgCom = @"自己发发的消息啊实打实的鞍山的";
    message1.msgTime = @"1413510745";
    message1.type = 2 ;
    SysMessage *message2 =[[SysMessage alloc]init];
    message2.msgId = 12549 ;
    message2.msgStatus =0;
    message2.type = 1 ;
    message2.msgCom =@"系统发的消息啊实打实的啊沙发沙发上打你们暗示法撒旦";
    message2.msgTime =@"1413510780";
//    NSDictionary *dic1 =[NSDictionary dictionaryWithObjectsAndKeys:@"12549",@"Id",@"自己发打<a href='http://store.apple.com'>link to apple store</a>",@"Msg",@"1413510745",@"Time",@"2",@"Type",@"0",@"status" ,nil];
//    NSDictionary *dic3 =[NSDictionary dictionaryWithObjectsAndKeys:@"12549",@"Id",@"自己发打实的鞍山的发发的消息啊实打实的鞍山发发发的消",@"Msg",@"1413510745",@"Time",@"2",@"Type",@"0",@"status" ,nil];
//    NSDictionary *dic2 =[NSDictionary dictionaryWithObjectsAndKeys:@"12550",@"Id",@"System发发发的消息啊实打实的鞍山发发发的消息啊实打实的鞍山的消发发的消息啊实打实的鞍山息啊实打实的鞍山的",@"Msg",@"1413510760",@"Time",@"1",@"Type",@"0",@"status" ,nil];
//    NSDictionary *dic4 =[NSDictionary dictionaryWithObjectsAndKeys:@"12550",@"Id",@"鞍山数据啊打卡上的啊沙发沙发",@"Msg",@"1413410760",@"Time",@"1",@"Type",@"0",@"status" ,nil];
    //    [allLogs addObject:dic1];
    //    [allLogs addObject:dic2];
    //    [allLogs addObject:dic3];
    //    [allLogs addObject:dic4];
    */
    
    timeOutCount = 0;
    isFristToGetMessage = YES;
    [[MyUserDefault standardUserDefaults] setUserAskStr:nil];  // 进入界面后 本地数据清掉
    [self requestForAllMyMessage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initWithObjects];
    
    [[MyUserDefault standardUserDefaults] setUserMsgNum:0];
    
    
    self.view.backgroundColor = kWitheColor ;
    
    headBar = [[HeadToolBar alloc] initWithTitle:@"消息中心" leftBtnTitle:@"返回" leftBtnImg:GetImageWithName(@"back") leftBtnHighlightedImg:nil rightBtnTitle:@"我要反馈" rightBtnImg:nil rightBtnHighlightedImg:nil backgroundColor:kBlueTextColor];
    [headBar.rightBtn addTarget:self action:@selector(onclickedAskQuestion) forControlEvents:UIControlEventTouchUpInside];
    [headBar.leftBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [self initQuestViewContent];     //常见问题
    
    [self initAskViewContent];
    [self initScrollView];
    
}
-(void)onclickedAskQuestion {
    if (tjScrollView.scrollView.contentOffset.x ==0) {
        alertTip =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"大部分用户的疑问我们都在常见问题中给出了解答，是否先查看常见问题？" delegate:self cancelButtonTitle:@"继续反馈" otherButtonTitles:@"查看常见问题", nil];
        [alertTip show];
    }else{
        CommentViewController *comment =[[CommentViewController alloc] initWithNibName:nil bundle:nil];
        comment.commentType = CommentTypeAsk ;
        [self.navigationController pushViewController:comment animated:YES];
    }
    
}
-(void)initAskButton {     //初始化提问
    
    UIView *btnBGView =[[UIView alloc] initWithFrame:CGRectMake(0, tjScrollView.scrollView.frame.size.height- SendViewHeight, kmainScreenWidth, SendViewHeight)];
    btnBGView.backgroundColor = kWitheColor ;
    
    CALayer *layer =[CALayer layer];
    layer.backgroundColor = kLineColor2_0.CGColor ;
    layer.frame = CGRectMake(0, LineWidth, btnBGView.frame.size.width, LineWidth);
    [btnBGView.layer addSublayer:layer];
    
    TaoJinButton *msgBtn = [[TaoJinButton alloc]initWithFrame:CGRectMake(kmainScreenWidth/2 -SendButtonWidth/2, SendViewHeight/2- SendButtonHeight/2, SendButtonWidth, SendButtonHeight) titleStr:@"反馈信息" titleColor:kWitheColor font:GetFont(16.0) logoImg:nil backgroundImg:[UIImage createImageWithColor:kBlueTextColor]];
    [msgBtn setBackgroundImage:[UIImage createImageWithColor:kLightBlueTextColor] forState:UIControlStateHighlighted];
    msgBtn.layer.masksToBounds = YES;
    msgBtn.layer.cornerRadius = msgBtn.frame.size.height /2 ;
    [msgBtn addTarget:self action:@selector(onClickedSendBackMsg) forControlEvents:UIControlEventTouchUpInside];
    [tjScrollView.scrollView addSubview:btnBGView];
    [btnBGView addSubview:msgBtn];
}
-(void)onClickedSendBackMsg {
    CommentViewController *comment = [[CommentViewController alloc] initWithNibName:nil bundle:nil];
    comment.commentType = CommentTypeAsk ;
    [self.navigationController pushViewController:comment animated:YES];
}
/**
 *  初始化输入框
 *
 *  @param frame 大小
 */

- (void)initWithTextViewFrame:(CGRect)frame{
    containView = [[UIView alloc] initWithFrame:frame];
    containView.backgroundColor = KLightGrayColor2_0;
    CALayer *layer = [CALayer layer];
    [layer setBackgroundColor:[kLineColor2_0 CGColor]];
    [layer setFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, LineWidth)];
    [containView.layer addSublayer:layer];
    
    imgBtn =[[TaoJinButton alloc]initWithFrame:CGRectMake(ImageButtonOffX, (SendViewHeight -ImageButtonWidth) /2, ImageButtonWidth, ImageButtonWidth) titleStr:@"" titleColor:nil font:nil logoImg:GetImageWithName(@"") backgroundImg:[UIImage createImageWithColor:kBlueTextColor]];
    [imgBtn addTarget:self action:@selector(onClickedGetUserImage) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview:imgBtn];
    
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(2* ImageButtonOffX +ImageButtonWidth, imgBtn.frame.origin.y, kmainScreenWidth -(3* ImageButtonOffX + ImageButtonWidth +SendButtonWidth), ImageButtonWidth)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 2;
    textView.backgroundColor = KLightGrayColor2_0;
    textView.internalTextView.backgroundColor = KLightGrayColor2_0;
    textView.returnKeyType = UIReturnKeyDefault;
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    textView.internalTextView.enablesReturnKeyAutomatically = YES;
    [textView setText:[[MyUserDefault standardUserDefaults] getShowPostsComment]];
    [containView addSubview:textView];
    containView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:containView];
    
    lineView =[[UIView alloc] init];
    [lineView setBackgroundColor:kLineColor2_0 ];
    [lineView setFrame:CGRectMake(textView.frame.origin.x +5, imgBtn.frame.origin.y +imgBtn.frame.size.height, kmainScreenWidth -(3 *ImageButtonOffX +ImageButtonWidth), LineWidth)];
    [containView addSubview:lineView];
    
    messageLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(textView.frame.origin.x + 8.0f, textView.frame.origin.y + 3.0f, 200.0, 30.0f) text:@"提点意见或取得联系" font:[UIFont systemFontOfSize:14] textColor:KGrayColor2_0 textAlignment:NSTextAlignmentLeft numberLines:1];
    [containView addSubview:messageLab];
    if(![NSString isEmptyString:[textView text]]){
        messageLab.hidden = YES;
    }else{
        messageLab.hidden = NO;
    }
    //发送按钮
    sendBtn = [[TaoJinButton alloc] initWithFrame:CGRectMake(kmainScreenWidth - 6.0f - SendButtonWidth, containView.frame.size.height/2 - SendButtonHeight/2, SendButtonWidth, SendButtonHeight) titleStr:@"提交" titleColor:kWitheColor font:[UIFont systemFontOfSize:14] logoImg:nil backgroundImg:[UIImage createImageWithColor:kBlueTextColor]];
    [sendBtn setBackgroundImage:[UIImage createImageWithColor:kLightBlueTextColor] forState:UIControlStateHighlighted];
    [sendBtn.layer setBorderWidth:LineWidth];
    [sendBtn.layer setBorderColor:[kLineColor2_0 CGColor]];
    [sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview:sendBtn];
}
-(void)sendAction:(UIButton *)button {  //发送消息
    
}

-(void)keyBoardWillShow:(NSNotification*)notification{
    NSValue *keyboardObj =[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect ;
    [keyboardObj getValue:&keyboardRect];
    
    NSTimeInterval time = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve;
    [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    animationOptions = curve << 16 ;
    [self adjustContainViewPosition:CGRectMake(0,kmainScreenHeigh- (keyboardRect.size.height +containView.frame.size.height), containView.frame.size.width, containView.frame.size.height) andTime:time andAnimationCure:animationOptions];
    
}
-(void) adjustContainViewPosition:(CGRect)rect andTime:(float) time andAnimationCure:(UIViewAnimationOptions )curve{
    [UIView animateWithDuration:time delay:0.0 options:curve animations:^{
        containView.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
}


-(void)viewDidAppear:(BOOL)animated{
    if (kDeviceVersion >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate =self;
    }
    
    if ([[MyUserDefault standardUserDefaults] getuserAskStr]) {
        NSDictionary *dic =[[MyUserDefault standardUserDefaults] getuserAskStr];
        
        if (allLogs.count ==0) {
            [allLogs addObject:dic];
            [tableView0 reloadData];
            if (tip) {
                [tip removeFromSuperview];
            }
        }else{
            [allLogs insertObject:dic atIndex:0];
            NSIndexPath *indexpath =[NSIndexPath indexPathForRow:0 inSection:0];
            [tableView0 insertRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationNone];
            if (allLogs.count >1) {
                [tableView0 reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                
            }
        }
        [[MyUserDefault standardUserDefaults] setUserAskStr:nil];
    }
    
}

-(void)onClickedGetUserImage{
    UIActionSheet* as=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    as.tag = ImgaePickerTag ;
    as.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [as dismissWithClickedButtonIndex:2 animated:YES];
    if (kDeviceVersion < 7.0) {
        LXTabViewController *tj = [[LXTabViewController alloc]init];
        [as showFromTabBar:tj.tabBar];
    }else{
        [as showInView:self.view];
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == ImgaePickerTag) {
        switch (buttonIndex) {
                //拍照
            case 0:
            {
                UIImagePickerControllerSourceType type=UIImagePickerControllerSourceTypeCamera;
                if([UIImagePickerController isSourceTypeAvailable:type]){
                    UIImagePickerController* pc=[[UIImagePickerController alloc]init];
                    pc.delegate=self;
                    pc.allowsEditing=YES;
                    pc.sourceType=UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:pc animated:YES completion:nil];
                }
            }
                break;
                //从相册取相片
            case 1:
            {
                UIImagePickerController* pc=[[UIImagePickerController alloc]init];
                pc.delegate=self;
                pc.allowsEditing=YES;
                pc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:pc animated:YES completion:nil];
                
            }
                break;
                
        }
    }else if (actionSheet.tag == DeleteTag){
        switch (buttonIndex) {
            case 0:
            {
                [self onClickDeleteBtn:deleteMsgID isAll:NO];     // 删除一条信息
            }
                break;
            case 1:
            {
                [self onClickDeleteBtn:0 isAll:YES];    // 删掉全部信息
            }
                break;
            default:
                break;
        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    getImage=[info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    float scale =[UIScreen mainScreen].scale ;
    if ([self isBigImage:getImage]==YES) {
        getImage =[CompressImage imageWithOldImage:getImage scaledToSize:CGSizeMake(120.0f *scale, 120.0f *scale)];
    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(getImage, self, nil, NULL);
    }
    [self sendSaveInforRequest:getImage];    //上传图片到服务器
}
-(void)sendSaveInforRequest:(UIImage *)image{
    
}
-(BOOL)isBigImage:(UIImage*)image{
    NSData* data =UIImageJPEGRepresentation(image, 1.0);
    
    if (data.length >10240) {
        return YES;
    }else{
        return NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [[LoadingView showLoadingView] actViewStopAnimation];
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)requestForAllMyMessage{
    if(isFristToGetMessage){
        [[LoadingView showLoadingView] actViewStartAnimation];
        isFristToGetMessage = false;
    }
    NSString *string =[NSString stringWithFormat:kOnlineWeb ,@"message/"];
    NSString *urlStr =[NSString stringWithFormat:@"%@%d",string,page];
    [LLAsynURLConnection requestForMethodGetWithURL:urlStr dataDic:nil andProtocolNum:@"40002" andTimeOut:httpTimeout successBlock:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            timeOutCount = 0;
            NSLog(@"请求获取我的消息中心【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                if(body != nil){
                    curPage = [[body objectForKey:@"curpage"] intValue];
                    maxPage = [[body objectForKey:@"maxpage"] intValue];
                    NSArray *msg = [body objectForKey:@"list"];
                    if([msg isKindOfClass:[NSNull class]] || msg.count ==0){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            tableView0.tableFooterView.hidden = YES;
                            [[LoadingView showLoadingView] actViewStopAnimation];
                            [self showTipView];
                        });
                    }else{
                        if(curPage == page){
                            page ++;
                            if(allLogs == nil){
                                allLogs = [[NSMutableArray alloc] initWithArray:msg];
                            }else{
                                [allLogs insertObjects:msg atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(allLogs.count, msg.count)]];
                            }
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            tableView0.tableFooterView.hidden = YES;
                            [tableView0 reloadData];
                            [[LoadingView showLoadingView] actViewStopAnimation];
                        });
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        tableView0.tableFooterView.hidden = YES;
                        [[LoadingView showLoadingView] actViewStopAnimation];
                    });
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                tableView0.tableFooterView.hidden = YES;
                [[LoadingView showLoadingView] actViewStopAnimation];
            });
            
        });
        
    } andFailBlock:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            if(timeOutCount < 2){
                [self requestForAllMyMessage];
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

//请求获取我的消息中心
-(void)requestToGetMyMessage{
    if(isFristToGetMessage){
        [[LoadingView showLoadingView] actViewStartAnimation];
        isFristToGetMessage = false;
    }
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid, @"PageNum":[NSNumber numberWithInt:page], @"Type":@"all"};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"MyCenterUI",@"GetMyMsg"];
    NSLog(@"请求获取我的消息中心【urlStr】 = %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            timeOutCount = 0;
            NSLog(@"请求获取我的消息中心【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                if(body != nil){
                    curPage = [[body objectForKey:@"CurPage"] intValue];
                    maxPage = [[body objectForKey:@"MaxPage"] intValue];
                    NSArray *msg = [body objectForKey:@"Msg"];
                    if([msg isKindOfClass:[NSNull class]]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            tableView0.tableFooterView.hidden = YES;
                            [[LoadingView showLoadingView] actViewStopAnimation];
                            [self showTipView];
                        });
                    }else{
                        if(curPage == page){
                            page ++;
                            if(allLogs == nil){
                                allLogs = [[NSMutableArray alloc] initWithArray:msg];
                            }else{
                                [allLogs insertObjects:msg atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(allLogs.count, msg.count)]];
                            }
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            tableView0.tableFooterView.hidden = YES;
                            [tableView0 reloadData];
                            [[LoadingView showLoadingView] actViewStopAnimation];
                        });
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        tableView0.tableFooterView.hidden = YES;
                        [[LoadingView showLoadingView] actViewStopAnimation];
                    });
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                tableView0.tableFooterView.hidden = YES;
                [[LoadingView showLoadingView] actViewStopAnimation];
            });
            
        });
    } fail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            if(timeOutCount < 2){
                [self requestToGetMyMessage];
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
    NSLog(@" buttonIndex  %d",buttonIndex);
    if ([alertView isEqual:alertTip]) {
        switch (buttonIndex) {
            case 0:  //继续反馈
            {
                CommentViewController *comment =[[CommentViewController alloc] initWithNibName:nil bundle:nil];
                comment.commentType = CommentTypeAsk ;
                [self.navigationController pushViewController:comment animated:YES];
            }
                break;
            case 1:   //浏览常见问题
            {
                [tjScrollView.scrollView setContentOffset:CGPointMake(kmainScreenWidth, 0) animated:YES];
                [tjScrollView.segmented setSelectedSegmentIndex:1];
            }
                break;
            default:
                break;
        }
    }
    if(alertView.tag == kTimeOutTag){
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [UIAlertView resetNetAlertNil];
        [[LoadingView showLoadingView] actViewStartAnimation];
        [self requestForAllMyMessage];
    }
}

-(void)showTipView{
    tip = [[ViewTip alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
    [tip setViewTipByImage:[UIImage imageNamed:@"tipview"]];
    [tip setViewTipByContent:@"暂无系统消息\n提供您的宝贵意见？"];
    [tableView0 insertSubview:tip atIndex:0];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    refreshWebLab.hidden =YES;
    webView.userInteractionEnabled =NO;
    [[LoadingView showLoadingView] actViewStopAnimation];

    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    [questSV setContentSize:CGSizeMake(kmainScreenWidth, webView.frame.size.height +20)];
    
    if (webView.frame.size.height >1) {
        [[LoadingView showLoadingView] actViewStopAnimation];
    }else{
        NSURL *url = [NSURL URLWithString:kCommonQuestAdress];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
        [webView loadRequest:request];
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSURLCache sharedURLCache] setMemoryCapacity: 0];
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    refreshWebLab.hidden =NO;
    webView.userInteractionEnabled =YES;
    [[LoadingView showLoadingView] actViewStopAnimation];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    refreshWebLab.hidden =YES;
    webView.userInteractionEnabled =NO;
    [[LoadingView showLoadingView] actViewStartAnimation];
}

-(void)refreshWebView{
    NSURL *url = [NSURL URLWithString:kCommonQuestAdress];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [questwebView loadRequest:request];
}
-(void)initQuestViewContent{      //常见问题
    /*
     questView =[[QuestTable alloc] initWithFrame:CGRectMake(0,0, kmainScreenWidth, kmainScreenHeigh -headBar.frame.size.height -headBar.frame.origin.y -SendViewHeight -tjScrollView.getButtonRowHeight) style:UITableViewStylePlain];
     questView.backgroundView = nil;
     questView.backgroundColor = [UIColor clearColor];
     */
    if (!questSV) {
        questSV = [[UIScrollView alloc]initWithFrame:CGRectMake(kmainScreenWidth, 0, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height)];
        if (kDeviceVersion < 7.0) {
            questSV.frame =CGRectMake(kmainScreenWidth, 0, kmainScreenWidth, questSV.frame.size.height -20);
        }
    }
    
    questwebView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, CGRectGetHeight(self.view.frame) -headBar.frame.size.height-headBar.frame.origin.y -tjScrollView.getButtonRowHeight)];
    NSString *adress =[[MyUserDefault standardUserDefaults] getAppCommentQuestion];
    [questwebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:adress] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10]];
    questwebView.delegate = self;
    questwebView.userInteractionEnabled =NO;
    questwebView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    [(UIScrollView* )[[questwebView subviews]objectAtIndex:0]setBounces:NO];
    questwebView.scalesPageToFit =NO;
    
    refreshWebLab =[[UnderLineLabel alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 15.0)];
    refreshWebLab.font = GetFont(12.0f);
    refreshWebLab.textColor = ColorRGB(155.0, 155.0, 155.0, 1) ;
    refreshWebLab.highlightedColor = ColorRGB(230, 230, 230, 1) ;
    refreshWebLab.shouldUnderline = YES;
    [refreshWebLab setText:@"点击刷新" andCenter:CGPointMake(kmainScreenWidth/2, 30)];
    [refreshWebLab sizeToFit];
    refreshWebLab.frame =CGRectMake( kmainScreenWidth/2 -refreshWebLab.frame.size.width/2, questwebView.frame.size.height/2- 7.0f, refreshWebLab.frame.size.width, refreshWebLab.frame.size.height);
    [refreshWebLab addTarget:self action:@selector(refreshWebView)];
    refreshWebLab.hidden =YES;
    [questwebView addSubview:refreshWebLab];

    [questSV addSubview:questwebView];
    
}

-(void)hiddenTheKeyboard {
    [textView resignFirstResponder];
    [self adjustContainViewPosition:CGRectMake(0, kmainScreenHeigh- containView.frame.size.height, containView.frame.size.width, containView.frame.size.height) andTime:0.25 andAnimationCure:animationOptions];
}
-(void)sendRequestForCommentQuestion {
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,@"page/help"];
    [LLAsynURLConnection requestForMethodGetWithURL:urlStr dataDic:nil andProtocolNum:@"80001" andTimeOut:httpTimeout successBlock:^(NSData *data) {
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//           NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           NSString *string =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
           NSLog(@" 常见问题请求 ==%@ ",string);
       });
    } andFailBlock:^(NSError *error) {
        
    }];
}

-(void)initScrollView{
    
    NSArray *arrayView =[[NSArray alloc] initWithObjects:tableView0,questSV, nil];
    NSArray *array =[[NSArray alloc] initWithObjects:@"消息记录",@"常见问题" ,nil];
    tjScrollView =[[TaoJinScrollView alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y  +headBar.frame.size.height , kmainScreenWidth, CGRectGetHeight(self.view.frame) -headBar.frame.size.height -headBar.frame.origin.y) btnAry:array btnAction:^(UISegmentedControl *segment) {
        if (segment.selectedSegmentIndex ==0) {
            
        }
        else{
//            [self sendRequestForCommentQuestion];
            
        }
    } slidColor:kBlueTextColor viewAry:arrayView];
    tjScrollView.scrollView.delaysContentTouches =NO;
    tableView0.frame =CGRectMake(0, 0, kmainScreenWidth, CGRectGetHeight(self.view.frame) -headBar.frame.origin.y -headBar.frame.size.height -[tjScrollView getButtonRowHeight] );
    msgScroll.frame =CGRectMake(0, 0, kmainScreenWidth, CGRectGetHeight(self.view.frame) -headBar.frame.origin.y -headBar.frame.size.height -[tjScrollView getButtonRowHeight]);
    
    questView.frame =CGRectMake(kmainScreenWidth, 0, kmainScreenWidth, CGRectGetHeight(self.view.frame) -headBar.frame.origin.y -headBar.frame.size.height -[tjScrollView getButtonRowHeight]);
    [self.view addSubview:tjScrollView];
    
}
-(void)initAskViewContent{      //提问
    
    if (tableView0) {
        [tableView0 removeFromSuperview];
        tableView0 = nil;
    }
    
    tableView0 = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kmainScreenWidth, kmainScreenHeigh -headBar.frame.size.height -headBar.frame.origin.y- tjScrollView.getButtonRowHeight ) style:UITableViewStylePlain];
    msgScroll =[[UIScrollView alloc] initWithFrame:tableView0.frame];
    [msgScroll setContentSize:CGSizeMake(msgScroll.frame.size.width, msgScroll.frame.size.height)];
    
    tableView0.delegate = self;
    tableView0.dataSource = self;
    tableView0.delaysContentTouches =NO;
    tableView0.backgroundView = nil;
    tableView0.backgroundColor = [UIColor clearColor];
    [tableView0 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    TablePullToLoadingView *loadingView = [[TablePullToLoadingView alloc] init];
    tableView0.tableFooterView = loadingView;
    tableView0.tableFooterView.hidden = YES;
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenTheKeyboard)];
    tapGest.numberOfTapsRequired =1;
    tapGest.numberOfTouchesRequired =1 ;
    [tableView0 addGestureRecognizer:tapGest];
    [msgScroll addSubview:tableView0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allLogs.count ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *string = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.celltag = indexPath.row;
    cell.backgroundColor = [UIColor clearColor];
    
    if (allLogs.count != 0 ) {
        cell.msg = [[SysMessage alloc]initSysMessageByDic:[allLogs objectAtIndex:indexPath.row ]];
        if (indexPath.row -1 >=0) {         //判断消息是否是同一天
            SysMessage *lastMsg =[[SysMessage alloc] initSysMessageByDic:[allLogs objectAtIndex:indexPath.row -1]];
            if ([lastMsg.msgTime isEqualToString:cell.msg.msgTime]) {
                cell.isOneDay =YES;
            }
        }
        [cell initMessageCellContentWith:cell.msg WithBlock:^(NSString *jumpUrl) {      //消息中的超链接
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:jumpUrl]];
        }];
        
    }
    cell.mcDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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

//获取长按手势
-(void)getLongPressGestureRecognizer:(int )msgid andCellTag:(int) tag{
    index =tag;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"删除该消息" ,@"清空", nil];
    actionSheet.tag = DeleteTag;
    deleteMsgID =msgid;
    if (kDeviceVersion < 7.0) {
        LXTabViewController *tj = [[LXTabViewController alloc] init];
        [actionSheet showFromTabBar:tj.tabBar];
    }else{
        [actionSheet showInView:self.view];
    }
}


//点击删除按钮
-(void)onClickDeleteBtn:(int )msgid isAll:(BOOL) isall{
    [self requestForDeleteMessageWithId:msgid];
}

-(void)requestForDeleteMessageWithId:(int)msgId{
    NSString *string =[NSString stringWithFormat:kOnlineWeb,@"message/del/"];
    NSString *urlStr =[NSString stringWithFormat:@"%@%d",string,msgId];
    [LLAsynURLConnection requestForMethodGetWithURL:urlStr dataDic:nil andProtocolNum:@"40003" andTimeOut:httpTimeout successBlock:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求删除我的信息【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                if(body != nil){
                    NSString *type = [body objectForKey:@"msg"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(type != nil ){
                            [[LoadingView showLoadingView] actViewStopAnimation];
                            if (msgId ==0) {
                                [allLogs removeAllObjects];
                                [tableView0 reloadData];

                            }else{
                            [allLogs removeObjectAtIndex:index ];
                            [tableView0 deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                            [tableView0 reloadData];
                            }
                            [StatusBar showTipMessageWithStatus:@"消息删除成功" andImage:[UIImage imageNamed:@"icon_yes.png"]andTipIsBottom:YES];
                            if (allLogs.count ==0) {
                                [self showTipView];
                            }
                        }
                        else{
                            [[LoadingView showLoadingView] actViewStopAnimation];
                        }
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[LoadingView showLoadingView] actViewStopAnimation];
                    });
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[LoadingView showLoadingView] actViewStopAnimation];
            });
            
        });
        
    } andFailBlock:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            if(timeOutCount < 2){
                [self requestForDeleteMessageWithId:msgId];
            }else{
                [[LoadingView showLoadingView] actViewStopAnimation];
            }
        }
        
    }];
}

//请求删除我的信息
-(void)requestToDeleteMyMessage:(NSDictionary *)dic{
    [[LoadingView showLoadingView] actViewStartAnimation];
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"MyCenterUI",@"GetMyMsg"];
    NSLog(@"请求删除我的信息【urlStr】 = %@",dic);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求删除我的信息【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                if(body != nil){
                    NSString *type = [body objectForKey:@"Type"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(type != nil && [@"del" isEqualToString:type]){
                            [[LoadingView showLoadingView] actViewStopAnimation];
                            [allLogs removeObjectAtIndex:index -1];
                            [tableView0 deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                            [tableView0 reloadData];
                            [StatusBar showTipMessageWithStatus:@"消息删除成功" andImage:[UIImage imageNamed:@"icon_yes.png"]andTipIsBottom:YES];
                            if (allLogs.count ==0) {
                                [self showTipView];
                            }
                        }else{
                            [[LoadingView showLoadingView] actViewStopAnimation];
                        }
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[LoadingView showLoadingView] actViewStopAnimation];
                    });
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[LoadingView showLoadingView] actViewStopAnimation];
            });
            
        });
    } fail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            if(timeOutCount < 2){
                [self requestToGetMyMessage];
            }else{
                [[LoadingView showLoadingView] actViewStopAnimation];
            }
        }
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageCell *cell = (MessageCell* )[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell getMessageCellHeight] ;
    
}

-(void)onClickBackBtn:(UIButton*)btn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
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
        //        float reload_distance = 2 * kTableLoadingViewHeight2_0;
        if(y > h - 1) {
            tableView0.tableFooterView.hidden = NO;
            [self requestForAllMyMessage];
        }else{
            tableView0.tableFooterView.hidden = YES;
        }
    }else{
        tableView0.tableFooterView.hidden =YES;
    }
}
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    CGRect r = containView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    containView.frame = r;
    sendBtn.frame = CGRectMake(sendBtn.frame.origin.x, sendBtn.frame.origin.y - diff, sendBtn.frame.size.width, sendBtn.frame.size.height);
    imgBtn.frame = CGRectMake(imgBtn.frame.origin.x, imgBtn.frame.origin.y -diff, imgBtn.frame.size.height, imgBtn.frame.size.height);
    lineView.frame =CGRectMake(lineView.frame.origin.x, lineView.frame.origin.y -diff, lineView.frame.size.width, lineView.frame.size.height);
    
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location >= 200 || [NSString isContainsEmoji:text])
        return NO;
    else
        return YES;
}


- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView{
    [growingTextView becomeFirstResponder];
    //    [messageLab setHidden:YES];
    /*
     if([growingTextView.text isEqualToString:NSLocalizedString(@"smsContent", nil)] && growingTextView.textColor == [UIColor grayColor])
     {
     growingTextView.text=@"";
     growingTextView.textColor=[UIColor blackColor];
     }
     */
}



- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView{
    NSString *text = [growingTextView text];
    if([NSString isEmptyString:text]){
        [messageLab setHidden:NO];
    }
}
-(BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView{
    return YES;
}
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
    NSString *text = [growingTextView text];
    if([NSString isEmptyString:text]){
        [messageLab setHidden:NO];
    }else{
        [messageLab setHidden:YES];
    }
    
    if([NSString isEmptyString:text]){
        [sendBtn setEnabled:NO];
    }else {
        [sendBtn setEnabled:YES];
    }
}

/**
*  点击消息 跳转回调
*
*  @param dataDic 跳转查看id
*/
-(void)onClickedJumpToReward:(NSDictionary *)dataDic{
    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:PushToReward object:nil userInfo:dataDic];
}
-(void)onClickedJumpToActivity:(NSDictionary *)dataDic{
    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:GoBackToFlowCenterNotic object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:PushToActivity object:nil userInfo:dataDic];
}
-(void)onClickedJumpToMission:(NSDictionary *)dataDic{
    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:GoBackToFlowCenterNotic object:nil userInfo:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end









