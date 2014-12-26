//
//  ShareItem.h
//  免费流量王
//
//  Created by keyrun on 14-10-20.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoJinLabel.h"
@interface ShareItem : UIView

@property (nonatomic ,strong) UIImageView *itemIcon ;    //分享平台icon

@property (nonatomic ,strong) TaoJinLabel *itemTitle ;     //分享平台名字
@property (nonatomic ,strong) TaoJinLabel *itemShareReward ;      // 分享奖励   未分享
@property (nonatomic ,strong) UIImageView *itemSharedMark ;      // 已分享标记
@property (nonatomic ,strong) TaoJinLabel *itemShared  ;         //已分享


-(id)initWithFrame:(CGRect)frame andIconImg:(UIImage *)img title:(NSString *)title andReward:(NSString *)rewardNum ;
@end
