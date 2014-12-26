//
//  HongBaoView.m
//  免费流量王
//
//  Created by keyrun on 14-10-23.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "HongBaoView.h"

@implementation HongBaoView
static UIImageView *animationImg =nil;

+(id) getHongBaoView {
    static HongBaoView *view  =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[self alloc] init];
    });
    return view ;
}
-(instancetype)initWithFrame:(CGRect)frame andHongBaoBlock:(HongBaoBlock) block{
    self =[super initWithFrame:frame];
    if (self) {
        _block = [block copy];
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedHongBao)];
        tap.numberOfTapsRequired =1 ;
//        [self addGestureRecognizer:tap];
        [self doHongBaoAnimation:frame];
    }
    return self ;
}
-(void)onClickedHongBao{
    _block();
}
-(void)doHongBaoAnimation:(CGRect) frame{
    UIImage *img = GetImage(@"1");
    self.frame =CGRectMake(frame.origin.x, frame.origin.y, img.size.width, img.size.height);
    self.animationImages =@[GetImage(@"4"),GetImage(@"3"),GetImage(@"1"),GetImage(@"2"),GetImage(@"3"),GetImage(@"4"),GetImage(@"5"),GetImage(@"6"),GetImage(@"5")];
    self.animationDuration = 0.9 ;
    self.animationRepeatCount =1;
    self.image = GetImage(@"6");
    [self startAnimating];
    
    [NSTimer scheduledTimerWithTimeInterval:2.9 target:self selector:@selector(doAnimation) userInfo:nil repeats:YES];
}
-(void)doAnimation{
    if (!self.isAnimating) {
        [self startAnimating];
    }
    
}
@end
