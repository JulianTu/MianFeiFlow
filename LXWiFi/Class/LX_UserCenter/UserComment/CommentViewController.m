//
//  CommentViewController.m
//  91TaoJin
//
//  Created by keyrun on 14-5-19.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "CommentViewController.h"
#import "HeadToolBar.h"
#import "CButton.h"
#import "CompressImage.h"
#import "LoadingView.h"
#import "MyUserDefault.h"
#import "JSONKit.h"
#import "AsynURLConnection.h"
#import "NSString+emptyStr.h"
#import "StatusBar.h"
#import "UniversalTip.h"
#import "LXTabViewController.h"
#import "TaoJinButton.h"
#import "TaoJinLabel.h"
#import "UIImage+ColorChangeTo.h"
#import "LLAsynURLConnection.h"
#import "UploadingView.h"
#import "TipView.h"
#define kComPadding                     10.0f
@interface CommentViewController ()
{
    MScrollVIew *ms;
    HeadToolBar *headBar;
    NSString *type;
    UIView *contentView ;
    TaoJinLabel *placeLab ;
    NSString *placeStr;
    UITextView *writeView;
    TaoJinButton *commentBtn;                                    //上传按钮
    
    NSMutableArray *btnArray;                               //3个按钮数组
    NSMutableArray *upLoadImgAry;                           //要上传的图片
    NSString *boundary;
    
    UIActionSheet *as;                                      //弹出框
    BOOL firstImage;
    BOOL secImage;
    BOOL thrImage;
    int phoneIndex;
    CGPoint currentPosition;
    CGPoint startPosition;
    CGRect kbCurrentRect;
    float oriHeight;
    float oriTextHeight;
    float ButtonSize ;
    NSMutableArray *dataArr;      //图片数据数组
    int urlCount ;
}
@end

@implementation CommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initObjects{
    btnArray =[[NSMutableArray alloc] init];
    dataArr =[[NSMutableArray alloc] initWithArray:@[[[NSNull alloc] init],[[NSNull alloc] init],[[NSNull alloc] init]]];
    upLoadImgAry = [[NSMutableArray alloc] initWithArray:@[[[NSNull alloc] init],[[NSNull alloc] init],[[NSNull alloc] init]]];
    [[MyUserDefault standardUserDefaults] setUserAskStr:nil];
}

-(void)goBackClicked{
    if (![NSString isEmptyString:writeView.text] || firstImage ==YES || secImage ==YES || thrImage ==YES) {
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"放弃本次编辑？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"放弃", nil];
        [alertView show];
    }else{
        [self popViewController];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==1) {
        [self popViewController];
    }
}

-(void)popViewController{
    [self closeKeyboard];
    //    [self dismissViewControllerAnimated:YES completion:^{
    //
    //    }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self initObjects];
    [self loadHeadView];
    [self loadContentView];
    [writeView becomeFirstResponder];
}
-(void)viewDidAppear:(BOOL)animated{
    [writeView becomeFirstResponder];
}
-(void)loadHeadView{
    switch (self.commentType) {
        case CommentTypeAsk:
            type =@"提问";
            headBar=[[HeadToolBar alloc] initWithTitle:@"反馈问题" leftBtnTitle:@"返回" leftBtnImg:GetImage(@"back") leftBtnHighlightedImg:nil rightBtnTitle:@"提交" rightBtnImg:nil rightBtnHighlightedImg:nil backgroundColor:kBlueTextColor];
            [headBar.rightBtn addTarget:self action:@selector(onClickedSend) forControlEvents:UIControlEventTouchUpInside];
            placeStr =[NSString stringWithFormat:@"填写反馈信息，将有机会获得流量币奖励；欢迎加入官方QQ群：15951159，与我们一起提升产品体验！"];
            break;
        case CommentTypePinLun:
            type =@"评论";
            headBar=[[HeadToolBar alloc] initWithTitle:@"评论内容" leftBtnTitle:@"返回" leftBtnImg:GetImage(@"back.png") leftBtnHighlightedImg:GetImage(@"back_sel.png") rightLabTitle:nil backgroundColor:KOrangeColor2_0];
            placeStr =[NSString stringWithFormat:@"评论内容，不少于5个字哦"];
            break;
        case CommentTypeShow:
            type =@"晒单";
            headBar=[[HeadToolBar alloc] initWithTitle:@"晒单内容" leftBtnTitle:@"" leftBtnImg:GetImage(@"back.png") leftBtnHighlightedImg:GetImage(@"back_sel.png") rightLabTitle:nil backgroundColor:KOrangeColor2_0];
            placeStr =[NSString stringWithFormat:@"晒单内容，不少于10个字哦"];
            break;
        default:
            break;
    }
    
    [headBar.leftBtn addTarget:self action:@selector(goBackClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    if (kDeviceVersion >= 7.0) {
        ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y + headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height + 20) andWithPageCount:3 backgroundImg:nil];
    }else{
        ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y + headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height) andWithPageCount:3 backgroundImg:nil];
    }
    ms.bounces = YES;
    ms.delegate = self;
    [ms setContentSize:CGSizeMake(kmainScreenWidth, ms.frame.size.height+1)];
    [self.view addSubview:ms];
    
    UITapGestureRecognizer *tapGest =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    [ms addGestureRecognizer:tapGest];
    
}

