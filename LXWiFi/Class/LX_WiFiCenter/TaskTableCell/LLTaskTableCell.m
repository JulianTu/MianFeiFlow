//
//  LLTaskTableCell.m
//  乐享WiFi
//
//  Created by keyrun on 14-10-13.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LLTaskTableCell.h"
#import "TaoJinLabel.h"

@implementation LLTaskTableCell
{
    UIImageView *taskImage ;
    TaoJinLabel *taskNameLab ;
    TaoJinLabel *taskIntroLab ;
    TaoJinLabel *taskRewardLab ;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self ;
}
-(void)loadTaskCellContentViewWith:(TaskObj *)task{
    
}

-(float) getTaskCellHeight{
    
    return 0.0;
}
@end
