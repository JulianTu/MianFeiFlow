//
//  LLRecordTypeCell.m
//  乐享WiFi
//
//  Created by keyrun on 14-10-14.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LLRecordTypeCell.h"

#define kTRLabOffx      10.0f
#define kTRLabOffy       12.0f
#define KTRLabH          16.0f
@implementation LLRecordTypeCell
{
    TaoJinLabel *_typeNameLab;
    
}

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
        _typeNameLab = [[TaoJinLabel alloc] initWithFrame:CGRectZero text:nil font:kFontSize_16 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft numberLines:1];
        
        self.selectedBackgroundView =[[UIView alloc]initWithFrame:self.frame];
      
        self.selectedBackgroundView.backgroundColor = kBlueTextColor;
        UIView *lineLayer = [[UIView alloc]init];
        lineLayer.frame = CGRectMake(0, 0, kRecordTabWidth, 5.0f);
        lineLayer.backgroundColor = [UIColor whiteColor];

        [self.contentView addSubview:_typeNameLab];

        
    }
    return self ;
}
-(void) setTypeLabTitle:(NSString *)title {
    _typeNameLab.text = title ;
    [_typeNameLab sizeToFit];
    _typeNameLab.frame = CGRectMake(kTRLabOffx, kTRLabOffy, kRecordTabWidth - kTRLabOffx, KTRLabH);
}
@end
