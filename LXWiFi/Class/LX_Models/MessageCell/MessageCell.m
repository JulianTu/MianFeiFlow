//
//  MessageCell.m
//  TJiphone
//
//  Created by keyrun on 13-10-9.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "MessageCell.h"
#import "SDImageView+SDWebCache.h"
#import "MyUserDefault.h"
#import "UIImage+ColorChangeTo.h"
#import "NSString+emptyStr.h"

#define kHeadWidth 45   //头像大小
#define kTCoffY  16.0  //时间和文本间隔 上下
#define kICoffx   10.0  //头像和文本间隔  左右
#define kTimeH  11.0  //时间高度
#define kTimeOffy    15.0f


#define kKCoffY 15.0   //框和文字 y间距
#define kKCoffX 15.0   //框和文字 x 间距
#define kHKoffx 10.0  // 头像和框 间距
#define kContentWidth    kmainScreenWidth -kHeadWidth- 2*kOffX_2_0 -kHKoffx -kKCoffX *2 // 消息内容宽度
@implementation MessageCell
{
    UILabel* _msgText;
    UILabel* label;
    UIImageView* _bgImageview;
    UIButton* _deleteImage;
    UILabel* _textLabel2;
    UIImageView* _arrowImage;
}
@synthesize rtLab =_rtLab ;
@synthesize deleteImage =_deleteImage;
@synthesize bgImageview =_bgImageview;
@synthesize isOneDay =_isOneDay ;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 11.0)];
        _timeLab.numberOfLines =1;
        _timeLab.backgroundColor =[UIColor clearColor];
        _timeLab.font =[UIFont systemFontOfSize:11.0];
        _timeLab.textAlignment=NSTextAlignmentCenter;
        _timeLab.textColor =KGrayColor2_0;
        _timeLab.hidden =NO;
        
        _msgText =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kContentWidth, 14.0)];
        _msgText.numberOfLines =0;
        _msgText.font =[UIFont systemFontOfSize:14.0];
        _msgText.lineBreakMode =NSLineBreakByWordWrapping;
        _msgText.backgroundColor =[UIColor clearColor];
        _msgText.frame =CGRectMake(0, 0, kContentWidth, 0);
        _msgText.textColor =kWitheColor;
        _msgText.hidden =YES;
        _msgText.userInteractionEnabled = YES;
        
        _rtLab = [[RTLabel alloc]initWithFrame:CGRectMake(0, 0, kContentWidth, 0)];
        _rtLab.hidden =YES ;
        _rtLab.delegate =self;
        _rtLab.userInteractionEnabled =YES;
        _rtLab.backgroundColor =[UIColor clearColor];
        
        _iconImage =[[UIImageView alloc] init];
        
        _bgImageview =[[UIImageView alloc]init];
        _bgImageview.tag =1000;
        _bgImageview.userInteractionEnabled =YES;
        
        UILongPressGestureRecognizer* gesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onClickCellImageView:)];
        [_bgImageview addGestureRecognizer:gesture];
        UILongPressGestureRecognizer* gesture2 =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onClickCellImageView:)];
        [_rtLab addGestureRecognizer:gesture2];
        UILongPressGestureRecognizer* gesture3 =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onClickCellImageView:)];
        [_msgText addGestureRecognizer:gesture3];
        
        [self.contentView addSubview:_timeLab];
        [self.contentView addSubview:_iconImage];
        [self.contentView addSubview:_bgImageview];
        [self.contentView addSubview:_msgText];
        [self.contentView addSubview:_rtLab];
        
    }
    return self;
}
-(UIButton *) loadAskQuestionBtnWith:(CGRect) frame withTitle:(NSString *)title andFont:(UIFont *)font{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =frame;
    [btn setBackgroundImage:[UIImage createImageWithColor:KGreenColor2_0] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage createImageWithColor:kSelectGreen] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font =font;
    return btn;
}
-(void)initAskBtn{
    UIButton *askBtn = [self loadAskQuestionBtnWith:CGRectMake(kOffX_float, kOffX_float, kmainScreenWidth -2* kOffX_float, 40) withTitle:@"我要提问" andFont:[UIFont systemFontOfSize:16.0]];
    [askBtn addTarget:self action:@selector(onClickedAskBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:askBtn];
    
}
-(void)onClickedAskBtn{
    [self.mcDelegate onClickAskBtn];
}
-(void)initMessageCellContentWith:(SysMessage *)message WithBlock:(msgCellBlock)block{
    _copyBlock = [block copy];
    CGSize newSize ;
    self.msg =message;
    if (_isOneDay ==NO) {
        NSString* timestr =self.msg.msgTime;
        _timeLab.text =timestr;
        [_timeLab sizeToFit];
        _timeLab.frame =CGRectMake(0, kTimeOffy, kmainScreenWidth, _timeLab.frame.size.height);
        _timeLab.hidden = NO;
    }else{
        _timeLab.hidden =NO;
        _timeLab.frame =CGRectMake(0, 0, kmainScreenWidth, _timeLab.frame.size.height);
    }
    
    
    if (message.type ==MessageTypeMe) {
        _msgText.hidden =NO;
        _rtLab.hidden =YES;
        _msgText.textColor =KBlockColor2_0;
        if ([[MyUserDefault standardUserDefaults] getUserPic]) {
            _iconImage.image =[UIImage imageWithData:[[MyUserDefault standardUserDefaults] getUserPic]];
            
        }else{
            NSString *iconStr =[[MyUserDefault standardUserDefaults] getUserIconUrl];
            [_iconImage setImageWithURL:[NSURL URLWithString:iconStr] refreshCache:NO needSetViewContentMode:false needBgColor:false placeholderImage:GetImage(@"usertx")];
        }
        _iconImage.frame =CGRectMake(kmainScreenWidth - kOffX_2_0 -kHeadWidth , _timeLab.frame.origin.y +_timeLab.frame.size.height +kTCoffY, kHeadWidth, kHeadWidth);
    }else{
        _msgText.hidden =YES;
        _rtLab.hidden =NO;
        [_rtLab setText:self.msg.msgCom];
         newSize = [_rtLab optimumSize];
        _iconImage.image = GetImage(@"touxiangsmall");
        _iconImage.frame =CGRectMake(kOffX_2_0 , _timeLab.frame.origin.y +_timeLab.frame.size.height +kTCoffY, kHeadWidth, kHeadWidth);
        _rtLab.frame =CGRectMake(_iconImage.frame.origin.x +kHeadWidth +kHKoffx +kKCoffX, _iconImage.frame.origin.y +kKCoffY,kContentWidth, newSize.height);
    }
    _iconImage.layer.masksToBounds = YES ;
    _iconImage.layer.cornerRadius = _iconImage.frame.size.width /2 ;

    
    UIImage *bgImage ;
    
    NSString *appendStr;
    if (self.msg.msgPicNum !=0) {   // 如果消息有图片 在文字前加上“图片”
        NSString *str =[[NSString alloc] init];
        for (int i =0;  i< self.msg.msgPicNum;  i++) {
            str =[str stringByAppendingString:@"[图片]"];
        }
        appendStr =[str stringByAppendingString:self.msg.msgCom];
        _msgText.text = appendStr;
    }else{
        _msgText.text =self.msg.msgCom;
    }
//    NSLog(@" messgaeCell text %@",self.msg.msgCom);
    [_msgText sizeToFit];
    
    if (_msg.type == MessageTypeMe) {
        
        _msgText.frame =CGRectMake(kmainScreenWidth - kOffX_2_0 -kHeadWidth - kHKoffx -kKCoffX -_msgText.frame.size.width , _iconImage.frame.origin.y +kKCoffY, kContentWidth, _msgText.frame.size.height);
        bgImage =GetImageWithName(@"msgBgImageMe");
        bgImage =[bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(bgImage.size.height - 5.0, bgImage.size.width *0.5, 4.0, bgImage.size.width *0.4) resizingMode:UIImageResizingModeStretch];
        _bgImageview.image =bgImage;
        
        
    }else{
        
//        _msgText.frame =CGRectMake(_iconImage.frame.origin.x +kHeadWidth +kHKoffx +kKCoffX, _iconImage.frame.origin.y +kKCoffY, kContentWidth, _msgText.frame.size.height);
        
        bgImage =GetImageWithName(@"msgBgImageSys");
        bgImage =[bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(bgImage.size.height - 5.0, bgImage.size.width *0.5, 4.0, bgImage.size.width *0.4) resizingMode:UIImageResizingModeStretch];
        _bgImageview.image =bgImage;
        _bgImageview.frame =CGRectMake(_rtLab.frame.origin.x -kKCoffX, _iconImage.frame.origin.y, kmainScreenWidth -2 *kOffX_2_0 -kHeadWidth-kHKoffx, _rtLab.frame.size.height +2 *kKCoffY);
        
    }
    
    if (_msgText.frame.size.height < 30.0) {
        _bgImageview.frame =CGRectMake(_bgImageview.frame.origin.x, _bgImageview.frame.origin.y, _bgImageview.frame.size.width, kHeadWidth);
        _msgText.frame =CGRectMake(_msgText.frame.origin.x, _msgText.frame.origin.y, 0, 14.0);
        [_msgText sizeToFit];
        
        if (_msg.type ==MessageTypeMe) {
            
            float bgWidth =_msgText.frame.size.width +2 *kKCoffX ;
            _bgImageview.frame =CGRectMake(_iconImage.frame.origin.x -kHKoffx -bgWidth , _iconImage.frame.origin.y, bgWidth, _msgText.frame.size.height + 2 *kKCoffY);
        }else{
            _bgImageview.frame =CGRectMake(_bgImageview.frame.origin.x, _bgImageview.frame.origin.y, _msgText.frame.size.width + 2*kKCoffX, kHeadWidth);
        }
    }else{
        if (_msg.type ==MessageTypeMe) {
            _bgImageview.frame =CGRectMake(kOffX_2_0, _iconImage.frame.origin.y, kmainScreenWidth -2 *kOffX_2_0 -kHeadWidth -kICoffx, _msgText.frame.size.height +2 *kKCoffY);
            
            _msgText.frame = CGRectMake(_bgImageview.frame.origin.x +kKCoffX, _msgText.frame.origin.y, _msgText.frame.size.width, _msgText.frame.size.height);
        }
        
    }
    if (newSize.height < 30.0) {
        if (_msg.type == MessageTypeOther) {
            _bgImageview.frame =CGRectMake(_bgImageview.frame.origin.x, _bgImageview.frame.origin.y, newSize.width + 2*kKCoffX, kHeadWidth);
            
        }
    }
   

}
-(void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url{
    NSLog(@" 超链接 %@ %@",url.relativeString ,self.msg.msgJumpType);
//    _copyBlock(url.relativeString);
    
    NSString *type = self.msg.msgJumpType ;
    if ([type isEqualToString:@"普通"]) {
        
    }else if ([type isEqualToString:@"奖品"]){
        NSDictionary *dic =@{@"pri":[NSNumber numberWithInt:self.msg.msgJumpId]};
        [self.mcDelegate onClickedJumpToReward:dic];
    }else if ([type isEqualToString:@"活动"]){
        NSDictionary *dic =@{@"act":self.msg.msgJumpUrl};
        [self.mcDelegate onClickedJumpToActivity:dic];
    }else if ([type isEqualToString:@"任务"]){
        [self.mcDelegate onClickedJumpToMission:nil];
    }
    
}
-(void)onClickCellImageView:(UILongPressGestureRecognizer *)longPress{
    
    if (longPress.state ==UIGestureRecognizerStateBegan) {
        [self.mcDelegate getLongPressGestureRecognizer:self.msg.msgId andCellTag:self.celltag];
    }
    
    
}

-(float)getMessageCellHeight{
    float height =0;
    
    if (_bgImageview.frame.size.height <= kHeadWidth ) {
        height = _iconImage.frame.origin.y +_iconImage.frame.size.height;
    }
    else{
        height = _bgImageview.frame.origin.y+_bgImageview.frame.size.height;
    }

    return height;
}
-(void)prepareForReuse{
    if (_msg.type == MessageTypeOther) {
        _msgText.hidden =YES;
    }else{
        _rtLab.hidden =YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
