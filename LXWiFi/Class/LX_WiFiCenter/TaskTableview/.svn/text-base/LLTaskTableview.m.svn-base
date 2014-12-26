//
//  LLTaskTableview.m
//  乐享WiFi
//
//  Created by keyrun on 14-10-13.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LLTaskTableview.h"
#import "LLTaskTableCell.h"
@implementation LLTaskTableview 

-(instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self setSeparatorColor:[UIColor clearColor]];
    }
    return self ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    LLTaskTableCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellID];
    if (!cell) {
        cell = [[LLTaskTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}
@end