-(void)closeKeyboard{
    [writeView resignFirstResponder];
}

-(void)loadContentView{
    
    placeLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(kOffX_2_0 +5, 14.0, kmainScreenWidth - (kOffX_2_0 +5), 0.0) text:placeStr font:GetFont(13.0) textColor:kContentTextColor textAlignment:NSTextAlignmentLeft numberLines:0];
    [placeLab sizeToFit];
    placeLab.frame = CGRectMake(placeLab.frame.origin.x, placeLab.frame.origin.y, placeLab.frame.size.width, placeLab.frame.size.height);
    
    writeView = [self loadTextViewWith:CGRectMake(kOffX_2_0, 6, kmainScreenWidth -2* kOffX_2_0, 82.0f) andTextColor:KBlockColor2_0 withFont:[UIFont systemFontOfSize:14.0]];
    if (self.commentType ==CommentTypeAsk) {
        writeView.returnKeyType =UIReturnKeyDone;
    }
    UIView *line =[self loadSperateLineWith:CGRectMake(writeView.frame.origin.x, 0.5f, kmainScreenWidth -kOffX_2_0, 0.5f) andBgColor:kGrayLineColor2_0];
    
    UIImage *image = GetImage(@"addimg");
    ButtonSize = image.size.width ;
    contentView =[self loadSperateLineWith:CGRectMake(0, writeView.frame.origin.y +writeView.frame.size.height+kComPadding , kmainScreenWidth, 131) andBgColor:[UIColor clearColor]];
    if (kDeviceVersion < 7.0) {
        placeLab.frame =CGRectMake(kOffX_2_0 +8, 13, kmainScreenWidth - 2*(kOffX_2_0 +8), 14.0);
        writeView.frame =CGRectMake(kOffX_2_0, 8, kmainScreenWidth -2*kOffX_2_0, 65.0);
        contentView.frame = CGRectMake(0, writeView.frame.origin.y +writeView.frame.size.height -4, kmainScreenWidth, 131);
    }
    oriHeight =contentView.frame.size.height;
    //初始化3个按钮
    for ( int i = 0; i < 3; i++) {
        UIButton * imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame = CGRectMake(kOffX_2_0 + i * (ButtonSize + kOffX_2_0), 0, ButtonSize, ButtonSize);
        [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
        imageBtn.tag = i;
        [btnArray addObject:imageBtn];
        imageBtn.adjustsImageWhenHighlighted = NO;
        [imageBtn addTarget:self action:@selector(onClickedImageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:imageBtn];
    }
    TaoJinLabel *tipLabe ;
    if (self.descriptorStr) {
        tipLabe =[[TaoJinLabel alloc] initWithFrame:CGRectMake(kOffX_2_0, line.frame.origin.y +line.frame.size.height +2*10.0 +ButtonSize, kmainScreenWidth -2*kOffX_2_0, 0) text:self.descriptorStr font:GetFont(14.0) textColor:KGrayColor2_0 textAlignment:NSTextAlignmentLeft numberLines:0];
        [tipLabe sizeToFit];
        tipLabe.frame = CGRectMake(kOffX_2_0, tipLabe.frame.origin.y, tipLabe.frame.size.width, tipLabe.frame.size.height);
        [contentView addSubview:tipLabe];
    }
    /*
     commentBtn = [[TaoJinButton alloc] initWithFrame:CGRectMake(kmainScreenWidth/2 -SendButtonWidth/2, line.frame.origin.y +line.frame.size.height + 10.0 + ButtonSize +10.0 +tipLabe.frame.size.height, SendButtonWidth, SendButtonHeight) titleStr:[NSString stringWithFormat:@"提交"] titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:17.0] logoImg:nil backgroundImg:[UIImage createImageWithColor:kBlueTextColor]];
     commentBtn.layer.masksToBounds = YES;
     commentBtn.layer.cornerRadius = commentBtn.frame.size.height /2;
     [commentBtn setBackgroundImage:[UIImage createImageWithColor:kLightBlueTextColor] forState:UIControlStateHighlighted];
     [commentBtn addTarget:self action:@selector(onClickedSend) forControlEvents:UIControlEventTouchUpInside];
     
     commentBtn.adjustsImageWhenHighlighted =NO;
     if (self.commentType == CommentTypeShow) {   //显示晒单提示
     [self showTip];
     }
     */
    //    [contentView addSubview:line];
    //    [contentView addSubview:commentBtn];
    [ms addSubview:placeLab];
    [ms addSubview:writeView];
    [ms addSubview:contentView];
}

/**
 *  如果是晒单列表进来的底部需要显示注意文案
 */
-(void)showTip{
    NSString *oneStr = [NSString stringWithFormat:@"3.晒单照片为金主与奖品合照，奖励%d金豆；",self.showGoldTwo];
    NSString *twoStr = [NSString stringWithFormat:@"4.晒单照片为奖品独照，奖励%d金豆；",self.showGoldOne];
    NSArray *array = [[NSArray alloc] initWithObjects:@"1.兑换一次实物奖品（已发货）获得一次晒单机会；",@"2.晒单照片必须为实物奖品，否则无法获得金豆奖励；",oneStr,twoStr, @"5.晒单内容将由活动组审核后发布到晒单广场。",nil];
    UniversalTip *tip = [[UniversalTip alloc] initWithFrame:CGRectMake(kOffX_2_0, commentBtn.frame.origin.y +commentBtn.frame.size.height +10.0f, kmainScreenWidth -2 *kOffX_2_0, 0) andTips:array andTipBackgrundColor:KTipBackground2_0 withTipFont:[UIFont systemFontOfSize:11.0] andTipImage:GetImage(@"tips_3.png") andTipTitle:@"晒单提示：" andTextColor:KOrangeColor2_0];
    [contentView addSubview:tip];
}

-(int)convertToInt:(NSString*)strtemp {
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength);
}

