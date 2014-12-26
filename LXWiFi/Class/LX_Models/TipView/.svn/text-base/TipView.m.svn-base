//
//  TipView.m
//  免费流量王
//
//  Created by keyrun on 14-11-19.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "TipView.h"
#define tipViewW   200.0f
#define tipViewH   100.0f
@interface TipView ()
@property (nonatomic ,strong) UIImageView *tipImg ;
@property (nonatomic ,strong) UILabel *tipLab ;
@property (nonatomic ,strong) UIView *blackView ;
@property (nonatomic ,strong)  UIWindow *overlayWindow ;
@property (nonatomic ,assign) BOOL isShowing ;
@end

@implementation TipView
@synthesize tipImg =_tipImg ;
@synthesize tipLab =_tipLab ;
@synthesize blackView =_blackView ;
@synthesize overlayWindow =_overlayWindow ;
@synthesize isShowing =_isShowing ;
+(TipView *)shareTipView {
    static TipView *tipview = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tipview =[[TipView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return tipview;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        _blackView = [[UIView alloc] initWithFrame:CGRectMake(kmainScreenWidth/2 -tipViewW/2, kmainScreenHeigh/2 -tipViewH/2, tipViewW, tipViewH)];
        _blackView.backgroundColor =[UIColor blackColor];
        _blackView.alpha =0.8f;
        _blackView.layer.cornerRadius =5.0f;
        _blackView.layer.masksToBounds =YES;
        
        _isShowing =NO;
        
        _tipImg =[[UIImageView alloc] initWithFrame:CGRectZero];
        
        _tipLab =[[UILabel alloc] initWithFrame:CGRectZero];
        _tipLab.backgroundColor =[UIColor clearColor];
        _tipLab.font = GetFont(16.0);
        _tipLab.textColor = kWitheColor;
        _tipLab.textAlignment =NSTextAlignmentCenter;
        
        _overlayWindow=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.userInteractionEnabled=NO;
        _overlayWindow.windowLevel=UIWindowLevelStatusBar;
        
        [_overlayWindow addSubview:self];
        [_overlayWindow makeKeyAndVisible];
        
        [self addSubview:_blackView];
        [self addSubview:_tipImg];
        [self addSubview:_tipLab];
        
    }
    return self ;
}
-(void) tipViewShowWithText:(NSString *)text andTipImage:(UIImage *)image {
    if (![[TipView shareTipView] isShowing]) {
        _overlayWindow.hidden =NO;
        _tipImg.image =image;
        _tipImg.frame =CGRectMake( kmainScreenWidth/2 -image.size.width/2, _blackView.frame.origin.y +15.0f, image.size.width, image.size.height);
        
        _tipLab.text = text;
        [_tipLab sizeToFit];
        _tipLab.frame = CGRectMake(kmainScreenWidth/2 -_tipLab.frame.size.width/2, _tipImg.frame.origin.y +_tipImg.frame.size.height +12.0f, _tipLab.frame.size.width, _tipLab.frame.size.height);
        _isShowing =YES;
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.0f];
    }
}
-(void)dismiss{
    _isShowing =NO;
    _overlayWindow.hidden =YES;
    
}
-(BOOL)showing{
    return _isShowing;
}


@end

