//
//  RecordProgressCell.m
//  免费流量王
//
//  Created by keyrun on 14-10-16.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "RecordProgressCell.h"
#define kPCellTitleW       120.0f
#define kPCellBgH          40.0f
#define kPCellTitleOffy    21.0f
#define kPCellNumOffy      7.0f
@implementation RecordProgressCell
{
    CALayer *_lineLayer;
}
@synthesize titleLab = _titleLab ;
@synthesize progressLab = _progressLab ;
@synthesize bgView =_bgView ;
@synthesize progressView = _progressView ;
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
        _titleLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(kmainScreenWidth- 2* kOffX_2_0 -kPCellTitleW -5.0f, 0, kPCellTitleW, 14.0) text:@"" font:GetFont(14.0f) textColor:kContentTextColor textAlignment:NSTextAlignmentRight numberLines:1];
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(kOffX_2_0, kOffX_2_0, kmainScreenWidth -2 *kOffX_2_0, kPCellBgH)];
        _bgView.backgroundColor = KLightGrayColor2_0 ;
        
        _lineLayer = [CALayer layer];
        _lineLayer.frame = CGRectMake(_titleLab.frame.origin.x -2.0, kOffX_2_0, 2.0, kPCellBgH);
        _lineLayer.backgroundColor = [[UIColor whiteColor] CGColor];
        
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(kOffX_2_0, 0, 0, kPCellBgH)];
        _progressLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 12.0) text:nil font:GetFont(12.0f) textColor:nil textAlignment:NSTextAlignmentLeft numberLines:1];
        
        
        [self.contentView addSubview:_bgView];
        [self.contentView addSubview:_progressView];
        [self.contentView addSubview:_progressLab];
        [self.contentView.layer addSublayer:_lineLayer];
        [self.contentView addSubview:_titleLab];
    }
    return self;
}
-(void)loadProgressCellViewWith:(NSString *)title andColor:(UIColor *)color currentNum:(float) cNum andMaxNum:(float)mNum{
    _titleLab.text = title ;
    [_titleLab sizeToFit];
    _titleLab.frame = CGRectMake(kmainScreenWidth  -_titleLab.frame.size.width -kOffX_2_0 -5.0f, kPCellTitleOffy +kOffX_2_0, _titleLab.frame.size.width, _titleLab.frame.size.height);
//    _lineLayer.frame = CGRectMake(_titleLab.frame.origin.x -5.0f, _lineLayer.frame.origin.y, _lineLayer.frame.size.width, _lineLayer.frame.size.height);
    
    float percent = cNum /mNum ;
    percent = percent >= 1? 1:percent ;
    NSLog(@" percent ==%f",percent);
    _progressView.frame = CGRectMake(kOffX_2_0, kOffX_2_0, (kmainScreenWidth -2*kOffX_2_0 -_titleLab.frame.size.width -10.0f) *percent, kPCellBgH);
    _progressView.backgroundColor =color ;
    
    if (cNum == 0.0) { 
        _progressView.frame = CGRectMake(kOffX_2_0, kOffX_2_0, 5.0f, kPCellBgH);
    }
    int num = cNum ;
    _progressLab.text= [NSString stringWithFormat:@"%d",num] ;
    [_progressLab sizeToFit];
    _progressLab.frame = CGRectMake(_progressView.frame.size.width +_progressView.frame.origin.x +5.0f, _progressView.frame.origin.y +5.0f , _progressLab.frame.size.width, _progressLab.frame.size.height);
    _progressLab.textColor = color;
}

@end
