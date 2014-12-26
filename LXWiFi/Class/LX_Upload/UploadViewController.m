//
//  UploadViewController.m
//  91TaoJin
//
//  Created by keyrun on 14-6-11.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "UploadViewController.h"
#import "HeadToolBar.h"
#import "TaoJinLabel.h"
#import "TaoJinButton.h"
#import "UIImage+ColorChangeTo.h"
#import "UniversalTip.h"
#import "LLAsynURLConnection.h"
#import "CompressImage.h"
#import "StatusBar.h"
#import "LoadingView.h"
#import "MyUserDefault.h"
#import "JSONKit.h"
#import "AsynURLConnection.h"
#import "MScrollVIew.h"
#import "ShowImgView.h"
#import "CompressImage.h"
#import "DashLineUI.h"
#import "UploadingView.h"
#import "TipView.h"
#define kDefShowImgW       (kmainScreenWidth -18*2 -10.0f) /2
#define kDefShowImgH       224.0
#define kBtnSizeH          45.0
#define kIpadScale2        0.75      //高宽比

#define kBtnSizeW          151.0f
#define kBtnOffx           55.0f       //按钮距边界的距离
@interface UploadViewController ()
{
    HeadToolBar *headBar;
    
    BOOL firstImage;
    BOOL secImage;
    NSMutableArray *btnArray;
    int phoneIndex;
    NSMutableArray *getImages;      //收集上传的图片
    NSMutableArray *dataArray;      // 图片数据数组
    BOOL isSuitable ;              // 选取的图片 符合要求
    MScrollVIew *ms;
    
    UIView *viewOne2;
    UIView *viewTwo2 ;
    UIView *viewOne;
    UIView *viewTwo ;
    
    int keyFailCount ;   //获取上传密钥失败次数
    
    float defImageSizeW;
    float defImageSizeH ;
}
@end

@implementation UploadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        firstImage =NO;
        secImage =NO;
        
    }
    return self;
}
-(void)onClickedGoBackBtn{
    if (firstImage ==YES || secImage ==YES) {
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"放弃本次编辑？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"放弃", nil];
        [alertView show];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==1) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    headBar =[[HeadToolBar alloc] initWithTitle:@"上传截图" leftBtnTitle:@"取消" leftBtnImg:GetImage(@"back") leftBtnHighlightedImg:nil rightBtnTitle:nil rightBtnImg:nil rightBtnHighlightedImg:nil backgroundColor:kBlueTextColor];
    [headBar.leftBtn addTarget:self action:@selector(onClickedGoBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    
    ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y + headBar.frame.size.height, kmainScreenWidth, CGRectGetHeight(self.view.frame) - headBar.frame.origin.y - headBar.frame.size.height) andWithPageCount:1 backgroundImg:nil];
    ms.bounces =YES;
    ms.backgroundColor= [UIColor whiteColor];
    [ms setContentSize:CGSizeMake(kmainScreenWidth, ms.frame.size.height+1)];
    if (kmainScreenHeigh < 568.0f) {
        [ms setContentSize:CGSizeMake(kmainScreenWidth, ms.frame.size.height+45)];
    }
    [self.view addSubview:ms];
    
    NSLog(@" tip %@",self.taskPhoto.taskPhoto_tipString);
    phoneIndex =0;
    btnArray =[[NSMutableArray alloc] init];
    getImages =[[NSMutableArray alloc] initWithObjects:[[NSNull alloc]init],[[NSNull alloc]init], nil];
    dataArray =[[NSMutableArray alloc] initWithArray:@[[[NSNull alloc] init],[[NSNull alloc] init]]];
    [self loadContentView];
}

