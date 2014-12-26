//
//  LoadingView.m
//  91淘金
//
//  Created by keyrun on 13-11-13.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView
    

static UIImageView *_animation = nil;
static UIActivityIndicatorView *activityView =nil;

+(id)showLoadingView{
    static LoadingView *loadingView = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        loadingView = [[self alloc] init];
    });
    return loadingView;
}

//全局动画加载开始
-(void)actViewStartAnimation{
  /*
    if(_animation != nil)
        [self actViewStopAnimation];
    
    _animation = [[UIImageView alloc] init];
    CGSize imgSize = [UIImage imageNamed:@"loadingView1.png"].size;
    _animation.frame = CGRectMake(kmainScreenWidth/2 - imgSize.width/2, kmainScreenHeigh/2 - imgSize.height/2, imgSize.width, imgSize.height);
    NSMutableArray *arrayImage = [[NSMutableArray alloc] init];
    for (int i = 1; i < 9; i ++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"loadingView%d.png",i]];
        [arrayImage addObject:image];
    }
    _animation.animationImages = arrayImage;
    _animation.animationDuration = 0.8;
    _animation.animationRepeatCount = 0;
   
    [win addSubview:_animation];
//    [_animation startAnimating];
    */
    UIWindow *win = [[UIApplication sharedApplication].windows lastObject];
    if (activityView !=nil) {
        [self actViewStopAnimation];
    }
    activityView =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.backgroundColor =[UIColor clearColor];
    activityView.center = CGPointMake(kmainScreenWidth/2, kmainScreenHeigh/2);
    activityView.color =[UIColor lightGrayColor];
    activityView.hidesWhenStopped =YES;
    [activityView startAnimating];
    [win addSubview:activityView];
    
}

//加载动画结束
-(void)actViewStopAnimation{
    if(activityView){
        [activityView stopAnimating];
        [activityView removeFromSuperview];
        activityView = nil;
    }
}
-(BOOL)actViewIsAnimation {
    return activityView.isAnimating ;
}
@end






