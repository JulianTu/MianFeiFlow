//
//  TcpClient.m
//  ConnectTest
//
//  Created by  SmallTask on 13-8-15.
//
//

#import "TcpClient.h"
#import "GCDAsyncSocket.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_INFO;

#define USE_SECURE_CONNECTION 0
#define ENABLE_BACKGROUNDING  0

#if USE_SECURE_CONNECTION
#define HOST @"www.paypal.com"
#define PORT 443
#else
#define HOST @"192.168.254.2"
#define PORT 55184
#endif

@implementation TcpClient
@synthesize asyncSocket;

+ (TcpClient *)sharedInstance;
{
    static TcpClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[TcpClient alloc] init];
    });
    
    return _sharedInstance;
}


-(id)init;
{
    self = [super init];
    recivedArray = [NSMutableArray arrayWithCapacity:10];
    return self;
}

-(void)setDelegate_ITcpClient:(id<ITcpClient>)_itcpClient;
{
    itcpClient = _itcpClient;
}

-(void)openTcpConnection:(NSString*)host port:(NSInteger)port;
{
//    DDLogInfo(@"%@", THIS_METHOD);
	
	// Setup our socket (GCDAsyncSocket).

	
//	dispatch_queue_t mainQueue = dispatch_get_main_queue();
	dispatch_queue_t mainQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
	asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    [asyncSocket setAutoDisconnectOnClosedReadStream:NO];

    
#if USE_SECURE_CONNECTION
	{
		NSString *host = HOST;
		uint16_t port = PORT;
		
		DDLogInfo(@"Connecting to \"%@\" on port %hu...", host, port);
    
		self.viewController.label.text = @"Connecting...";
		
		NSError *error = nil;
		if (![asyncSocket connectToHost:@"www.paypal.com" onPort:port error:&error])
		{
			DDLogError(@"Error connecting: %@", error);
			self.viewController.label.text = @"Oops";
		}
	}
#else
	{
		
		NSError *error = nil;
		if (![asyncSocket connectToHost:host onPort:port error:&error])
		{
			DDLogError(@"Error connecting: %@", error);

		}
        
		// You can also specify an optional connect timeout.
		
        //	NSError *error = nil;
        //	if (![asyncSocket connectToHost:host onPort:80 withTimeout:5.0 error:&error])
        //	{
        //		DDLogError(@"Error connecting: %@", error);
        //	}
		
	}
#endif
    


}

-(void)writeString:(NSString*)datastr;
{
    NSString *requestStr = [NSString stringWithFormat:@"%@",datastr];
    
    NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    [self writeData:requestData];
}

-(void)writeData:(NSData*)data;
{
    TAG_SEND++;
    [asyncSocket writeData:data withTimeout:-1. tag:TAG_SEND];
}

-(void)read;
{

    [asyncSocket readDataWithTimeout:-1 tag:0];
//    [asyncSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:TAG_SEND];
//    [asyncSocket readDataToData:[GCDAsyncSocket ZeroData] withTimeout:-1 tag:0];
//    [asyncSocket readDataToLength:1 withTimeout:-1 tag:0];
}

-(long)GetSendTag;
{
    return TAG_SEND;
}

