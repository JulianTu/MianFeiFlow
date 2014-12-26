//
//  JFQCell.m
//  免费流量王
//
//  Created by keyrun on 14-10-24.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "JFQCell.h"
#import "TaoJinButton.h"
#import "SDImageView+SDWebCache.h"
#define kJFQcellH      70.0f
#define kJFQcellItemPadding     18.0f 
#define kJFQcellItemSize        50.0f
@implementation JFQCell
@synthesize cellScroll = _cellScroll ;
@synthesize jfqsArr = _jfqsArr ;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kJFQcellH)];
        _cellScroll.showsHorizontalScrollIndicator = NO;
        _cellScroll.showsVerticalScrollIndicator = NO;
        _cellScroll.delegate = self;
        _cellScroll.backgroundColor = kWitheColor ;
        [self addSubview:_cellScroll];
    }
    return self;
}
-(void) loadJFQCellWith:(NSArray *)jfqs withBlock:(JFQCellBlock)block{
    copyBlock = [block copy];
    
    for (int i=0; i < jfqs.count; i++) {
        JFQClass *jfq = [[JFQClass alloc]initWithDictionary:[jfqs objectAtIndex:i]];
        TaoJinButton *btn = [[TaoJinButton alloc] initWithFrame:CGRectMake(kOffX_2_0 +i* (kJFQcellItemSize+ kJFQcellItemPadding), kOffX_2_0, kJFQcellItemSize, kJFQcellItemSize) titleStr:nil titleColor:nil font:nil logoImg:nil backgroundImg:nil];
        btn.tag = i ;
        [btn addTarget:self action:@selector(clickedJFQItem:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *image =[[UIImageView alloc] initWithFrame:btn.frame];
        [image setImageWithURL:[NSURL URLWithString:jfq.icon] refreshCache:NO needBgColor:NO placeholderImage:nil];
        [_cellScroll addSubview:image];
        [_cellScroll addSubview:btn];
    }
    [_cellScroll setContentSize:CGSizeMake(kOffX_2_0 +jfqs.count *(kJFQcellItemSize +kJFQcellItemPadding), kJFQcellH)];
}
-(void) clickedJFQItem:(TaoJinButton *)btn {
    copyBlock(btn);
}
@end
