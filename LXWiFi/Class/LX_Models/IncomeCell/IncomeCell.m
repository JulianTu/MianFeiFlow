//
//  IncomeCell.m
//  TJiphone
//
//  Created by keyrun on 13-10-9.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "IncomeCell.h"
#import "TaoJinLabel.h"

#define kICContentOffy         12.0f
#define kICContentOffx         12.0f
#define kICValueOffy           22.0f
#define kICValuePadding        15.0f
@implementation IncomeCell{
    UIView *separentLabel;
    UIImageView *logo;
    
    TaoJinLabel *commentLab;                                        //变化的内容
    TaoJinLabel *beanValue;                                         //金豆的变化值
    TaoJinLabel *timeLab;
}

//@synthesize beanValue = _beanValue;
//@synthesize commentLab = _commentLab;
//@synthesize timeLab = _timeLab;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
/*
        //加载金豆的Logo
        logo =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beans_2.png"]];
        logo.frame =CGRectMake(296,20 , 19, 19);
        [self addSubview:logo];
  */
        //加载金豆变化值
        
        beanValue = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0, kICValueOffy, kmainScreenWidth -kICValuePadding, 14) text:@"" font:[UIFont fontWithName:@"Helvetica-Bold" size:16.0] textColor:nil textAlignment:NSTextAlignmentRight numberLines:1];
        [self addSubview:beanValue];
        
        //加载金豆变化的内容
        commentLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(kICContentOffx, kICContentOffy, kmainScreenWidth - 60.0f, 0) text:@"" font:[UIFont systemFontOfSize:16.0] textColor:kBlackTextColor textAlignment:NSTextAlignmentLeft numberLines:0];
        [self addSubview:commentLab];
        
        //加载时间
        
        timeLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(kICContentOffx, commentLab.frame.origin.y + commentLab.frame.size.height+ 7.0f, 100, 12) text:@"" font:[UIFont systemFontOfSize:11] textColor:kContentTextColor textAlignment:NSTextAlignmentLeft numberLines:1];
        [self addSubview:timeLab];
        
        separentLabel = [[UIView alloc] initWithFrame:CGRectMake(5.0f, timeLab.frame.origin.y + timeLab.frame.size.height + 15.0, kmainScreenWidth, 0.5)];
        separentLabel.backgroundColor = kGrayLineColor2_0;
        [separentLabel setAlpha:1];
        [self addSubview:separentLabel];
    }
    return self;
}

-(void)initIncomeCell{
        
    if (![self.userlog.value hasPrefix:@"-"]) {
        beanValue.textColor = KOrangeColor2_0;
        beanValue.text =[NSString stringWithFormat:@"+%@",self.userlog.value];
    }else if ([self.userlog.value hasPrefix:@"-"]){
        beanValue.textColor = kBlueTextColor;
        beanValue.text =[NSString stringWithFormat:@"%@",self.userlog.value];
    }
    
    commentLab.text = self.userlog.message;
    [commentLab sizeToFit];
    commentLab.frame = CGRectMake(commentLab.frame.origin.x, commentLab.frame.origin.y, kmainScreenWidth - 70.0f, commentLab.frame.size.height);
    
    [beanValue sizeToFit];
    beanValue.frame = CGRectMake(kmainScreenWidth - beanValue.frame.size.width - kOffX_float, 20.0f, beanValue.frame.size.width, beanValue.frame.size.height);
    
    
    logo.frame = CGRectMake(beanValue.frame.origin.x + beanValue.frame.size.width + 5.0f, beanValue.frame.origin.y - 3.0f, logo.frame.size.width, logo.frame.size.height);
    
    timeLab.text = self.userlog.time;
    [timeLab sizeToFit];
    timeLab.frame = CGRectMake(timeLab.frame.origin.x, commentLab.frame.origin.y + commentLab.frame.size.height + 5.0, timeLab.frame.size.width, timeLab.frame.size.height);
    
    separentLabel.frame = CGRectMake(separentLabel.frame.origin.x, timeLab.frame.origin.y + timeLab.frame.size.height + 15, separentLabel.frame.size.width, separentLabel.frame.size.height);
}

-(float)getIncomeCellHeight{
    float height = timeLab.frame.origin.y + timeLab.frame.size.height + 15.0f+LineWidth;
    return height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
