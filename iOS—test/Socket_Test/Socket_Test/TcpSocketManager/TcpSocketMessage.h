//
//  SocketMessage.h
//  Socket_Test
//
//  Created by 陈登文 on 2021/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum int8_t {
    TcpMessageTypeConnected,
    TcpMessageTypeFailed,
    TcpMessageTypeDisconnected,
    TcpMessageTypeSend,
    TcpMessageTypeWrite
} TcpMessageType;

@interface TcpSocketMessage : NSObject

@property(nonatomic,assign) NSUInteger connectionKey;
@property(nonatomic,copy) NSData *messageData;
@property(assign) NSUInteger tag;
@property(assign) TcpMessageType messageType;

@property(readonly,assign) NSUInteger hash;

@end

NS_ASSUME_NONNULL_END
