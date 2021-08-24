//
//  NSMapTableTest.m
//  FuncGroup
//
//  Created by gary on 2017/3/14.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface NSMapTableTest : XCTestCase
{
    NSMapTable *_mapTable;
}

@end

@implementation NSMapTableTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _mapTable = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsWeakMemory];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSString *key = @"key";
    NSNumber *value = @(10);
    [_mapTable setObject:key forKey:value];
    [self aaaa];
}

-(void)aaaa{
    NSLog(@"keyValue == %@",_mapTable);
    NSEnumerator *eum = [_mapTable objectEnumerator];
    NSString *key;
    while((key = [eum nextObject]))
    {
        NSLog(@"keyValue == %@",key);
    }
    
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
