//
//  SharePlatformView.h
//  免费流量王
//
//  Created by keyrun on 14-10-20.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerService.h"
@protocol SharePlatformViewDelegate <NSObject>



@end

@interface SharePlatformView : UIView <UMSocialUIDelegate>
{
    NSArray *typesName;
    int failCount ;
}
@property (nonatomic ,strong) id <SharePlatformViewDelegate> shareViewDelegate ;

@property (nonatomic ,strong) UIViewController *presentVC ;
@property (nonatomic ,strong) NSArray *shareTypes;
@property (nonatomic, strong) NSMutableArray *items ;

@property (nonatomic, strong) NSDictionary *shareContent ;

-(id)initWithFrame:(CGRect)frame andShareTypes:(NSArray *)types andImages:(NSArray *)icons titles:(NSArray *)titles rewards:(NSArray *)rewards;
@end
