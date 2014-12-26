//
//  ShareItem.m
//  免费流量王
//
//  Created by keyrun on 14-10-20.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "ShareItem.h"
#define kSVPadding      10.0f
#define kSVIconSize      40.0f
@implementation ShareItem
@synthesize itemIcon = _itemIcon ;
@synthesize itemShareReward = _itemShareReward ;
@synthesize itemTitle = _itemTitle ;
@synthesize itemShared = _itemShared ;
@synthesize itemSharedMark = _itemSharedMark ;
-(id)initWithFrame:(CGRect)frame andIconImg:(UIImage *)img title:(NSString *)title andReward:(NSString *)rewardNum{
    self = [super initWithFrame:frame];
    if (self) {
        
        _itemIcon = [[UIImageView alloc] initWithImage:img];
        _itemIcon.frame = CGRectMake(frame.size.width/2 -kSVIconSize/2, 0, kSVIconSize, kSVIconSize);
        float height = kSVIconSize + 14.0f + 15.0f +2*kSVPadding ;
        _itemIcon.frame =CGRectMake(_itemIcon.frame.origin.x, frame.size.height /2 -height/2, kSVIconSize, kSVIconSize);
        
        _itemTitle = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0, _itemIcon.frame.origin.y +_itemIcon.frame.size.height +kSVPadding, frame.size.width, 14.0) text:title font:GetFont(14.0) textColor:KBlockColor2_0 textAlignment:NSTextAlignmentCenter numberLines:1];
        
        _itemShared = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0, _itemTitle.frame.origin.y +_itemTitle.frame.size.height +kSVPadding, frame.size.width, 12.0) text:@"今日已分享" font:GetFont(11.0) textColor:kLineColor2_0 textAlignment:NSTextAlignmentCenter numberLines:1];
        _itemShared.hidden = YES ;
        
        _itemSharedMark = [[UIImageView alloc] initWithImage:GetImage(@"")];
        _itemSharedMark.frame = CGRectMake(0, 0, 0, 0);
        
        _itemShareReward = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0, _itemTitle.frame.origin.y +_itemTitle.frame.size.height +kSVPadding, frame.size.width, 15.0) text:[NSString stringWithFormat:@"+%@",rewardNum] font:GetBoldFont(15.0) textColor:KOrangeColor2_0 textAlignment:NSTextAlignmentCenter numberLines:1];
        
        CALayer *rightLayer = [CALayer layer];
        rightLayer.frame = CGRectMake(frame.size.width -LineWidth, 0, LineWidth, frame.size.height);
        rightLayer.backgroundColor = kLineColor2_0.CGColor ;
        
        CALayer *bottomLayer = [CALayer layer];
        bottomLayer.frame = CGRectMake(0, frame.size.height -LineWidth, frame.size.width, LineWidth);
        bottomLayer.backgroundColor = kLineColor2_0.CGColor ;
        
        [self addSubview:_itemIcon];
        [self addSubview:_itemTitle];
        [self addSubview:_itemShareReward];
        [self addSubview:_itemShared];
        [self.layer addSublayer:rightLayer];
        [self.layer addSublayer:bottomLayer];
        
    }
    return self;
}

@end