-(void)onClickedSend{
    
    int length =[self convertToInt:writeView.text];
    if ( length == 0) {
        switch (self.commentType) {
            case CommentTypeAsk:
                [StatusBar showTipMessageWithStatus:@"请输入反馈内容" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
                break;
            case CommentTypePinLun:
                [StatusBar showTipMessageWithStatus:@"请输入评论内容" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
                break;
            case CommentTypeShow:
                [StatusBar showTipMessageWithStatus:@"请输入晒单内容" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
                break;
        }
    }else if(writeView.text.length < 10 && self.commentType == CommentTypeAsk){
        [StatusBar showTipMessageWithStatus:@"反馈内容不得少于10个字" andImage:nil andTipIsBottom:YES];
    }else if(writeView.text.length < 5 && self.commentType == CommentTypePinLun){
        [StatusBar showTipMessageWithStatus:@"评论内容不能少于5个字" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
    }else if (writeView.text.length < 10 && self.commentType == CommentTypeShow){
        [StatusBar showTipMessageWithStatus:@"晒单内容不能少于10个字" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
    }else{

        [[UploadingView shareUploadView] showWithText:@"正在提交问题" andViewControler:self];
        [writeView resignFirstResponder];
        BOOL havePhoto =NO;
        for (id obj in upLoadImgAry) {
            if (![obj isKindOfClass:[NSNull class]]) {
                havePhoto =YES;
                break;
            }
        }
        if (havePhoto ==YES) {
            [self requestForUploadPhotoToken];   // 发送请求 带图的
        }else{
            NSDictionary *dic =@{@"message":writeView.text};
            [self requestForSendMsg:dic];
        }
        
    }
}
-(void)requestForSendMsg:(NSDictionary *)dic{
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,@"message/send"];
    [LLAsynURLConnection requestURLWith:urlStr dataDic:dic andProtocolNum:@"40004" andTimeOut:httpTimeout connectSuccess:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@" 发送反馈信息 == %@",dataDic);
            if ([[dataDic objectForKey:@"flag"] intValue] ==1) {
                NSDictionary *body =[dataDic objectForKey:@"body"];
                int askId =[[body objectForKey:@"id"]intValue];
                NSDictionary *strDic = [self getAskStrWith:askId];
                [[MyUserDefault standardUserDefaults] setUserAskStr:strDic];    //提问成功后保存数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UploadingView shareUploadView] dismiss];
                    [[TipView shareTipView] tipViewShowWithText:@"提交成功" andTipImage:GetImage(@"yes")];
//                    [StatusBar showTipMessageWithStatus:@"提问成功" andImage:nil andTipIsBottom:YES];
                    [self popViewController];    // 返回消息中心
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UploadingView shareUploadView] dismiss];
//                    [StatusBar showTipMessageWithStatus:@"提问失败" andImage:nil andTipIsBottom:YES];
                    [[TipView shareTipView] tipViewShowWithText:@"提交失败，请再次提交" andTipImage:GetImage(@"no")];
                });
                
            }
        });
    } andFail:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UploadingView shareUploadView] dismiss];
            [[TipView shareTipView] tipViewShowWithText:@"提交失败，请再次提交" andTipImage:GetImage(@"no")];
        });

    }];
}

