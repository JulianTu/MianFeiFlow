//
//  RecordProgressCell.h
//  免费流量王
//
//  Created by keyrun on 14-10-16.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoJinLabel.h"
@interface RecordProgressCell : UITableViewCell

@property (nonatomic ,strong) TaoJinLabel *titleLab ;
@property (nonatomic ,strong) TaoJinLabel *progressLab;         //进度数
@property (nonatomic ,strong) UIView *bgView ;
@property (nonatomic ,strong) UIView *progressView ;           // 进度条
@property (nonatomic ,strong) CALayer *lineLayer ;
-(void)loadProgressCellViewWith:(NSString *)title andColor:(UIColor *)color currentNum:(float) cNum andMaxNum:(float)mNum ;

@end
