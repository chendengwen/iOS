//
//  MyProxy.m
//  Test
//
//  Created by gary on 2021/6/7.
//

#import "MyProxy.h"

@implementation MyProxy

+(instancetype)proxyWithObj:(id)object{
    MyProxy *proxy = [MyProxy alloc];
    //hold住要hook的对象
    proxy->_innerObject = object;
    //注意返回的值是Proxy对象
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    //这里可以返回任何NSMethodSignature对象，你也可以完全自己构造一个
    return [_innerObject methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    
    if([_innerObject respondsToSelector:invocation.selector]){
        NSString *selectorName = NSStringFromSelector(invocation.selector);
        NSLog(@"Before calling %@",selectorName);
        [invocation retainArguments];
        NSMethodSignature *sig = [invocation methodSignature];
        //获取参数个数，注意再本例里这里的值是3，为什么呢？
        //对，就是因为objc_msgSend的前两个参数是隐含的
        NSUInteger cnt = [sig numberOfArguments];
        
        //本例只是简单的将参数和返回值打印出来
        for (int i = 0; i < cnt; i++) {
            const char * type = [sig getArgumentTypeAtIndex:i];
            if(strcmp(type, "@") == 0){
                NSObject *obj;
                [invocation getArgument:&obj atIndex:i];
                //这里输出的是："parameter (0)'class is MyProxy"
                //也证明了这是objc_msgSend的第一个参数
                NSLog(@"parameter (%d)'class is %@",i,[obj class]);
            }
            else if(strcmp(type, ":") == 0){
                SEL sel;
                [invocation getArgument:&sel atIndex:i];
                //这里输出的是:"parameter (1) is barking:"
                //也就是objc_msgSend的第二个参数
                NSLog(@"parameter (%d) is %@",i,NSStringFromSelector(sel));
            }
            else if(strcmp(type, "q") == 0){
                int arg = 0;
                [invocation getArgument:&arg atIndex:i];
                //这里输出的是:"parameter (2) is int value is 4"
                //稍后会看到我们再调用barking的时候传递的参数就是4
                NSLog(@"parameter (%d) is int value is %d",i,arg);
            }
        }
        
        //消息转发
        [invocation invokeWithTarget:_innerObject];
        const char *retType = [sig methodReturnType];
        if(strcmp(retType, "@") == 0){
            NSObject *ret;
            [invocation getReturnValue:&ret];
            //这里输出的是:"return value is wang wang!"
            NSLog(@"return value is %@",ret);
        }
        NSLog(@"After calling %@",selectorName);
    }
}

@end


