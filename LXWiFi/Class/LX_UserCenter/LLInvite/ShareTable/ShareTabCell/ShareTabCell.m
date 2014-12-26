//
//  ShareTabCell.m
//  免费流量王
//
//  Created by keyrun on 14-10-15.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "ShareTabCell.h"
#import "UIImage+ColorChangeTo.h"
#import "StatusBar.h"
#define kCellTextOffy       2.0f
#define kCellHeadOffy       15.0f
#define kCellBtnOffx        54.0f
#define kCellLineOffx       16.0f
@implementation ShareTabCell

@synthesize title =_title ;
@synthesize content = _content ;
@synthesize reward = _reward ;
@synthesize textLab = _textLab ;
@synthesize isHeadCell = _isHeadCell ;
@synthesize shareBtn =_shareBtn ;
@synthesize codeImgBtn = _codeImgBtn ;
@synthesize isBottomCell =_isBottomCell ;
@synthesize lineLabel = _lineLabel ;
@synthesize dashLine = _dashLine ;
@synthesize lineLabBG =_lineLabBG ;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        _title = [[TaoJinLabel alloc] initWithFrame:CGRectMake(kOffX_2_0, 0, kmainScreenWidth, 16.0) text:nil font:kFontSize_16 textColor:kBlackTextColor textAlignment:NSTextAlignmentLeft numberLines:1];
        _content = [[TaoJinLabel alloc] initWithFrame:CGRectMake(kOffX_2_0, 0, kmainScreenWidth- 2*(kOffX_2_0), 15.0) text:nil font:kFontSize_14 textColor:kContentTextColor textAlignment:NSTextAlignmentLeft numberLines:0];
        _textLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth -kOffX_2_0, 11.0) text:@"流量币" font:kFontSize_11 textColor:KOrangeColor2_0 textAlignment:NSTextAlignmentRight numberLines:1];
        _reward =[[TaoJinLabel alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 16.0) text:nil font:[UIFont boldSystemFontOfSize:16.0] textColor:KOrangeColor2_0 textAlignment:NSTextAlignmentLeft numberLines:1];
        
        _shareBtn = [[TaoJinButton alloc]initWithFrame:CGRectZero titleStr:@"分享" titleColor:kWitheColor font:GetFont(17.0) logoImg:GetImage(@"") backgroundImg:[UIImage createImageWithColor:kBlueTextColor]];
        [_shareBtn setBackgroundImage:[UIImage createImageWithColor:kLightBlueTextColor] forState:UIControlStateHighlighted];
        _shareBtn.hidden = YES ;
        _shareBtn.tag = 1001 ;
        _shareBtn.layer.masksToBounds = YES;
        _shareBtn.adjustsImageWhenHighlighted = NO;
        [_shareBtn addTarget:self action:@selector(onClickedLinelabel) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.imageEdgeInsets = UIEdgeInsetsMake(7.0f, 30.0f, 7.0f, 90.0f);
        
        _codeImgBtn = [[TaoJinButton alloc] initWithFrame:CGRectZero titleStr:@"" titleColor:nil font:nil logoImg:GetImage(@"") backgroundImg:[UIImage createImageWithColor:kBlueTextColor]];
        [_codeImgBtn setBackgroundImage:[UIImage createImageWithColor:kLightBlueTextColor] forState:UIControlStateHighlighted];
        _codeImgBtn.adjustsImageWhenHighlighted = NO ;
        _codeImgBtn.layer.masksToBounds =YES;
        _codeImgBtn.tag = 1002 ;
        [_codeImgBtn addTarget:self action:@selector(onClickedLinelabel) forControlEvents:UIControlEventTouchUpInside];
        _codeImgBtn.hidden = YES ;
        
        _lineLabel = [[UnderLineLabel alloc] initWithFrame:CGRectMake(kOffX_2_0, 0, kmainScreenWidth, 14.0f)];
        _lineLabel.font = GetFont(14.0f);
        _lineLabel.textColor = ColorRGB(155.0, 155.0, 155.0, 1);
        _lineLabel.highlightedColor = ColorRGB(230, 230, 230, 1)  ;
        _lineLabel.shouldUnderline = YES;
        [_lineLabel addTarget:self action:@selector(onClickedLinelabel)];
        _lineLabel.hidden = YES;
        
        _dashLine = [[DashLine alloc] initWithFrame:CGRectZero lineColor:kLineColor2_0];
        _dashLine.hidden = YES ;

        _lineLabBG = [[UIView alloc] initWithFrame:CGRectZero];
        _lineLabBG.backgroundColor =[UIColor clearColor];
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedLinelabel2:)];
        [_lineLabBG addGestureRecognizer:tap];
        
        
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_content];
        [self.contentView addSubview:_reward];
        [self.contentView addSubview:_textLab];
        [self.contentView addSubview:_shareBtn];
        [self.contentView addSubview:_codeImgBtn];
        [self.contentView addSubview:_dashLine];
        
        [self.contentView addSubview:_lineLabel];
        [self.contentView addSubview:_lineLabBG];
    }
    return self ;
}
-(void)onClickedLinelabel2:(UITapGestureRecognizer *)tapGest{
    if (tapGest.state == UIGestureRecognizerStateEnded) {
        _lineLabel.backgroundColor = ColorRGB(230, 230, 230, 1) ;
        double delaySec = 0.1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _lineLabel.backgroundColor = [UIColor clearColor];
        });
    }
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:superLinker]];
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.persistent =YES;
    NSString* string =superLinker;
    if (string) {
        [pasteboard setValue:string forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
        [StatusBar showTipMessageWithStatus:@"邀请链接复制成功" andImage:nil andTipIsBottom:YES];
    }

    
}
-(void)onClickedLinelabel{
    _lineLabel.backgroundColor = ColorRGB(230, 230, 230, 1) ;
    double delaySec = 0.1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _lineLabel.backgroundColor = [UIColor clearColor];
    });
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:superLinker]];
    
}
-(void)loadCellHeadVie:(NSString *)content{
    _content.text =content ;
    _content.textColor = kBlueTextColor ;
    [_content sizeToFit];
    _content.frame = CGRectMake(kOffX_2_0, 15.0f, _content.frame.size.width, _content.frame.size.height);
    
    _textLab.hidden = YES;
}
-(void)loadShareTabCellViewWithTitle:(NSString *)title Content:(NSString *)content rewardNum:(NSString *)rewardNum{
    _title.text = title ;
    [_title sizeToFit];
    _title.frame = CGRectMake(kOffX_2_0, 0, _title.frame.size.width, _title.frame.size.height);
    
    _content.text = content ;
    [_content sizeToFit];
    _content.frame = CGRectMake(kOffX_2_0, _title.frame.origin.y +_title.frame.size.height + kCellTextOffy, _content.frame.size.width, _content.frame.size.height);
    
    _textLab.text = @"流量币";
    [_textLab sizeToFit];
    _textLab.frame = CGRectMake(kmainScreenWidth -_textLab.frame.size.width -kOffX_2_0, _title.frame.origin.y +5.0f, _textLab.frame.size.width, _textLab.frame.size.height);
    
    _reward.text =[NSString stringWithFormat:@"+%@",rewardNum] ;
    [_reward sizeToFit];
    _reward.frame = CGRectMake(_textLab.frame.origin.x -_reward.frame.size.width -5.0f, _title.frame.origin.y, _reward.frame.size.width, _reward.frame.size.height);
    
    _dashLine.frame =CGRectMake(kCellLineOffx +_title.frame.origin.x +_title.frame.size.width, _title.frame.size.height/2, _reward.frame.origin.x -kOffX_2_0 - _title.frame.origin.x -_title.frame.size.width -kCellLineOffx, 0.5f);
    _dashLine.hidden = NO ;
    
}
-(float) getShareCellHeigth{
    if (_isHeadCell) {
        return 15.0f +_content.frame.size.height ;
    }else if (_isBottomCell){
        if (kmainScreenHeigh <568.0f) {
            return _lineLabel.frame.origin.y +_lineLabel.frame.size.height +25.0f;
        }else{
            return  _lineLabel.frame.origin.y +_lineLabel.frame.size.height;
        }
    } else{
        
        if (_content.frame.origin.y +_content.frame.size.height +15.0f <= 54.0f) {
            return 54.0f;
        }else{
        
            return _content.frame.origin.y +_content.frame.size.height +15.0f;
        }
    }
}
-(void) loadCellBottomViewWithURL:(NSString *)urlStr{
    superLinker =urlStr;
    float width = kmainScreenWidth - 2*kCellBtnOffx - kButtonHeigh -5.0f;
    _shareBtn.frame = CGRectMake(kCellBtnOffx, 15.0f, width, kButtonHeigh);
    _shareBtn.layer.cornerRadius = kButtonHeigh /2 ;
    _shareBtn.hidden = YES ;
    
    _codeImgBtn.frame = CGRectMake(_shareBtn.frame.origin.x +_shareBtn.frame.size.width + 5.0f, _shareBtn.frame.origin.y, kButtonHeigh, kButtonHeigh);
    _codeImgBtn.layer.cornerRadius = _codeImgBtn.frame.size.width /2 ;
    _codeImgBtn.hidden = YES;
    
    [_lineLabel setText:@"复制专属的邀请链接" andCenter:CGPointMake(50, 30 )];
    _lineLabel.frame = CGRectMake(kmainScreenWidth/2 -_lineLabel.frame.size.width/2, 15.0f, _lineLabel.frame.size.width, _lineLabel.frame.size.height);
    _lineLabel.hidden = NO;
    
    _lineLabBG.frame = CGRectMake(_lineLabel.frame.origin.x -10.0f, _lineLabel.frame.origin.y -5.0f, _lineLabel.frame.size.width +20.0f, _lineLabel.frame.size.height +10.0f);
    
    _title.hidden = YES;
    _content.hidden = YES;
    _reward.hidden = YES;
    _textLab.hidden = YES;
}
@end