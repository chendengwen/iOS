//
//  Device_DBController.m
//  FuncGroup
//
//  Created by zhong on 2017/3/1.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "Device_DBController.h"
#import "WhereStatement.h"

@implementation Device_DBController

-(NSArray *)getArchivesRecordPageIndex:(NSInteger)pageIndex{
    DeviceModel *model = [[DeviceModel alloc] init];
    NSArray *dataArr = [self.dbHelper executeToModel:model
                                                 sql:[Device_DBController getRecordAArchivesageIndex]
                                       withArguments:@[[NSString stringWithFormat:@"%ld",(long)pageIndex*10]]];
    return dataArr;
}

-(NSArray *)getAllArchivesRecord{
    DeviceModel *model = [[DeviceModel alloc] init];
    NSArray *dataArr = [self.dbHelper executeToModel:model
                                                 sql:[Device_DBController getAllRecord]
                                       withArguments:nil];
    return dataArr;
}

-(void)insertRecord:(NSArray *)models{
    if (models == nil)
        return;


    BOOL success = [self.dbHelper insertDbByTableModels:models columns:@[
                                                                           PropertyStr(model.deviceName),
                                                                           PropertyStr(model.locked),
                                                                           PropertyStr(model.deviceIcon),
                                                                           PropertyStr(model.MAC),
                                                                           PropertyStr(model.UUID),
                                                                           PropertyStr(model.time)
                         ]];
    if (!success) {
        printf("插入DeviceModel失败！！！");
    }
}

-(void)deleteRecord:(DeviceModel *)model{
    if (model == nil)
        return;
    
    BOOL success = [self.dbHelper deleteDbByTableModels:@[model] where:@[]];
    if (!success) {
        printf("删除DeviceModel失败！！！");
    }
}

-(void)updateRecord:(DeviceModel *)model{
    if (model == nil)
        return;
    
    BOOL success = [self.dbHelper updateDbByTableModels:@[model] setColumns:@[
                                                                              PropertyStr(model.deviceName),
                                                                              PropertyStr(model.locked),
                                                                              PropertyStr(model.deviceIcon),
                                                                              PropertyStr(model.MAC),
                                                                              PropertyStr(model.UUID),
                                                                              PropertyStr(model.time)
                                                               ] where:@[ [WhereStatement instanceWithKey:@"ArchivesID"]]];
    if (!success) {
        printf("更改DeviceModel失败！！！");
    }
}

-(NSArray *)queryRecord:(DeviceModel *)model{
    //- (NSArray *)queryAllToModel:(BaseModel *)model
    //where:(NSArray *)expressions;
    WhereStatement *where_1 = [WhereStatement instanceWithKey:@"Name"
                operation:SqlOperationEqual
             relationShip:SqlLinkRelationShipOr];
    WhereStatement *where_2 = [WhereStatement instanceWithKey:@"IdCard"
                                                    operation:SqlOperationEqual
                                                 relationShip:SqlLinkRelationShipOr];
    
    NSArray *dataArr = [self.dbHelper queryAllToModel:model where:@[where_1,where_2]];
    return dataArr;
}


#pragma mark === SqlStatement
+ (NSString *)getRecordAArchivesageIndex
{
    return @"select * from [DeviceModel]"
    " ORDER BY [time] desc"
    " limit 10 offset ?";
}

+ (NSString *)getAllRecord
{
    return @"select * from [DeviceModel]"
    " ORDER BY [time] desc";
}

#pragma mark === HealthDBCtlProtocol
- (NSArray *)getRecordPageIndex:(NSInteger)pageIndex{
    return [self getArchivesRecordPageIndex:pageIndex];
}

- (NSArray *)getAllRecord{
    return [self getAllArchivesRecord];
}



@end
