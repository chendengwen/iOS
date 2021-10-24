//
//  SocketConnection.h
//  Socket_Test
//
//  Created by 陈登文 on 2021/10/24.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>

NS_ASSUME_NONNULL_BEGIN

@interface TcpSocketConnection : NSObject<NSCopying>

@property(nonatomic,strong) GCDAsyncSocket * __nonnull asyncSocket;
@property(nonatomic,copy) NSString * __nonnull ip;
@property(assign) int port;

/** 需要重连的次数 */
@property (assign) int8_t reConnectCount;
/** 已重连次数 */
@property (assign) int8_t reConnectedCount;
//@property(nonatomic,copy) NSString *connectStatusStr;

/** 连接开始时间 */
@property(nonatomic,copy) NSDate *startTime;
/** 完成连接消耗时间 */
@property(assign) float connectConsumingTime;

@property(readonly,assign) NSUInteger hash;

///生成连接对象
+(TcpSocketConnection *)connectionWithIP:(NSString *)ip port:(int8_t)port;

@end

NS_ASSUME_NONNULL_END
