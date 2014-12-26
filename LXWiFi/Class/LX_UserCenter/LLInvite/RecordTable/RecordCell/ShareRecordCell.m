//
//  ShareRecordCell.m
//  免费流量王
//
//  Created by keyrun on 14-10-15.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "ShareRecordCell.h"
#import "UIImage+ColorChangeTo.h"
#define kRCellBtnW    90.0f
#define kRCellH        55.0f
#define kRCellBtnH     34.0f
@implementation ShareRecordCell
@synthesize dashLine = _dashLine ;
@synthesize contentLab = _contentLab ;
@synthesize doneBtn = _doneBtn ;
@synthesize missionState = _missionState ;
@synthesize isLastOne = _isLastOne ;
@synthesize bottomLine = _bottomLine ;
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
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        _doneBtn = [[TaoJinButton alloc] initWithFrame:CGRectMake(kmainScreenWidth -kRCellBtnW -kOffX_2_0, kRCellH /2 -kRCellBtnH/2, kRCellBtnW, kRCellBtnH) titleStr:@"" titleColor:nil font:GetFont(14.0) logoImg:nil backgroundImg:nil];
        _doneBtn.tag =5300;
        
        _contentLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(kOffX_2_0, 0, kmainScreenWidth -(kOffX_2_0 + _doneBtn.frame.size.width), 14.0f) text:@"" font:GetFont(14.0f) textColor:kBlackTextColor textAlignment:NSTextAlignmentLeft numberLines:1];
        [_doneBtn addTarget:self action:@selector(onClickedRewardBtn) forControlEvents:UIControlEventTouchUpInside];
        _doneBtn.hidden = YES;
        _contentLab.hidden = YES ;
        
        _dashLine =[[UIView alloc] initWithFrame:CGRectMake(0, LineWidth, kmainScreenWidth , LineWidth)];
        _bottomLine =[[UIView alloc] initWithFrame:CGRectMake(kOffX_2_0,kRCellH - LineWidth, kmainScreenWidth - kOffX_2_0, LineWidth)];
        _dashLine.backgroundColor = kLineColor2_0;
        _dashLine.hidden = YES;
        
        _bottomLine.backgroundColor = kLineColor2_0 ;
        _bottomLine.hidden =NO;
        [self.contentView addSubview:_bottomLine];
        [self.contentView addSubview:_dashLine];
        [self.contentView addSubview:_doneBtn];
        [self.contentView addSubview:_contentLab];
    }
    return self;
}
-(void)onClickedRewardBtn{
    _copyBlock(self.invisiteNum,self.indexTag,self.numString);
}

-(void) loadMissionCellViewWith:(NSString *)contentStr andMissionState:(MissionState )state rewardNum:(NSString* )number block:(ShareCellBlock)block{
    _copyBlock = [block copy];
    self.numString = number;
//    _doneBtn.tag = self.indexTag;
    _doneBtn.hidden = NO;
    _contentLab.hidden = NO ;
    _contentLab.text = contentStr ;
    [_contentLab sizeToFit];
    _contentLab.frame = CGRectMake(kOffX_2_0, kRCellH/2 -_contentLab.frame.size.height/2, _contentLab.frame.size.width, _contentLab.frame.size.height);
    switch (state) {
        case 0: // 未完成
        {
            [_doneBtn setTitle:[NSString stringWithFormat:@"%@流量币",number] forState:UIControlStateNormal];
            [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_doneBtn setBackgroundImage:[UIImage createImageWithColor:kLineColor2_0] forState:UIControlStateNormal];
            _doneBtn.userInteractionEnabled = NO;

        }
            break;
        case 1: // 完成 未领取
        {
            [_doneBtn setTitle:[NSString stringWithFormat:@"%@流量币",number] forState:UIControlStateNormal];
            [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_doneBtn setBackgroundImage:[UIImage createImageWithColor:KOrangeColor2_0] forState:UIControlStateNormal];
            [_doneBtn setBackgroundImage:[UIImage createImageWithColor:KLightOrangeColor2_0] forState:UIControlStateHighlighted];
            
        }
            break;
        case 2: // 领取
        {
            [_doneBtn setTitle:[NSString stringWithFormat:@"已领取"] forState:UIControlStateNormal];
            [_doneBtn setTitleColor:kLineColor2_0 forState:UIControlStateNormal];
            [_doneBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            _doneBtn.layer.borderWidth =1.0f;
            _doneBtn.layer.borderColor = kLineColor2_0.CGColor ;
            _doneBtn.userInteractionEnabled = NO;
            _contentLab.textColor = kLineColor2_0 ;
            
        }
            break;
        default:
            break;
    }
    _doneBtn.layer.masksToBounds = YES;
    _doneBtn.layer.cornerRadius = 5.0f;
    
    if (_isFirstOne) {
        _dashLine.hidden =NO;
    }
    if (_isLastOne) {
        _bottomLine.frame = CGRectMake(0, _bottomLine.frame.origin.y, kmainScreenWidth, _bottomLine.frame.size.height);
    }
}
@end
