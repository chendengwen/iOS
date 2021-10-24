//
//  SocketMessage.m
//  Socket_Test
//
//  Created by 陈登文 on 2021/10/24.
//

#import "TcpSocketMessage.h"

@implementation TcpSocketMessage

-(NSUInteger)hash {
    return self.hash & self.messageData.hash & self.tag;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"message info: \n type: %d \n tag: %ld \n content: %@",self.messageType, self.tag, [[NSString alloc] initWithData:self.messageData encoding:NSUTF8StringEncoding]];
}

@end
