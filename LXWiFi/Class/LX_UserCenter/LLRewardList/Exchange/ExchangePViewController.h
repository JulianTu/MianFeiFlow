//
//  ExchangePViewController.h
//  TJiphone
//
//  Created by keyrun on 13-9-28.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MScrollVIew.h"
@interface ExchangePViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIWebViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray* array;
 
    UITextField* phoneText;
    NSMutableArray* array2;
    int position;
}
@property(nonatomic,strong)UIImageView* imageView;
@property(nonatomic,assign)BOOL isRechargeQ;
@property(nonatomic,strong)NSString* rechargeType;
-(void)loadContentViews;
-(void)makeDashLine ;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tag:(int )tag;
@end
