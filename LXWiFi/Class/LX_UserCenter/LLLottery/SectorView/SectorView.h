//
//  SectorView.h
//  免费流量王
//
//  Created by keyrun on 14-10-24.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectorView : UIView
{
    CGPoint center ;
}
@property (nonatomic ,strong) UIColor *bgColor ;
@property (nonatomic ,assign) float radius ;
-(instancetype)initWithFrame:(CGRect)frame andSectorRadius:(float)radius ;
-(void) loadLotteryReward:(NSString *)rewards andTextColor:(UIColor *)textColor ;

- (void) loadLotteryReward:(NSArray *)rewardArr;
@end
