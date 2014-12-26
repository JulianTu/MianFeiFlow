//
//  LLPageControl.h
//  免费流量王
//
//  Created by keyrun on 14-11-3.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLPageControl : UIView
{
    NSMutableArray *array;
}
@property (nonatomic ,assign) int pageCount ;
@property (nonatomic ,strong) UIColor *currentColor ;
@property (nonatomic ,strong) UIColor *pageTintColor ;
@property (nonatomic ,assign) int currentPage;
@end
