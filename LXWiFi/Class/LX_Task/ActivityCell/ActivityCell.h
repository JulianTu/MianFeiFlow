//
//  ActivityCell.h
//  免费流量王
//
//  Created by keyrun on 14-10-29.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLScrollView.h"
@interface ActivityCell : UITableViewCell <UIScrollViewDelegate>
{
    NSArray *actArray ;
}
@property (nonatomic ,strong) LLScrollView *activityView;
@property (nonatomic ,strong)  NSTimer*timer;
@property (nonatomic ,strong) UIScrollView *activityScroll ;
-(void) loadContentWithData:(NSArray *)images ;
@end
