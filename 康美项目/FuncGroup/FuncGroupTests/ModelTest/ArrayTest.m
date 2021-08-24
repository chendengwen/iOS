//
//  ArrayTest.m
//  FuncGroup
//
//  Created by gary on 2017/3/10.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface ArrayTest : XCTestCase

@end

@implementation ArrayTest

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
    
    NSString *str1 = @"first 00000";
    NSString *str2 = @"second 1";
    NSString *str3 = @"121";
    NSMutableArray *array = [NSMutableArray arrayWithObjects:str1,str2,str3, nil];
    
    NSLog(@"array address === %p ",array);
    // array address === 0x17405e5d0
    NSLog(@"str1 address === %p  str2 address === %p  str3 address === %p",str1,str2,str3);
    // str1 address === 0x10131ce50  str2 address === 0x10131ce70  str3 address === 0x10131ce90
    NSLog(@"&str1 address === %x  &str2 address === %x  &str3 address === %x",(unsigned int)&str1,(unsigned int)&str2,(unsigned int)&str3);
    // &str1 address === 6fd45a70  &str2 address === 6fd45a68  &str3 address === 6fd45a60
    NSLog(@"&array address === %x  &array +1 address === %x  &array +2 address === %x &array +3 address === %x",(unsigned int)&array,(unsigned int)&array+1,(unsigned int)&array+2,(unsigned int)&array+3);
    // &array address === 6fd45a58  &array +1 address === 6fd45a60  &array +2 address === 6fd45a68 &array +3 address === 6fd45a70
    
    NSLog(@"array size == %zu",sizeof(array));
    // array size == 8
    NSLog(@"&array size == %zu",sizeof(&array));
    // &array size == 8
    NSLog(@"str1 size == %zu",sizeof(str1));
    // str1 size == 8
    NSLog(@"&str1 size == %zu",sizeof(&str1));
    // &str1 size == 8
//    class_getInstanceSize([array class]);
    
    int intArray[4] = {10, 20, 30, 40};
    // intArray address === 0x16fd45a88 intArra + 1 address === 0x16fd45a8c
    NSLog(@"intArray address === %p intArra + 1 address === %p",intArray,intArray + 1);
    // intArray address === 0x16fd45a88  &intArray address === 0x16fd45a98
    NSLog(@"intArray address === %p  &intArray address === %p",&intArray,&intArray+1);
    // intArray size == 16
    NSLog(@"intArray size == %zu",sizeof(intArray));
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
