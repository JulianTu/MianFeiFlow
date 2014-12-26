//
//  SectorView.m
//  免费流量王
//
//  Created by keyrun on 14-10-24.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "SectorView.h"
#import "TaoJinLabel.h"
#define Pai      3.1415926
@implementation SectorView
@synthesize radius = _radius ;
-(instancetype)initWithFrame:(CGRect)frame andSectorRadius:(float)radius{
    self = [super initWithFrame:frame];
    if (self) {
        center = CGPointMake(frame.size.width/2, frame.size.height/2);
        _radius = radius-1 ;
        self.backgroundColor = kWitheColor;
        
    }
    return self ;
}

- (void)drawRect:(CGRect)rect {
    UIColor *blue = ColorRGB(255.0, 245.0, 156.0, 1.0);
    UIColor *yellow  = ColorRGB(113.0, 201.0, 233.0, 1.0);
    
    [[UIColor whiteColor] setStroke];

    [blue setFill];
    NSLog(@"center  x %f",self.center.x);
    [self drawSectorViewWithCenter:CGPointMake(center.x, center.y) radius:_radius startAngle:-Pai/3 endAngle:0 clockwise:YES];
    [yellow setFill];
    [self drawSectorViewWithCenter:CGPointMake(center.x, center.y) radius:_radius startAngle:0 endAngle:Pai/3 clockwise:YES];
    [blue setFill];
    
    [self drawSectorViewWithCenter:CGPointMake(center.x, center.y) radius:_radius startAngle:Pai/3 endAngle:Pai*2/3 clockwise:YES];
    [yellow setFill];
    [self drawSectorViewWithCenter:CGPointMake(center.x, center.y) radius:_radius startAngle:2*Pai/3 endAngle:Pai clockwise:YES];
    [blue setFill];
    
    [self drawSectorViewWithCenter:CGPointMake(center.x, center.y) radius:_radius startAngle:Pai endAngle:-Pai*2/3 clockwise:YES];
    
    [yellow setFill];
    [self drawSectorViewWithCenter:CGPointMake(center.x, center.y) radius:_radius startAngle:-Pai*2/3 endAngle:-Pai/3 clockwise:YES];


}
- (void) loadLotteryReward:(NSArray *)rewardArr {
     UIColor *blueColor = ColorRGB(15.0, 106.0, 179.0, 1.0);
    UIColor *cofferColor = ColorRGB(125.0, 60.0, 28.0, 1.0);
    for (int i=0; i <rewardArr.count; i++) {
        UIColor *textColor = i%2 ==0? blueColor :cofferColor;
        
//        float rewardLabOffy = i <3 ? 38.0 +i*38.0 :(self.frame.size.height -15 -38.0) -38*(i-3);
        float rewardLabOffy ;
        float radius;
        if ( i== 1 || i== 5) {
            radius = i == 1? Pai/3 : (-Pai/3) ;
            rewardLabOffy =  self.frame.size.width/3 -12.0f;
        }else if (i == 0 || i== 3){
            radius = i== 0? 0.0f : (Pai) ;
            rewardLabOffy = i ==0 ? 12.0f : self.frame.size.height -12.0f -15.0f ;
        }else {
            radius = i==2 ? 2*Pai/3 :(4*Pai/3) ;
            rewardLabOffy = self.frame.size.width /3 *2 ;
        }
        float rewardLabOffx ;
        if (i <=3) {
            rewardLabOffx = i %3 == 0 ? self.frame.size.width/3 :self.frame.size.width/3*2 ;
        }
        else{
            rewardLabOffx = 0 ;
        }
        float a =1;
        if (1 == 2 || i==3 || i ==4) {
            a = -1;
        }
        TaoJinLabel *rewardLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(rewardLabOffx, rewardLabOffy, self.frame.size.width/3, 15) text:[rewardArr objectAtIndex:i] font:GetBoldFont(14.0) textColor:textColor textAlignment:NSTextAlignmentCenter numberLines:1];
        TaoJinLabel *coinLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(rewardLab.frame.origin.x, rewardLab.frame.origin.y +a *rewardLab.frame.size.height, self.frame.size.width/3, 12) text:@"流量币" font:GetFont(11.0) textColor:textColor textAlignment:NSTextAlignmentCenter numberLines:1];
        if (i ==1 ) {
            coinLab.frame = CGRectMake(rewardLab.frame.origin.x -12.0f, rewardLab.frame.origin.y +8.0f, self.frame.size.width/3, 12.0f);
        }else if (i ==2 ){
            coinLab.frame = CGRectMake(rewardLab.frame.origin.x-12.0f, rewardLab.frame.origin.y -7.0f, self.frame.size.width/3, 12.0f);
        }else if (i ==4) {
            coinLab.frame = CGRectMake(rewardLab.frame.origin.x +14.0f, rewardLab.frame.origin.y -7.0f, self.frame.size.width/3, 12.0f);
        }else if (i ==5) {
            coinLab.frame = CGRectMake(rewardLab.frame.origin.x +14.0f, rewardLab.frame.origin.y +7.0f, self.frame.size.width/3, 12.0f);
        }
//        rewardLab.backgroundColor = [UIColor redColor];
//        coinLab.backgroundColor = [UIColor redColor];
        rewardLab.transform = CGAffineTransformMakeRotation(radius);
        coinLab.transform = CGAffineTransformMakeRotation(radius);
        [self addSubview:rewardLab];
        [self addSubview:coinLab];
    }
    

}
-(void) loadLotteryReward:(NSString *)rewards andTextColor:(UIColor *)textColor{
       
    float rewardLabOffy = 12.0f;
    float rewardLabOffx = 0.0f ;
    TaoJinLabel *rewardLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(rewardLabOffx, rewardLabOffy, self.frame.size.width, 15) text:rewards font:GetBoldFont(14.0) textColor:textColor textAlignment:NSTextAlignmentCenter numberLines:1];
    TaoJinLabel *coinLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(rewardLab.frame.origin.x, rewardLab.frame.origin.y +rewardLab.frame.size.height, self.frame.size.width, 15) text:@"流量币" font:GetFont(14.0) textColor:textColor textAlignment:NSTextAlignmentCenter numberLines:1];
   
    [self addSubview:rewardLab];
    [self addSubview:coinLab];

    
}
-(void) drawSectorViewWithCenter:(CGPoint)centerP radius:(float)radius startAngle:(float)startAngle endAngle:(float)endAngle clockwise:(BOOL) clockwise {
    CGContextRef context = UIGraphicsGetCurrentContext() ;
    CGContextMoveToPoint(context, centerP.x, centerP.y);
    CGContextAddArc(context, centerP.x, centerP.y, radius, startAngle, endAngle, clockwise?0:1);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
