//
//  DashLineButton.m
//  免费流量王
//
//  Created by keyrun on 14-11-7.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "DashLineButton.h"

@implementation DashLineButton
{
    CAShapeLayer *_shapeLayer;
}
@synthesize borderColor =_borderColor ;
+(id)buttonWithType:(UIButtonType)buttonType {
    DashLineButton *btn= [super buttonWithType:buttonType];
    if (btn) {
        
    }
    return btn;
}
- (void)drawRect:(CGRect)rect {
    if (_shapeLayer) [_shapeLayer removeFromSuperlayer];
    
    //border definitions
    CGFloat cornerRadius = 5.0;
    CGFloat borderWidth = 1.0;
    NSInteger dashPattern1 = 2.0;
    NSInteger dashPattern2 = 2.0;
    UIColor *lineColor = _borderColor ? _borderColor : [UIColor blackColor];
    
    //drawing
    CGRect frame = self.bounds;
    
    _shapeLayer = [CAShapeLayer layer];
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    //creating a path
    CGMutablePathRef path = CGPathCreateMutable();

    //drawing a border around a view
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    //path is set as the _shapeLayer object's path
    _shapeLayer.path = path;
    CGPathRelease(path);
    
    _shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    _shapeLayer.frame = frame;
    _shapeLayer.masksToBounds = NO;
    [_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    _shapeLayer.strokeColor = [lineColor CGColor];
    _shapeLayer.lineWidth = borderWidth;
    _shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:dashPattern1], [NSNumber numberWithInt:dashPattern2], nil] ;
    _shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view
    [self.layer addSublayer:_shapeLayer];
    self.layer.cornerRadius = cornerRadius;
        });
    });
}


@end
