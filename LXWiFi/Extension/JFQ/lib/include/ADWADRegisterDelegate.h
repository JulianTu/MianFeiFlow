//
//  ADWADRegisterDelegate.h
//  ADWADSDK
//
//  Created by  on 12-6-14.
//  Copyright (c) 2012年 adways. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ADWADRegisterDelegate <NSObject>

@optional

- (void)registerDidFinished;
- (void)registerDidFailed;

@end
