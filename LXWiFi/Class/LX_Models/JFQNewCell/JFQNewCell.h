//
//  JFQNewCell.h
//  免费流量王
//
//  Created by keyrun on 14-11-8.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoJinLabel.h"
#import "JFQClass.h"
 typedef void(^JFQNewCellBlock)(int index);

@interface JFQNewCell : UITableViewCell

{
    TaoJinLabel *label;
    UIView *lineView ;
    JFQNewCellBlock _copyBlock;
}
@property (nonatomic, strong) UIImageView *jfqIcon;
@property (nonatomic ,strong) TaoJinLabel *jfqName ;
@property (nonatomic ,strong) TaoJinLabel *jfqInfor ;
@property (nonatomic ,assign) int cellIndex;

-(void) initJFQNewCellWith:(JFQClass *)jfqClass andBlock:(JFQNewCellBlock)block;

@end
