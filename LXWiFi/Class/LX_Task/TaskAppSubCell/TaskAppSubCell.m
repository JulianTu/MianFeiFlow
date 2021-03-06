//
//  TaskAppSubCell.m
//  91TaoJin
//
//  Created by keyrun on 14-5-13.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "TaskAppSubCell.h"
#import "UIImage+ColorChangeTo.h"
#import "NSString+emptyStr.h"

@implementation TaskAppSubCell{
    UIImageView *phoneBackgroundView;                           //需要截图上传的背景（浅灰色部分）
//    UIImageView *phoneView;                                     //上传截图的背景（橙色或深灰色部分）
    UILabel *phoneLab;                                          //上传截图的文案
    int _state;
    
    UIImageView *lineView;
}

@synthesize beanLab = _beanLab;
@synthesize inforLab = _inforLab;
@synthesize installBtn = _installBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isShowSeparatedLine:(BOOL)isShowSeparatedLine isHideBeanLab:(BOOL)isHideBeanLab isShowBtn:(BOOL)isShowBtn isBlank:(BOOL)isBlank{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        if(!isShowBtn){
            if(isShowSeparatedLine){
                lineView = [[UIImageView alloc] initWithFrame:CGRectMake(kOffX_2_0, 0.0f, kmainScreenWidth - kOffX_2_0 * 2, 0.5f)];
                lineView.backgroundColor = kLineColor2_0;
                [self addSubview:lineView];
            }
            
            float height = 0.0f;
            if(isBlank)
                height = 5.0f;
            
            //            phoneView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)];
            //            phoneView.image = [UIImage createImageWithColor:KOrangeColor2_0];
            //            phoneView.hidden = YES;
            //            [self addSubview:phoneView];
            
            phoneLab = [self loadLabelWithFrame:CGRectMake(kmainScreenWidth - 50.0f - kOffX_2_0, 0.0f, 50.0f, 0.0f) textAlignment:NSTextAlignmentCenter];
            phoneLab.backgroundColor = KOrangeColor2_0;
            phoneLab.textColor = [UIColor whiteColor];
            phoneLab.hidden = YES;
            [self addSubview:phoneLab];
            
            phoneBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)];
            phoneBackgroundView.image = [UIImage createImageWithColor:KLightGrayColor2_0];
            phoneBackgroundView.hidden = YES;
            phoneBackgroundView.layer.cornerRadius = 2.0f;
            phoneBackgroundView.layer.masksToBounds =YES;
            [self addSubview:phoneBackgroundView];
            
            float y = lineView == nil ? 0.0f : lineView.frame.origin.y + lineView.frame.size.height;
            self.beanLab = [self loadLabelWithFrame:CGRectMake(kOffX_2_0, y + 3.0f + height, 50.0f, 11.0f) textAlignment:NSTextAlignmentRight];
            [self addSubview:self.beanLab];
            self.beanLab.hidden = isHideBeanLab;
            self.inforLab = [self loadLabelWithFrame:CGRectMake(self.beanLab.frame.origin.x + self.beanLab.frame.size.width + kOffX_2_0 + 9.0f, y + 2.0f + height, kmainScreenWidth - self.beanLab.frame.origin.x - self.beanLab.frame.size.width - kOffX_2_0 * 2, self.beanLab.frame.size.height) textAlignment:NSTextAlignmentLeft];
            [self addSubview:self.inforLab];
        }else{
            self.installBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.installBtn.frame = CGRectMake(kmainScreenWidth/2 -SendButtonWidth/2, 7.0f, SendButtonWidth, SendButtonHeight);
            [self.installBtn setBackgroundImage:[UIImage createImageWithColor:kBlueTextColor] forState:UIControlStateNormal];
            [self.installBtn setBackgroundImage:[UIImage createImageWithColor:kLightBlueTextColor] forState:UIControlStateHighlighted];
            self.installBtn.layer.masksToBounds = YES;
            self.installBtn.layer.cornerRadius = SendButtonHeight/2 ;
            [self.installBtn setTitle:@"安装/打开" forState:UIControlStateNormal];
            self.installBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [self addSubview:self.installBtn];
        }
    }
    return self;
}



/**
 *  初始化Label
 *
 *  @param frame         大小
 *  @param textAlignment 文案的排列方式
 *
 */
-(UILabel *)loadLabelWithFrame:(CGRect )frame textAlignment:(NSTextAlignment)textAlignment{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:11];
    label.textAlignment = textAlignment;
    label.numberOfLines = 0;
    return label;
}

/**
 *  动态设置subCell的信息
 *
 *  @param beanNum          金豆数量
 *  @param rightTitleStr    右边文案
 *  @param state            表示正在完成还是已完成的状态(1：未完成；2：已完成；3：审核中)
 *  @param phoneTaskInfo    上传截图的任务说明
 */