-(long)GetRecivedTag;
{
    return TAG_RECIVED;
}
-(void)setMsgBlcok:(MsgBlock)msgBlcok{
    copyBlcok =[msgBlcok copy];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Socket Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    self.isConnected = YES;
	DDLogInfo(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    NSLog(@"  readStream  %@ ",sock.readStream);
    NSString *msg =[NSString stringWithFormat:@"连接成功，本地地址 :%@ port:%hu", [sock localHost], [sock localPort]];
	copyBlcok(msg);
    DDLogInfo(@"localHost :%@ port:%hu", [sock localHost], [sock localPort]);
    [self read];

#if USE_SECURE_CONNECTION
	{
		// Connected to secure server (HTTPS)
        
#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
		{
			// Backgrounding doesn't seem to be supported on the simulator yet
			
			[sock performBlock:^{
				if ([sock enableBackgroundingOnSocket])
					DDLogInfo(@"Enabled backgrounding on socket");
				else
					DDLogWarn(@"Enabling backgrounding failed!");
			}];
		}
#endif
		
		// Configure SSL/TLS settings
		NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
		
		// If you simply want to ensure that the remote host's certificate is valid,
		// then you can use an empty dictionary.
		
		// If you know the name of the remote host, then you should specify the name here.
		//
		// NOTE:
		// You should understand the security implications if you do not specify the peer name.
		// Please see the documentation for the startTLS method in GCDAsyncSocket.h for a full discussion.
		
		[settings setObject:@"www.paypal.com"
					 forKey:(NSString *)kCFStreamSSLPeerName];
		
		// To connect to a test server, with a self-signed certificate, use settings similar to this:
		
        //	// Allow expired certificates
        //	[settings setObject:[NSNumber numberWithBool:YES]
        //				 forKey:(NSString *)kCFStreamSSLAllowsExpiredCertificates];
        //
        //	// Allow self-signed certificates
        //	[settings setObject:[NSNumber numberWithBool:YES]
        //				 forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
        //
        //	// In fact, don't even validate the certificate chain
        //	[settings setObject:[NSNumber numberWithBool:NO]
        //				 forKey:(NSString *)kCFStreamSSLValidatesCertificateChain];
		
		DDLogInfo(@"Starting TLS with settings:\n%@", settings);
		
		[sock startTLS:settings];
		
		// You can also pass nil to the startTLS method, which is the same as passing an empty dictionary.
		// Again, you should understand the security implications of doing so.
		// Please see the documentation for the startTLS method in GCDAsyncSocket.h for a full discussion.
		
	}
#else
	{
		// Connected to normal server (HTTP)
		
#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
		{
			// Backgrounding doesn't seem to be supported on the simulator yet
			
			[sock performBlock:^{
				if ([sock enableBackgroundingOnSocket])
					DDLogInfo(@"Enabled backgrounding on socket");
				else
					DDLogWarn(@"Enabling backgrounding failed!");
			}];
		}
#endif
	}
#endif
    
    //模拟发送一条数据
//    NSString *requestStr = [NSString stringWithFormat:@"GET / HTTP/1.1\r\nHost: %@\r\n\r\n", HOST];
//	NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
//    
//    [sock writeData:requestData withTimeout:20. tag:1];
    
    
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
//	DDLogInfo(@"socketDidSecure:%p", sock);
//	self.viewController.label.text = @"Connected + Secure";
	
	NSString *requestStr = [NSString stringWithFormat:@"GET / HTTP/1.1\r\nHost: %@\r\n\r\n", HOST];
	NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
	
	[sock writeData:requestData withTimeout:-1 tag:0];
	[sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
    dispatch_async(dispatch_get_main_queue(), ^{
        [itcpClient OnSendDataSuccess:[NSString stringWithFormat:@"tag:%li",tag]];

    });
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSLog(@"socket:%p didReadData:withTag:%ld", sock, tag);
	data =[data subdataWithRange:NSMakeRange(4, data.length -4)];
	NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//	DDLogInfo(@"HTTP Response:\n%@", httpResponse);
    
    TAG_RECIVED = tag;
    
    if(![httpResponse isEqualToString:@""])
        [recivedArray addObject:httpResponse];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [itcpClient OnReceiveDataDictionary:dataDic];
        [itcpClient OnReciveData:httpResponse];
    });

    
    [self read];
    
    [self writeString:@""];
    
	
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    
	NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
    dispatch_async(dispatch_get_main_queue(), ^{
        [itcpClient OnConnectionError:err];
        self.isConnected =NO;
    });
}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock
{
    
}



@end
