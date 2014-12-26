//
//  LLCtrBtn.h
//  乐享WiFi
//
//  Created by keyrun on 14-10-13.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLCenterItem : UIView

@property (nonatomic ,strong) UIImageView *itemImg ;
@property (nonatomic ,strong) UILabel *itemNameLab ;

@property (nonatomic ,strong) UIButton *itemBtn ;

@property (nonatomic ,strong) UIImageView *itemHotImg ;   // hot 图片

@property (nonatomic ,strong) UILabel *itemMsgLab ;      // 消息数

@property (nonatomic ,strong) UILabel *itemIcomLab ;     // 收支金币数

-(id)initWithFrame:(CGRect)frame itemImage:(UIImage *)image itemName:(NSString *)name ;
@end
