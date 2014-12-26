//
//  LXUserCenterController.h
//  乐享WiFi
//
//  Created by keyrun on 14-9-17.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLUserCenterCell.h"
#import "MScrollVIew.h"
@interface LXUserCenterController : UIViewController <UITableViewDataSource ,UITableViewDelegate ,UserCenterCellDelegate ,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MScrollVIewDelegate,UIAlertViewDelegate>
@property (nonatomic, assign) BOOL isRequesting; 
-(void)initDataSource;
@end
