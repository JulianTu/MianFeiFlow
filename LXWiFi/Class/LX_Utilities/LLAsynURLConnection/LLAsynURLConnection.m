//
//  LLAsynURLConnection.m
//  免费流量王
//
//  Created by keyrun on 14-11-4.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import "LLAsynURLConnection.h"
#import "JSNsstring.h"
#import "JSONKit.h"
#import "MyUserDefault.h"
#import "NSData+DesCode.h"
#import "GTMBase64.h"
#import "Base64.h"
@implementation LLAsynURLConnection

+(id)requestURLWith:(NSString *)urlStr dataDic:(NSDictionary *)dic andProtocolNum:(NSString *)num andTimeOut:(int)time connectSuccess:(AsySuccess)success andFail:(AsyFail)fail{
    LLAsynURLConnection *obj =[[self alloc]initWithURL:urlStr dataDic:dic andNum:num timeOut:time success:success fail:fail];
    return obj;
}
+(id)requestForMethodGetWithURL:(NSString *)urlStr dataDic:(NSDictionary *)dic andProtocolNum:(NSString *)num andTimeOut:(int)time successBlock:(AsySuccess)success andFailBlock:(AsyFail)fail{
    LLAsynURLConnection *obj =[[self alloc] initForGetRequestURL:urlStr dataDic:dic andProtocolNum:num andTimeOut:time success:success fail:fail];
    return obj;
}
-(id)initWithURL:(NSString *)urlStr dataDic:(NSDictionary *)dataDic andNum:(NSString *)num timeOut:(int)timeOut success:(AsySuccess)success fail:(AsyFail)fail{
    NSURL *_url = [[NSURL alloc] initWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:timeOut];
    [request setHTTPMethod:@"POST"];
    requestMethod =1 ;
    codeKey =@"12345678";
    if (![urlStr hasSuffix:@"login"]) {
        codeKey =[[MyUserDefault standardUserDefaults] getRequestCodeKey];
    }
    
    
    //    JSNsstring *jsstring = [[JSNsstring alloc]initStringByDictionary:dataDic];
    NSString *jsstring = [dataDic JSONString];
    
    NSString *encryString =[NSData encryptUseDES:jsstring key:codeKey];
    /*
     NSBundle* bundle=[NSBundle mainBundle];
     NSString* plistPath=[bundle pathForResource:@"1" ofType:@"json"];
     NSData *data2 =[NSData dataWithContentsOfFile:plistPath];
     NSString *bb =[[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
     
     NSDictionary *dicTest =[[NSUserDefaults standardUserDefaults] objectForKey:@"Test"];
     
     NSString *aaa =[NSData encryptUseDES:[dicTest JSONString] key:codeKey];
     
     NSLog(@" 简单字符 ==%@  %@ %@",[dicTest JSONString],aaa ,jsstring);
     NSString *encode =[NSData decryptUseDES:encryString key:codeKey];
     NSLog(@" string == %@  加密后==%@  %@ 解密后==%@",jsstring,encryString,aaa,encode);
     */
    encryString =[encryString stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    encryString = [encryString stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    encryString =[[JSNsstring alloc] initStringByString:encryString];
    [jsstring stringByAppendingString:[NSString stringWithFormat:@"protocol==%@",num]];
    
    NSData *data =[encryString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    if ([[MyUserDefault standardUserDefaults] getCookieSid]) {
        if ([urlStr hasSuffix:@"login"]) {
            // 登陆请求不发送cookieSid  测试发送
        }else{
            [request setValue:[[MyUserDefault standardUserDefaults] getCookieSid] forHTTPHeaderField:@"Cookie"];
        }
    }else{
        [request setValue:@"head" forHTTPHeaderField:@"content-length"];
    }
    
    _timer =[NSTimer scheduledTimerWithTimeInterval:timeOut target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
    self =[super initWithRequest:request delegate:self startImmediately:NO];
    if (self) {
        [self scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        _success =[success copy];
        _fail = [fail copy];
        [self start];
    }
    return self;
}
-(id)initForGetRequestURL:(NSString *)urlStr dataDic:(NSDictionary *)dic andProtocolNum:(NSString *)num andTimeOut:(int) time success:(AsySuccess)success fail:(AsyFail)fail{
    requestUrl =urlStr ;
    
    codeKey =[[MyUserDefault standardUserDefaults] getRequestCodeKey];
    //    JSNsstring *string =[[JSNsstring alloc] initStringByDictionary:dic];
    NSURL *_url = [[NSURL alloc] initWithString:urlStr ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:time];
    [request setHTTPMethod:@"GET"];
    requestMethod = 2;
    if ([[MyUserDefault standardUserDefaults] getCookieSid]) {
        if ([urlStr hasSuffix:@"login"]) {
            // 登陆请求不发送cookieSid  测试发送
        }else{
            [request setValue:[[MyUserDefault standardUserDefaults] getCookieSid] forHTTPHeaderField:@"Cookie"];
        }
    }else{
        [request setValue:@"head" forHTTPHeaderField:@"content-length"];
    }
    
    _timer =[NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
    self =[super initWithRequest:request delegate:self startImmediately:NO];
    if (self) {
        [self scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        _success =[success copy];
        _fail = [fail copy];
        [self start];
    }
    return self;
}
-(void)timeOut{
    [self connection:self didFailWithError:[NSError errorWithDomain:@"连接超时" code:timeOutErrorCode userInfo:nil]];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse *httpRep =(NSHTTPURLResponse *)response;
    //     NSLog(@" 请求响应== %@ ",httpRep.allHeaderFields);
    if ([httpRep.allHeaderFields objectForKey:@"Set-Cookie"]) {
        NSString *cookieSid =[httpRep.allHeaderFields objectForKey:@"Set-Cookie"];
        [[MyUserDefault standardUserDefaults] setCookieSid:cookieSid];
    }
    
    if(_data != nil){
        [_data resetBytesInRange:NSMakeRange(0, _data.length)];
    }else{
        _data = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSString *receiveStr = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    if ([receiveStr isEqualToString:@"relogin"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginAgainNotic object:nil];
    }else{
        receiveStr =[receiveStr stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
        receiveStr = [receiveStr stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
        
        NSString *codeString =[NSData decryptUseDES:receiveStr key:codeKey];
        //  NSLog(@" 收到的数据 ==%@   C %@  CodeKey ==%@",[[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding],codeString,receiveStr);
        NSData *codeData =[codeString dataUsingEncoding:NSUTF8StringEncoding];
        _success(codeData);

    }
    if ([requestUrl hasSuffix:@"help"]) {
        _success(_data);
    }
    if(_timer != nil){
        [_timer invalidate];
        _timer = nil;
    }
    
    /*
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     //        NSString *dic =[NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:nil];
     NSString *string =[[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
     //        NSString *codestring =[dic JSONString];
     //        NSString *string =[NSData encryptUseDES:codestring key:@"12345678"];
     //        NSString *string2 =[NSData decryptUseDES:string key:@"12345678"];
     //        NSLog(@"  AAA %@  BB%@  CC%@ ",codestring ,string ,string2);
     
     if ([[dic objectForKey:@"flag"] intValue] ==2) {
     NSDictionary *body =[dic objectForKey:@"body"];
     if ([[body objectForKey:@"msg"] isEqualToString:@"re login!"]) {     //重新登录请求时发送通知
     NSLog(@" Send Relogin Message");
     [[NSNotificationCenter defaultCenter] postNotificationName:LoginAgainNotic object:nil];
     }
     }
     
     if ([string isEqualToString:@"relogin"]) {
     [[NSNotificationCenter defaultCenter] postNotificationName:LoginAgainNotic object:nil];
     }
     });
     */
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _fail(error);
}

@end
