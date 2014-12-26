//
//  ShareMethodCell.m
//  免费流量王
//
//  Created by keyrun on 14-10-16.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "ShareMethodCell.h"
#define karrowImgSizeW     9.0f
#define karrowImgSizeH     14.0f
#define karrowOffy         25.0f
#define ktitleOffy          13.0f
#define kMCellH             65.0f
@implementation ShareMethodCell
@synthesize mContent = _mContent ;
@synthesize mTitle = _mTitle ;
@synthesize arrowImg = _arrowImg ;
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
        
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _mTitle = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 16.0) text:nil font:GetFont(16.0) textColor:kBlackTextColor textAlignment:NSTextAlignmentLeft numberLines:1];
        _mContent = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth- (3 *kOffX_2_0 +karrowImgSizeW ), 13.0) text:nil font:GetFont(13.0) textColor:kContentTextColor textAlignment:NSTextAlignmentLeft numberLines:1];
        _arrowImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        
        UIView *bgView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kMCellH)];
        bgView.backgroundColor = ColorRGB(245.0, 245.0, 245.0, 1.0) ;
        
        UIView* line = [[UIView alloc] init];
        line.frame = CGRectMake(0, kMCellH -LineWidth, kmainScreenWidth, LineWidth);
        line.backgroundColor = kLineColor2_0 ;
        
        CALayer *layer =[CALayer layer];
        layer.backgroundColor = kLineColor2_0.CGColor;
        [layer setFrame:CGRectMake(0, kMCellH -0.5, kmainScreenWidth, LineWidth)];
        
        self.selectedBackgroundView =[[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = ColorRGB(250.0, 250.0, 250.0, 1.0);
        
        [self.layer addSublayer:layer];
        [self.contentView addSubview:bgView];
        [self.contentView addSubview:_arrowImg];
        [self.contentView addSubview:_mContent];
        [self.contentView addSubview:_mTitle];
        //        [self addSubview:line];
    }
    return self;
}
-(void)loadMethodCellWith:(NSString *)title andContent:(NSString *)content withTipType:(ShareTipType)type{
    _mTitle.text = title ;
    [_mTitle sizeToFit];
    _mTitle.frame = CGRectMake(kOffX_2_0, ktitleOffy, _mTitle.frame.size.width, _mTitle.frame.size.height);
    
    if (type != ShareTipTypeNo) {
        UIImage *tipImage ;
        tipImage = type == ShareTipTypeHot ? GetImage(@"tip_hot") :GetImage(@"tip_new");
        _arrowImg.image =tipImage ;
        _arrowImg.frame = CGRectMake(_mTitle.frame.origin.x +_mTitle.frame.size.width +10.0f, _mTitle.frame.origin.y +2.0f, tipImage.size.width, tipImage.size.height);
    }
    _mContent.text = content ;
    [_mContent sizeToFit];
    _mContent.frame = CGRectMake(kOffX_2_0, _mTitle.frame.origin.y +_mTitle.frame.size.height +kOffX_2_0, _mContent.frame.size.width, _mContent.frame.size.height);
    
}
@end
