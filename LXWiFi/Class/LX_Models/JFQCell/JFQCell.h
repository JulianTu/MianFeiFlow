//
//  JFQCell.h
//  免费流量王
//
//  Created by keyrun on 14-10-24.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFQClass.h"
#import "TaoJinButton.h"
typedef void(^JFQCellBlock)(TaoJinButton *btn);

@interface JFQCell : UITableViewCell <UIScrollViewDelegate>
{
    JFQCellBlock copyBlock ;
}
@property (nonatomic ,strong) UIScrollView *cellScroll ;
@property (nonatomic ,strong)  NSArray *jfqsArr ;
-(void) loadJFQCellWith:(NSArray *)jfqs withBlock:(JFQCellBlock) block;
@end
