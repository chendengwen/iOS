//
//  TcpSubscriber.h
//  Socket_Test
//
//  Created by 陈登文 on 2021/10/24.
//

#import <Foundation/Foundation.h>
#import "TcpSocketMessage.h"
#import "TcpSocketConnection.h"

typedef void(^TCPMessageBlock)(TcpSocketMessage * _Nonnull message);

NS_ASSUME_NONNULL_BEGIN

@interface TcpSubscriber : NSObject

@property(nonatomic,strong) TcpSocketConnection *connection;
@property(nonatomic,copy) TCPMessageBlock messageCallBack;

+(instancetype)subscriberWithConnection:(TcpSocketConnection *)connection callback:(TCPMessageBlock)block;

@end


@interface NSObject (TcpMessageSubscribe)

-(void)subscribe:(TcpSocketConnection *)connection callback:(TCPMessageBlock)block;

-(void)cancelSubscribe:(TcpSocketConnection *)connection;

@end

NS_ASSUME_NONNULL_END
