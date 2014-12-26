//
//  LLRecordTypeTable.m
//  乐享WiFi
//
//  Created by keyrun on 14-10-14.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LLRecordTypeTable.h"
#import "LLRecordTypeCell.h"

@implementation LLRecordTypeTable

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withDataArr:(NSArray *)array{
    self =[super initWithFrame:frame style:style];
    if (self) {
        self.types =array ;
        self.delegate = self;
        self.dataSource = self ;
        self.scrollEnabled = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone ;
        [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    return self ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.types.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kRecordTabWidth, 1.0f)];
    view.backgroundColor = [UIColor clearColor];
    view.alpha = 0.0f;
    return view ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0f ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"record";
    LLRecordTypeCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LLRecordTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell setTypeLabTitle:[self.types objectAtIndex:indexPath.section]];
   
    if (kDeviceVersion < 7.0) {
        cell.contentView.backgroundColor = kLightBlueTextColor ;
    }else{
        cell.backgroundColor = kLightBlueTextColor ;
    }
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kRecordTabCellHeigh ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.typeDelegate didSelectedRowIndex:indexPath.section];
    
    NSArray *allCellPaths = [tableView visibleCells];
    for (NSIndexPath *path in allCellPaths) {
        if ([path isEqual:indexPath]) {
            
            LLRecordTypeCell *cell = (LLRecordTypeCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.backgroundColor = kBlueTextColor;
//            cell.typeNameLab.text =@"选择";

        }else{
            LLRecordTypeCell *cell = (LLRecordTypeCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.backgroundColor = kLightBlueTextColor;
        }
    }
    
    
}

@end
