//
//  MessageViewController.h
//  TJiphone
//
//  Created by keyrun on 13-9-30.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCell.h"
#import "HPGrowingTextView.h"
@interface MessageViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,MessageCellDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UITextViewDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate ,UINavigationControllerDelegate ,HPGrowingTextViewDelegate ,UIWebViewDelegate>


@end
