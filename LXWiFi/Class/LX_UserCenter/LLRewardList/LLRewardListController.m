//
//  LLRewardListController.m
//  免费流量王
//
//  Created by keyrun on 14-10-15.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LLRewardListController.h"
#import "HeadToolBar.h"
#import "MyUserDefault.h"
#import "ButtonRowView.h"
#import "ExchangePViewController.h"
#import "ExchangeQViewController.h"
#import "RewardGoodsView.h"
#import "SDImageView+SDWebCache.h"
#import "GoodsDetailsController.h"
@interface LLRewardListController ()
{
    HeadToolBar *headBar ;
    ButtonRowView *buttonRowView ;
    UITableView *goodsContent ;
    NSMutableArray *temporaryAllGoodsAry;
    UILabel *userBeanLab ;
    UIImageView* coinImage;
}
@end

@implementation LLRewardListController
@synthesize allGoodsAry = _allGoodsAry ;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWitheColor ;
    
    NSNumber *jdCount;
    if ([[MyUserDefault standardUserDefaults] getUserBeanNum]) {
        jdCount =[[MyUserDefault standardUserDefaults] getUserBeanNum];
    }else{
        jdCount =[NSNumber numberWithInt:0];
    }

    headBar =[[HeadToolBar alloc]initWithTitle:@"奖品兑换" leftBtnTitle:@"" leftBtnImg:GetImageWithName(@"back") leftBtnHighlightedImg:GetImageWithName(@"") rightLabTitle:jdCount backgroundColor:kBlueTextColor];
    [headBar.leftBtn addTarget:self action:@selector(goBackVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];

    [self initRewardTypeView];
    [self setRewardGoodsContentView];
}

