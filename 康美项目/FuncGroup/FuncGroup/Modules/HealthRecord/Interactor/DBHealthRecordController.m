//
//  DBHealthRecordController.m
//  FuncGroup
//
//  Created by gary on 2017/2/23.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "DBHealthRecordController.h"

#import "AppCacheManager.h"
#import "HealthBaseModel.h"

@implementation DBHealthRecordController

Class ModelOfType(HealthRecordType type){
    // 元素顺序和 HealthRecordType 枚举索引相对应
    NSArray *modelClassArr = @[@"HealthRecordModel",
                               @"BPValueModel",
                               @"BSValueModel",
                               @"temperatureValueModel"];
    
    return NSClassFromString(modelClassArr[type]);
}

#pragma mark === HealthDBCtlProtocol
/*!
 @brief 查询相关的方法
 */
-(NSArray<HealthBaseModel *> *)getAllRecord{
    return [self getDBDataAtPageIndex:0 allData:YES pageSize:20 withUID:NO];
}

-(NSArray<HealthBaseModel *> *)getAllRecordByUID{
    return [self getDBDataAtPageIndex:0 allData:YES pageSize:20 withUID:YES];
}

- (NSArray<HealthBaseModel *> *)getRecordPageIndex:(NSInteger)pageIndex{
    return [self getDBDataAtPageIndex:pageIndex allData:NO pageSize:10 withUID:YES];
}

- (NSArray<HealthBaseModel *> *)getRecordPageIndex:(NSInteger)pageIndex pageSize:(int)size{
    return [self getDBDataAtPageIndex:pageIndex allData:NO pageSize:size withUID:YES];
}

/*!
 @brief 根据条件查询
 @param pageIndex 查询的分页索引
 @param all 是否是获取全表，为YES时pageIndex无效
 @param size 分页尺寸，默认为10，获取全表时默认为20
 @param whether 是否是根据uid来查
 @return NSArray<HealthBaseModel *> 结果数据列表
 */
-(NSArray<HealthBaseModel *> *)getDBDataAtPageIndex:(NSInteger)pageIndex allData:(BOOL)all pageSize:(int)size withUID:(BOOL)whether{
    Class class = ModelOfType(self.type);
    HealthBaseModel *model = [[class alloc] init];
    
    NSString *sqlStatement = all ? [class getAllDBRecordByUID:whether] : [class getDBRecordAtPageByUID:whether];
    
    NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:2];
    
    // !!! 注意参数顺序,根据sql语句添加参数
    if (whether) {
        NSUInteger uid = member.currentUserArchives.ArchivesID.unsignedIntegerValue;
        [arguments addObject:[NSString stringWithFormat:@"%zd",uid]];
        if (self.type == HealthRecordAll) {
            [arguments addObject:[NSString stringWithFormat:@"%zd",uid]];
            [arguments addObject:[NSString stringWithFormat:@"%zd",uid]];
        }
    }
    if (!all) {
        [arguments addObject:[NSString stringWithFormat:@"%ld",(long)pageIndex*size]];
    }
    
    NSArray *dataArr = [self.dbHelper executeToModel:model
                                                 sql:sqlStatement
                                       withArguments:arguments];
    
    return dataArr;
}

/*
 @brief 插入相关的方法
 */
-(BOOL)insertRecord:(HealthBaseModel *)model{
    if (model == nil)
        return NO;
    
    model.uid = member.currentUserArchives.ArchivesID.unsignedIntegerValue;
    NSArray *propeties = [[model objectPropeties:1] arrayByAddingObject:@"uid"];
    BOOL success = [self.dbHelper insertDbByTableModels:@[model] columns:propeties];
    if (!success) {
        printf("插入Model失败！！！");
    }
    
    return success;
}


@end
