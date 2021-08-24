//
//  ViewController.m
//  UDPTest
//
//  Created by mac on 2017/12/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncUdpSocket.h"
#import "GCDAsyncSocket.h"

@interface ViewController ()<GCDAsyncUdpSocketDelegate,GCDAsyncSocketDelegate>
{
    
    GCDAsyncUdpSocket *udpSocket;
    GCDAsyncSocket *tcpSocket;
    dispatch_queue_t _sendQueue;
    
    int tcpMsgTag;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /** UDP  **/
    /*
    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    if(![udpSocket bindToPort:20002 error:&error]){
        NSLog(@"error in bindToPort");
        //return;
    }else {//监听成功则开始接收信息
        [udpSocket beginReceiving:&error];
    }
    
    //启用广播
    [udpSocket enableBroadcast:YES error:&error];
    if (error) {
        NSLog(@"2:%@",error);
        return;
    }
     */
        
    
    
}

- (IBAction)buttonClick:(id)sender {

    _sendQueue = dispatch_queue_create("udp_send_queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(_sendQueue, ^(){
        // udp不用连接,故直接发送数据
            [udpSocket sendData:[@"123" dataUsingEncoding:NSUTF8StringEncoding] toHost:@"255.255.255.255" port:20002 withTimeout:-1 tag:0];
    });
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"发送信息成功");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"发送信息失败");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSLog(@"接收到%@的消息:%@",address,data);//自行转换格式吧
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"udpSocket关闭");
}



- (IBAction)tcpConnectClick:(id)sender {
    /** TCP  **/
    /**/
    tcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
//    [tcpSocket connectToAddress:[@"192.168.2.2" dataUsingEncoding:NSUTF8StringEncoding] error:&error];
    [tcpSocket connectToHost:@"192.168.2.2" onPort:20001 error:&error];
    if (error) {
        NSLog(@"连接服务器  失败");
        NSLog(@"%@",error);
    } else {
        NSLog(@"连接服务器  成功");
    }
}

- (IBAction)tcpSendMessage:(id)sender {
    NSString *loginStr = [NSString stringWithFormat:@"msaaage -- %d",tcpMsgTag];
    // 把string转成NSData
    NSData *data = [loginStr dataUsingEncoding:NSUTF8StringEncoding];
    [tcpSocket writeData:data withTimeout:-1 tag:tcpMsgTag];
    
    tcpMsgTag++;
}


-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"成功连接到%@:%d",host,port);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if (err) {
        NSLog(@"%@",err);
    }
}

// 数据成功发送到服务器
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
    // 需要自己调用读取方法，socket才会调用代理方法读取数据
    [tcpSocket readDataWithTimeout:-1 tag:tag];
    
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
   NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"message == %@",msg);
}


@end
