//
//  PostGoodsController.m
//  TJiphone
//
//  Created by keyrun on 13-10-15.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "PostGoodsController.h"
#import "MScrollVIew.h"
#import "DidRewardView.h"
#import "StatusBar.h"
#import "RewardListViewController.h"
#import "GoodsDetailsController.h"
#import "HeadToolBar.h"
#import "CButton.h"

@interface PostGoodsController ()
{
    //    HeadView* headView;
    HeadToolBar *headBar;
    UIPickerView* pickView;
    UITextField* topField;
    UILabel* secondField;
    UITextField* thirdField;
    UITextField* fourField;
    NSDictionary* areaDic;
    NSMutableArray* provinceTmp;
    NSArray* provinces;
    NSArray* citys;
    NSArray* districts;
    NSString* selectedPro;
    NSString* getAdress;
    UIToolbar* toolBar;
    MScrollVIew* ms;
    
    NSString* area;
    NSString* adress;
    UILabel* tipLabel ;
    CButton *chargeBtn ;
    int pIndex;
    int cIndex;
    int dIndex;
    
    int isCancel;
}
@end

@implementation PostGoodsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)hidKeyBoard{
    if ([topField resignFirstResponder] ==NO) {
        [topField resignFirstResponder];
    }
    if ([thirdField resignFirstResponder] ==NO) {
        [thirdField resignFirstResponder];
    }
    if ([fourField resignFirstResponder] ==NO) {
        [fourField resignFirstResponder];
    }
    
    if (pickView) {
        [pickView removeFromSuperview];
        pickView =nil;
    }
    if (toolBar) {
        [toolBar removeFromSuperview];
        toolBar =nil;
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self hidKeyBoard];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //ios7 以上，更改状态栏的样式
    if ([[[UIDevice currentDevice]systemVersion]floatValue] <7.0) {
        
    }else{
        UIView* view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 20)];
        view.backgroundColor =[UIColor blackColor];
        [self.view addSubview:view];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidKeyBoard) name:@"hidAllKeyBoard" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didRewardGoodsPopView) name:@"popview" object:nil];
    
    
    headBar =[[HeadToolBar alloc] initWithTitle:@"收货地址" leftBtnTitle:@"返回" leftBtnImg:GetImage(@"back") leftBtnHighlightedImg:nil rightLabTitle:nil backgroundColor:kBlueTextColor];
    headBar.leftBtn.tag =1;
    [headBar.leftBtn addTarget:self action:@selector(onClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    NSUserDefaults* ud =[NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:@"UserRewardArea"]) {
        area =[ud objectForKey:@"UserRewardArea"];
    }else{
        area =@"";
    }
    
//    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    
    if (kDeviceVersion >= 7.0) {
        ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y + headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height + 20) andWithPageCount:1 backgroundImg:nil];
    }else{
        ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y + headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height) andWithPageCount:1 backgroundImg:nil];
    }
    
    [ms setContentSize:CGSizeMake(kmainScreenWidth, ms.frame.size.height+1)];
    ms.delegate =self;
    ms.bounces =YES;
    [self.view addSubview:ms];
    
    [self getAreaData];
    [self initViewContent];
    
    //    if (kmainScreenHeigh < 568.0) {
    //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePosition:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //    }
    
}
-(void)changePosition:(NSNotification *)notic{
    NSDictionary *dic =[notic userInfo];
    CGRect kbSize = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];;
    NSTimeInterval time = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve animationCurve ;
    [[dic objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    UIViewAnimationOptions options = animationCurve << 16 ;
    
    [self adjustPositionWithTime:time viewAnimation:options position:kbSize];
    
    
}
-(void)adjustPositionWithTime:(NSTimeInterval) time viewAnimation:(UIViewAnimationOptions) option position:(CGRect) rect{
    float a = chargeBtn.frame.origin.y +headBar.frame.origin.y +headBar.frame.size.height;
    float b = CGRectGetHeight(self.view.frame) - rect.size.height -chargeBtn.frame.size.height -5.0f;
    float c = b-a;
    c = c < 0? c*-1:c;
    c = rect.origin.y ==kmainScreenHeigh? 0:c ;
    NSLog(@" 高度差  == %f",c);
    float oriH =headBar.frame.origin.y +headBar.frame.size.height ;
    [UIView animateWithDuration:time delay:0.0f options:option animations:^{
        ms.frame = CGRectMake(0, oriH - c, ms.frame.size.width, ms.frame.size.height);
        [self.view insertSubview:ms belowSubview:headBar];
        
    } completion:^(BOOL finished) {
        
    }];
}


-(void)closeKeyboard{
    [topField resignFirstResponder];
    [thirdField resignFirstResponder];
    [fourField resignFirstResponder];
}
-(void)getAreaData{
    NSBundle* bundle=[NSBundle mainBundle];
    NSString* plistPath=[bundle pathForResource:@"area" ofType:@"plist"];
    areaDic =[[NSDictionary alloc]initWithContentsOfFile:plistPath];
    
    NSArray* components=[areaDic allKeys];
    NSArray* sortedArray=[components sortedArrayUsingComparator: ^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    provinceTmp=[[NSMutableArray alloc]init];
    for (int i=0; i<sortedArray.count; i++) {
        NSString* index=[sortedArray objectAtIndex:i];
        NSArray* tem=[[areaDic objectForKey:index]allKeys];
        [provinceTmp addObject:[tem objectAtIndex:0]];
    }
    provinces=[[NSArray alloc]initWithArray:provinceTmp];
    NSUserDefaults* ud =[NSUserDefaults standardUserDefaults];
    int proIndex=0;
    if ([ud objectForKey:@"proIndex"]) {
        proIndex =[[ud objectForKey:@"proIndex"]integerValue];
        
    }
    /*
     NSString* index=[sortedArray objectAtIndex:proIndex];
     NSString* selected=[provinces objectAtIndex:proIndex];
     //省
     NSDictionary* diction=[areaDic objectForKey:index];
     
     NSDictionary* dic=[NSDictionary dictionaryWithDictionary:[diction objectForKey:selected]];
     
     NSArray* cityArray=[[NSArray alloc]initWithArray:[dic allKeys]];
     cityArray=[components sortedArrayUsingComparator: ^(id obj1, id obj2){
     if ([obj1 integerValue] > [obj2 integerValue]) {
     return (NSComparisonResult)NSOrderedDescending;
     }
     if ([obj1 integerValue] < [obj2 integerValue]) {
     return (NSComparisonResult)NSOrderedAscending;
     }
     return (NSComparisonResult)NSOrderedSame;
     }];
     
     int twoIndex=0;
     if ([ud objectForKey:@"proIndex"]) {
     twoIndex =[[ud objectForKey:@"proIndex"]integerValue];
     }
     NSDictionary* cityDic=[NSDictionary dictionaryWithDictionary:[dic objectForKey:[cityArray objectAtIndex:twoIndex]]];
     //市
     
     citys=[[NSArray alloc]initWithArray:[cityDic allKeys]];
     
     NSString* selectCity=[citys objectAtIndex:0];
     
     districts=[[NSArray alloc]initWithArray:[cityDic objectForKey:selectCity]];
     */
    // [Sun] 2014.02.12 锁定选择器中的邮寄地址
    NSString *index = [sortedArray objectAtIndex:proIndex];
    NSString *selected = [provinces objectAtIndex:proIndex];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    cityArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    int twoIndex=0;
    if ([ud objectForKey:@"cityIndex"]) {
        twoIndex =[[ud objectForKey:@"cityIndex"]integerValue];
    }
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:twoIndex]]];
    citys = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    
    NSString *selectedCity = [citys objectAtIndex: 0];
    districts = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    
    
}
-(void)initViewContent{
    NSUserDefaults* userdefaults =[NSUserDefaults standardUserDefaults];
    //    UIImageView* topCellImgae=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_top.png"]];
    //    topCellImgae.frame=CGRectMake(5, 15, 310, 45);
    float cellH =45.0;
    float cellOffY =15.0;
    topField=[[UITextField alloc]initWithFrame:CGRectMake(kOffX_2_0, cellOffY, kmainScreenWidth -2*kOffX_2_0, 20)];
    topField.placeholder=@"收货人姓名";
    topField.textColor=KGrayColor2_0;
    topField.delegate=self;
    topField.backgroundColor=[UIColor clearColor];
    topField.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    topField.font=[UIFont systemFontOfSize:16.0];
    if ([userdefaults objectForKey:@"UserRewardName"]) {
        topField.text =[userdefaults objectForKey:@"UserRewardName"];
        topField.textColor =KBlockColor2_0;
    }else{
        topField.text=@"";
    }
    topField.returnKeyType =UIReturnKeyDone;
    //    [ms addSubview:topCellImgae];
    [ms addSubview:topField];
    
    //    UIImageView* secondCellImgae=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_center.png"]];
    //    secondCellImgae.frame=CGRectMake(5, topCellImgae.frame.origin.y+topCellImgae.frame.size.height-1, 310, 45);
    UIImage *moreImg =GetImage(@"more.png");
    UIImageView* nextImage=[[UIImageView alloc]initWithImage:moreImg];
    nextImage.frame=CGRectMake(kmainScreenWidth -15.0 - moreImg.size.width, cellH +(cellH -moreImg.size.height)/2, moreImg.size.width, moreImg.size.height);
    UIButton* selcetBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [selcetBtn addTarget:self action:@selector(onClickAdressChoose) forControlEvents:UIControlEventTouchUpInside];
    
    secondField=[[UILabel alloc]initWithFrame:CGRectMake(kOffX_2_0, topField.frame.origin.y + cellH, kmainScreenWidth -2*kOffX_2_0, 17)];
    secondField.text= @"所在地区";
    secondField.textColor=KBlockColor2_0;
    secondField.backgroundColor=[UIColor clearColor];
    secondField.font=[UIFont systemFontOfSize:16.0];
    if ([userdefaults objectForKey:@"UserRewardArea"]) {
        secondField.text =[userdefaults objectForKey:@"UserRewardArea"];
    }else{
        
    }
    selcetBtn.frame=secondField.frame;
    //    [ms addSubview:secondCellImgae];
    [ms addSubview:secondField];
    [ms addSubview:nextImage];
    [ms addSubview:selcetBtn];
    
    //    UIImageView* thirdCellImgae=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_center.png"]];
    //    thirdCellImgae.frame=CGRectMake(5, secondCellImgae.frame.origin.y+secondCellImgae.frame.size.height-1, 310, 45);
    thirdField=[[UITextField alloc]initWithFrame:CGRectMake(kOffX_2_0, secondField.frame.origin.y + cellH, secondField.frame.size.width, 20)];
    thirdField.placeholder=@"详细街道地址";
    thirdField.delegate=self;
    thirdField.contentHorizontalAlignment =UIControlContentVerticalAlignmentCenter;
    thirdField.textColor=KGrayColor2_0;
    thirdField.font=[UIFont systemFontOfSize:16.0];
    if ([userdefaults objectForKey:@"UserRewardAdress"]) {
        thirdField.text =[userdefaults objectForKey:@"UserRewardAdress"];
        thirdField.textColor =KBlockColor2_0;
    }else{
        thirdField.text = @"";
    }
    thirdField.returnKeyType =UIReturnKeyDone;
    //    [ms addSubview:thirdCellImgae];
    [ms addSubview:thirdField];
    
    fourField=[[UITextField alloc]initWithFrame:CGRectMake(kOffX_2_0, thirdField.frame.origin.y +cellH, secondField.frame.size.width, 20)];
    fourField.placeholder=@"手机号码";
    fourField.textColor=KGrayColor2_0;
    fourField.contentHorizontalAlignment =UIControlContentVerticalAlignmentCenter;
    fourField.delegate=self;
    fourField.font=[UIFont systemFontOfSize:16.0];
    if ([userdefaults objectForKey:@"UserRewardPhoneNumber"]) {
        fourField.text =[userdefaults objectForKey:@"UserRewardPhoneNumber"];
        fourField.textColor =KBlockColor2_0;
    }else{
        fourField.text = @"";
    }
    fourField.returnKeyType =UIReturnKeyDone;
    //    [ms addSubview:fourCellImgae];
    [ms addSubview:fourField];
    
    for (int i=1; i <=4; i++) {
        UIView *line =[self loadSperateLineWithFrame:CGRectMake(kOffX_2_0, i* (cellH -0.5f), kmainScreenWidth -kOffX_2_0, 0.5f)];
        [ms addSubview:line];
    }
    float btnW =SendButtonWidth ;
    if (!chargeBtn) {
        chargeBtn = [self loadBtnWithFrame:CGRectMake(kmainScreenWidth/2 -btnW/2, cellH *4+ kOffX_2_0, SendButtonWidth, SendButtonHeight) withTitle:@"立即兑换" andFont:[UIFont systemFontOfSize:16.0]];
        chargeBtn.tag =2;
        chargeBtn.layer.cornerRadius = chargeBtn.frame.size.height/ 2 ;
        [chargeBtn addTarget:self action:@selector(onClickedExchangeGoods) forControlEvents:UIControlEventTouchUpInside];
        [ms addSubview:chargeBtn];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField ==fourField) {
        if([textField.text stringByAppendingString:string].length>11 ){
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
    
}

-(CButton *)loadBtnWithFrame:(CGRect)frame withTitle:(NSString *)title andFont:(UIFont*) font{
    CButton * btn =[CButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor =btn.nomalColor =kBlueTextColor;
    btn.changeColor =kLightBlueTextColor;
    btn.frame =frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font =font;
    return btn;
}


-(UIView *)loadSperateLineWithFrame:(CGRect) frame{
    UIView *line =[[UIView alloc]initWithFrame:frame];
    line.backgroundColor =kLineColor2_0;
    return line;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.textColor =KBlockColor2_0;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:fourField]) {
        [fourField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    textField.textColor =KBlockColor2_0;
    if (pickView) {
        [pickView removeFromSuperview];
        pickView =nil;
        [toolBar removeFromSuperview];
        toolBar =nil;
    }
}
-(void)onClickAdressChoose{
    [topField resignFirstResponder];
    [thirdField resignFirstResponder];
    [fourField resignFirstResponder];
    if ( !pickView ) {
        
        pickView=[[UIPickerView alloc]initWithFrame:CGRectZero];
        pickView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        //    pickView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        pickView.delegate=self;
        pickView.dataSource=self;
        pickView.showsSelectionIndicator=YES;
        [pickView setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1]];
        //        [pickView selectRow:0 inComponent:PROVINCE_COMPONENT animated:YES];
        
        NSUserDefaults* ud =[NSUserDefaults standardUserDefaults];
        if ([ud objectForKey:@"proIndex"] ) {
            int oneIndex =[[ud objectForKey:@"proIndex"]integerValue];
            [pickView selectRow:oneIndex inComponent:PROVINCE_COMPONENT animated:YES];
            int twoIndex =[[ud objectForKey:@"cityIndex"]integerValue];
            [pickView selectRow:twoIndex inComponent:CITY_COMPONENT animated:YES];
            int threeIndex =[[ud objectForKey:@"disIndex"]integerValue];
            [pickView selectRow:threeIndex inComponent:DISTRICT_COMPONENT animated:YES];
            
        }
        
        pickView.frame=CGRectMake(0,kmainScreenHeigh-216, kmainScreenWidth, 216);
        [self.view addSubview:pickView];
    }
    //创建确定，取消按钮
    NSMutableArray* items=[[NSMutableArray alloc]initWithCapacity:3];
    UIButton* confirmButton;
    UIButton *cannelButton;
    if (kDeviceVersion >= 7.0) {
        confirmButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        confirmButton.backgroundColor =[UIColor clearColor];
        cannelButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        cannelButton.backgroundColor =[UIColor clearColor];
    }else{
        confirmButton =[UIButton buttonWithType:UIButtonTypeCustom];
        cannelButton =[UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    confirmButton.frame =CGRectMake(5, 285, 60, 29);
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    confirmButton.titleLabel.font =[UIFont systemFontOfSize:18.0];
    [confirmButton addTarget:self action:@selector(confirmPickView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* item1 =[[UIBarButtonItem alloc]initWithCustomView:confirmButton];
    
    
    
    cannelButton.frame=CGRectMake(5, 5, 60, 29);
    [cannelButton setTitle:@"取消" forState:UIControlStateNormal];
    cannelButton.titleLabel.font=[UIFont systemFontOfSize:18.0];
    [cannelButton addTarget:self action:@selector(pickViewHide) forControlEvents:UIControlEventTouchUpInside];
    //【李德争】2014.1.20 根据需求 不要取消按钮的边框
    //    [cannelButton setBackgroundColor:[UIColor redColor]];
    //    [cannelButton setBackgroundImage:[UIImage imageNamed:@"quxiao1.png"] forState:UIControlStateNormal];
    //    [cannelButton setBackgroundImage:[UIImage imageNamed:@"quxiao2.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithCustomView:cannelButton];
    
    
    UIBarButtonItem *spaceItem3=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //【李德争】2014.1.16 根据需求，删除取消按钮
    //    UIBarButtonItem* item2 =[[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    //
    //    [cancelBtn setTintColor:[UIColor whiteColor]];
    [items addObject:item2];
    [items addObject:spaceItem3];
    [items addObject:item1];
    if (! toolBar) {
        
        toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, pickView.frame.origin.y-44, kmainScreenWidth, 44)];
        toolBar.hidden=NO;
        toolBar.barStyle=UIBarStyleDefault;
        toolBar.items=items;
        [self.view addSubview:toolBar];
    }
}
-(void)confirmPickView{
    NSInteger provinceIndex = [pickView selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [pickView selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [pickView selectedRowInComponent: DISTRICT_COMPONENT];
    
    pIndex =provinceIndex;
    cIndex =cityIndex;
    dIndex =districtIndex;
    
    NSString *provinceStr = [provinces objectAtIndex: provinceIndex];
    NSString *cityStr = [citys objectAtIndex: cityIndex];
    NSString *districtStr = [districts objectAtIndex:districtIndex];
    
    if ([provinceStr isEqualToString: cityStr] && [cityStr isEqualToString: districtStr]) {
        cityStr = @"";
        districtStr = @"";
    }
    else if ([cityStr isEqualToString: districtStr]) {
        districtStr = @"";
    }
    //修复黑龙江  哈尔滨市 区bug
    if (provinceIndex ==9 && cityIndex ==0 && districtIndex ==0) {
        districtStr =@"道里区";
    }
    if (provinceIndex ==9 && cityIndex ==0 && districtIndex ==1) {
        districtStr =@"南岗区";
    }
    if (provinceIndex ==4 && cityIndex ==4 && districtIndex ==2) {
        districtStr =@"邢台县";
    }
    if (!getAdress) {
        getAdress = [NSString stringWithFormat: @"%@%@%@", provinceStr, cityStr, districtStr];
        
    }else{
        getAdress=[NSString stringWithFormat:@"%@%@%@%@",provinceStr,cityStr,districtStr,thirdField.text];
    }
    
    area = [NSString stringWithFormat: @"%@,%@,%@", provinceStr, cityStr, districtStr];
    secondField.text =area;
    [thirdField becomeFirstResponder];
    [toolBar removeFromSuperview];
    toolBar =nil;
    [pickView removeFromSuperview];
    pickView =nil;
    [self getAreaData];
}
-(void)pickViewHide{
    isCancel =1;
    
    [pickView removeFromSuperview];
    pickView =nil;
    [toolBar removeFromSuperview];
    toolBar =nil;
    
    [self getAreaData];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == PROVINCE_COMPONENT) {
        return [provinces count];
    }else if (component == CITY_COMPONENT){
        return citys.count;
    }else{
        return districts.count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == PROVINCE_COMPONENT) {
        return [provinces objectAtIndex:row];
    }else if (component == CITY_COMPONENT){
        return [citys objectAtIndex:row];
    }else{
        return [districts objectAtIndex:row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component ==PROVINCE_COMPONENT) {
        selectedPro=[provinces objectAtIndex:row];
        NSDictionary* temp=[NSDictionary dictionaryWithDictionary:[areaDic objectForKey:[NSString stringWithFormat:@"%d",row]]];
        NSDictionary* dic=[NSDictionary dictionaryWithDictionary:[temp objectForKey:selectedPro]];
        NSArray* cityArray=[dic allKeys];
        NSArray* sortedArray=[cityArray sortedArrayUsingComparator:^(id obj1, id obj2){
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        citys = [[NSArray alloc] initWithArray: array];
        
        NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        districts = [[NSArray alloc] initWithArray: [cityDic objectForKey: [citys objectAtIndex: 0]]];
        [pickerView selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [pickerView reloadComponent: CITY_COMPONENT];
        [pickerView reloadComponent: DISTRICT_COMPONENT];
        
    }
    else if (component == CITY_COMPONENT) {
        NSString *provinceIndex = [NSString stringWithFormat: @"%d", [provinces indexOfObject: selectedPro]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedPro]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        
        
        districts = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        [pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [pickerView reloadComponent: DISTRICT_COMPONENT];
    }
    
}


-(void)onClickBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onClickedExchangeGoods{
    
    DidRewardView* view=[[DidRewardView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
    view.isAdress=YES;
    view.type =102;
    
    view.phoneNumber=fourField.text;
    view.JDs =self.beanCount;
    
    view.goodsName =self.good.introduce;
    view.area =secondField.text;
    view.adress =thirdField.text;
    view.goods =self.good;
    view.name = topField.text;
    
    //    [view setBasicView];
    
    BOOL b4=fourField.text.length==11 && [self isPureInt:fourField.text];
    
    BOOL b3 =[thirdField.text isEqualToString:@""];
    
    //    BOOL b2 =[secondField.text isEqualToString:@"所在地区"];
    BOOL b2 =[area isEqualToString:@""];
    BOOL b1 =[topField.text isEqualToString:@""];
    if (b1==1 && b2==0 && b3==0 && b4==1) {
        [StatusBar showTipMessageWithStatus:@"请输入收货人姓名" andImage:[UIImage imageNamed:@"icon_no.png"]andTipIsBottom:YES];
    }else if (b1==0 && b2==1 && b3==0 && b4==1) {
        [StatusBar showTipMessageWithStatus:@"请选择收货地区" andImage:[UIImage imageNamed:@"icon_no.png"]andTipIsBottom:YES];
    }
    else if (b1==0 && b2==0 && b3==1 && b4==1) {
        [StatusBar showTipMessageWithStatus:@"请输入收货详细地址" andImage:[UIImage imageNamed:@"icon_no.png"]andTipIsBottom:YES];
    }
    else if (b1==0 && b2==0 && b3==0 && b4==0) {
        [StatusBar showTipMessageWithStatus:@"请输入正确的手机号" andImage:[UIImage imageNamed:@"icon_no.png"]andTipIsBottom:YES];
    }
    else{
        if (b1==0 && b2==0 && b3==0 && b4==1) {
            view.area =[view.area stringByReplacingOccurrencesOfString:@"," withString:@""];
            [view setBasicView];
            [self.view addSubview:view];
        }else{
            [StatusBar showTipMessageWithStatus:@"请填写完整收货信息" andImage:[UIImage imageNamed:@"icon_no.png"]andTipIsBottom:YES];
        }
    }
    [topField resignFirstResponder];
    [thirdField resignFirstResponder];
    [fourField resignFirstResponder];
    if (pickView) {
        [pickView removeFromSuperview];
        pickView =nil;
    }
    if (toolBar) {
        [toolBar removeFromSuperview];
        toolBar =nil;
    }
    
}

-(BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
-(void)didRewardGoodsPopView{
    NSUserDefaults* ud =[NSUserDefaults standardUserDefaults];
    [ud setObject:topField.text forKey:@"UserRewardName"];
    [ud setObject:secondField.text forKey:@"UserRewardArea"];
    [ud setObject:thirdField.text forKey:@"UserRewardAdress"];
    [ud setObject:fourField.text forKey:@"UserRewardPhoneNumber"];
    
    [ud setObject:[NSNumber numberWithInt:pIndex] forKey:@"proIndex"];
    [ud setObject:[NSNumber numberWithInt:cIndex] forKey:@"cityIndex"];
    [ud setObject:[NSNumber numberWithInt:dIndex] forKey:@"disIndex"];
    
    [ud synchronize];
    // 直接用RewardListViewController 的navigation 跳转  ios7 返回不了
    //    GoodsDetailsController* goodDetails =[[GoodsDetailsController alloc]initWithNibName:nil bundle:nil];
    RewardListViewController* re =[[RewardListViewController alloc]initWithNibName:nil bundle:nil];
    re.isRootPush =YES;
    NSLog(@"  Post VC");
    //    [goodDetails.navigationController pushViewController:re animated:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