-(NSDictionary *)getLocationPinLunData{
    //    NSString *writeStr =[writeView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *writeStr = writeView.text;
    long time =[[NSDate date] timeIntervalSince1970];
    
    NSString *userName = [[MyUserDefault standardUserDefaults] getUserNickname] ;
    NSString *userId = [[MyUserDefault standardUserDefaults] getUserId] ;
    NSString *iconUrl = [[MyUserDefault standardUserDefaults] getUserIconUrl];
    NSMutableArray *imgData =[[NSMutableArray alloc] init];
    for(int i = 0 ; i < upLoadImgAry.count; i ++){
        NSObject *object = [upLoadImgAry objectAtIndex:i];
        if(![object isKindOfClass:[NSNull class]]){
            UIImage *image = (UIImage *)object;
            NSLog(@"image(%f,%f)",image.size.width, image.size.height);
            NSData* data =[NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
            [imgData addObject:data];
        }
    }
    NSDictionary *dic = @{@"Id": _topicId, @"Content":writeStr, @"Time":[NSNumber numberWithLong:time], @"UserNickName":userName, @"UserId":userId, @"UserPic":iconUrl, @"Pic":imgData};
    return dic;
}

-(NSDictionary *)getUserShowPostDic{
    //    NSString *writeStr =[writeView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *writeStr = writeView.text;
    NSMutableArray *imgData =[[NSMutableArray alloc] init];
    for(int i = 0 ; i < upLoadImgAry.count; i ++){
        NSObject *object = [upLoadImgAry objectAtIndex:i];
        if(![object isKindOfClass:[NSNull class]]){
            UIImage *image = (UIImage *)object;
            
            NSData* data = [NSData dataWithData:UIImagePNGRepresentation(image)];
            NSDictionary *dic = @{@"Url": data, @"Width":[NSNumber numberWithInt:image.size.width], @"Height":[NSNumber numberWithInt:image.size.height]};
            [imgData addObject:dic];
        }
    }
    NSDictionary *userShowPostDic = @{@"Content": writeStr, @"Pic":imgData, @"UserNickName":[[MyUserDefault standardUserDefaults] getUserNickname], @"UserId":[[MyUserDefault standardUserDefaults] getUserId], @"UserPic":[[MyUserDefault standardUserDefaults] getUserIconUrl], @"Time":[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]], @"ReplyNum":@0, @"ShId":_topicId, @"Status":@1};
    return userShowPostDic;
}

-(NSDictionary *)getAskStrWith:(int )asdID{        // 提问
    NSString *str =[[NSString alloc] init];
    for(int i = 0 ; i < upLoadImgAry.count; i ++){
        NSObject *object = [upLoadImgAry objectAtIndex:i];
        if(![object isKindOfClass:[NSNull class]]){
            str =[str stringByAppendingString:@"[图片]"];
        }
    }
    NSString *writeStr =[writeView.text stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    str= [str stringByAppendingString:writeStr];
    
    long dtime =[[NSDate date] timeIntervalSince1970];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:dtime];
    NSDate* nowDate=[NSDate date];
    
    NSTimeZone* zone=[NSTimeZone systemTimeZone];
    NSInteger interval=[zone secondsFromGMTForDate:nowDate];
    NSDate* date2 =[date dateByAddingTimeInterval:interval];
    
    NSString* dateStr =[date2 description];
    NSLog(@" dateStr == %@",dateStr);
    
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"content",dateStr,@"time",@"1",@"status",@"1",@"type",[NSNumber numberWithInt:asdID],@"id", nil];   //拼接本地提问数据
    return dic;
}
-(void)requestForUploadPhotoToken{
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,@"ucenter/picupload"];
    [LLAsynURLConnection requestForMethodGetWithURL:urlStr dataDic:nil andProtocolNum:@"40007" andTimeOut:httpTimeout successBlock:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@" 获取上传图片密钥 == %@ ",dataDic);
            if ([[dataDic objectForKey:@"flag"] intValue] ==1) {
                NSDictionary *body =[dataDic objectForKey:@"body"];
                NSString *key =[body objectForKey:@"upload_key"];
                if (key) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self requestForPostPhotoWithKey:key];
                    });
                    
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UploadingView shareUploadView] dismiss];
                    [[TipView shareTipView] tipViewShowWithText:@"提交失败，请再次提交" andTipImage:GetImage(@"no")];
                });
            }
        });
    } andFailBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UploadingView shareUploadView] dismiss];
            [[TipView shareTipView] tipViewShowWithText:@"提交失败，请再次提交" andTipImage:GetImage(@"no")];
        });
        NSLog(@" 获取传图密钥失败 ");
    }];
}

