//
//  TcpSubscriber.m
//  Socket_Test
//
//  Created by 陈登文 on 2021/10/24.
//

#import "TcpSubscriber.h"

@implementation TcpSubscriber

+(instancetype)subscriberWithConnection:(TcpSocketConnection *)connection callback:(TCPMessageBlock)block {
    TcpSubscriber *subscriber = [[TcpSubscriber alloc] init];
    subscriber.connection = connection;
    subscriber.messageCallBack = block;
    return subscriber;;
}

@end


#import "TcpSocketManager.h"

@implementation NSObject (TcpMessageSubscribe)

-(void)subscribe:(TcpSocketConnection *)connection callback:(TCPMessageBlock)block{
    [[TcpSocketManager sharedInstance].messageHandler subscribeMessageFromConnection:connection messageHandler:block];
}

-(void)cancelSubscribe:(TcpSocketConnection *)connection {
    [[TcpSocketManager sharedInstance].messageHandler cancelSubscribeMessageFromConnection:connection];
}



@end
