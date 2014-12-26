//
//  MessageCell.h
//  TJiphone
//
//  Created by keyrun on 13-10-9.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SysMessage.h"
#import "MessageFrame.h"
#import "RTLabel.h"
#define kTextColor [UIColor colorWithRed:105.0/255.0 green:66.0/255.0 blue:15.0/255.0 alpha:1]
@protocol MessageCellDelegate <NSObject>

@optional
-(void)getLongPressGestureRecognizer:(int )msgid andCellTag:(int) tag;
-(void)onClickDeleteBtn:(int )msgid andCellTag:(int)tag;

-(void) onClickAskBtn;

@required
-(void) onClickedJumpToReward:(NSDictionary *)dataDic;
-(void) onClickedJumpToActivity:(NSDictionary *)dataDic;
-(void) onClickedJumpToMission:(NSDictionary *)dataDic ;

@end

 typedef void(^msgCellBlock)(NSString *jumpUrl);

@interface MessageCell : UITableViewCell <RTLabelDelegate>
{
    msgCellBlock _copyBlock ;
}
@property (weak, nonatomic) IBOutlet UIImageView *cellBGImage2;
@property (weak, nonatomic) IBOutlet UILabel *cellContent;
@property (weak, nonatomic) IBOutlet UIImageView *cellBGImage;
@property (weak, nonatomic) IBOutlet UILabel *cellTime;
@property (weak, nonatomic) IBOutlet UIImageView *cellHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *cellName;
@property(nonatomic,strong) NSDictionary* cellDic;
@property(nonatomic,assign) int celltag;

@property(nonatomic,strong)UIImageView* arrowImage;

@property(nonatomic,strong) UIButton* contentBtn;
@property (nonatomic ,strong) UIImageView *iconImage;
@property (nonatomic ,strong) UILabel *timeLab;

@property(nonatomic,strong) UIImageView* bgImageview;
@property(nonatomic,strong)UIButton* deleteImage;

@property(nonatomic,strong)UILabel* name;
@property(nonatomic,strong)UILabel* time;
@property (nonatomic,strong) SysMessage* msg;
@property (nonatomic,assign) BOOL isOneDay;

@property (nonatomic ,strong) RTLabel *rtLab;       //带下划线超链接文本
@property (nonatomic ,strong) UILabel* msgText;

@property (nonatomic ,strong) MessageFrame *messageFrame;
@property (nonatomic,strong) id<MessageCellDelegate> mcDelegate;
-(void)initMessageCellContentWith:(SysMessage *)message WithBlock:(msgCellBlock) block;
-(float)getMessageCellHeight;
-(void)initAskBtn;
@end
