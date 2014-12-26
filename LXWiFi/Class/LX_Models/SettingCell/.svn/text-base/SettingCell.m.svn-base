//
//  SettingCell.m
//  免费流量王
//
//  Created by keyrun on 14-10-20.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "SettingCell.h"
#import "UIImage+ColorChangeTo.h"
#define kSettingNextSize   14.0f
#define kSettingCheckSize      24.0f
#define kSettingCellH          52.0f
#define kSettingCellTipW        60.0f
#define kSettingCellTipH        15.0f
@implementation SettingCell
@synthesize cellCheckBtn = _cellCheckBtn ;
@synthesize cellTitle = _cellTitle ;
@synthesize cellNextImg = _cellNextImg ;
@synthesize cellTip = _cellTip ;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellNextImg = [[UIImageView alloc] initWithImage:nil];
        _cellNextImg.frame = CGRectMake(kmainScreenWidth -kOffX_2_0 -kSettingNextSize, kSettingCellH/2 -kSettingNextSize/2, kSettingNextSize, kSettingNextSize);
        
        topLayer =[[UIView alloc]init];
        topLayer.backgroundColor = kLineColor2_0 ;
        topLayer.frame = CGRectMake(0, 0, kmainScreenWidth, LineWidth);
        
        bottomLayer =[[UIView alloc]init];
        bottomLayer.backgroundColor = kLineColor2_0 ;
        bottomLayer.frame = CGRectMake(0, kSettingCellH -LineWidth, kmainScreenWidth, LineWidth);
        
        _cellTitle =[[TaoJinLabel alloc] initWithFrame:CGRectMake(kOffX_2_0, 0, kmainScreenWidth, 16.0) text:nil font:GetFont(16.0) textColor:kBlackTextColor textAlignment:NSTextAlignmentLeft numberLines:1];
        
        _cellCheckBtn = [[TaoJinButton alloc] initWithFrame:CGRectMake(kmainScreenWidth -kSettingCheckSize- kOffX_2_0, kSettingCellH/2 -kSettingCheckSize/2, kSettingCheckSize, kSettingCheckSize) titleStr:nil titleColor:nil font:nil logoImg:nil backgroundImg:[UIImage createImageWithColor:kBlueTextColor]];
        _cellCheckBtn.layer.masksToBounds = YES;
        _cellCheckBtn.layer.cornerRadius = kSettingCheckSize/2 ;
        
        _cellTip = [[TaoJinLabel alloc] initWithFrame:CGRectMake(_cellNextImg.frame.origin.x -kOffX_2_0 -kSettingCellTipW, kSettingCellH/2 -kSettingCellTipH/2, kSettingCellTipW, kSettingCellTipH) text:@"有新版本" font:GetFont(11.0) textColor:kWitheColor textAlignment:NSTextAlignmentCenter numberLines:1];
        _cellTip.backgroundColor = kRedTextColor ;
        _cellTip.layer.cornerRadius = _cellTip.frame.size.height/2 ;
        _cellTip.layer.masksToBounds = YES ;
        _cellTip.hidden = YES;

        self.selectedBackgroundView =[[UIView alloc] initWithFrame:CGRectMake(0, 5, kmainScreenWidth, kSettingCellH- 5)];
        self.selectedBackgroundView.backgroundColor = ColorRGB(250.0, 250.0, 250.0, 1.0);
//        self.backgroundColor = ColorRGB(250.0, 250.0, 250.0, 1.0) ;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
        [self.contentView addSubview:_cellTitle];
        [self.contentView addSubview:_cellCheckBtn];
        [self.contentView addSubview:_cellNextImg];
        [self.contentView addSubview:_cellTip];
        [self.contentView addSubview:topLayer];
        [self.contentView addSubview:bottomLayer];

    }
    return self ;
}
-(void) loadSettingCellViewWithTitle:(NSString *)title isFirstRow:(BOOL) isFirst{
    _cellTitle.text = title ;
    [_cellTitle sizeToFit];
    _cellTitle.frame = CGRectMake(kOffX_2_0, kSettingCellH/2 -_cellTitle.frame.size.height/2, _cellTitle.frame.size.width, _cellTitle.frame.size.height);
    
    if (isFirst) {
        topLayer.hidden = NO;
    }else{
        topLayer.hidden = YES;
    }
    
}
@end
