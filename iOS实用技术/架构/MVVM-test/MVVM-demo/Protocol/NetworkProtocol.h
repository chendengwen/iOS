//
//  NetworkProtocol.h
//  MVVM-demo
//
//  Created by gary on 2021/7/6.
//

typedef void(^RequestSuccess)(id data);
typedef void(^RequestFail)(NSError *error);

@protocol NetWorkProtocol <NSObject>

-(void)fetchData:(NSString *)path params:(NSDictionary *)params success:(RequestSuccess)successBlock fail:(RequestFail)failBlock;

@end
