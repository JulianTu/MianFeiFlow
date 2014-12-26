//
//  LLAsynURLConnection.h
//  免费流量王
//
//  Created by keyrun on 14-11-4.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^AsySuccess)(NSData *data) ;
 typedef void(^AsyFail)(NSError *error);

@interface LLAsynURLConnection : NSURLConnection <NSURLConnectionDataDelegate ,NSURLConnectionDelegate>
{
    NSTimer *_timer;
    AsySuccess _success ;
    AsyFail _fail ;
    NSMutableData *_data ;
    NSString *codeKey;
    int requestMethod ;
    
    NSString *requestUrl;
}
+(id)requestURLWith:(NSString *)urlStr dataDic:(NSDictionary *)dic andProtocolNum:(NSString *)num andTimeOut:(int)time connectSuccess:(AsySuccess) success andFail:(AsyFail) fail;

/**
*  异步GET请求
*
*  @param urlStr  URL地址
*  @param dic     数据字典
*  @param time    超时时间
*  @param success 成功block
*  @param fail    失败block
*
*  @return connction
*/
+(id)requestForMethodGetWithURL:(NSString *)urlStr dataDic:(NSDictionary *)dic andProtocolNum:(NSString *)num andTimeOut:(int)time successBlock:(AsySuccess)success andFailBlock:(AsyFail)fail;
@end
