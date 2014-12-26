//
//  LLPageControl.m
//  免费流量王
//
//  Created by keyrun on 14-11-3.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LLPageControl.h"
#import "TaoJinButton.h"
#define kDianSize      5.0f

@implementation LLPageControl
@synthesize currentColor =_currentColor ;
@synthesize currentPage = _currentPage ;
@synthesize pageTintColor =_pageTintColor ;
-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        array = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self ;
}
-(void)setPageCount:(int )pageCount{
    _pageCount =pageCount;
    float firstOneX = kmainScreenWidth/2 - (pageCount *kDianSize)/2 -(pageCount -1)*kDianSize/2;
    for (TaoJinButton *btn in array) {
        [btn removeFromSuperview];
    }
    [array removeAllObjects];

    for (int i=0; i <pageCount; i++) {
        TaoJinButton *dianBtn = [[TaoJinButton alloc] initWithFrame:CGRectMake(firstOneX +2*kDianSize*i, 0, kDianSize, kDianSize)];
        dianBtn.tag =i +100;
        dianBtn.layer.masksToBounds =YES ;
        dianBtn.layer.cornerRadius = kDianSize/2 ;
        [array addObject:dianBtn];
        [self addSubview:dianBtn];
    }
    if (pageCount ==1) {
        self.hidden =YES;
    }else{
        self.hidden =NO;
    }
}
-(void)setCurrentPage:(int)currentPage{
    _currentPage = currentPage ;
    for (TaoJinButton *btn in array) {
        btn.backgroundColor = btn.tag ==100 +currentPage ? _currentColor : _pageTintColor;
    }

}
-(void)setPageTintColor:(UIColor *)pageTintColor{
    _pageTintColor =pageTintColor ;
    for (TaoJinButton*btn in array) {
        btn.backgroundColor =pageTintColor ;
    }
}
-(void)setCurrentColor:(UIColor *)currentColor {
    _currentColor =currentColor ;

    [(TaoJinButton *)[self viewWithTag:_currentPage +100] setBackgroundColor:currentColor];

    
}
@end