-(void)requestForPostPhotoWithKey:(NSString *)key{
    [writeView resignFirstResponder];
    NSString *adress =[[MyUserDefault standardUserDefaults] getPhotoServiceAdress];
    NSString *contentStr = writeView.text;
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    NSString *userID = [[MyUserDefault standardUserDefaults]getUserId];
    NSMutableDictionary *dic;
    NSString *urlStr;
    if (_commentType ==CommentTypeAsk){
        dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"uid" :userID,@"upload_key":key}];
        if (adress) {
            urlStr =adress ;
        }
        NSLog(@"请求发表【提问】【urlStr】= %@   %@",urlStr,dic);
    }
    NSString *paramStr = [dic JSONString];
    NSMutableData* body = [NSMutableData data];
    boundary = @"0xKhTmLbOuNdArY";
    [body appendData:[[NSString stringWithFormat:@"\n--%@\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data;name='param';value='%@'\n\n",paramStr] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (_commentType == CommentTypeAsk){
        [body appendData:[[NSString stringWithFormat:@"{\"uid\":\"%@\",\"upload_key\":\"%@\"}",userID,key] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"\n--%@\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //第二段
    int imageTag=0;
    
    //将字典排序 不然图片顺序会乱
    NSArray* array = dic.allKeys;
    
    array = [array sortedArrayUsingComparator:^(id obj1 ,id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result == NSOrderedDescending;
    }];
    for (int i = 0; i <upLoadImgAry.count; i++) {
        
        
        NSObject *object = [upLoadImgAry objectAtIndex:i];
        if(![object isKindOfClass:[NSNull class]]){
            UIImage *image = (UIImage *)object;
            NSData *dataImg = UIImageJPEGRepresentation(image, 1.0);
            if (dataImg.length > 100*1024) {
                dataImg = UIImageJPEGRepresentation(image, 0.5);
                NSLog(@" big %d",dataImg.length);
            }else if(dataImg.length > 50*1024 && dataImg.length < 100 *1024){
                dataImg = UIImageJPEGRepresentation(image,0.6);
                NSLog(@" small %d",dataImg.length);
            }
            [body appendData:[[NSString stringWithFormat:@"\n--%@\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data;name='userfile_%d';filename='userfile.jpg'\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
            imageTag++;
            [body appendData:[[NSString stringWithFormat:@"Content-Type:image/jpg\n\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:dataImg];
            [body appendData:[[NSString stringWithFormat:@"\n--%@--\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
    }
    BOOL canRequest = YES;
    /*
     if(self.commentType == CommentTypeShow){
     BOOL isNoImage = YES;
     for(int i = 0 ; i < upLoadImgAry.count; i ++){
     NSObject *object = [upLoadImgAry objectAtIndex:i];
     if(![object isKindOfClass:[NSNull class]]){
     isNoImage = NO;
     break;
     }
     }
     if(isNoImage){
     canRequest = NO;
     [StatusBar showTipMessageWithStatus:@"晒单需要插入奖品图片" andImage:[UIImage imageNamed:@"laba.png"] andTipIsBottom:YES];
     }
     }
     */
    if(canRequest){
        [AsynURLConnection requestWithURLToSendJSONL:urlStr boundary:boundary paramStr:paramStr body:body timeOut:httpTimeout +30 success:^(NSData *data) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSArray *dicArr =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@" 上传图片数据 == %@  %@",dicArr,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                
                if (dicArr.count >0) {
                    NSDictionary *dic = [dicArr objectAtIndex:0];
                    if ([dic objectForKey:@"success"]) {
                        NSMutableArray *allAdress=[[NSMutableArray alloc] init];
                        for (NSDictionary *dictionary in dicArr) {
                            NSDictionary *succDic =[dictionary objectForKey:@"success"];
                            NSString *urlAdress =[succDic objectForKey:@"url_name"];
                            [allAdress addObject:urlAdress];
                        }
                         NSLog(@"  图片上传成功url == %@ ",allAdress);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSDictionary *sendDic =@{@"message":writeView.text ,@"pics":allAdress};
                            [self requestForSendMsg:sendDic];
                            
                        });
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[UploadingView shareUploadView] dismiss];
                            [[TipView shareTipView] tipViewShowWithText:@"提交失败，请再次提交" andTipImage:GetImage(@"no")];
                        });
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UploadingView shareUploadView] dismiss];
                        [[TipView shareTipView] tipViewShowWithText:@"提交失败，请再次提交" andTipImage:GetImage(@"no")];
                    });
                }
                
            });
            
        } fail:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UploadingView shareUploadView] dismiss];
                [[TipView shareTipView] tipViewShowWithText:@"提交失败，请再次提交" andTipImage:GetImage(@"no")];
            });
        }];
        
        /*
         [AsynURLConnection requestWithURLToSendJSONL:urlStr boundary:boundary paramStr:paramStr body:body timeOut:httpTimeout + 30 success:^(NSData *data) {
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         NSString *errStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@" error %@" ,errStr);
         if(_commentType == CommentTypeShow){
         NSLog(@"请求创建【晒单】【response】= %@",dic);
         }else if(_commentType == CommentTypePinLun){
         NSLog(@"请求发表【评论】【response】= %@",dic);
         }else if (_commentType == CommentTypeAsk){
         NSLog(@"请求提问【提问】【response】= %@",dic);
         }
         int flag = [[dic objectForKey:@"flag"] intValue];
         NSDictionary *body = [dic objectForKey:@"body"];
         NSString *message = [dic objectForKey:@"msg"];
         if(flag == 1){
         
         if(![message isEqualToString:@""]){
         //上传成功
         //                    NSDictionary *msg = [body objectForKey:@"Msg"];
         dispatch_async(dispatch_get_main_queue(), ^{
         [[LoadingView showLoadingView] actViewStopAnimation];
         if (_commentType == CommentTypeShow) {
         _topicId = [body objectForKey:@"id"];
         [StatusBar showTipMessageWithStatus:@"晒单提交成功，等待审核" andImage:[UIImage imageNamed:@"icon_yes.png"]andTipIsBottom:YES];
         [self popViewController];
         [self.delegate reloadView:[self getUserShowPostDic]];
         }else if (_commentType == CommentTypePinLun){
         NSDictionary *msgDic = [body objectForKey:@"Msg"];
         if ([[msgDic objectForKey:@"message"] integerValue] == 0) {
         [StatusBar showTipMessageWithStatus:@"评论成功" andImage:[UIImage imageNamed:@"icon_yes.png"] andTipIsBottom:YES];
         }else{
         int gold =[[msgDic objectForKey:@"message"] intValue];
         [StatusBar showTipMessageWithStatus:@"评论成功，" andImage:[UIImage imageNamed:@"icon_yes"] andCoin:[NSString stringWithFormat:@"+%d",gold] andSecImage:[UIImage imageNamed:@"tipBean"] andTipIsBottom:YES];
         
         }
         _topicId =[body objectForKey:@"id"];
         NSDictionary *dic =[self getLocationPinLunData];
         [self popViewController];
         [self.delegate reloadView:dic];
         }else if (_commentType == CommentTypeAsk){
         int askId =[[body objectForKey:@"id"]intValue];
         [StatusBar showTipMessageWithStatus:@"提问成功" andImage:GetImage(@"icon_yes.png") andTipIsBottom:YES];
         NSDictionary *strDic = [self getAskStrWith:askId];
         [[MyUserDefault standardUserDefaults] setUserAskStr:strDic];    //提问成功后保存数据
         [self popViewController];    // 返回消息中心
         }
         
         //自己回复的本地记录加一，避免返回界面时获取记录数的时候显示为新数量为1
         //                        [self setReplyNumber:_topicType topicId:_topicId];
         //                        if(self.callBack){
         //                            self.callBack(YES);
         //                        }
         });
         }else{
         dispatch_async(dispatch_get_main_queue(), ^{
         [[LoadingView showLoadingView] actViewStopAnimation];
         if (_commentType == CommentTypeShow) {
         [StatusBar showTipMessageWithStatus:@"晒单失败" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
         }else if (_commentType == CommentTypePinLun){
         [StatusBar showTipMessageWithStatus:@"评论失败" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
         }else if (_commentType == CommentTypeAsk){
         [StatusBar showTipMessageWithStatus:@"提问失败" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
         }
         });
         }
         }else{
         dispatch_async(dispatch_get_main_queue(), ^{
         [[LoadingView showLoadingView] actViewStopAnimation];
         if(flag == 2){
         if ([message isEqualToString:@"-30003003"]) {
         [StatusBar showTipMessageWithStatus:@"内容不能为空" andImage:[UIImage imageNamed:@"icon_no.png"] andTipIsBottom:YES];
         }else if ([message isEqualToString:@"-30003004"]){
         [StatusBar showTipMessageWithStatus:@"图片尺寸太大" andImage:[UIImage imageNamed:@"icon_no.png"] andTipIsBottom:YES];
         }
         }
         });
         }
         });
         } fail:^(NSError *error) {
         NSLog(@"【error】= %@",error);
         [[LoadingView showLoadingView] actViewStopAnimation];
         [StatusBar showTipMessageWithStatus:@"发送不成功，请再次发送" andImage:[UIImage imageNamed:@"icon_no.png"] andTipIsBottom:YES];
         }];
         */
    }
    
}
-(void) requestForPostPhotoURL:(NSString *)photoUrl{
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,@"ucenter/avatar"];
    NSDictionary *dic =@{@"pics":photoUrl};
    [LLAsynURLConnection requestURLWith:urlStr dataDic:dic andProtocolNum:@"40008" andTimeOut:httpTimeout connectSuccess:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"POST图片地址 ==%@  ",dataDic);
            if ([[dataDic objectForKey:@"flag"] intValue] ==1) {
                
            }
        });
    } andFail:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UploadingView shareUploadView] dismiss];
            [[TipView shareTipView] tipViewShowWithText:@"提交失败，请再次提交" andTipImage:GetImage(@"no")];
        });
    }];
}

