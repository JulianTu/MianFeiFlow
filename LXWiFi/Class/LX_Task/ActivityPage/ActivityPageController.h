//
//  ActivityPageController.h
//  免费流量王
//
//  Created by keyrun on 14-10-25.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityPageController : UIViewController <UIWebViewDelegate>

@property (nonatomic ,strong) NSString *activityUrl ;    //活动页地址
@property (nonatomic ,assign) BOOL isPush;
-(void) initWebView;
@end
