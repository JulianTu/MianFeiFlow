//
//  TablePullToLoadingView.m
//  91TaoJin
//
//  Created by keyrun on 14-5-26.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "TablePullToLoadingView.h"

@implementation TablePullToLoadingView

- (id)init{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, kTableLoadingViewHeight2_0)];
    if (self) {
        UIImageView *_animation = [[UIImageView alloc] init];
        CGSize imgSize = [UIImage imageNamed:@"bottom1"].size;
        _animation.frame = CGRectMake(kmainScreenWidth/2 - imgSize.width/2, self.frame.size.height/2 - imgSize.height/2, imgSize.width, imgSize.height);
        NSMutableArray *arrayImage = [[NSMutableArray alloc] init];
        for (int i = 1; i < 9; i ++) {
            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"bottom%d",i]];
            if (image) {
                [arrayImage addObject:image];
            }
            
        }
        _animation.animationImages = arrayImage;
        _animation.animationDuration = 0.8;
        [self addSubview:_animation];
        [_animation startAnimating];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *_animation = [[UIImageView alloc] init];
        CGSize imgSize = [UIImage imageNamed:@"bottom1"].size;
        _animation.frame = CGRectMake(kmainScreenWidth/2 - imgSize.width/2, frame.size.height/2 - imgSize.height/2, imgSize.width, imgSize.height);
        NSMutableArray *arrayImage = [[NSMutableArray alloc] init];
        for (int i = 1; i < 9; i ++) {
            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"bottom%d",i]];
            if (image) {
                [arrayImage addObject:image];
            }
            
        }
        _animation.animationImages = arrayImage;
        _animation.animationDuration = 0.8;
        [self addSubview:_animation];
        [_animation startAnimating];
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