-(void)setTaskAppSubCellWithBeanNum:(int )beanNum rightTitleStr:(NSString *)rightTitleStr state:(int)state phoneTaskInfo:(NSString *)phoneTaskInfo{
    float height = 0.0f;
//    if([step isEqualToString:@"11"]){
//        height = 5.0f;
//    }
    _state = state;
    if(beanNum > 0 && (state == 1 || state == 3)){
        [_beanLab setText:[NSString stringWithFormat:@"+%d",beanNum]];
        _beanLab.textColor = KOrangeColor2_0;
    }else{
        [_beanLab setText:@"已完成"];
        _beanLab.textColor = kAppInforTextColor;
    }
    _beanLab.frame = CGRectMake(0.0f, _beanLab.frame.origin.y + height, 60.0f, 20.0f);
    [_inforLab setText:rightTitleStr];
    if(beanNum > 0){
        _inforLab.textColor = kBlueTextColor;
    }else{
        _inforLab.textColor = kAppInforTextColor;
    }
    [_inforLab sizeToFit];
    if(state == 3){
        if(![NSString isEmptyString:phoneTaskInfo]){
            //【审核中】
            _inforLab.frame = CGRectMake(_inforLab.frame.origin.x, _inforLab.frame.origin.y + height, kmainScreenWidth - self.beanLab.frame.origin.x - self.beanLab.frame.size.width - kOffX_2_0 * 2 - phoneLab.frame.size.width, _inforLab.frame.size.height + 8.0f);
            [_inforLab sizeToFit];
            _inforLab.frame = CGRectMake(_inforLab.frame.origin.x, _inforLab.frame.origin.y, kmainScreenWidth - self.beanLab.frame.origin.x - self.beanLab.frame.size.width - kOffX_2_0 * 2 - phoneLab.frame.size.width, _inforLab.frame.size.height + 8.0f);
            _inforLab.textColor = KOrangeColor2_0;
            phoneBackgroundView.hidden = NO;
            phoneLab.hidden = NO;
            phoneLab.text = @"审核中";
            phoneLab.backgroundColor = kAppInforTextColor;
        }
    }else if(state == 1){
        if(![NSString isEmptyString:phoneTaskInfo]){
            //【上传截图】
            _inforLab.frame = CGRectMake(_inforLab.frame.origin.x, _inforLab.frame.origin.y + height, kmainScreenWidth - self.beanLab.frame.origin.x - self.beanLab.frame.size.width - kOffX_2_0 * 2 - phoneLab.frame.size.width, _inforLab.frame.size.height + 8.0f);
            [_inforLab sizeToFit];
            _inforLab.frame = CGRectMake(_inforLab.frame.origin.x, _inforLab.frame.origin.y , kmainScreenWidth - self.beanLab.frame.origin.x - self.beanLab.frame.size.width - kOffX_2_0 * 2 - phoneLab.frame.size.width, _inforLab.frame.size.height + 8.0f);
            _inforLab.textColor = KOrangeColor2_0;
            phoneBackgroundView.hidden = NO;
            phoneLab.hidden = NO;
            phoneLab.text = @"上传截图";
            phoneLab.backgroundColor = KOrangeColor2_0;
        }else{
            //【未完成】
            _inforLab.frame = CGRectMake(_inforLab.frame.origin.x , _inforLab.frame.origin.y + height, kmainScreenWidth - self.beanLab.frame.origin.x - self.beanLab.frame.size.width - kOffX_2_0 * 2 -phoneLab.frame.size.width, _inforLab.frame.size.height + 8.0f);
            [_inforLab sizeToFit];
            _inforLab.frame = CGRectMake(_inforLab.frame.origin.x , _inforLab.frame.origin.y , kmainScreenWidth - self.beanLab.frame.origin.x - self.beanLab.frame.size.width - kOffX_2_0 * 2 - phoneLab.frame.size.width, _inforLab.frame.size.height + 8.0f);
            _inforLab.textColor = KGreenColor2_0;
            phoneBackgroundView.hidden = YES;
            phoneLab.hidden = YES;
        }
    }else if(state == 2){
        //【已完成】
        _inforLab.frame = CGRectMake(_inforLab.frame.origin.x , _inforLab.frame.origin.y + height, kmainScreenWidth - self.beanLab.frame.origin.x - self.beanLab.frame.size.width - kOffX_2_0 * 2 -phoneLab.frame.size.width, _inforLab.frame.size.height + 8.0f);
        [_inforLab sizeToFit];
        _inforLab.frame = CGRectMake(_inforLab.frame.origin.x , _inforLab.frame.origin.y , kmainScreenWidth - self.beanLab.frame.origin.x - self.beanLab.frame.size.width - kOffX_2_0 * 2 -phoneLab.frame.size.width, _inforLab.frame.size.height + 8.0f);
        _inforLab.textColor = KGrayColor2_0;
        phoneBackgroundView.hidden = YES;
        phoneLab.hidden = YES;
    }
    phoneBackgroundView.frame = CGRectMake(_inforLab.frame.origin.x - 4.0f, _inforLab.frame.origin.y, _inforLab.frame.size.width, _inforLab.frame.size.height);

    phoneLab.frame = CGRectMake(phoneLab.frame.origin.x, phoneBackgroundView.frame.origin.y, phoneLab.frame.size.width, phoneBackgroundView.frame.size.height);
    
}

/**
 *  设置描述内容
 *
 *  @param description 描述的内容
 */
-(void)setTaskAppSubCellWithDescription:(NSString *)description{
    [_inforLab setText:description];
    _inforLab.textColor = KRedColor2_0;
    [_inforLab sizeToFit];
    _inforLab.frame = CGRectMake(_inforLab.frame.origin.x, 7.0f, kmainScreenWidth - 60.0f - kOffX_2_0 * 2, _inforLab.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if(selected){
        phoneLab.highlighted = YES;
        phoneBackgroundView.highlighted = YES;
    }
    // Configure the view for the selected state
}


-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (_state == 1) {
        if(highlighted){
            phoneLab.backgroundColor = KLightOrangeColor2_0;
            phoneBackgroundView.image = [UIImage createImageWithColor:kBlockBackground2_0];
        }else{
            phoneLab.backgroundColor = KOrangeColor2_0;
            phoneBackgroundView.image = [UIImage createImageWithColor:KLightGrayColor2_0];
        }
    }
}
@end













