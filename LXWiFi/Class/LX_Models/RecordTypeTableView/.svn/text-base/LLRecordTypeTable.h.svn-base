//
//  LLRecordTypeTable.h
//  乐享WiFi
//
//  Created by keyrun on 14-10-14.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LLRecordTypeTableDelegate <NSObject>

-(void) didSelectedRowIndex:(int)row ;

@end
@interface LLRecordTypeTable : UITableView <UITableViewDataSource ,UITableViewDelegate>

@property (nonatomic ,strong) id <LLRecordTypeTableDelegate> typeDelegate ;
@property (nonatomic ,strong) NSArray *types ;
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withDataArr:(NSArray *)array;
@end
