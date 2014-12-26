//
//  LLUserCenterCell.m
//  乐享WiFi
//
//  Created by keyrun on 14-10-14.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LLUserCenterCell.h"
#import "LLCenterItem.h"
#import "TaoJinButton.h"
#import "SDImageView+SDWebCache.h"
#import "MyUserDefault.h"
#import "UIImage+ColorChangeTo.h"
#define kHeadImageOffX      20.0f
#define kHeadImageOffY      40.0f
#define kHeadImageSize      90.0f
#define kFlowTextOffY       73.0f
#define kHeadHeight         100.0f
#define kItemTextOffY   70.0f
#define kItemTextSize   16.0f
#define kItemImgOffY    18.0f
#define kItemLineW      0.5f
#define kItemIconTag     3000
#define kItemMsgTag      3100
#define kItemIncomeTag    3200
@implementation LLUserCenterCell
{
    UIImageView *_headImage ;
    TaoJinLabel *_flowNumLab ;
    TaoJinLabel *_flowCountLab ;
    UIImageView *_itemHotImg ;
    UILabel *_oneLab;
    
}
@synthesize nameOne =_nameOne ;
@synthesize nameTwo =_nameTwo;
@synthesize nameThree =_nameThree ;
@synthesize oneLab =_oneLab;
@synthesize twoImg = _twoImg;
@synthesize threeImg =_threeImg;
@synthesize twoLab =_twoLab ;
@synthesize threeLab =_threeLab;
@synthesize oneImg =_oneImg ;
@synthesize oneBtn =_oneBtn ;
@synthesize twoBtn =_twoBtn ;
@synthesize threeBtn =_threeBtn ;
@synthesize msgLab = _msgLab ;
@synthesize itemHotImg =_itemHotImg;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundView = nil ;
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        _msgLab = [self loadLabWithFrame:CGRectZero name:@"" withColor:kRedTextColor];
        _itemHotImg = [self loadImageViewFrame:CGRectZero andImage:nil];
