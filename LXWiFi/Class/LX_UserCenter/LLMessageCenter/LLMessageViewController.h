//
//  LLMessageViewController.h
//  免费流量王
//
//  Created by keyrun on 14-10-15.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCell.h"
#import "HPGrowingTextView.h"
@interface LLMessageViewController : UIViewController <UITableViewDataSource ,UITableViewDelegate ,MessageCellDelegate ,HPGrowingTextViewDelegate ,UIImagePickerControllerDelegate,UIActionSheetDelegate ,UINavigationControllerDelegate>

@end
