//
//  LLMessageViewController.m
//  免费流量王
//
//  Created by keyrun on 14-10-15.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LLMessageViewController.h"
#import "HeadToolBar.h"
#import "TaoJinScrollView.h"
#import "TaoJinLabel.h"
#import "MyUserDefault.h"
#import "NSString+emptyStr.h"
#import "TaoJinButton.h"
#import "UIImage+ColorChangeTo.h"
#import "LXTabViewController.h"
#import "CompressImage.h"
#define SendViewHeight                                          61.0f                       //输入框的高度
#define SendButtonHeight                                        30.0f                       //发送按钮的高度
#define SendButtonWidth                                         50.0f                       //发送按钮的高度
#define ImageButtonWidth                                        41.0f                       //选取图片按钮高度
#define ImageButtonOffX                                         10.0f                       //选图按钮 x偏移度
@interface LLMessageViewController ()
{
    HeadToolBar *headBar ;
    UITableView *askTableView;
    NSMutableArray *allLogs ;
    UITableView* questView ;
    TaoJinScrollView *tjScrollView;
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
}
@end

@implementation LLMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWitheColor ;
    
    headBar = [[HeadToolBar alloc] initWithTitle:@"消息中心" leftBtnTitle:@"" leftBtnImg:GetImageWithName(@"back.png") leftBtnHighlightedImg:GetImageWithName(@"back_sel.png") rightLabTitle:nil backgroundColor:kBlueTextColor];
    
    [headBar.leftBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [self initQuestViewContent];
    
    [self initAskViewContent];
    [self initScrollView];
    [self initWithTextViewFrame:CGRectMake(0.0f, kmainScreenHeigh - SendViewHeight - (kBatterHeight), kmainScreenWidth, SendViewHeight )];
}
-(void)initQuestViewContent{
    questView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, kmainScreenWidth, kmainScreenHeigh -headBar.frame.size.height -headBar.frame.origin.y ) style:UITableViewStylePlain];
    questView.backgroundView = nil;
    questView.backgroundColor = [UIColor clearColor];
    
}
-(void)initScrollView {
    NSArray *arrayView =[[NSArray alloc] initWithObjects:askTableView,questView, nil];
    NSArray *array =[[NSArray alloc] initWithObjects:@"我要提问",@"常见问题" ,nil];
    tjScrollView =[[TaoJinScrollView alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y  +headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh -headBar.frame.size.height -headBar.frame.origin.y) btnAry:array btnAction:^(UIButton *button) {
        if (button.tag ==1) {
            
        }
        else{
            //            if (questView.isFirst) {
            //                [questView requestCommonQuest];
            //            }
            
        }
    } slidColor:kBlueTextColor viewAry:arrayView];
    tjScrollView.scrollView.delaysContentTouches =NO;
    askTableView.frame =CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y -headBar.frame.size.height -[tjScrollView getButtonRowHeight]);
    if (kDeviceVersion < 7.0) {
        askTableView.frame  =CGRectMake(0, 0, kmainScreenWidth, askTableView.frame.size.height -20);
    }
    questView.frame =CGRectMake(320.0f, 0, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y -headBar.frame.size.height -[tjScrollView getButtonRowHeight]);
    if (kDeviceVersion < 7.0) {
        questView.frame =CGRectMake(kmainScreenWidth, 0, kmainScreenWidth, questView.frame.size.height -20);
    }
    [self.view addSubview:tjScrollView];
    
}
-(void)initAskViewContent{
    if (askTableView) {
        [askTableView removeFromSuperview];
        askTableView = nil;
    }
    askTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kmainScreenWidth, kmainScreenHeigh -headBar.frame.size.height -headBar.frame.origin.y ) style:UITableViewStylePlain];
    
    askTableView.delegate = self;
    askTableView.dataSource = self;
    askTableView.delaysContentTouches =NO;
    askTableView.backgroundView = nil;
    askTableView.backgroundColor = [UIColor clearColor];
    [askTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}