//        _oneLab = [self loadLabWithFrame:CGRectZero name:nil withColor:kWitheColor];
        
       /*
        _twoLab = [self loadLabWithFrame:CGRectZero name:nil withColor:kWitheColor];
        _threeLab = [self loadLabWithFrame:CGRectZero name:nil withColor:kWitheColor];
        
        _oneImg = [[UIImageView alloc]init];
        _twoImg = [[UIImageView alloc]init];
        _threeImg = [[UIImageView alloc]init];
        
        _oneBtn = [self loadBtnWithFrame:CGRectMake(0, 0, kmainScreenWidth/3, kmainScreenWidth/3)];
        _oneBtn.tag = 100 ;
        _twoBtn = [self loadBtnWithFrame:CGRectMake(kmainScreenWidth/3, 0, kmainScreenWidth/3, kmainScreenWidth/3)];
        _twoBtn.tag = 101 ;
        _threeBtn = [self loadBtnWithFrame:CGRectMake(kmainScreenWidth /3 *2, 0, kmainScreenWidth/3, kmainScreenWidth/3)];
        _threeBtn.tag = 102 ;
       
        
        [self.contentView addSubview:_twoLab];
        [self addSubview:_threeLab];
        [self addSubview:_oneImg];
        [self addSubview:_twoImg];
        [self addSubview:_threeImg];
       */

    }
    return self;
}
-(void) onclickedSetting {
    _copyBlock() ;
}
-(void)loadCellHeadViewWith:(NSString *)userFlows andFlowNum:(NSString *)number withBlock:(UserHeadCellBlock)block{
    self.backgroundView =[[UIView alloc] init];
    self.backgroundColor = kBlueTextColor ;
    if (kDeviceVersion <7.0) {
        self.contentView.backgroundColor = kBlueTextColor;
    }
    
    _copyBlock = [block copy];
    float bterH = kBatterHeight;
    _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(kHeadImageOffX, kHeadImageOffY -bterH, kHeadImageSize, kHeadImageSize)];
    _headImage.image = GetImageWithName(@"usertx");
    _headImage.layer.masksToBounds =YES;
    _headImage.layer.cornerRadius = kHeadImageSize /2 ;
    
    UIImage *cameraImg = GetImage(@"camera");
    UIImageView *cameraView =[[UIImageView alloc] initWithImage:cameraImg];
    cameraView.frame =CGRectMake(_headImage.frame.origin.x +(_headImage.frame.size.width/2- cameraImg.size.width/2), 70.0f+_headImage.frame.origin.y, cameraImg.size.width, cameraImg.size.height);
    
    UIImage *setimage = GetImageWithName(@"settingicon");
    float settingOffy = 32.0f -bterH;
    TaoJinButton *setting = [[TaoJinButton alloc] initWithFrame:CGRectMake(kmainScreenWidth -12.0f -setimage.size.width-5.0f, settingOffy-5.0f, setimage.size.width+10.0f, setimage.size.height+10.0f) titleStr:nil titleColor:nil font:nil logoImg:setimage backgroundImg:nil];
    [setting setImage:[setimage imageByApplyingAlpha:0.5f] forState:UIControlStateHighlighted];
    [setting addTarget:self action:@selector(onclickedSetting) forControlEvents:UIControlEventTouchUpInside];
    
    TaoJinButton *imgBtn =[[TaoJinButton alloc] initWithFrame:_headImage.frame titleStr:nil titleColor:nil font:nil logoImg:nil backgroundImg:nil];
    imgBtn.layer.masksToBounds = YES;
    imgBtn.layer.cornerRadius = imgBtn.frame.size.width/2 ;
    [imgBtn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *BGView =[[UIView alloc] initWithFrame:CGRectMake(kHeadImageOffX -2, kHeadImageOffY-2 -bterH, kHeadImageSize +4, kHeadImageSize +4)];
    BGView.backgroundColor = kWitheColor ;
    BGView.layer.cornerRadius = BGView.frame.size.width /2 ;
    [self.contentView addSubview:BGView];
    
    _flowNumLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(_headImage.frame.origin.x +_headImage.frame.size.width + 12.0f, kFlowTextOffY -bterH, kmainScreenWidth -_headImage.frame.origin.x-_headImage.frame.size.width -12.0f, 16) text:[NSString stringWithFormat:@"流量号：%@",[[MyUserDefault standardUserDefaults] getUserId]] font:kFontSize_16 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft numberLines:1];
    
    _flowCountLab =[[TaoJinLabel alloc]initWithFrame:CGRectMake(_flowNumLab.frame.origin.x, _flowNumLab.frame.origin.y +_flowNumLab.frame.size.height + 7.0f, _flowNumLab.frame.size.width, 20.0f) text:[NSString stringWithFormat:@"您共有%@流量币",[[MyUserDefault standardUserDefaults]getUserBeanNum]] font:kFontSize_16 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft numberLines:1];
    NSMutableAttributedString *attString =[[NSMutableAttributedString alloc] initWithString:_flowCountLab.text];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0, 3)];
    [attString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18.0] range:NSMakeRange(3, userFlows.length)];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(3+ userFlows.length , 3)];
    [attString addAttribute:NSForegroundColorAttributeName value:kWitheColor range:NSMakeRange(0, userFlows.length +6)];
    _flowCountLab.attributedText =attString;
    
    if ([UIScreen mainScreen].scale == 3) {
        _headImage.frame = CGRectMake(kHeadImageOffX, kHeadImageOffY -bterH +25.0f, kHeadImageSize, kHeadImageSize);
        cameraView.frame =CGRectMake(_headImage.frame.origin.x +(_headImage.frame.size.width/2- cameraImg.size.width/2), 70.0f+_headImage.frame.origin.y, cameraImg.size.width, cameraImg.size.height);
        imgBtn.frame = _headImage.frame ;
        BGView.frame = CGRectMake(kHeadImageOffX -2, kHeadImageOffY-2 -bterH +25.0f, kHeadImageSize +4, kHeadImageSize +4);
        _flowNumLab.frame = CGRectMake(_headImage.frame.origin.x +_headImage.frame.size.width + 12.0f, kFlowTextOffY -bterH +25.0f, kmainScreenWidth -_headImage.frame.origin.x-_headImage.frame.size.width -12.0f, 16);
        _flowCountLab.frame = CGRectMake(_flowNumLab.frame.origin.x, _flowNumLab.frame.origin.y +_flowNumLab.frame.size.height + 7.0f, _flowNumLab.frame.size.width, 20.0f);
    }
    
    [self.contentView addSubview:_headImage];
    [self.contentView addSubview:imgBtn];
    [self.contentView addSubview:setting];
    [self.contentView addSubview:_flowCountLab];
    [self.contentView addSubview:_flowNumLab];
    [self.contentView addSubview:cameraView];
}
-(UIImageView *)loadImageViewFrame:(CGRect)rect andImage:(UIImage *)image {
    UIImageView *img =[[UIImageView alloc] initWithImage:image];
    img.frame = rect;
    return img;
}
-(void)loadSubCellWithTitle:(NSArray *)titles andImgae:(NSArray *)images {
    self.backgroundColor =[UIColor whiteColor];
    float itemSize = kmainScreenWidth / 3;
    if (images.count >0) {
        UIImage *image =[images objectAtIndex:0];
        _oneImg =[self loadImageViewFrame:CGRectMake((kmainScreenWidth/3 - image.size.width) /2 + kmainScreenWidth/3 *0, kItemImgOffY, image.size.width, image.size.height) andImage:image];
        _twoImg =[self loadImageViewFrame:CGRectMake((kmainScreenWidth/3 - image.size.width) /2 + kmainScreenWidth/3 *1, kItemImgOffY, image.size.width, image.size.height) andImage:[images objectAtIndex:1]];
        _threeImg =[self loadImageViewFrame:CGRectMake((kmainScreenWidth/3 - image.size.width) /2 + kmainScreenWidth/3 *2, kItemImgOffY, image.size.width, image.size.height) andImage:[images objectAtIndex:2]];
        _oneBtn = [self loadBtnWithFrame:CGRectMake(kmainScreenWidth/3 *0, 0, itemSize, itemSize)];
        _oneBtn.tag = 100;
        _twoBtn = [self loadBtnWithFrame:CGRectMake(kmainScreenWidth/3 *1, 0, itemSize, itemSize)];
        _twoBtn.tag = 101;
        _threeBtn = [self loadBtnWithFrame:CGRectMake(kmainScreenWidth/3 *2, 0, itemSize, itemSize)];
        _threeBtn.tag =102 ;
        
        _nameOne = [self loadLabWithFrame:CGRectMake(kmainScreenWidth/3 *0, _oneImg.frame.origin.y +_oneImg.frame.size.height +5.0f, kmainScreenWidth/3, kItemTextSize) name:[titles objectAtIndex:0] withColor:[UIColor blackColor]];
        _nameTwo = [self loadLabWithFrame:CGRectMake(kmainScreenWidth/3 *1, _twoImg.frame.origin.y +_twoImg.frame.size.height +5.0f, kmainScreenWidth/3, kItemTextSize) name:[titles objectAtIndex:1] withColor:[UIColor blackColor]];
        _nameThree = [self loadLabWithFrame:CGRectMake(kmainScreenWidth/3 *2, _threeImg.frame.origin.y +_threeImg.frame.size.height +5.0f, kmainScreenWidth/3, kItemTextSize) name:[titles objectAtIndex:2] withColor:[UIColor blackColor]];
        
        _oneLab = [self loadLabWithFrame:CGRectMake(kmainScreenWidth/3 *0, _nameOne.frame.origin.y+ _nameOne.frame.size.height , kmainScreenWidth /3, kItemTextSize) name:@"" withColor:[UIColor orangeColor]];
        _twoLab = [self loadLabWithFrame:CGRectMake(kmainScreenWidth/3 *1, _nameTwo.frame.origin.y+ _nameTwo.frame.size.height , kmainScreenWidth /3, kItemTextSize) name:@"" withColor:[UIColor orangeColor]];
        _threeLab = [self loadLabWithFrame:CGRectMake(kmainScreenWidth/3 *2, _nameThree.frame.origin.y+ _nameThree.frame.size.height , kmainScreenWidth /3, kItemTextSize) name:@"" withColor:[UIColor orangeColor]];
        _oneLab.font = GetBoldFont(16);
        _twoLab.font = GetBoldFont(16);
        _threeLab.font = GetBoldFont(16);
        
        _msgLab.frame =CGRectMake(_threeImg.frame.origin.x, _threeImg.frame.origin.y +(_threeImg.frame.size.height -13.0f)/2 -2.0f, _threeImg.frame.size.width, 13.0f);
        _msgLab.font = GetFont(13.0f);
        
        if (self.indexRow ==2) {
            UIImage *hotImg = GetImage(@"HOT");
            _itemHotImg.frame = CGRectMake(1* kmainScreenWidth/3, 0, hotImg.size.width, hotImg.size.height);
            _itemHotImg.image =hotImg ;
        }
        
        [self.contentView addSubview:_oneBtn];
        [self.contentView addSubview:_twoBtn];
        [self.contentView addSubview:_threeBtn];
        [self.contentView addSubview:_oneImg];
        [self.contentView addSubview:_twoImg];
        [self.contentView addSubview:_threeImg];
        [self.contentView addSubview:_nameOne];
        [self.contentView addSubview:_nameTwo];
        [self.contentView addSubview:_nameThree];
        [self.contentView addSubview:_oneLab];
        [self.contentView addSubview:_twoLab];
        [self.contentView addSubview:_threeLab];
        [self.contentView addSubview:_msgLab];
        [self.contentView addSubview:_itemHotImg];

    }
    CALayer *rightLine = [self loadLayerWithFrame:CGRectMake(kmainScreenWidth/3  -kItemLineW, 0, kItemLineW, kmainScreenWidth/3)];
    CALayer *rightLine2 = [self loadLayerWithFrame:CGRectMake(kmainScreenWidth/3*2  -kItemLineW, 0, kItemLineW, kmainScreenWidth/3)];
    CALayer *bottomLine = [self loadLayerWithFrame:CGRectMake(0, kmainScreenWidth/3 -kItemLineW, kmainScreenWidth, kItemLineW)];
    [self.contentView.layer addSublayer:rightLine];
    [self.contentView.layer addSublayer:rightLine2];
    [self.contentView.layer addSublayer:bottomLine];

    
    /*
    for (int i= 0; i < titles.count; i++) {
        
     
        UIImageView* _itemImg = [[UIImageView alloc] initWithImage:image];
        _itemImg.tag = kItemIconTag +i;
        _itemImg.frame = CGRectMake((kmainScreenWidth/3 - image.size.width) /2 + kmainScreenWidth/3 *i, kItemImgOffY, image.size.width, image.size.height);
        
        UILabel* _itemNameLab = [self loadLabWithFrame:CGRectMake(kmainScreenWidth/3 *i, _itemImg.frame.origin.y +_itemImg.frame.size.height +5.0f, kmainScreenWidth/3, kItemTextSize) name:[titles objectAtIndex:i] withColor:[UIColor blackColor]];
        
        UILabel* _itemIcomLab = [self loadLabWithFrame:CGRectMake(kmainScreenWidth/3 *i, _itemNameLab.frame.origin.y+ _itemNameLab.frame.size.height , kmainScreenWidth /3, kItemTextSize) name:@"" withColor:[UIColor orangeColor]];
        _itemIcomLab.font = GetBoldFont(16);
        _itemIcomLab.tag = kItemIncomeTag +i;
        _itemIcomLab.hidden = YES;
        
        UILabel* _itemMsgLab = [self loadLabWithFrame:CGRectMake(_itemImg.frame.origin.x, _itemImg.frame.origin.y +(_itemImg.frame.size.height -13.0f)/2 -2.0f, _itemImg.frame.size.width, 13.0f) name:@"" withColor:[UIColor redColor]];
        _itemMsgLab.font = GetFont(13.0f);
        _itemMsgLab.tag = kItemMsgTag +i ;
        _itemMsgLab.hidden =YES;
        
        UIImage *hotImg = GetImage(@"HOT");
        _itemHotImg = [[UIImageView alloc] initWithFrame:CGRectMake(i* kmainScreenWidth/3, 0, hotImg.size.width, hotImg.size.height)];
        _itemHotImg.image = hotImg ;
        _itemHotImg.hidden =YES;
        
        if (i ==1 && self.indexRow ==2) {
            _itemHotImg.hidden = NO;
        }
        // 大小根据手机尺寸变
        
        CALayer *rightLine = [self loadLayerWithFrame:CGRectMake(kmainScreenWidth/3 *i -kItemLineW, 0, kItemLineW, kmainScreenWidth/3)];
        CALayer *bottomLine = [self loadLayerWithFrame:CGRectMake(kmainScreenWidth/3 *i, kmainScreenWidth/3 -kItemLineW, kmainScreenWidth/3, kItemLineW)];
        
        UIButton *_itemBtn =[self loadBtnWithFrame:CGRectMake(kmainScreenWidth/3 *i, 0, itemSize, itemSize)];
        _itemBtn.tag = 100 + i ;
        _itemBtn.userInteractionEnabled = YES;
        
        [self.contentView addSubview:_itemBtn];
        [self.contentView addSubview:_itemIcomLab];
        [self.contentView addSubview:_itemImg];
        [self.contentView addSubview:_itemMsgLab];

        [self.contentView addSubview:_itemNameLab];
        [self.contentView addSubview:_itemHotImg];
        [self.layer addSublayer:rightLine];
        [self.layer addSublayer:bottomLine];
        
        if (i ==0 ) {
            _oneLab.frame = CGRectMake(kmainScreenWidth/3 *i, _itemNameLab.frame.origin.y+ _itemNameLab.frame.size.height , kmainScreenWidth /3, kItemTextSize);
            _oneLab.font = GetBoldFont(16);
            _oneLab.tag = kItemIncomeTag +i;
            [self.contentView addSubview:_oneLab];
        }
        
        
    }
    */
    
}
-(void)loadSubcellWithTitles:(NSArray *)titles andImages:(NSArray *)images andType:(int) type {
    self.oneLab.text = [titles objectAtIndex:0];
    self.oneLab.frame = CGRectMake(kmainScreenWidth/3 *0, kItemTextOffY, kmainScreenWidth/3, kItemTextSize);
    _twoLab.text = [titles objectAtIndex:1];
    _twoLab.frame = CGRectMake(kmainScreenWidth/3 , kItemTextOffY, kmainScreenWidth/3, kItemTextSize);
    _threeLab.text = [titles objectAtIndex:2];
    _threeLab.frame = CGRectMake(kmainScreenWidth/3 *2 , kItemTextOffY, kmainScreenWidth/3, kItemTextSize);
    
    UIImage *image = [images objectAtIndex:0];
    _oneImg.image =image;
    _oneImg.frame = CGRectMake((kmainScreenWidth/3 - image.size.width) /2 + kmainScreenWidth/3 *0, 0, image.size.width, image.size.height);
    
    UIImage *image2 = [images objectAtIndex:1];
    _twoImg.image =image2;
    _twoImg.frame = CGRectMake((kmainScreenWidth/3 - image2.size.width) /2 + kmainScreenWidth/3 *0, 0, image2.size.width, image2.size.height);
    UIImage *image3 = [images objectAtIndex:2];
    _threeImg.image =image3;
    _threeImg.frame = CGRectMake((kmainScreenWidth/3 - image3.size.width) /2 + kmainScreenWidth/3 *0, 0, image3.size.width, image3.size.height);
    
}
-(CALayer *)loadLayerWithFrame:(CGRect)frame{
    CALayer *layer = [CALayer layer];
    [layer setBackgroundColor:[kLineColor2_0 CGColor]];
    [layer setFrame:frame];
    return layer;
}
-(UIButton *)loadBtnWithFrame:(CGRect)frame {
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =frame;
    [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(revertColor:) forControlEvents:UIControlEventTouchUpOutside];
    [btn addTarget:self action:@selector(revertColor:) forControlEvents:UIControlEventTouchCancel];
    return btn;
}
-(void)onClickBtn:(UIButton *)btn{
    btn.backgroundColor = [UIColor clearColor];
    [self.delegate onClickBtn:btn andIndexRow: self.indexRow];
    
}
-(void)changeColor:(UIButton* )btn{
    btn.backgroundColor = ColorRGB(246.0, 246.0, 246.0, 1.0);
}
-(void)revertColor:(UIButton* )btn{
    btn.backgroundColor =[UIColor clearColor];
}

