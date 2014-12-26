//
//  LLCtrBtn.m
//  乐享WiFi
//
//  Created by keyrun on 14-10-13.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LLCenterItem.h"
#define kItemTextOffY  72.0f
#define kItemTextSize   15.0f
#define kItemImgOffY    30.0f
#define kItemLineW      0.5f
@implementation LLCenterItem
{
    UILabel *_itemNameLab ;
    UIImageView *_itemImg ;
    UIButton *_itemBtn ;
    UILabel *_itemMsgLab ;
    UIImageView *_itemHotImg ;
    UILabel *_itemIcomLab ;
}
-(id)initWithFrame:(CGRect)frame itemImage:(UIImage *)image itemName:(NSString *)name{
    self = [super initWithFrame:frame];
    if (self) {
        _itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _itemBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [_itemBtn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchDown];
        [_itemBtn addTarget:self action:@selector(revertColor:) forControlEvents:UIControlEventTouchUpInside];
        [_itemBtn addTarget:self action:@selector(revertColor:) forControlEvents:UIControlEventTouchUpOutside];
        [_itemBtn addTarget:self action:@selector(revertColor:) forControlEvents:UIControlEventTouchCancel];
        
        _itemNameLab = [self loadLabWithFrame:CGRectMake(0, kItemTextOffY, frame.size.width, kItemTextSize) name:name withColor:[UIColor blackColor]];
        
        _itemImg = [[UIImageView alloc] initWithImage:image];
        _itemImg.frame =CGRectMake(frame.size.width/2 -image.size.width, 30.0f, image.size.width, image.size.height);
        
        _itemIcomLab = [self loadLabWithFrame:CGRectMake(0, kItemTextOffY + _itemNameLab.frame.size.height + 7.0f, frame.size.width, kItemTextSize) name:@"" withColor:[UIColor orangeColor]];
        _itemIcomLab.font = GetBoldFont(16);
        _itemIcomLab.hidden = YES;
        
        _itemMsgLab = [self loadLabWithFrame:CGRectMake(_itemImg.frame.origin.x, _itemImg.frame.origin.y +(_itemImg.frame.size.height -11.0f)/2, _itemImg.frame.size.width, 11.0f) name:@"" withColor:[UIColor redColor]];
        _itemMsgLab.hidden =YES;

        //        _itemHotImg = [UIImageView alloc] initWithFrame:CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)
        // 大小根据手机尺寸变
        
        CALayer *rightLine = [self loadLayerWithFrame:CGRectMake(frame.size.width -kItemLineW, 0, kItemLineW, frame.size.height)];
        CALayer *bottomLine = [self loadLayerWithFrame:CGRectMake(0, frame.size.height -kItemLineW, frame.size.width, kItemLineW)];
        
        
        self.backgroundColor =[UIColor clearColor];
        
        [self addSubview:_itemImg];
        [self addSubview:_itemNameLab];
        [self addSubview:_itemIcomLab];
        [self addSubview:_itemMsgLab];
        [self.layer addSublayer:bottomLine];
        [self.layer addSublayer:rightLine];
//        [self addSubview:_itemBtn];
        
    }
    return self;
}
-(void)changeColor:(UIButton* )btn{
    
    _itemBtn.backgroundColor = kJFQSelctColor2_0;
}
-(void)revertColor:(UIButton* )btn{
    _itemBtn.backgroundColor =[UIColor clearColor];
}

-(CALayer *)loadLayerWithFrame:(CGRect)frame{
    CALayer *layer = [CALayer layer];
    [layer setBackgroundColor:[kLineColor2_0 CGColor]];
    [layer setFrame:frame];
    return layer;
}

-(UILabel *)loadLabWithFrame:(CGRect)frame name:(NSString *)name withColor:(UIColor *)color{
    UILabel *lab =[[UILabel alloc]initWithFrame:frame];
    lab.backgroundColor = [UIColor clearColor];
    lab.textAlignment = NSTextAlignmentCenter ;
    lab.textColor = color;
    lab.font = kFontSize_11 ;
    lab.text = name ;
    return lab ;
}
@end