-(TaoJinButton *)loadCommentBtnWith:(CGRect) frame{
    TaoJinButton *btn =[TaoJinButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage createImageWithColor:KGreenColor2_0] forState:UIControlStateNormal];
    btn.frame =frame;
    return btn;
}

-(UIView *)loadSperateLineWith:(CGRect) frame andBgColor:(UIColor *)color{
    UIView *line= [[UIView alloc] initWithFrame:frame];
    line.backgroundColor =color;
    return line;
}

-(UILabel *)loadLabelWith:(CGRect) frame andPlaceText:(NSString *)text andTextColor:(UIColor *)color andFont:(UIFont *)font{
    UILabel *label =[[UILabel alloc] initWithFrame:frame];
    label.userInteractionEnabled =NO;
    label.backgroundColor =[UIColor clearColor];
    label.textColor =color;
    label.font =font;
    label.text =text;
    return label;
}
-(UITextView *)loadTextViewWith:(CGRect) frame andTextColor:(UIColor *)color withFont:(UIFont *)font{
    UITextView *tv =[[UITextView alloc] initWithFrame:frame];
    tv.backgroundColor =[UIColor clearColor];
    tv.delegate =self;
    tv.textColor =color;
    tv.font =font;
    tv.showsVerticalScrollIndicator =NO;
    return tv;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"] && self.commentType ==CommentTypeAsk) {
        [textView resignFirstResponder];
        return NO;
    }
    if ((range.location >=500 || [NSString isContainsEmoji:text]) && self.commentType ==CommentTypePinLun ) {
        return NO;
    }else if((range.location >=400 || [NSString isContainsEmoji:text]) && self.commentType ==CommentTypeShow){
        
        return NO;
    }else{
        return YES;
    }
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect line =[textView caretRectForPosition:textView.selectedTextRange.start];
    CGFloat overflow =line.origin.y +line.size.height -(textView.contentOffset.y +textView.bounds.size.height -textView.contentInset.bottom -textView.contentInset.top);
    if (overflow > 0) {
        CGPoint offset =textView.contentOffset;
        offset.y += offset.y + 7;
        //        [UIView animateWithDuration:0.2 animations:^{
        [textView setContentOffset:offset];
        
        //        }];
    }
    
}
-(void)textViewDidChange:(UITextView *)textView{
    
    NSString* text = textView.text;
    if([NSString isContainsEmoji:text]){
        NSRange textRange = [writeView selectedRange];
        [writeView setText:[NSString disable_emoji:text]];
        [writeView setSelectedRange:textRange];
    }else{
        if (text.length == 0) {
            placeLab.text =placeStr;
        }else{
            placeLab.text = @"";
        }
        /*
         float off_y2 =ms.frame.size.height -kbCurrentRect.size.height -oriHeight ;
         
         //    [writeView sizeThatFits:CGSizeMake(writeView.frame.size.width, 10000)];
         writeView.frame =CGRectMake(writeView.frame.origin.x, writeView.frame.origin.y, kmainScreenWidth - 2 * kOffX_float, writeView.contentSize.height);
         
         [self doContentPositionChanegAnimation:writeView.frame.origin.y +writeView.contentSize.height];
         
         if (contentView.frame.origin.y >off_y2) {
         [self contentViewStopAnimation:off_y2];
         oriTextHeight =contentView.frame.origin.y - writeView.frame.origin.y;
         writeView.frame =CGRectMake(writeView.frame.origin.x, writeView.frame.origin.y, writeView.frame.size.width, oriTextHeight );
         
         }
         
         CGRect line =[textView caretRectForPosition:textView.selectedTextRange.start];
         CGFloat overflow =line.origin.y +line.size.height -(textView.contentOffset.y +textView.bounds.size.height -textView.contentInset.bottom -textView.contentInset.top);
         if (overflow > 0 ) {
         CGPoint offset =textView.contentOffset;
         offset.y += overflow + 7;
         //        [UIView animateWithDuration:0.2 animations:^{
         [textView setContentOffset:offset];
         
         //        }];
         }
         */
    }
    
    
    //    [self doSomeAnimationWith:off_y2];
}
-(void)doSomeAnimationWith:(float) off_y{
    
    if (contentView.frame.origin.y > off_y -16.5) {
        [self contentViewStopAnimation:off_y ];
        if (contentView.frame.origin.y == off_y -16.5) {
            writeView.frame =CGRectMake(writeView.frame.origin.x, writeView.frame.origin.y -16.5, writeView.frame.size.width, off_y -writeView.frame.origin.y);
            NSLog( @"  write %f  %f",writeView.frame.origin.y,writeView.frame.size.height);
        }
    }
}
-(void)contentViewStopAnimation:(float) off_y {
    contentView.frame =CGRectMake(0, off_y -18.5, contentView.frame.size.width, contentView.frame.size.height);
}

