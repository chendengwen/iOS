////
////  UserArchiveDBControllerTest.m
////  FuncGroup
////
////  Created by gary on 2017/3/6.
////  Copyright © 2017年 gary. All rights reserved.
////
//

#import <XCTest/XCTest.h>

#import "AppCacheManager.h"
#import "DBUserArchivesController.h"
#import "Archives_DBController.h"
#import "ArchivesModel.h"
#import "ConstantKeys.h"
#import "MemberManager.h"
#import "AppCacheManager.h"

#include <objc/runtime.h>

@interface UserArchiveDBControllerTest : XCTestCase
@property (nonatomic,strong) DBUserArchivesController *dbCtl;
@property (nonatomic,strong) Archives_DBController *dbCtl_2;
@end

@implementation UserArchiveDBControllerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _dbCtl = [DBUserArchivesController dbController];
    _dbCtl_2 = [Archives_DBController dbController];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

-(void)testGetModelList{
//    [[AppCacheManager sharedAppCacheManager] setAppCache:G_str(@"%lu", (unsigned long)model.uid) forKey:@"currentID"];
    
    NSArray *modelList = [_dbCtl getAllRecord];
    XCTAssertNotNil(modelList,@"成功查询到所有数据");
    
    ArchivesModel *model = [_dbCtl getCurrentUserArchive];
    XCTAssertNotNil(model,@"成功根据uid查询到数据");
}

-(void)testInsertModel{
    ArchivesModel *model = [[ArchivesModel alloc] init];
//    model.ArchivesID = @(arc4random()%1000);
    model.Name = G_str(@"user_%d",arc4random()%1000);
    model.IdCard = G_str(@"32188778666765%d",arc4random()%1000);
    
    [_dbCtl insertArchivesRecord:model];
    
    // 缓存当前用户ID
    [[AppCacheManager sharedAppCacheManager] setAppCache:G_str(@"%@", model.ArchivesID) forKey:KCurrentID];
    [[AppCacheManager sharedAppCacheManager] setAppCache:G_str(@"%@", model.Name) forKey:KCurrentName];
    [[AppCacheManager sharedAppCacheManager] setAppCache:G_str(@"%@", model.IdCard) forKey:KIdCard];
}

-(void)testInsertArchives_DBModel{
    ArchivesModel *model = [[ArchivesModel alloc] init];
//    model.ArchivesID = @(arc4random()%1000);
    model.Name = G_str(@"user_%d",arc4random()%1000);
    model.IdCard = G_str(@"32188778666765%d",arc4random()%1000);
    
    [_dbCtl_2 insertArchivesRecord:model];
}

-(void)testUpdateModel{
    ArchivesModel *model = [_dbCtl getCurrentUserArchive];
    XCTAssertNotNil(model,@"成功根据uid查询到数据");
    
    model.Address = @"我给你搬了家";
    BOOL success = [_dbCtl updateRecord:model];
    XCTAssertTrue(success,@"更新成功");
}

-(void)testDeleteModel{
    NSArray *modelList = [_dbCtl getAllRecord];
    XCTAssertNotNil(modelList,@"成功查询到所有数据");
    
    BOOL success = [_dbCtl deleteRecord:modelList.lastObject];
    XCTAssertTrue(success,@"删除成功");
}

void IMP_AddFunction(id self, SEL _cmd, NSString *param) {
    NSLog(@"%@",[NSString stringWithFormat:@"成功添加了一个方法%@",param]);
}

-(void)testAddMethod{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    class_addMethod([_dbCtl class], @selector(addFunction:), (IMP)IMP_AddFunction, "v@:@");
    [_dbCtl performSelector:@selector(addFunction:) withObject:@"1123 addFunction"];
#pragma clang diagnostic pop
}

-(void)testClear{
//    ArchivesModel *model = [[ArchivesModel alloc] init];
//    [MemberManager sharedInstance].currentUserArchives = model;
    
    [MemberManager sharedInstance].currentUserArchives = nil;
}

-(void)testArchive{
    ArchivesModel *model = [MemberManager sharedInstance].currentUserArchives;
    XCTAssertNotNil(model,@"缓存数据不为空");
    //    [MemberManager sharedInstance].currentUserArchives = nil;
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
