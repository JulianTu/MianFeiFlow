//
//  TaskFootView.m
//  免费流量王
//
//  Created by keyrun on 14-11-13.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "TaskFootView.h"

@implementation TaskFootView

@synthesize taskTip =_taskTip ;

-(instancetype)initWithFrame:(CGRect)frame WithBlock:(TaskFootViewBlock)block{
    self =[super initWithFrame:frame];
    if (self) {
        _copyBlock =[block copy];
        self.backgroundColor = kWitheColor;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, 5.0f)];
        lineView.backgroundColor = kBlockBackground2_0;
        [self addSubview:lineView];
        
        _taskTip =[[UnderLineLabel alloc] initWithFrame:CGRectMake(0, (frame.size.height -5.0f)/2 -6.0f, kmainScreenWidth, 20.0)];
        _taskTip.font = GetFont(12.0f);
        _taskTip.textColor = ColorRGB(155.0, 155.0, 155.0, 1) ;
        _taskTip.highlightedColor = ColorRGB(230, 230, 230, 1) ;
        _taskTip.shouldUnderline = YES;
        _taskTip.userInteractionEnabled =YES;
        [_taskTip setText:@"做任务没有收到流量币奖励?" andCenter:CGPointMake(kmainScreenWidth/2, 30)];
        [_taskTip sizeToFit];
        _taskTip.frame =CGRectMake( kmainScreenWidth/2 -_taskTip.frame.size.width/2, (frame.size.height -CGRectGetHeight(lineView.frame))/2 -6.0f, _taskTip.frame.size.width, _taskTip.frame.size.height);

        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkChargeRules:)];
        [_taskTip addGestureRecognizer:tap];
        
        UITapGestureRecognizer *tap2 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkChargeRules:)];
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(_taskTip.frame.origin.x -10, _taskTip.frame.origin.y -5, _taskTip.frame.size.width +20.0f, _taskTip.frame.size.height +10.0f)];
        [view addGestureRecognizer:tap2];
        [self addSubview:view];
        [self addSubview:_taskTip];
        
    }
    return self;
}
-(void)checkChargeRules:(UITapGestureRecognizer *)tapGest{
    if(tapGest.state == UIGestureRecognizerStateEnded){
        _taskTip.backgroundColor =ColorRGB(230, 230, 230, 1);
        double delayInSeconds = 0.1;
        dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_queue_t concurrentQueue = dispatch_get_main_queue();
        dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
            [_taskTip setBackgroundColor:[UIColor clearColor]];
        });

    }
    _copyBlock() ;
}
@end
