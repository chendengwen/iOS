//
//  MyProxy.h
//  Test
//
//  Created by gary on 2021/6/7.
//

#import <Foundation/Foundation.h>

@interface MyProxy : NSProxy{
    //在内部hold住一个要hook的对象
    id _innerObject;
}

+(instancetype)proxyWithObj:(id)object;

@end