-(TaoJinButton *)loadShowImgBtnWithFrame:(CGRect) frame andTitle:(NSString *)title andLogoImg:(UIImage *)img andTag:(int)tag{
    TaoJinButton *btn =[[TaoJinButton alloc] initWithFrame:frame titleStr:title titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16.0f] logoImg:img backgroundImg:[UIImage createImageWithColor:kBlueTextColor]];
    btn.adjustsImageWhenHighlighted =NO;
    btn.tag =tag;
    btn.imageEdgeInsets =UIEdgeInsetsMake(7.0f, 30.0f, 7.0f, 90.0f);
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius =btn.frame.size.height /2 ;
    [btn addTarget:self action:@selector(onClickedShowImg:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage createImageWithColor:kLightBlueTextColor] forState:UIControlStateHighlighted];
    return btn;
}
-(void)loadContentView{
    TaoJinLabel *contentLab =[[TaoJinLabel alloc] initWithFrame:CGRectMake(kOffX_float, kOffX_2_0, kmainScreenWidth - 2 *kOffX_float, 0) text:self.taskPhoto.taskPhoto_missionDes font:[UIFont systemFontOfSize:14.0] textColor:KBlockColor2_0 textAlignment:NSTextAlignmentLeft numberLines:0];
    [contentLab sizeToFit];
    contentLab.frame =CGRectMake(kOffX_float, 10, kmainScreenWidth -2 *kOffX_float, contentLab.frame.size.height);
    [ms addSubview:contentLab];
    
    float tipLabOffy = 14.0f ;
    TaoJinLabel *tipLab;
    if (self.taskPhoto.taskPhoto_tipString) {
        tipLab= [[TaoJinLabel alloc] initWithFrame:CGRectMake(kOffX_2_0, contentLab.frame.origin.y +contentLab.frame.size.height +tipLabOffy, kmainScreenWidth -2*kOffX_2_0, 0) text:self.taskPhoto.taskPhoto_tipString font:GetFont(11.0) textColor:KRedColor2_0 textAlignment:NSTextAlignmentLeft numberLines:0];
        [tipLab sizeToFit];
        tipLab.frame = CGRectMake(kOffX_2_0, tipLab.frame.origin.y, tipLab.frame.size.width, tipLab.frame.size.height);
        [ms addSubview:tipLab];
    }
    DashLineUI *dashUI =[[DashLineUI alloc] init];
    dashUI.spacePattern = 2.0;
    dashUI.borderWidth = 1.0 ;
    dashUI.dashPattern = 2.0 ;
    dashUI.cornerRadius = 0.0 ;
    dashUI.borderColor = ColorRGB(180.0, 180.0, 180.0, 1.0);
    
    float scale = 224.0f/ 145.0f;
    defImageSizeW = kDefShowImgW;
    defImageSizeH = defImageSizeW *scale;
    TaoJinButton *imgOne =[[TaoJinButton alloc]initWithFrame:CGRectMake((kmainScreenWidth -defImageSizeW)/2, tipLab.frame.origin.y +tipLab.frame.size.height +2*kOffX_2_0, defImageSizeW , defImageSizeH) titleStr:nil titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14.0f] logoImg:nil backgroundImg:nil];
    imgOne.adjustsImageWhenHighlighted =NO;
    imgOne.tag =0;
    [imgOne addTarget:self action:@selector(getImgFromLocation:) forControlEvents:UIControlEventTouchUpInside];
    imgOne = (TaoJinButton *)[dashUI addDashLineUI:imgOne];
    [ms addSubview:imgOne];
    
    [btnArray addObject:imgOne];
    
    float imageSizeW = imgOne.frame.size.width ;
    float imageSizeH = imgOne.frame.size.height ;
    float lineW =25.0f;
    viewOne =[self loadShortLineView:CGRectMake(imageSizeW/2 -lineW/2, imageSizeH/2 -1.0f, lineW, 2.0f)];
    viewTwo = [self loadShortLineView:CGRectMake(imgOne.frame.size.width/2 -1.0f, imageSizeH/2 -lineW/2, 2.0f
                                                         , lineW)];
    [imgOne addSubview:viewOne];
    [imgOne addSubview:viewTwo];
    
    NSLog(@" imageone %f %f" ,imgOne.frame.size.width,imgOne.frame.size.height);

    
    if (self.taskPhoto.taskPhoto_imgCount >1) {
        imgOne.frame =CGRectMake((kmainScreenWidth -defImageSizeW*2 -10.0f)/2, tipLab.frame.origin.y +tipLab.frame.size.height +10, defImageSizeW, defImageSizeH);
        TaoJinButton *imgTwo  =[[TaoJinButton alloc]initWithFrame:CGRectMake(imgOne.frame.origin.x+imgOne.frame.size.width + 10.0f, imgOne.frame.origin.y, defImageSizeW , defImageSizeH) titleStr:nil titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14.0f] logoImg:nil backgroundImg:GetImage(@"showImgDef")];
        imgTwo.tag =1;
        [imgTwo addTarget:self action:@selector(getImgFromLocation:) forControlEvents:UIControlEventTouchUpInside];
        imgTwo.adjustsImageWhenHighlighted =NO;
        
        DashLineUI *dashUI2 =[[DashLineUI alloc] init];
        dashUI2.spacePattern = 2.0;
        dashUI2.borderWidth = 1.0 ;
        dashUI2.dashPattern = 2.0 ;
        dashUI2.cornerRadius = 0.0 ;
        dashUI2.borderColor = ColorRGB(180.0, 180.0, 180.0, 1.0);
        imgTwo = (TaoJinButton *)[dashUI2 addDashLineUI:imgTwo];
        [ms addSubview:imgTwo];
        [btnArray addObject:imgTwo];
        
        viewOne2 =[self loadShortLineView:CGRectMake(imageSizeW/2 -lineW/2, imageSizeH/2 -1.0f, lineW, 2.0f)];
        viewTwo2 = [self loadShortLineView:CGRectMake(imgTwo.frame.size.width/2 -1.0f,  imageSizeH/2 -lineW/2, 2.0f
                                                             , lineW)];
        [imgTwo addSubview:viewOne2];
        [imgTwo addSubview:viewTwo2];

        
    }
    float uploadBtnW = SendButtonWidth;
    
    TaoJinButton *uploadBtn =[[TaoJinButton alloc]initWithFrame:CGRectMake(kmainScreenWidth/2 -uploadBtnW/2 -kBtnSizeH/2 , imgOne.frame.origin.y +imgOne.frame.size.height +2*kOffX_2_0, uploadBtnW , SendButtonHeight) titleStr:[NSString stringWithFormat:@"上传截图"] titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16.0f] logoImg:nil backgroundImg:[UIImage createImageWithColor:kBlueTextColor]];
    uploadBtn.layer.masksToBounds = YES ;
    uploadBtn.layer.cornerRadius = SendButtonHeight /2 ;
    [uploadBtn setBackgroundImage:[UIImage createImageWithColor:kLightBlueTextColor] forState:UIControlStateHighlighted];
    [uploadBtn addTarget:self action:@selector(upLoadImgBtn) forControlEvents:UIControlEventTouchUpInside];
    [ms addSubview:uploadBtn];
    
    TaoJinButton *exampleBtn = [self loadShowImgBtnWithFrame:CGRectMake(uploadBtn.frame.origin.x +uploadBtn.frame.size.width +5.0f, imgOne.frame.origin.y +imgOne.frame.size.height +2 *kOffX_2_0, SendButtonHeight, SendButtonHeight) andTitle:@"图例" andLogoImg:nil andTag:1];
    [ms addSubview:exampleBtn];
    
    if (uploadBtn.frame.origin.y +uploadBtn.frame.size.height +headBar.frame.origin.y+headBar.frame.size.height > ms.frame.size.height) {
        [ms setContentSize:CGSizeMake(kmainScreenWidth, uploadBtn.frame.origin.y +uploadBtn.frame.size.height +headBar.frame.origin.y +headBar.frame.size.height +10.0f)];
    }

}
-(UIView *)loadShortLineView:(CGRect)frame  {
    UIView *view =[[UIView alloc]initWithFrame:frame];
    view.backgroundColor = ColorRGB(180.0, 180.0, 180.0, 1.0);
    return view;
}
-(void)upLoadImgBtn{       //点击上传
    
    CGSize screenSize =[UIScreen mainScreen].bounds.size;
    float scale =[UIScreen mainScreen].scale;
    if (firstImage ==YES && secImage ==YES && btnArray.count == 2) {
        UIImage *image =[getImages objectAtIndex:0];
        
        UIImage *image2 =[getImages objectAtIndex:1];
        
        CGSize size1 =image.size;
        CGSize size2 =image2.size;
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            [self requestForUploadPhotoToken];
            /*
            float scale1 =  (size1.height )/size1.width;
            float scale2 = (size2.height )/size2.width;
            float scaleWH1 =size1.width /size1.height;
            float scaleWH2 =size2.width /size2.height;
            if (scale1 ==scale2 && scale1 ==kIpadScale2) {
                [self creatUploadImgRequest];
            }else if (scaleWH1 ==scaleWH2 && scaleWH1 ==kIpadScale2){
                [self creatUploadImgRequest];
            }
            else{
                [StatusBar showTipMessageWithStatus:@"上传的图片尺寸不符合要求" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
            }
     */
        }else{
            screenSize =CGSizeMake(screenSize.width *scale, screenSize.height *scale);
            if (CGSizeEqualToSize(size1, size2) ==YES && CGSizeEqualToSize(size2, screenSize) ==YES) {
                [self requestForUploadPhotoToken];
            }else{
                [StatusBar showTipMessageWithStatus:@"上传的图片尺寸不符合要求" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
            }
        }
    }else if (btnArray.count ==1 && firstImage ==YES){
        
        UIImage *image =[getImages objectAtIndex:0];
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            float scale1 = (image.size.height *1.0)/(image.size.width *1.0) ;
            float scale2 = image.size.width /image.size.height;
            if ( scale1 == kIpadScale2 || scale2 ==kIpadScale2) {
                [self requestForUploadPhotoToken];
            }else{
                [StatusBar showTipMessageWithStatus:@"上传的图片尺寸不符合要求" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
            }
        }else{
            
            if (CGSizeEqualToSize(image.size, CGSizeMake(screenSize.width *scale, screenSize.height *scale))) {
                [self requestForUploadPhotoToken];
            }else{
                [StatusBar showTipMessageWithStatus:@"上传的图片尺寸不符合要求" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
            }
        }
    }else if ( btnArray.count ==2  && firstImage ==YES){
        [StatusBar showTipMessageWithStatus:@"请插入第二张截图后上传" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
    }else if (btnArray.count ==2 && secImage ==YES){
        [StatusBar showTipMessageWithStatus:@"请插入第二张截图后上传" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
    }
    else{
        [StatusBar showTipMessageWithStatus:@"请插入截图后上传" andImage:GetImage(@"laba.png") andTipIsBottom:YES];
    }
}
-(void)getImgFromLocation:(TaoJinButton *)btn{       //取本地图片
    phoneIndex =btn.tag;
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc] init];
    PhotoViewController *photoVC =[[PhotoViewController alloc] initWithCollectionViewLayout:layout];
    photoVC.pvDelegate =self;
    [self presentViewController:photoVC animated:YES completion:^{
    
    }];

}
-(void)getImageFromLocation:(UIImage *)image{
   
    [getImages replaceObjectAtIndex:phoneIndex withObject:image];

    [dataArray replaceObjectAtIndex:phoneIndex withObject:[self getImageData:image]];
    float scalew = [UIScreen mainScreen].scale ;
    if (image.size.height > 960.0f) {
        float scale =defImageSizeW*1.0 /(kmainScreenWidth*1.0);
        CGSize newSize =CGSizeMake(defImageSizeW, image.size.height *scale/scalew);
       
        image = [CompressImage imageWithCutImage:image moduleSize:newSize];
    }else{
        image = [CompressImage imageWithOldImage:image scaledToSize:CGSizeMake(defImageSizeW, defImageSizeH)];
    }
    UIButton *phoneBtn = [btnArray objectAtIndex:phoneIndex];
    [phoneBtn setBackgroundImage:image forState:UIControlStateNormal];
    switch (phoneIndex) {
        case 0:
            firstImage =YES;
            viewOne.hidden = YES;
            viewTwo.hidden = YES;
            break;
        case 1:
            secImage =YES;
            viewOne2.hidden = YES;
            viewTwo2.hidden = YES;
            break;
        default:
            break;
    }
    
}
-(NSData *)getImageData:(UIImage *)image{
    NSData* dataImg = UIImagePNGRepresentation(image);
    NSLog(@"  imagesize %@ %d ",NSStringFromCGSize(image.size),dataImg.length);
    if (dataImg.length > 100*1024) {
        dataImg = UIImageJPEGRepresentation(image, 0.1);
        NSLog(@" big %d",dataImg.length);
    }else if(dataImg.length > 50*1024 && dataImg.length < 100 *1024){
        dataImg = UIImageJPEGRepresentation(image,0.6);
        NSLog(@" small %d",dataImg.length);
    }
    return dataImg;
}
-(UIImage *)getResultImageFrom:(UIImage *)image inRect:(CGRect) rect{
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}
-(void)onClickedShowImg:(TaoJinButton *)btn{
    switch (btn.tag) {
        case 1:        // 展示示例图
        {
            
            ShowImgView *view =[[ShowImgView alloc] initWithImgListArr:self.taskPhoto.taskPhoto_imageAry];
            [view showImages];
            
        }
            break;
        case 2:         // 评论
        {
            NSURL *url =[NSURL URLWithString:self.taskPhoto.taskPhoto_commentUrl];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
        default:
            break;
    }
}
/**
*  获取上传截图key
*/
-(void)requestForUploadPhotoToken{

    [[UploadingView shareUploadView] showWithText:@"正在上传截图" andViewControler:self];

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
                [[UploadingView shareUploadView] dismiss];
            }
        });

    } andFailBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UploadingView shareUploadView] dismiss];
        });
        NSLog(@" 获取传图密钥失败 ");
        keyFailCount ++;
        if (keyFailCount <3) {
            [self requestForUploadPhotoToken];
        }
    }];
}

