//
//  ADWADError.h
//  ADWADBanner
//
//  Created by song duan on 12-5-2.
//  Copyright (c) 2012年 adways. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Defines

typedef enum {
	eErrorNetwork = 0,	// 网络错误, 详细请看subcode,subcode包含_ADWADNetworkErrorCode, 如 eErrorConnectionFailure
	eErrorProtocol,     // 协议参数错误,服务器返回错误码 详细请看subcode,subcode包含_ADWADProtocolErrorCode, 如 error_protocol_param_absence
	eErrorXMLParser,	// 解析错误, 详细请看subcode,subcode包含_ADWADXMLParseErrorCode 
	eErrorHTTPError,	// http响应为非 200(ok) 错误, 详细请看subcode,subcode会含http status错误代码，如404等
	
	eADWADErrorMax
} _ADWADErrorTypeCode;
typedef NSInteger ADWADErrorTypeCode;

typedef enum {
    eErrorConnectionFailure = 1, 
    eErrorRequestTimedOut = 2,
    eErrorAuthentication = 3,
    eErrorRequestCancelled = 4,
    eErrorUnableToCreateRequest = 5,
    eErrorInternalErrorWhileBuildingRequest  = 6,
    eErrorInternalErrorWhileApplyingCredentials  = 7,
	eErrorFileManagement = 8,
	eErrorTooMuchRedirection = 9,
	eErrorUnhandledException = 10,
	
	eErrorNetworkErrorCodeMax = eErrorUnhandledException
} _ADWADNetworkErrorCode;
typedef NSInteger ADWADNetworkErrorCode;

typedef enum {
    eErrorXmlParseNoHeader = 0,            // response has no header
    eErrorXmlParselNoBody,                 // response has no body
    eErrorXmlParseUnknown,                 // unknown parse error
} _ADWADXMLParseErrorCode;
typedef NSInteger ADWADXMLParseErrorCode;

typedef enum {
    eErrorJsonParseUnknown = 0             // unknown parse error
} _ADWADJSONParseErrorCode;
typedef NSInteger ADWADJSONParseErrorCode;

typedef enum {
	// 10000以下的保留为HTTP错误代码使用，如501，404等
	
	// 10000 ~ 20000 内的为Reserved
	error_reserved_base = 10000,
	
	// 20000以上为ADWAD服务器返回错误代码
	// 常规错误 20000
	error_protocol_base = 20000,
		
	// 参数错误:	1		
	error_protocol_param_unknown    = error_protocol_base + 1000,      // 1000	参数错误，未明确具体类别
	error_protocol_param_absence,                                      // 1001	缺少参数
	error_protocol_param_type_error,                                   // 1002	参数类型错误
	error_protocol_param_value_over,                                   // 1003	参数值错误，如超出取值范围等
    
    // 2 ~ 4 待扩展
    
	// 执行异常：5	
	error_protocol_execute_exception = error_protocol_base + 5000,     // 2000	程序执行时产生未处理的异常，程序出错
	// end
	error_protocol_unknown,                                            // 未知错误（eg，未知API错误）
	error_protocol_max = error_protocol_unknown
	
} _ADWADProtocolErrorCode;
typedef NSInteger ADWADProtocolErrorCode;


@interface ADWADError : NSObject
{
    NSString    *_description;
	NSInteger   _code;
	NSInteger   _subCode;
	NSError     *_detail;
}

@property (nonatomic, copy) NSString *description;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign) NSInteger subCode;
@property (nonatomic, retain) NSError *detail;

+ (ADWADError*)errorWithCode:(NSInteger)aTypecode 
               withSubcode:(NSInteger)aSubcode 
           withDescription:(NSString *)aDescription 
             withDetailErr:(NSError *)aDetail;

- (ADWADError*)initWithCode:(NSInteger)aTypecode 
              withSubcode:(NSInteger)aSubcode 
                 withDescription:(NSString *)aDescription 
            withDetailErr:(NSError *)aDetail;

+ (NSString *)protocolErrorCodeToString:(NSInteger)aErrcode;

@end