-(void)setRewardGoodsContentView{
    goodsContent = [[UITableView alloc]initWithFrame:CGRectMake(0, buttonRowView.frame.origin.y + buttonRowView.frame.size.height ,kmainScreenWidth , kmainScreenHeigh- kfootViewHeigh - buttonRowView.frame.origin.y - buttonRowView.frame.size.height - (kBatterHeight)) style:UITableViewStylePlain];
    [goodsContent setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    goodsContent.delegate = self;
    goodsContent.dataSource = self;
    goodsContent.backgroundColor = [UIColor clearColor];
    
//    TablePullToLoadingView *loadingView = [[TablePullToLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, kTableLoadingViewHeight2_0)];
//    goodsContent.tableFooterView = loadingView;
//    goodsContent.tableFooterView.hidden = YES;
    
    
    [self.view addSubview:goodsContent];
}


-(void)initRewardTypeView {
    NSArray *imgAry = @[@"icon_qcoin.png",@"icon_hf.png",@"icon_zfb.png"];
    NSArray *titleAry = @[@"现金兑换",@"Q币兑换",@"话费兑换"];
    NSArray *colorAry = @[kBlueTextColor, KOrangeColor2_0, KPurpleColor2_0];
    
    buttonRowView = [[ButtonRowView alloc] initWithFrame:CGRectMake(0.0f, headBar.frame.size.height, kmainScreenWidth, 0.0f) imgAry:imgAry titleAry:titleAry colorAry:colorAry btnAction:^(UIButton *button) {
        [self onClickRewardButton:button];
    }];

    [self.view addSubview:buttonRowView];
}
-(void)onClickRewardButton:(UIButton *)btn{
    UINavigationController* nc=(UINavigationController* )[UIApplication sharedApplication].keyWindow.rootViewController;
    switch (btn.tag) {
            //兑换成Q币
        case 1:
        {
            ExchangeQViewController *exQ = [[ExchangeQViewController alloc]initWithNibName:nil bundle:nil];
            [nc pushViewController:exQ animated:YES];
        }
            break;
            //兑换成手机话费
        case 2:
        {
            ExchangePViewController *exP = [[ExchangePViewController alloc] initWithNibName:nil bundle:nil tag:1];
            exP.isRecharge = NO;
            [nc pushViewController:exP animated:YES];
        }
            break;
        case 3:
        {
            ExchangePViewController *exP = [[ExchangePViewController alloc] initWithNibName:nil bundle:nil tag:2];
            exP.isRecharge = YES;
            exP.rechargeType = @"支付宝";
            [nc pushViewController:exP animated:YES];
        }
            break;
        default:
            break;
    }

}
-(void)goBackVC{
    [self.navigationController popViewControllerAnimated:YES];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 143.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (temporaryAllGoodsAry.count%2 == 1)
        return temporaryAllGoodsAry.count/2+1;
    
    return temporaryAllGoodsAry.count/2;
}

//初始化奖品列表
-(void)initWithCell:(RewardGoodsView *)cell allGoods:(NSArray *)allGoods indexPath:(NSIndexPath *)indexPath{
    int leftTag = indexPath.row * 2;
    cell.leftGoods = [allGoods objectAtIndex:leftTag];
    NSURL *leftUrl = [NSURL URLWithString:cell.leftGoods.picString];
    [cell.leftImage setImageWithURL:leftUrl refreshCache:YES placeholderImage:GetImageWithName(@"pic_def.png")];
    
    if(allGoods.count % 2 == 0 || (allGoods.count % 2 == 1 && indexPath.row < allGoods.count/2)){
        cell.rightGoods = [allGoods objectAtIndex:leftTag + 1];
        cell.rightView.hidden = NO;
        NSURL *rightUrl = [NSURL URLWithString:cell.rightGoods.picString];
        [cell.rightImage setImageWithURL:rightUrl refreshCache:YES placeholderImage:GetImageWithName(@"pic_def.png")];
    }else {
        cell.rightView.hidden = YES;
    }
    
    [cell initCellContent];
    cell.leftBtn.tag = leftTag;
    [cell.leftBtn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.rightBtn.tag = leftTag + 1;
    [cell.rightBtn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IDENTIFIER = @"RewardGoodsCell";
    RewardGoodsView *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (cell == nil) {
        cell = [[RewardGoodsView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [self initWithCell:cell allGoods:temporaryAllGoodsAry indexPath:indexPath];
    
    //    for (UIView *currentView in cell.subviews)
    //    {
    //        if([currentView isKindOfClass:[UIScrollView class]])
    //        {
    //            ((UIScrollView *)currentView).delaysContentTouches = NO;
    //            break;
    //        }
    //    }
    
    return cell;
}

//点击商品，通过tag来区分点击的是左边还是右边商品,将这个对象传递过去
-(void)onClicked:(UIButton* )obj{
    UINavigationController *nc = (UINavigationController* )[UIApplication sharedApplication].keyWindow.rootViewController;
    GoodsModel *goodsModel = [temporaryAllGoodsAry objectAtIndex:obj.tag];
    GoodsDetailsController *gd = [[GoodsDetailsController alloc] initWithNibName:nil bundle:nil];
    gd.goodsModel = goodsModel;
    [nc pushViewController:gd animated:YES];
}

//淘金豆的显示
-(void)initBeanCount:(NSNumber *)number{
    if (userBeanLab == nil) {
        userBeanLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 0, 14)];
        userBeanLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        userBeanLab.numberOfLines = 1;
        userBeanLab.lineBreakMode = NSLineBreakByWordWrapping;
        userBeanLab.backgroundColor = [UIColor clearColor];
        userBeanLab.text = [NSString stringWithFormat:@"%@",number];
        [userBeanLab sizeToFit];
        userBeanLab.frame = CGRectMake(10, 14, userBeanLab.frame.size.width, 14);
        userBeanLab.textColor = [UIColor whiteColor];
        //        [headBar addSubview:userBeanLab];
    }else{
        [userBeanLab setText:[NSString stringWithFormat:@"%ld",[number longValue]]];
    }
    if(coinImage == nil){
        coinImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beans_2.png"]];
        coinImage.frame = CGRectMake(userBeanLab.frame.origin.x + userBeanLab.frame.size.width+5,11 , 19, 19);
        //        [headBar addSubview:coinImage];
    }else{
        coinImage.frame = CGRectMake(userBeanLab.frame.origin.x + userBeanLab.frame.size.width+5,11 , 19, 19);
    }
}

/**
 *  转换服务器的数据为本地对象数据
 *
 *  @param arr 服务器的数据
 */
-(NSMutableArray *)reinitGoodsObject:(NSArray *)arr{
    NSMutableArray *goodsAry = [[NSMutableArray alloc] init];
    for(int i = 0 ; i < arr.count; i ++){
        GoodsModel *goodsModel = [[GoodsModel alloc] initGoodsModelByDictionary:[arr objectAtIndex:i]];
        [goodsAry addObject:goodsModel];
    }
    //    for (int i = 0; i < arr.count; i++) {
    //        NSArray* array = [arr objectAtIndex:i];
    //        for (int n = 0; n < array.count ; n++) {
    //            GoodsModel *gm = [[GoodsModel alloc]initGoodsModelByDictionary:[array objectAtIndex:n]];
    //            [goodsAry addObject:gm];
    //        }
    //    }
    return goodsAry;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float y_float = goodsContent.contentOffset.y;
    if (y_float < 0)
        return;
    
    if(_allGoodsAry.count != 0 && page != maxPage && goodsContent.tableFooterView.hidden == YES){
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        if(y > h - 1) {
            goodsContent.tableFooterView.hidden = NO;
            [self requestToGoodsAry];
        }else{
            goodsContent.tableFooterView.hidden = YES;
        }
    }else{
        goodsContent.tableFooterView.hidden =YES;
    }
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
