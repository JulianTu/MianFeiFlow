//
//  HongBaoView.h
//  免费流量王
//
//  Created by keyrun on 14-10-23.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoJinButton.h"

typedef  void(^HongBaoBlock)();
@interface HongBaoView : UIImageView
{
    HongBaoBlock _block ;
}
@property (nonatomic ,strong) TaoJinButton *button ;

-(instancetype)initWithFrame:(CGRect)frame andHongBaoBlock:(HongBaoBlock) block;
-(void)onClickedHongBao ;
@end
