//
//  ADWADUrlImageQueueDelegate.h
//  ADWADBanner
//
//  Created by song duan on 12-5-26.
//  Copyright (c) 2012年 adways. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADWADError;

@protocol ADWADUrlImageQueueDelegate <NSObject>

@optional

- (void)queueImageFinished:(NSString *)aUrl;
- (void)queueImageFailed:(NSString*)aUrl error:(ADWADError *)aError;

@end
