//
//  OCMock_Read.m
//  FuncGroup
//
//  Created by gary on 2017/3/2.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

/*!
 对于一些不容易构造或不容易获取的对象，此时可以创建一个虚拟的对象（mock object）来完成测试。
 
 例如你可能要尝试100次才会返回一个NSError，通过mock object你可以自行创建一个NSError对象，
 测试在出错情况下程序的处理是否符合你的预期。
 
 例如你要连接服务器但是服务器在实验室，你在外工作的时候就无法测试了（小弟就试过这种情况，非常反感），
 这个时候你可以创建一个虚拟的服务器，并返回一些你指定的数据，从而绕过服务器。
 
 例如假设你要访问一个数据库，但是访问过程的开销巨大，
 这时你可以虚拟一个数据库，并且返回一些自行定制的数据，从而绕过了数据库的访问。
 */
#import "OCMock.h"

// 宏定义无任何含义，仅为方便对示例伪代码的理解
#define SomeClass           NSObject
#define instanceMethod      init
#define someMethod          description
#define someMethodParams    conformsToProtocol
#define anObject            [[NSObject alloc] init]

@interface OCMock_Read : NSObject

@end

@implementation OCMock_Read

//mock方法返回值
-(void)mock__1{
    //mock方法返回值这个应该是最常用的一种情况了，也是非常简单的一种情况。示例代码如下：
    
    id mockClass = OCMClassMock([SomeClass class]);
    // OCMStrictClassMock 当mock调用一个没有stub的方法的时候会抛出一个异常。这需要在mock的生命周期中每一个方法调用都要被stub掉
//    id mockClass2 = OCMStrictClassMock([SomeClass class]);
    // 当一个没有stub掉的方法被调用了，这个方法会被转发到真实的对象上。这是对mock技术上的欺骗，但是非常有用，当有一些类不适合让自己很好的被stub
//    Thing *someThing = [[Thing alloc] init];
//    id mockClass3 = OCMPartialMock(someThing);
    
    //没有参数的方法
    OCMStub([mockClass someMethod]).andReturn(anObject);
    //有参数的方法
    //一个非常重要的说明：注意[OCMArg any]的用法。当指定一个带参数的方法时，方法被调用并且参数为指定参数的话，mock会返回andReturn:指定的值。[OCMArg any]方法告诉stub匹配所有的参数值。
    OCMStub([mockClass someMethodParams:[OCMArg any]]).andReturn(anObject);
    
    /*
     这里需要注意的就是有参数的方法，参数是可以具体指定的，也就是说只有满足你指定的具体参数的调用才会被mock指定返回值。例子中的[OCMArg any]是指任意参数。
     */
}

//验证mock方法被调用
-(void)mock__2{
    //有些时候需要验证我们执行的代码流程是否调用了某个外部的方法，这个时候用OCMock就比较简单来实现
    
    id mockClass = OCMClassMock([SomeClass class]);
    //...
    //some code
    //...
    // 没有被调用时会抛出异常
    OCMVerify([mockClass someMethod]);
}

//验证mock方法没有被调用
-(void)mock__3{
    //而有些时候呢，我们想要验证代码没有调用某个方法，这里因为OCMock对这种情况没有支持，我也查阅了很多资料，最后想出了一个比较取巧的办法
    
    static BOOL isCalled = false;
    id mockClass = OCMClassMock([SomeClass class]);
    OCMStub([mockClass someMethod]).andDo(^(NSInvocation *invocation){
        isCalled = YES;
    });
    //...
    //some code
    //...
//    XCTAssertFalse(isCalled,@"");
}

//验证mock方法传入的参数
-(void)mock__4{
    //有的情况需要验证传递给外部调用的参数是否符合预期，示例代码：
    
    id mockClass = OCMClassMock([SomeClass class]);
    OCMStub([mockClass someMethodParams:[OCMArg checkWithBlock:^BOOL(id obj) {
        //...
        //some code
        //...
        return YES;
    }]]);
}

//mock单例
-(void)mock__5{
    //如果我们mock的类是个单例的话，那么使用之前的方法进行mock是不会生效的。不过OCMock提供了一个很简单的解决方法，那就是调用单例返回mock。
    
    id mockClass = OCMClassMock([SomeClass class]);
    OCMStub([mockClass instanceMethod]).andReturn(mockClass);
}

//mock block : using OCMock andDo: operator.
-(void)mock__6{
    //1.这个mock对象使用带NSInvocation参数的“andDo”方法。一个NSInvocation对象代表一个‘objectivetified’（对象标示）表现的方法调用。通过这个NSinvocation对象，使得拦截传递给我们的方法的block参数变得可能。
    
    //2.用与我们测试的方法中相同的方法签名声明一个block参数。
    
    //3.NSInvocation实例方法"getArgument:atIndex:"将赋值后的块函数传递到原始函数中定义的块函数中。注意：在Objective-C中，传递给任意方法的前两个参数都是“self”和“_cmd”.这是一个运行时的小功能以及用下标来获取NSInvocation参数时我们需要考虑的东西。
    
    //4.最后，传递这个回调的预定义字典。
    /*OCMStub([groupModelMock downloadWeatherDataForZip:@"80304" callback:[OCMArg any]]]).andDo((^(NSInvocation *invocation){
        //2. declare a block with same signature
        void (^weatherStubResponse)(NSDictionary *dict);
        //3. link argument 3 with with our block callback
        [invocation getArgument:&weatherStubResponse atIndex:3];
        //4. invoke block with pre-defined input
        NSDictionary *testResponse = @{@"high": @(43) , @"low": @(12)};
        weatherStubResponse(groupMemberMock);
    }));*/
}


@end

