//
//  JFQNewCell.m
//  免费流量王
//
//  Created by keyrun on 14-11-8.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "JFQNewCell.h"
#import "SDImageView+SDWebCache.h"
#define kJfqIconOffy       15.0f
#define kJfqIconSize        51.0f
#define kJfqPadding         12.0f
#define kJfqCellH           85.0f
#define kJfqLineH           5.0f   //底部线高
@implementation JFQNewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _jfqIcon =[[UIImageView alloc] initWithFrame:CGRectMake(kOffX_2_0, kJfqIconOffy, kJfqIconSize, kJfqIconSize)];
        _jfqName = [[TaoJinLabel alloc] initWithFrame:CGRectMake(_jfqIcon.frame.origin.x +_jfqIcon.frame.size.width +kJfqPadding, _jfqIcon.frame.origin.y +5.0f, 200, 17.0f) text:@"" font:GetFont(16.0) textColor:kBlackTextColor textAlignment:NSTextAlignmentLeft numberLines:1];
        label =[[TaoJinLabel alloc] initWithFrame:CGRectMake(_jfqName.frame.origin.x +_jfqName.frame.size.width, _jfqName.frame.origin.y , 200, 17.0) text:@"流量频道" font:GetFont(16.0) textColor:kBlackTextColor textAlignment:NSTextAlignmentLeft numberLines:1];
        _jfqInfor =[[TaoJinLabel alloc] initWithFrame:CGRectMake(_jfqName.frame.origin.x , _jfqName.frame.origin.y +_jfqName.frame.size.height +kJfqPadding, kmainScreenWidth- 2*kOffX_2_0 -_jfqIcon.frame.size.width -kJfqPadding, 12.0) text:@"" font:GetFont(11.0) textColor:kContentTextColor textAlignment:NSTextAlignmentLeft numberLines:1];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kJfqCellH -kJfqLineH, kmainScreenWidth, kJfqLineH)];
        lineView.backgroundColor = ColorRGB(230.0, 230.0, 230.0, 1.0);
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedCell)];
        [self addGestureRecognizer:tap];
        [self.contentView addSubview:_jfqIcon];
        [self.contentView addSubview:_jfqName];
        [self.contentView addSubview:label];
        [self.contentView addSubview:_jfqInfor];
        [self.contentView addSubview:lineView];
    }
    return self;
}
-(void)onClickedCell{
    _copyBlock(self.cellIndex);
}
-(void) initJFQNewCellWith:(JFQClass *)jfqClass andBlock:(JFQNewCellBlock)block{
    _copyBlock = [block copy];
    NSString *imageURL = jfqClass.icon;
    [_jfqIcon setImageWithURL:[NSURL URLWithString:imageURL] refreshCache:NO needSetViewContentMode:false needBgColor:false placeholderImage:GetImage(@"deficon")];
    
    NSString *name = jfqClass.name ;
    _jfqName.text =name;
    [_jfqName sizeToFit];
    _jfqName.frame =CGRectMake(_jfqName.frame.origin.x, _jfqName.frame.origin.y, _jfqName.frame.size.width, _jfqName.frame.size.height);
    
    label.frame =CGRectMake(_jfqName.frame.origin.x +_jfqName.frame.size.width, _jfqName.frame.origin.y+1.0f, 200, 17.0);
    
    NSString *infor =jfqClass.content ;
    _jfqInfor.text =infor;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
