//
//  LLMethodTable.h
//  免费流量王
//
//  Created by keyrun on 14-10-15.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLMethodDelegate <NSObject>

-(void) selectedMethodTableIndex:(int) index andUrl:(NSString *) methodUrl andName:(NSString *)name;

@end

@interface LLMethodTable : UITableView <UITableViewDataSource ,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic ,strong) id <LLMethodDelegate> methodDelegate ;
@property (nonatomic ,assign) BOOL haveRequest;
- (void) initShareMethodData;

@end
