//
//  PhoneCarrierHelper.h
//  免费流量王
//
//  Created by keyrun on 14-10-23.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface PhoneCarrierHelper : NSObject
{
    NSString *phoneCity ;
    NSString *phoneSIM ;
}
+(PhoneCarrierHelper *)sharePhoneCarrierHelper ;
-(NSString *)checkPhoneCarrier:(NSString *)phoneNum ;
@end
