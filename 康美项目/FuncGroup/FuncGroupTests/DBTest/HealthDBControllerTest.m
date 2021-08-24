//
//  HealthDBControllerTest.m
//  FuncGroup
//
//  Created by gary on 2017/3/2.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCMock.h"

#import "AppCacheManager.h"
#import "DBHealthRecordController.h"
#import "temperatureValueModel.h"

@interface HealthDBControllerTest : XCTestCase

@property (nonatomic,strong) DBHealthRecordController *dbCtl;

@end

@implementation HealthDBControllerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _dbCtl = [DBHealthRecordController dbController];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
}

-(void)testInsertTPModel{
    
    _dbCtl.type = HealthRecordTiWen;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    int latestUID = 1020;
    
    for (int i = 0; i < 15; i ++) {
        temperatureValueModel *model = [[temperatureValueModel alloc] init];
        model.uid = latestUID + i;
        model.value = 37.5;
        sleep(1);
        NSDate *result = [NSDate dateWithTimeIntervalSince1970:i*123];
        model.data =  [dateFormatter stringFromDate:result];
        
//        [[AppCacheManager sharedAppCacheManager] setAppCache:G_str(@"%lu", (unsigned long)model.uid) forKey:@"currentID"];
        
        BOOL success = [_dbCtl insertRecord:model];
        XCTAssertTrue(success, @"insertRecord failed");
    }
    
    temperatureValueModel *OCModel = OCMClassMock([temperatureValueModel class]);
    OCModel.uid = latestUID + 20;
    OCModel.value = 37.5;
    sleep(1);
    NSDate *result = [NSDate dateWithTimeIntervalSince1970:100090];
    OCModel.data =  [dateFormatter stringFromDate:result];

}

-(void)testGetModelListPageIndex{
    _dbCtl.type = HealthRecordAll;
    
    NSArray *modelList = [_dbCtl getAllRecord];
    XCTAssertNotNil(modelList,@"成功根据uid查询到数据");
}

-(void)testGetModelList{
    _dbCtl.type = HealthRecordTiWen;
    
    NSArray *modelList = [_dbCtl getAllRecord];
    XCTAssertNotNil(modelList,@"成功查询到数据");
    NSArray *modelListByUID = [_dbCtl getAllRecordByUID];
    XCTAssertNotNil(modelListByUID,@"成功根据uid查询到数据");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
