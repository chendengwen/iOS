//
//  BaseCodingModelTest.m
//  FuncGroup
//
//  Created by gary on 2017/3/3.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestCodingModel.h"
#import "OCMock.h"

@interface BaseCodingModelTest : XCTestCase

@end

@implementation BaseCodingModelTest

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

-(void)testArchive{
    TestCodingModel *model = [[TestCodingModel alloc] init];
    model.name = @"cdw";
    model.sex = @"男";
    
    NSString *name = @"1222";
    [model setValue:name forKey:@"name"];
    
    XCTAssertEqual(model.name, name,@"1 两值应该相等");
    
    TestCodingModel *model_1 = (TestCodingModel *)[TestCodingModel valuesFromUnarchiveing];
    XCTAssertEqualObjects(model.name, model_1.name,@"2 两值应该相等");
    
    BOOL success = [model archiveRootObjectToFile];
    XCTAssertTrue(success,@"本地化失败");
}

-(void)testUnarchive{
    TestCodingModel *model = (TestCodingModel *)[TestCodingModel valuesFromUnarchiveing];
    XCTAssertNotNil(model,@"本地文件解码失败");
}

-(void)testOCMock{
    id jalopy = OCMStrictClassMock([TestCodingModel class]);
    OCMStub([jalopy testSomeFunction:@"OCMStub"]).andReturn(@"123");
    
    
    NSLog(@"iii = %@",[jalopy testSomeFunction:@"OCMStub"]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