- (void)onClickBackBtn:(UIButton* )btn{
    [self.navigationController popViewControllerAnimated:YES];
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
    cell.tag = indexPath.row;
    cell.backgroundColor = [UIColor clearColor];
    
    if (allLogs.count != 0 ) {
        cell.msg = [[SysMessage alloc]initSysMessageByDic:[allLogs objectAtIndex:indexPath.row ]];
        if (indexPath.row -1 >=0) {         //判断消息是否是同一天
            SysMessage *lastMsg =[[SysMessage alloc] initSysMessageByDic:[allLogs objectAtIndex:indexPath.row -1]];
            if ([lastMsg.msgTime isEqualToString:cell.msg.msgTime]) {
                cell.isOneDay =YES;
            }
        }
        [cell initMessageCellContentWith:cell.msg];
        
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
-(void)onClickedGetUserImage{
    UIActionSheet* as=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    
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
        case 2:
        {
            
        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    getImage=[info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if ([self isBigImage:getImage]==YES) {
        getImage =[CompressImage imageWithOldImage:getImage scaledToSize:CGSizeMake(120 *2, 120 *2)];
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

-(void)sendAction:(id)sender{
    
}

-(void)getLongPressGestureRecognizer:(int )msgid andCellTag:(int) tag{
    
}
-(void)onClickDeleteBtn:(int )msgid andCellTag:(int)tag{
    
}

-(void) onClickAskBtn{
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyBoardWillShow:(NSNotification*)notification{
    NSDictionary *info = [notification userInfo];
    //获取当前显示的键盘高度
    kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey ] CGRectValue].size;
    //获取当前键盘与上一次键盘的高度差
    CGFloat distanceToMove = kbSize.height - normalKeyboardHeight;
    
//    UIViewAnimationCurve animationCurve ;
//    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
//    animationOptions =animationCurve << 16 ;
//    
//    [self keyboardToMoveView:distanceToMove isUp:YES isReloadTable:NO comment:nil animationOption:animationOptions];
//    normalKeyboardHeight = kbSize.height;
    
    
}

/*
 *   键盘移动输入框跟随移动
 */
/*
-(void)keyboardToMoveView:(int)height isUp:(BOOL)isUp isReloadTable:(BOOL)isReloadTable comment:(Comment *)comment animationOption:(UIViewAnimationOptions)options{
    
    [UIView animateWithDuration:0.25f delay:0.0f options:options  animations:^{
        CGRect smsBgcgreat = [containView frame];
        if(isUp){
            smsBgcgreat.origin.y -= height ;
        }else{
            smsBgcgreat.origin.y += height;
        }
        [containView setFrame:smsBgcgreat];
    } completion:^(BOOL finished) {
        if(finished && isReloadTable){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [UIView animateWithDuration:0.5f animations:^{
                if(detail.detail_commentAry.count > 1){
                    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }
            }completion:^(BOOL finished) {
                if(finished){
                    [detail.detail_commentAry insertObject:comment atIndex:0];
                    if(detail.detail_commentAry.count > 1){
                        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }else{
                        [_tableView reloadData];
                    }
                    if(detail.detail_commentAry.count <= 1){
                        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }
                }
            }];
        }
    }];
    
    
}
*/
/*
 *   点击非输入框或键盘时隐藏键盘
 */
-(void)touchToHidenKeyBoard:(UITapGestureRecognizer*)recognizer
{
    [self hideKeyBoard];
//    [self resumnView:NO comment:nil];
}

/*
 *   处理隐藏键盘
 */
-(void)hideKeyBoard
{
    [textView resignFirstResponder];
}

/*
 *   还原输入框的位置
 */
/*
-(void)resumnView:(BOOL)isReloadTable comment:(Comment *)comment
{
    if(containView.frame.origin.y != kmainScreenHeigh - containView.frame.size.height){
        [self keyboardToMoveView:kbSize.height isUp:NO isReloadTable:isReloadTable comment:comment animationOption:animationOptions];
        normalKeyboardHeight = 0;
    }
}
*/
/**
 *  滚动列表时收回键盘
 *
 */
/*
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self hideKeyBoard];
    [self resumnView:NO comment:nil];
}
*/
@end
