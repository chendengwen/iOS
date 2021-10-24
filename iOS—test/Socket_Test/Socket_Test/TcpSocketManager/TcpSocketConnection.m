//
//  SocketConnection.m
//  Socket_Test
//
//  Created by 陈登文 on 2021/10/24.
//

#import "TcpSocketConnection.h"

@implementation TcpSocketConnection

+(TcpSocketConnection *)connectionWithIP:(NSString *)ip port:(int8_t)port {
    TcpSocketConnection *connection = [[TcpSocketConnection alloc] init];
    connection.ip = ip;
    connection.port = port;
    return connection;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _reConnectCount = 2;
    }
    return self;
}

-(NSUInteger)hash {
    return self.ip.hash & self.port;
}

-(BOOL)isEqual:(id)object {
    if (object == nil || ![object isKindOfClass:self.class]) return NO;
    
    TcpSocketConnection *connection = (TcpSocketConnection *)object;
    if (connection.hash == self.hash && [connection.asyncSocket isEqual:self.asyncSocket]) {
        return YES;
    }
    return NO;
}

-(id)copy {
    TcpSocketConnection *connection = [[TcpSocketConnection alloc] init];
    connection.ip = self.ip;
    connection.port = self.port;
    connection.asyncSocket = self.asyncSocket;
    connection.startTime = self.startTime;
    connection.connectConsumingTime = self.connectConsumingTime;
    return connection;
}

-(id)copyWithZone:(NSZone *)zone {
    TcpSocketConnection *connection = [[TcpSocketConnection alloc] init];
    connection.ip = self.ip;
    connection.port = self.port;
    connection.asyncSocket = self.asyncSocket;
    connection.startTime = self.startTime;
    connection.connectConsumingTime = self.connectConsumingTime;
    return connection;
}

@end
