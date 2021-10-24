//
//  SocketMessageHandler.m
//  Socket_Test
//
//  Created by 陈登文 on 2021/10/24.
//

#import "TcpSocketMessageHandler.h"
#import "TcpSubscriber.h"

NSString * _Nullable const TCPConnectionNotification = @"TCPConnectionNotification";
NSString * _Nullable const TCPMessageNotification = @"TCPConnectionNotification";



@interface TcpSocketMessageHandler ()
{
    NSLock *_lock;
}
//@property(nonatomic,strong) NSMutableArray<TcpSubscriber*> *subscriberArr;
@property(nonatomic,strong) NSMutableDictionary<NSNumber*, NSMutableArray<TcpSubscriber *>*> *subscribersDic;
@end

@implementation TcpSocketMessageHandler

- (instancetype)init {
    self = [super init];
    if (self) {
//        _subscriberArr = [NSMutableArray arrayWithCapacity:10];
        _subscribersDic = [NSMutableDictionary dictionaryWithCapacity:10];
        _lock = [[NSLock alloc] init];
    }
    return self;
}

#pragma Private
-(nullable TcpSocketConnection *)getConnectionForKey:(nonnull NSNumber *)key {
    return [self.connectionDic objectForKey:key];
}

-(nullable NSMutableArray<TcpSubscriber *>*)getSubscriberForKey:(nonnull NSNumber *)key {
    return [self.subscribersDic objectForKey:key];
}

#pragma Public
-(void)subscribeMessageFromConnection:(TcpSocketConnection *)connection messageHandler:(TCPMessageBlock)block {
    TcpSubscriber *subscriber = [TcpSubscriber subscriberWithConnection:connection callback:block];
    [_lock lock];
    NSMutableArray<TcpSubscriber *> *subscriberOfConn = [self.subscribersDic objectForKey:@(connection.hash)];
    if (subscriberOfConn == nil) {
        subscriberOfConn = [NSMutableArray arrayWithCapacity:2];
    }
    [subscriberOfConn addObject:subscriber];
    [self.subscribersDic setObject:subscriberOfConn forKey:@(connection.hash)];
    [_lock unlock];
}

-(void)cancelSubscribeMessageFromConnection:(TcpSocketConnection *)connection {
    NSMutableArray<TcpSubscriber *> *subscriberOfConn = [self.subscribersDic objectForKey:@(connection.hash)];
    for (TcpSubscriber *subscriber in subscriberOfConn) {
        if (subscriber.connection == connection) {
            [_lock lock];
            [subscriberOfConn removeObject:subscriber];
            [_lock unlock];
            continue;
        }
    }
}

-(void)connectionDisconnected:(TcpSocketConnection *)connection {
    //连接已被关闭
    //给订阅者发起回调
    NSMutableArray<TcpSubscriber *> *subscriberOfConn = [self.subscribersDic objectForKey:@(connection.hash)];
    TcpSocketMessage *message = [[TcpSocketMessage alloc] init];
    message.messageType = TcpMessageTypeDisconnected;
    message.tag = -300; //表示连接失败
    message.connectionKey = connection.hash;
    message.messageData = [@"连接已被关闭！" dataUsingEncoding:NSUTF8StringEncoding];
    
    if (subscriberOfConn != nil && subscriberOfConn.count > 0) {
        for (TcpSubscriber *subscriber in subscriberOfConn) {
            dispatch_async(dispatch_get_main_queue(), ^{
                subscriber.messageCallBack(message);
            });
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectionNotification object:@{
            @"status":@-300,
            @"ip": connection.ip,
            @"port": @(connection.port)
        }];
    }
}

-(void)connectSuccess:(TcpSocketConnection *)connection {
    //给订阅者发起回调
    NSMutableArray<TcpSubscriber *> *subscriberOfConn = [self.subscribersDic objectForKey:@(connection.hash)];
    TcpSocketMessage *message = [[TcpSocketMessage alloc] init];
    message.messageType = TcpMessageTypeConnected;
    message.tag = -100; //表示连接成功
    message.connectionKey = connection.hash;
    message.messageData = [@"连接成功！" dataUsingEncoding:NSUTF8StringEncoding];
    
    if (subscriberOfConn != nil && subscriberOfConn.count > 0) {
        for (TcpSubscriber *subscriber in subscriberOfConn) {
            dispatch_async(dispatch_get_main_queue(), ^{
                subscriber.messageCallBack(message);
            });
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectionNotification object:@{
            @"status":@-100,
            @"ip": connection.ip,
            @"port": @(connection.port)
        }];
    }
}

-(void)connectFail:(TcpSocketConnection *)connection {
    //给订阅者发起回调
    NSMutableArray<TcpSubscriber *> *subscriberOfConn = [self.subscribersDic objectForKey:@(connection.hash)];
    TcpSocketMessage *message = [[TcpSocketMessage alloc] init];
    message.messageType = TcpMessageTypeFailed;
    message.tag = -200; //表示连接失败
    message.connectionKey = connection.hash;
    message.messageData = [@"连接失败！" dataUsingEncoding:NSUTF8StringEncoding];
    
    if (subscriberOfConn != nil && subscriberOfConn.count > 0) {
        for (TcpSubscriber *subscriber in subscriberOfConn) {
            dispatch_async(dispatch_get_main_queue(), ^{
                subscriber.messageCallBack(message);
            });
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:TCPConnectionNotification object:@{
            @"status":@-200,
            @"ip": connection.ip,
            @"port": @(connection.port)
        }];
    }
}

-(void)sendSuccess:(TcpSocketMessage *)message {
    //
    // ........
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TCPMessageNotification object:@{
        @"status":@0,
        @"ip": @"",
        @"port": @(0000)
    }];
}

-(void)sendFail:(TcpSocketMessage *)message {
    
}

-(void)writeSuccess:(TcpSocketMessage *)message {
    
}

-(void)writeFail:(TcpSocketMessage *)message {
    
}

@end

