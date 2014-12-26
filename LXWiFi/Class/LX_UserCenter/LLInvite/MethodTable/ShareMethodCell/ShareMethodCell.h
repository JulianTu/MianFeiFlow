//
//  ShareMethodCell.h
//  免费流量王
//
//  Created by keyrun on 14-10-16.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoJinLabel.h"

typedef enum{
    ShareTipTypeHot = 0,
    ShareTipTypeNew ,
    ShareTipTypeNo
}ShareTipType;

@interface ShareMethodCell : UITableViewCell

@property (nonatomic ,strong) TaoJinLabel *mTitle ;
@property (nonatomic ,strong) TaoJinLabel *mContent ;

@property (nonatomic ,strong) UIImageView *arrowImg ;  //热门标示图

-(void)loadMethodCellWith:(NSString *)title andContent:(NSString *)content withTipType:(ShareTipType)type;
@end
