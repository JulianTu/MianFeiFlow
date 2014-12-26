//
//  NewUserTableCell.m
//  91TaoJin
//
//  Created by keyrun on 14-5-24.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "NewUserTableCell.h"
#import "SDImageView+SDWebCache.h"
#import "MyUserDefault.h"
#import "CButton.h"
#define kLogoSize 29.0
#define kUserTabCellH    52.0f
@implementation NewUserTableCell
{
    UIImageView *nextImage;
    UIImageView *cellImage;
    UILabel *_cellTitle;
    UIImageView *_hotImage;
    UILabel *_coinLabel;
    UIImageView *messageTip ;
    UILabel *_messageLabel;
    UIView* line;
    CALayer *layer;
    CALayer *toplayer;
}
@synthesize hotImage =_hotImage;
@synthesize messageLabel =_messageLabel;
@synthesize coinLabel =_coinLabel;
@synthesize erinnernLab =_erinnernLab;
@synthesize userJdsLab =_userJdsLab;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {


        self.backgroundColor =[UIColor clearColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
        
        toplayer =[CALayer layer];
        [toplayer setBackgroundColor:kGrayLineColor2_0.CGColor];
        toplayer.hidden = YES;
        [self.layer addSublayer:toplayer];
        
        layer =[CALayer layer];
        [layer setBackgroundColor:kGrayLineColor2_0.CGColor];
        
        [self.layer addSublayer:layer];
        
        
        _cellTitle = [self loadLabWithFrame:CGRectMake(kOffX_2_0, kUserTabCellH/2 -15, kmainScreenWidth , 30) andText:nil andTextColor:[UIColor blackColor] withFont:[UIFont systemFontOfSize:16.0]];
        [self addSubview:_cellTitle];
        
        CButton *btn =[CButton buttonWithType:UIButtonTypeCustom];
        btn.frame =CGRectMake(0, 0, kmainScreenWidth, kUserTabCellH);
        btn.backgroundColor =[UIColor clearColor];
        btn.nomalColor =[UIColor clearColor];
        btn.changeColor =ColorRGB(250.0, 250.0, 250.0, 1.0);
        [btn addTarget:self action:@selector(onClickedCell) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:btn];
        
        self.selectedBackgroundView =[[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor =ColorRGB(250.0, 250.0, 250.0, 1.0);

    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{

    [super setSelected:selected animated:animated];
    
}
-(void)onClickedCell{
    
}
-(UILabel *)loadLabWithFrame:(CGRect) frame andText:(NSString *)text andTextColor:(UIColor *)color withFont:(UIFont *)font{
    UILabel *lab =[[UILabel alloc] initWithFrame:frame];
    lab.text =text;
    lab.textColor =color;
    lab.font =font;
    lab.backgroundColor =[UIColor clearColor];
    return lab;
}
-(UIImageView *)loadImageViewWithFrame :(CGRect) frame andImage:(UIImage *)image {
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:frame];
    imageView.image =image;
    return imageView;
}
-(void)setCellViewByType:(int )type andWithImage:(UIImage*)image andCellTitle:(NSString* )title{
    [layer setFrame:CGRectMake(kOffX_2_0, kUserTabCellH -0.5, kmainScreenWidth -kOffX_2_0, 0.5)];
    if (self.isBottom == YES) {
        [layer setFrame:CGRectMake(0, kUserTabCellH -0.5, kmainScreenWidth, LineWidth)];
    }
    if (self.isHead) {
        toplayer.hidden =NO;
        [toplayer setFrame:CGRectMake(0, 0, kmainScreenWidth, LineWidth)];

    }
    
    _cellTitle.text =title ;
    
    
}
-(void)initUserCenterHeadCell{
    [layer setFrame:CGRectMake(0, 99.5, self.frame.size.width , 0.5)];
    
    _userIcon=[self loadImageViewWithFrame:CGRectMake(kOffX_2_0, kOffX_2_0, 65, 65) andImage:GetImage(@"touxiang.png")];
    
    nextImage.frame =CGRectMake(296, 44, 8, 12);
    
   
    //提示信息显示
    _erinnernLab = [self loadLabWithFrame:CGRectMake(_userIcon.frame.origin.x + _userIcon.frame.size.width + 11, _userIcon.frame.origin.y, 200, 17) andText:nil andTextColor:KGrayColor2_0 withFont:[UIFont systemFontOfSize:16.0]];
    
    //用户昵称
    UILabel *userNameLab = [self loadLabWithFrame:CGRectMake(_erinnernLab.frame.origin.x, _erinnernLab.frame.origin.y + _erinnernLab.frame.size.height +11, 180, 12) andText:[NSString stringWithFormat:@"淘金号:%@",[[MyUserDefault standardUserDefaults] getUserInvcode]] andTextColor:KGrayColor2_0 withFont:[UIFont systemFontOfSize:11.0]];
    
    //显示【金豆】文案
    UILabel *jinDouLab = [self loadLabWithFrame:CGRectMake(_erinnernLab.frame.origin.x, userNameLab.frame.origin.y + userNameLab.frame.size.height+11,36, 16) andText:@"金豆" andTextColor:KBlockColor2_0 withFont:[UIFont systemFontOfSize:16.0]];
    
    //显示金豆数量
    _userJdsLab = [self loadLabWithFrame:CGRectMake(jinDouLab.frame.origin.x+jinDouLab.frame.size.width, jinDouLab.frame.origin.y, 100, 16) andText:nil andTextColor:KOrangeColor2_0 withFont:[UIFont boldSystemFontOfSize:16.0]];
   
    [self.contentView addSubview:_userIcon];
    [self.contentView addSubview:_erinnernLab];
    [self.contentView addSubview:userNameLab];
    [self.contentView addSubview:jinDouLab];
    [self.contentView addSubview:_userJdsLab];
    self.contentView.backgroundColor =KLightGrayColor2_0;
}

//设置cell的金豆提示信息
-(void)showCellCoinDetails:(id)coin withIncomeType:(int)type{
    
    NSNumber* num =[NSNumber numberWithInt:0];
    if (_coinLabel.text) {
        _coinLabel.text=nil;
    }
    if ([coin isKindOfClass:[NSNull class]]) {
//        if (coinImage) {
//            [coinImage removeFromSuperview];
//        }
        
    }else{
        switch (type) {
                //绿色
            case 1:
            {
                if (coin == nil) {
//                    if (coinImage) {
//                        [coinImage removeFromSuperview];
//                    }
                }else{
                    _coinLabel.textColor=KGreenColor2_0;
                    if (coin ==num) {
                        
                    }else{
                        _coinLabel.text=[NSString stringWithFormat:@"%@",coin];
//                        [self insertSubview:coinImage belowSubview:nextImage];
                    }
                }
            }
                break;
                //红色
            case 2:
            {
                _coinLabel.textColor=KRedColor2_0;
                if (coin ==num) {
                    
                }else{
                    _coinLabel.text=[NSString stringWithFormat:@"+%@",coin];
//                    [self insertSubview:coinImage belowSubview:nextImage];
                }
            }
                break;
        }
    }
}
//设置cell的消息提示
-(void)showCellMessageTip:(int)number{
    if (number >0) {
        _messageLabel.text=[NSString stringWithFormat:@"%d",number];
        _messageLabel.hidden=NO;
        messageTip.hidden=NO;
    }else{
        _messageLabel.hidden=YES;
        messageTip.hidden=YES;
    }
}
-(void)setTitleLabFont:(float)size andTitleColor:(UIColor *)color{
    _cellTitle.font =[UIFont systemFontOfSize:size];
    _cellTitle.textColor =color;
}

-(void)setImageFrame:(CGRect )imageFrame andTitleFrame:(CGRect)titleFrame {
    cellImage.frame=imageFrame;
    _cellTitle.frame=titleFrame;
    
}


- (void)awakeFromNib
{
    // Initialization code
}


@end
