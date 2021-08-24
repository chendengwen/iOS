//
//  TestDemo.m
//  FuncGroup
//
//  Created by gary on 2017/3/27.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCMock.h"
#import "TestModel.h"
#import "TestView.h"
#import "TableDataSource.h"

@interface TestDemo : XCTestCase

@end

@implementation TestDemo

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}


// OCMClassMock 一种友好的mock，不会在没有OCMExpect或OCMStub设置类的所有方法时抛出异常
-(void)testClassMock{
    id classMock = OCMClassMock([TestView class]);
    
    //设置预设
    OCMStub([classMock addModel:[OCMArg isNotNil]]);
    //设置期望，这个classMock需要执行addTweet方法且参数不为nil。不然的话会抛出异常
    OCMExpect([classMock addModel:[OCMArg isNotNil]]);
    
    /* 如果设置了期望而不执行的话会抛出异常 */
    //注释 addModel 的调用测试会报错
    TestModel *testTweet = [[TestModel alloc] init];
    testTweet.userName = @"齐滇大圣";
    [classMock addModel:testTweet];
    
    OCMVerifyAll(classMock);
}

// OCMStrictClassMock 它要求执行类中的所有方法，所以比较适合用来测试必须实现的方法
// !!!!  测试发现貌似OCMStrictClassMock不起作用
- (void)testStrictMock3{
    id classMock = OCMStrictClassMock([TestView class]);
    
    TestModel *testTweet = [[TestModel alloc] init];
    testTweet.userName = @"齐滇大圣";
    [classMock addModel:testTweet];
    
    OCMVerifyAll(classMock);
}

-(void)testTableDataSource{
    // 1.创建TableDataSource
    __block UITableViewCell *configuredCell = nil;
    __block id configuredObject = nil;
    TableViewCellConfigureBlock block = ^(UITableViewCell *a, id b) {
        configuredCell   = a;
        configuredObject = b;
    };
    TableDataSource *dataSource = [[TableDataSource alloc] initWithItems:@[@"a", @"b"]
                                                          CellIdentifier:@"foo"
                                                      ConfigureCellBlock:block];
    
    // 2.创建mock table view
    id mockTableView = OCMClassMock([UITableView class]);
    // 3.设定mockTableView的行为包括返回值
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    OCMStub([mockTableView dequeueReusableCellWithIdentifier:@"foo"]).andReturn(cell);
    OCMStub([mockTableView reloadData]);
    // 4.主动调用cellForRowAtIndexPath方法
    id result = [dataSource tableView:mockTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    // 5.验证mockTableView的行为，如果方法没有被调用会抛出错误
    OCMVerify([mockTableView reloadData]);
    // 验证所有方法
//    OCMVerifyAll(mockTableView);
    
    XCTAssertEqual(result, cell, @"should return equel value ----configuredCell");
    XCTAssertEqual(configuredCell, cell, @"should return equel value ----configuredCell");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
