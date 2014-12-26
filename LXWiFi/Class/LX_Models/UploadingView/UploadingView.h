//
//  UploadingView.h
//  免费流量王
//
//  Created by keyrun on 14-11-17.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadingView : UIView

+(UploadingView *)shareUploadView ;
-(void) showWithText:(NSString *)text andViewControler:(UIViewController *)vc;
-(void) dismiss;
-(BOOL) isUploading;
@end
