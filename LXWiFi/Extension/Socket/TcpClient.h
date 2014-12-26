//
//  TcpClient.h
//  ConnectTest
//
//  Created by  SmallTask on 13-8-15.
//
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "ITcpClient.h"
typedef  void (^MsgBlock)(NSString *) ;

@interface TcpClient : NSObject
{
    long TAG_SEND;
    long TAG_RECIVED;
    
    id<ITcpClient> itcpClient;
    
    NSMutableArray *recivedArray;
    MsgBlock copyBlcok ;
}

@property (nonatomic,retain) GCDAsyncSocket *asyncSocket;
@property (nonatomic, assign) MsgBlock msgBlcok ;
@property (nonatomic,assign) BOOL isConnected;     //之前的链接状态

+ (TcpClient *)sharedInstance;

-(void)setDelegate_ITcpClient:(id<ITcpClient>)_itcpClient;

-(void)openTcpConnection:(NSString*)host port:(NSInteger)port;

-(void)read:(NSInteger)tag;

-(void)writeString:(NSString*)datastr;

-(void)writeData:(NSData*)data;

-(long)GetSendTag;

-(long)GetRecivedTag;


@end
