//
//  DrawLabel.m
//  免费流量王
//
//  Created by keyrun on 14-10-21.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "DrawLabel.h"

@implementation DrawLabel
@synthesize drawColor = _drawColor ;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   
    CGSize shadowOffset = self.shadowOffset ;
    UIColor *textColor = self.textColor ;
    
    CGContextRef c = UIGraphicsGetCurrentContext() ;
    CGContextSetLineWidth(c, 2);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = _drawColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor ;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    self.shadowOffset = shadowOffset ;
}


@end
