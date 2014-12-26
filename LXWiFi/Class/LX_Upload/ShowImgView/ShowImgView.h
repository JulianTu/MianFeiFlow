//
//  ShowImgView.h
//  91TaoJin
//
//  Created by keyrun on 14-6-11.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoJinLabel.h"
@interface ShowImgView : UIView <UIScrollViewDelegate>
{
    UIPageControl *pc;
    TaoJinLabel *pageLab ;
    int maxPage; 
}
-(id)initWithImgListArr:(NSArray *)listArr;
-(void)showImages;
@end
