//
//  ActivityObj.h
//  免费流量王
//
//  Created by keyrun on 14-11-10.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityObj : NSObject

@property (nonatomic ,strong) NSString *actWebURL;
@property (nonatomic ,assign) int actId ;
@property (nonatomic ,strong) NSString *actType ;
@property (nonatomic ,strong) NSString *actImgURL;

-(instancetype)initActivityObjWithDictionary:(NSDictionary *)dic;
@end
