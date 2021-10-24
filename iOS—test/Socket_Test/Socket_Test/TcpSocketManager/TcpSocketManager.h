//
//  SocketManager.h
//  Socket_Test
//
//  Created by 陈登文 on 2021/10/23.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>
#import "TcpSocketConnection.h"
#import "TcpSocketMessageHandler.h"
NS_ASSUME_NONNULL_BEGIN

@interface TcpSocketManager : NSObject<GCDAsyncSocketDelegate>

+ (instancetype)sharedInstance;

@property(nonatomic,strong) TcpSocketMessageHandler *messageHandler;


/**
 * 读取数据
 */
- (void)readDataFromConnection:(TcpSocketConnection *)connection withTimeout:(NSTimeInterval)timeout tag:(long)tag;
/**
 * 发送数据
 */
- (void)writeToConnection:(TcpSocketConnection *)connection withData:(NSData *)data withTag:(long)tag;
/**
 * 开启TCPSocketServe
 */
-(void)start:(TcpSocketConnection *)connection;
/**
 * 关闭TCPSocketServe
 */
- (void)disconnect:(TcpSocketConnection *)connection;


@end

NS_ASSUME_NONNULL_END
