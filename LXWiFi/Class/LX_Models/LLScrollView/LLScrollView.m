//
//  LLScrollView.m
//  乐享WiFi
//
//  Created by keyrun on 14-10-13.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LLScrollView.h"

@implementation LLScrollView
{
    UIPageControl *pageControl ;
    UIScrollView *_scrollView ;
    int currentPage ;
    int maxPage;
}
-(id)initWithFrame:(CGRect)frame WithPageArray:(NSArray *)viewArr andPageControlFrame:(CGRect) ctlFrame llScrollBlock:(LLScrollBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
        
        _copyBlock = [block copy];
        
        maxPage = viewArr.count ;
        currentPage = 0;
        pageControl = [[UIPageControl alloc] initWithFrame:ctlFrame];
        pageControl.numberOfPages = viewArr.count ;
        pageControl.pageIndicatorTintColor = ColorRGB(255.0, 255.0, 255.0, 0.5);
        pageControl.currentPageIndicatorTintColor = kWitheColor;
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate =self;
        _scrollView.showsVerticalScrollIndicator = NO ;
        
        for (int i=0; i< viewArr.count; i++) {
            UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width *i, 0, frame.size.width, frame.size.height)];
            imageView.image = [viewArr objectAtIndex:i];
            [_scrollView addSubview:imageView];
        }
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTipScrollViewContent)];
        [self addGestureRecognizer:tap];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changeContentOffx) userInfo:nil repeats:YES];
        [_scrollView setContentMode:UIViewContentModeTop];
        [_scrollView setContentOffset:CGPointMake(0, 0)];
        [self addSubview:_scrollView];
        [self addSubview:pageControl];
    }
    return self;
}
-(void) onTipScrollViewContent {
    _copyBlock(currentPage);
}
-(void) changeContentOffx {
    currentPage ++ ;
    if (currentPage == maxPage) {
        currentPage = 0;
    }
    pageControl.currentPage = currentPage ;

    dispatch_async(dispatch_get_main_queue(), ^{
        [_scrollView setContentOffset:CGPointMake(kmainScreenWidth *currentPage , 0) animated:YES];
    });
    
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageControl.currentPage = scrollView.contentOffset.x / (kmainScreenWidth) ;
}
@end
