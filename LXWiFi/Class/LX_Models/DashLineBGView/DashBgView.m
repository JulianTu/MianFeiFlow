//
//  DashBgView.m
//  免费流量王
//
//  Created by keyrun on 14-10-15.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "DashBgView.h"

@implementation DashBgView

-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title{
    self= [super initWithFrame:frame];
    if (self) {
        
    }
    return self ;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, KBlockColor2_0.CGColor);
    float lengths[] ={2,2};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
    
    CGContextMoveToPoint(context, 0, self.frame.size.height);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
    
    CGContextStrokePath(context);
}


@end
