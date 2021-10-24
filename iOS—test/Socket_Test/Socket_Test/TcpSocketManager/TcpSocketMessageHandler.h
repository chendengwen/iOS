//
//  SocketMessageHandler.h
//  Socket_Test
//
//  Created by 陈登文 on 2021/10/24.
//

#import <Foundation/Foundation.h>
#import "TcpSocketConnection.h"


extern NSString * _Nullable const TCPConnectionNotification;
extern NSString * _Nullable const TCPMessageNotification;

NS_ASSUME_NONNULL_BEGIN

@class TcpSocketMessage;
/**
 * 统一处理socket回调，根据connection分派message
 */
@interface TcpSocketMessageHandler : NSObject

///连接中socket，断开连接后发送断开的消息后移除
@property(nonatomic,strong) NSMutableDictionary<NSNumber*, TcpSocketConnection*> *connectionDic;

///订阅消息
-(void)subscribeMessageFromConnection:(TcpSocketConnection *)connection messageHandler:(void(^)(TcpSocketMessage *))block;
///取消订阅
-(void)cancelSubscribeMessageFromConnection:(TcpSocketConnection *)connection;
///断开连接（发出最后一条消息）
-(void)connectionDisconnected:(TcpSocketConnection *)connection;

-(void)connectSuccess:(TcpSocketConnection *)connection;
-(void)connectFail:(TcpSocketConnection *)connection;

-(void)sendSuccess:(TcpSocketMessage *)message;
-(void)sendFail:(TcpSocketMessage *)message;

-(void)writeSuccess:(TcpSocketMessage *)message;
-(void)writeFail:(TcpSocketMessage *)message;


@end

NS_ASSUME_NONNULL_END
