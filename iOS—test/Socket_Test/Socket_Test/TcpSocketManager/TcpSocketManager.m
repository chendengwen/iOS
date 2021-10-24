//
//  SocketManager.m
//  Socket_Test
//
//  Created by 陈登文 on 2021/10/23.
//

#import "TcpSocketManager.h"
#import "TcpSocketMessageHandler.h"

@interface TcpSocketManager ()
{
//    GCDAsyncSocket *_asyncSocket;
//    int reConnectCount;
    dispatch_queue_t _delegateQueue;
    dispatch_queue_t _connectQueue;
    dispatch_source_t _connectTimer;
    BOOL connectInterrupt;
    
    NSLock *_lock;
}

@property(nonatomic,strong) NSMutableDictionary<NSNumber*, TcpSocketConnection*> *connectingDic;

@end

@implementation TcpSocketManager

static TcpSocketManager *tcpsocket = nil;
static dispatch_once_t onceToken;
//static NSDate *startDate;

+ (instancetype)sharedInstance {
    dispatch_once(&onceToken, ^{
        tcpsocket = [[self alloc] init];
    });
    return tcpsocket;
}

- (instancetype)init
{
    if (self = [super init]) {
        _delegateQueue = dispatch_queue_create("tcpSocketDelegateQueue", DISPATCH_QUEUE_CONCURRENT);
        _connectQueue = dispatch_queue_create("tcpSocketConnectQueue", DISPATCH_QUEUE_CONCURRENT);
        _connectingDic = [NSMutableDictionary dictionaryWithCapacity:10];
        _lock = [[NSLock alloc] init];
        _messageHandler = [[TcpSocketMessageHandler alloc] init];
    }
    return self;
}

/**
 * 连接远端
 */
-(void)start:(TcpSocketConnection *)connection{
    if ([_connectingDic.allKeys containsObject:@(connection.hash)]) {
        TcpSocketConnection *conn = [_connectingDic objectForKey:@(connection.hash)];
        if (conn.asyncSocket.isConnected) { return; }
        [_connectingDic removeObjectForKey:@(connection.hash)];
    }
    [self connectWithConnection:connection.copy];
}

//连接socket 地址 端口号
- (void)connectWithConnection:(TcpSocketConnection *)connection
{
    GCDAsyncSocket *asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_delegateQueue];
    connection.asyncSocket = asyncSocket;
    
    NSError *error = nil;
    [connection.asyncSocket connectToHost:connection.ip onPort:connection.port withTimeout:4.0 error:&error];
    connection.startTime = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSLog(@"%@",[NSString stringWithFormat:@"开始连接 %@:%d", connection.ip, connection.port]);
    
    if (error) {
        NSLog(@"%@",[NSString stringWithFormat:@"连接错误:%@ - %@:%d", error, connection.ip, connection.port]);
        [self reConnect:connection];
    } else {
        [_connectingDic setObject:connection forKey:@(connection.hash)];
    }
}

//重连
-(void)reConnect:(TcpSocketConnection *)connection {
    if (connection.reConnectedCount >= connection.reConnectCount) {
        return;
    }
    
    //延后一秒再尝试重连
    __weak typeof(self) weakSelf = self;
    __block TcpSocketConnection *conn = connection.copy;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC * 1)), _connectQueue, ^{
        NSError *error = nil;
        [conn.asyncSocket connectToHost:conn.ip onPort:conn.port withTimeout:4.0 error:&error];
        conn.reConnectedCount ++;
        conn.startTime = [NSDate dateWithTimeIntervalSinceNow:0];
        
        NSLog(@"%@",[NSString stringWithFormat:@"开始连接 %@:%d", conn.ip, conn.port]);

        if (error) {
            NSLog(@"%@",[NSString stringWithFormat:@"连接错误%d次:%@ - %@:%d", conn.reConnectedCount, error, conn.ip, conn.port]);
            [self reConnect:conn];
        } else {
            [weakSelf.connectingDic setObject:conn forKey:@(conn.hash)];
        }
    });
}

//-(void)reConnectForTimes:(TcpSocketConnection *)connection {
//    if(_connectTimer != nil) {
//        dispatch_source_cancel(_connectTimer);
//        _connectTimer = nil;
//    }
//    if(connection.reConnectCount > 6){
//        connection.reConnectCount = 6;
//    }
//
//    _connectQueue = dispatch_queue_create("_reConnectFCQueue", NULL);
//    _connectTimer= dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _connectQueue);
//    //开始时间
//    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC);
//    //间隔时间
//    uint64_t interval = NSEC_PER_SEC * connection.reConnectCount;
//    dispatch_source_set_timer(_connectTimer, start, interval, 0);
//    //设置回调
//    __weak __typeof__(self) weakSelf = self;
//    dispatch_source_set_event_handler(_connectTimer, ^{
//        [weakSelf connectTimerStart:connection];
//    });
//    //启动timer
//    dispatch_resume(_connectTimer);
//}


//断开连接
- (void)disconnect:(TcpSocketConnection *)connection
{
    [connection.asyncSocket disconnect];
}

//读
- (void)readDataFromConnection:(TcpSocketConnection *)connection withTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    [connection.asyncSocket readDataWithTimeout:-1 tag:tag];
}

//写
- (void)writeToConnection:(TcpSocketConnection *)connection withData:(NSData *)data withTag:(long)tag;
{
    [connection.asyncSocket writeData:data withTimeout:-1 tag:tag];
}

#pragma mark -- GCDAsyncSocketDelegate method

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"已经断开");
    TcpSocketConnection *connection = [self getConnectionForSocket:sock];
    [self.messageHandler connectionDisconnected:connection];
    if ([_connectingDic.allKeys containsObject:@(connection.hash)]) {
        [_connectingDic removeObjectForKey:@(connection.hash)];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {

    TcpSocketConnection *connection = [self getConnectionForSocket:sock];
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval seconds = [now timeIntervalSinceDate:connection.startTime];
    connection.connectConsumingTime = seconds;
    
    NSLog(@"%@:%d 端口连接成功", host, port);
    NSLog(@"连接耗时：%f 秒", seconds);

//    if(_connectTimer!=nil)
//    {
//        dispatch_source_cancel(_connectTimer);
//        _connectTimer = nil;
//    }
    
//    [sock readDataWithTimeout:-1 tag:kTcpFCPort];
    
    [self.messageHandler connectSuccess:connection];
}

//读数据成功代理
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    [sock readDataWithTimeout:-1 tag:tag];
}

///发送消息成功之后回调
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
//    [sock readDataWithTimeout:-1 tag:kTcpFCPort];
}

//断开重连方法
-(void)connectTimerStart:(TcpSocketConnection *)connection{
    @autoreleasepool {
        dispatch_async(_connectQueue, ^{
            NSLog(@"%@",[NSString stringWithFormat:@"重新连接 %@:%d -- 第%d次", connection.ip, connection.port, connection.reConnectedCount]);
            [self connectWithConnection:connection];
        });
    }
}

#pragma Private
-(TcpSocketConnection *)getConnectionForSocket:(GCDAsyncSocket *)sock {
    //根据sock查找connection
    for (TcpSocketConnection *connection in _connectingDic.allValues) {
        if (sock.hash == connection.asyncSocket.hash) {
            return connection;
        }
    }
    return nil;
}

@end