-(UILabel *)loadLabWithFrame:(CGRect)frame name:(NSString *)name withColor:(UIColor *)color{
    UILabel *lab =[[UILabel alloc]initWithFrame:frame];
    lab.backgroundColor = [UIColor clearColor];
    lab.textAlignment = NSTextAlignmentCenter ;
    lab.textColor = color;
    lab.font = GetFont(13.0f) ;
    lab.text = name ;
    return lab ;
}
-(void) changeIncomeLab:(NSString *)incomeCount type:(int)type{
    UIColor *color = type ==1 ? KOrangeColor2_0 :kBlueTextColor ;
    
//    [(UILabel *)[self.contentView viewWithTag:kItemIncomeTag ] setText:incomeCount];
//    [(UILabel *)[self.contentView viewWithTag:kItemIncomeTag ] setHidden:NO];
//    [(UILabel *)[self.contentView viewWithTag:kItemIncomeTag ] setTextColor:color];
    [_oneLab setText:incomeCount];
    [_oneLab setTextColor:color];
    [_oneLab setHidden:NO];
}
-(void) changeMsgLab:(NSString *)msgCount {


    [_msgLab setText:msgCount];
    [_msgLab setHidden:NO];
    if (msgCount.length >0) {
        [_threeImg setImage:GetImage(@"icon_3_2")];
        [_msgLab setTextColor:kWitheColor];
    }else{
        [_threeImg setImage: GetImage(@"icon_3_1")];
    }
}
-(void)changeUserCoin:(NSString *)coins {
    _flowCountLab.text =[NSString stringWithFormat:@"您共有%@流量币",coins] ;
    NSMutableAttributedString *attString =[[NSMutableAttributedString alloc] initWithString:_flowCountLab.text];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0, 3)];
    [attString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18.0] range:NSMakeRange(3, coins.length)];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(3+ coins.length , 3)];
    [attString addAttribute:NSForegroundColorAttributeName value:kWitheColor range:NSMakeRange(0, coins.length +6)];
    _flowCountLab.attributedText =attString;

}
-(void)changeUserIcon:(NSString *)iconUrl{
    [_headImage setImageWithURL:[NSURL URLWithString:iconUrl] refreshCache:NO needSetViewContentMode:false needBgColor:false placeholderImage:GetImage(@"usertx")];
}
-(void)changeUserNumber:(NSString *)number{
    [_flowNumLab setText:[NSString stringWithFormat:@"流量号：%@",number]];
}
-(void)prepareForReuse{
    
}
@end
