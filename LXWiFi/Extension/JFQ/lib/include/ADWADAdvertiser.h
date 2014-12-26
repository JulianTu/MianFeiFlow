//
//  ADWADAdvertiser.h
//  ADWADBanner
//
//  Created by song duan on 12-5-28.
//  Copyright (c) 2012年 adways. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADWADAdvertiser : NSObject

/*
 function: 广告主发送该请求到服务端，上传一些参数。
 parameter: @siteId， ADWAD生成，开发者从ADWAD网站上可获得。
            @siteKey，ADWAD生成，开发者从ADWAD网站上可获得。
            @advertisement，ADWAD生成，开发者从ADWAD网站上可获得。
            @campaignId，活动id。ADWAD生成，开发者从ADWAD网站上可获得。
            @sandBox，YES用正是环境，NO用测试环境
 */

+ (void)advertiserWithSiteId:(NSString *)siteId
                     siteKey:(NSString *)siteKey 
               advertisement:(NSString *)advertisement 
                  campaignId:(NSString *)campaignId 
                     sandBox:(BOOL)sandBox;
@end
