//
//  LLScrollView.h
//  乐享WiFi
//
//  Created by keyrun on 14-10-13.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
 typedef void(^LLScrollBlock)(int currentPage);

@interface LLScrollView : UIView <UIScrollViewDelegate>
{
    LLScrollBlock _copyBlock ;
}
@property (nonatomic ,strong) UIScrollView *scrollView ;

-(id)initWithFrame:(CGRect)frame WithPageArray:(NSArray *)viewArr andPageControlFrame:(CGRect) ctlFrame llScrollBlock:(LLScrollBlock) block;

@end
