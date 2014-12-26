//
//  TaoJinButton.m
//  91TaoJin
//
//  Created by keyrun on 14-5-22.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "TaoJinButton.h"

@implementation TaoJinButton

/**
 *  初始化自定义按钮
 *
 *  @param frame         大小
 *  @param titleStr      文案（正常状态）
 *  @param titleColor    文案颜色（正常状态）
 *  @param font          字体（正常状态）
 *  @param logoImg       图标（正常状态）
 *  @param backgroundImg 背景（正常状态）
 *
 */
- (id)initWithFrame:(CGRect)frame titleStr:(NSString *)titleStr titleColor:(UIColor *)titleColor font:(UIFont *)font logoImg:(UIImage *)logoImg backgroundImg:(UIImage *)backgroundImg{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    if(self){

        self.frame = frame;
        [self setTitle:titleStr forState:UIControlStateNormal];
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        self.titleLabel.font = font;
        [self setImage:logoImg forState:UIControlStateNormal];
        self.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        [self setBackgroundImage:backgroundImg forState:UIControlStateNormal];
    }
    return self;
}
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect bounds =self.bounds ;
    CGFloat widthDelta =MAX(50.0 -bounds.size.width,0);
    CGFloat heightDelta =MAX(50.0 -bounds.size.height, 0);
    bounds =CGRectInset(bounds, -0.5* widthDelta, -0.5* heightDelta);
    return CGRectContainsPoint(bounds, point);
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