/**
*  上传截图到服务器
*
*  @param key 上传密钥
*/
-(void)requestForPostPhotoWithKey:(NSString *)key{
    for (TaoJinButton *btn in btnArray) {
        btn.userInteractionEnabled =NO;
    }

    NSString *boundary;
    NSMutableDictionary *dic;
    NSString* urlStr;
    NSNumber *num;
    int rand =arc4random()/100000;
    num =[NSNumber numberWithInt:rand];
    
    NSString *userID = [[MyUserDefault standardUserDefaults]getUserId];
    
    dic =[[NSMutableDictionary alloc] initWithDictionary:@{@"uid": userID,@"upload_key":key}];     //需要活动id 和任务序列id
    NSString *adress =[[MyUserDefault standardUserDefaults] getPhotoServiceAdress];
    if (adress) {
        urlStr =adress;
    }
    
    NSLog(@"请求上传截图【urlStr】= %@   %@",urlStr,dic);
    
    NSString *paramStr = [dic JSONString];
    /*
     if(firstImage){
     
     NSObject *obj =[getImages objectAtIndex:0];
     [dic setObject:(UIImage *)obj forKey:[NSString stringWithFormat:@"userPic0"]];
     
     }
     if(secImage){
     
     NSObject *obj2 =[getImages objectAtIndex:1];
     [dic setObject:(UIImage *)obj2 forKey:[NSString stringWithFormat:@"userPic1"]];
     }
     */
    NSMutableData* body = [NSMutableData data];
    boundary = @"0xKhTmLbOuNdArY";
    [body appendData:[[NSString stringWithFormat:@"\n--%@\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data;name='param';value='%@'\n\n",paramStr] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"{\"uid\":\"%@\",\"upload_key\":\"%@\"}",userID ,key] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\n--%@\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //第二段
    int imageTag=0;
    
    //将字典排序 不然图片顺序会乱
    NSArray* array = dic.allKeys;
    array = [array sortedArrayUsingComparator:^(id obj1 ,id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result == NSOrderedDescending;
    }];
    
    for (int i = 0; i < dataArray.count; i++) {
        id value =[dataArray objectAtIndex:i];
        if (![value isKindOfClass:[NSNull class]]) {
            NSData *dataImg =[dataArray objectAtIndex:i];
            
            /*
             NSString *key = [array objectAtIndex:i];
             id value = [dic objectForKey:key];
             if ([value isKindOfClass:[UIImage class]]) {
             UIImage* im = [dic objectForKey:key];
             
             NSData* dataImg =[NSData dataWithData: UIImageJPEGRepresentation(im, 1.0)];
             if (dataImg.length > 100*1024) {
             dataImg = UIImageJPEGRepresentation(im, .08);
             }else if(dataImg.length > 50*1024 && dataImg.length < 100 *1024){
             dataImg = UIImageJPEGRepresentation(im, 0.3);
             }
             */
            [body appendData:[[NSString stringWithFormat:@"\n--%@\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data;name='userfile_%d';filename='userfile.jpg'\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
            imageTag++;
            [body appendData:[[NSString stringWithFormat:@"Content-Type:image/jpg\n\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:dataImg];
            [body appendData:[[NSString stringWithFormat:@"\n--%@--\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    NSLog(@" img body %d",body.length);
    [AsynURLConnection requestWithURLToSendJSONL:urlStr boundary:boundary paramStr:paramStr body:body timeOut:httpTimeout+30 success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error;
            NSArray *dicArr =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"上传截图【reaponse】 = %@",dicArr);
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
                    NSString *tid =[NSString stringWithFormat:@"%d",self.taskPhoto.taskPhoto_appId];
                    NSString *listorder =[NSString stringWithFormat:@"%d",self.taskPhoto.taskPhoto_step];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSDictionary *sendDic =@{@"mid":tid ,@"task":listorder ,@"pics":allAdress};
                        [self requestForSendMsg:sendDic];
                        
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [StatusBar showTipMessageWithStatus:@"上传截图失败，请重新上传" andImage:[UIImage imageNamed:@"icon_no.png"] andTipIsBottom:YES];
                        [[UploadingView shareUploadView] dismiss];
                        [[TipView shareTipView] tipViewShowWithText:@"上传失败，请再次上传" andTipImage:GetImage(@"no")];

                    });
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UploadingView shareUploadView] dismiss];
                    [[TipView shareTipView] tipViewShowWithText:@"上传失败，请再次上传" andTipImage:GetImage(@"no")];
                });
            }
            
            for (TaoJinButton *btn in btnArray) {
                btn.enabled =YES;
            }
        });

        

    } fail:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UploadingView shareUploadView] dismiss];
            [[TipView shareTipView] tipViewShowWithText:@"上传失败，请再次上传" andTipImage:GetImage(@"no")];
        });
        for (TaoJinButton *btn in btnArray) {
            btn.enabled =YES;
        }

    }];
    /*
    [AsynURLConnection requestWithURLToSendJSONL:urlStr boundary:boundary paramStr:paramStr body:body timeOut:httpTimeout+30 success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error;
            NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"error【reaponse】 = %@",error);
            NSLog(@"上传截图【reaponse】 = %@",dataDic);
            if ([[dataDic objectForKey:@"flag"]intValue]==1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [StatusBar showTipMessageWithStatus:@"截图上传成功，请等待审核" andImage:GetImage(@"icon_yes.png") andTipIsBottom:YES];
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                    [self.delegate uploadImageSuccess];
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [StatusBar showTipMessageWithStatus:@"上传截图失败，请重新上传" andImage:[UIImage imageNamed:@"icon_no.png"] andTipIsBottom:YES];
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
            }
            for (TaoJinButton *btn in btnArray) {
                btn.userInteractionEnabled =YES;
            }
        });
    } fail:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[LoadingView showLoadingView] actViewStopAnimation];
            [StatusBar showTipMessageWithStatus:@"上传截图失败，请重新上传" andImage:[UIImage imageNamed:@"icon_no.png"] andTipIsBottom:YES];
        });
        for (TaoJinButton *btn in btnArray) {
            btn.enabled =YES;
        }
    }];
     */
}
-(void)requestForSendMsg:(NSDictionary *)dic{
    
    NSString *urlStr =[NSString stringWithFormat:kOnlineWeb,@"mission/screenshot"];
    [LLAsynURLConnection requestURLWith:urlStr dataDic:dic andProtocolNum:@"20007" andTimeOut:httpTimeout connectSuccess:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@" 发送反馈信息 == %@",dataDic);
            if ([[dataDic objectForKey:@"flag"] intValue] ==1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UploadingView shareUploadView] dismiss];
//                    [StatusBar showTipMessageWithStatus:@"截图上传成功，请等待审核" andImage:nil andTipIsBottom:YES];
                    [[TipView shareTipView] tipViewShowWithText:@"上传成功" andTipImage:GetImage(@"yes")];
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                    [self.delegate uploadImageSuccess];

                });
                
            }else{
                NSDictionary *body =[dataDic objectForKey:@"body"];
                NSString *errMsg =[body objectForKey:@"error"];
                NSLog(@" 上传失败error == %@",errMsg);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UploadingView shareUploadView] dismiss];
                    [[TipView shareTipView] tipViewShowWithText:@"上传失败，请再次上传" andTipImage:GetImage(@"no")];

                });
            }
            
        });
    } andFail:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UploadingView shareUploadView] dismiss];
            [[TipView shareTipView] tipViewShowWithText:@"上传失败，请再次上传" andTipImage:GetImage(@"no")];
        });
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