-(void)doContentPositionChanegAnimation:(float)off_y{
    [UIView animateWithDuration:0.2 animations:^{
        contentView.frame =CGRectMake(contentView.frame.origin.x, off_y, contentView.frame.size.width, contentView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma 键盘事件
-(void)keyboardWillShow:(NSNotification *)notic{
    NSValue* keyboardObject=[[notic userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    kbCurrentRect =keyboardRect;
    //    CGRect oldRect =writeView.frame;
    //    writeView.frame =CGRectMake(oldRect.origin.x, oldRect.origin.y, oldRect.size.width, kmainScreenHeigh -oldRect.origin.y  -keyboardRect.size.height);
}

-(void)keyboardWillChange:(NSNotification *)notic{
    /*
     NSValue* keyboardObject=[[notic userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
     CGRect keyboardRect;
     [keyboardObject getValue:&keyboardRect];
     kbCurrentRect =keyboardRect;
     float offH =ms.frame.size.height -kbCurrentRect.size.height -oriHeight ;
     [self doSomeAnimationWith:offH];
     */
}

-(void)keyboardWillHidden:(NSNotification *)notic{
    
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
}

-(NSData *)getImageData:(UIImage *)image{
    NSData* dataImg = UIImagePNGRepresentation(image);
    NSLog(@"  imagesize %@ %d ",NSStringFromCGSize(image.size),dataImg.length);
    if (dataImg.length > 100*1024) {
        dataImg = UIImageJPEGRepresentation(image, 0.5);
        NSLog(@" big %d",dataImg.length);
    }else if(dataImg.length > 50*1024 && dataImg.length < 100 *1024){
        dataImg = UIImageJPEGRepresentation(image,0.6);
        NSLog(@" small %d",dataImg.length);
    }
    return dataImg;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //获取原始图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    int defaultImgWidth = kmainScreenWidth - 2 * Spacing2_0;
    if(_commentType == CommentTypePinLun){
        defaultImgWidth = kmainScreenWidth - 2 * Spacing2_0 - 37.0f - Spacing2_0;
    }
    //按比例先缩小图片
    float localwidth = image.size.width;
    /*
     float localwidth1 = localwidth > defaultImgWidth ? defaultImgWidth : localwidth;
     float localheight = image.size.height;
     float localheight1 = localheight * (localwidth1/localwidth);
     */
    NSLog(@"按比例先缩小图片");
    //    UIImage *changeImg = [self scaleToSize:image size:CGSizeMake(localwidth1, localheight1)];
    //    [dataArr replaceObjectAtIndex:phoneIndex withObject:[self getImageData:changeImg]];
    //宽度处理(按晒单和评论界面的显示宽度处理)
    float width = 0.0f;
    float scale = [[UIScreen mainScreen] scale];
    if(_commentType == CommentTypeShow && image.size.width > 306 ){
        width = 306.0f * scale;
    }else if(_commentType == CommentTypePinLun && image.size.width > 262.0 ){
        width = 262.0f * scale;
    }else if (_commentType ==CommentTypeAsk && image.size.width > kmainScreenWidth -60){
        width = scale * (kmainScreenWidth -60.0f);
    }
    UIImage *buttonImg = [image copy];
    if(width > 0){
        float scale = width/image.size.width;
        float newHeight = scale * image.size.height;
        NSLog(@"image1 (%f, %f)",width, newHeight);
        image = [CompressImage imageWithOldImage:image scaledToSize:CGSizeMake(width, newHeight)];
        
        NSLog(@"image2 (%f, %f)",image.size.width, image.size.height);
        buttonImg = [CompressImage imageWithCutImage:image moduleSize:CGSizeMake(ButtonSize, ButtonSize)];

    }
    
    UIButton *phoneBtn = [btnArray objectAtIndex:phoneIndex];
    [upLoadImgAry replaceObjectAtIndex:phoneIndex withObject:image];
    [phoneBtn setBackgroundImage:buttonImg forState:UIControlStateNormal];
    switch (phoneIndex) {
        case 0:
            firstImage = YES;
            break;
        case 1:
            secImage = YES;
            break;
        case 2:
            thrImage = YES;
            break;
        default:
            break;
    }
    
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            //拍照
        case 0:
        {
            UIImagePickerControllerSourceType type2 = UIImagePickerControllerSourceTypeCamera;
            if([UIImagePickerController isSourceTypeAvailable:type2]){
                UIImagePickerController *pc = [[UIImagePickerController alloc]init];
                pc.delegate = self;
                pc.allowsEditing =NO;
                pc.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:pc animated:YES completion:nil];
            }
        }
            break;
            //从相册取相片
        case 1:
        {
            UIImagePickerController *pc = [[UIImagePickerController alloc]init];
            pc.delegate = self;
            pc.allowsEditing =NO;
            pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:pc animated:YES completion:nil];
        }
            break;
        case 2:
        {
            
            for (UIButton* btn in btnArray) {
                if (btn.tag == phoneIndex) {
                    [upLoadImgAry replaceObjectAtIndex:phoneIndex withObject:[[NSNull alloc] init]];
                    [btn setBackgroundImage:[UIImage imageNamed:@"addimg"] forState:UIControlStateNormal];
                    switch (btn.tag) {
                        case 0:
                            firstImage = NO;
                            break;
                        case 1:
                            secImage = NO;
                            break;
                        case 2:
                            thrImage = NO;
                            break;
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}

-(void)onClickedImageBtn:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
            as = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",firstImage ? @"删除" : nil, nil];
            break;
        case 1:
            as = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",secImage ? @"删除" : nil, nil];
            break;
        case 2:
            as = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",thrImage ? @"删除" : nil, nil];
            break;
    }
    phoneIndex = btn.tag;
    as.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [as dismissWithClickedButtonIndex:2 animated:YES];
    
    if (kDeviceVersion < 7.0) {
        LXTabViewController *tj = [[LXTabViewController alloc] init];
        [as showFromTabBar:tj.tabBar];
    }else{
        [as showInView:self.view];
    }
}

/**
 *  滚动列表时收回键盘
 *
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [writeView resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
