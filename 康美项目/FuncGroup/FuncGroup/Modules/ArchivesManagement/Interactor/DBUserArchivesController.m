//
//  DBUserArchivesController.m
//  FuncGroup
//
//  Created by gary on 2017/3/6.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "DBUserArchivesController.h"
#import "ArchivesModel.h"
#import "NSObject+Property.h"
#import "WhereStatement.h"
#import "AppCacheManager.h"
#import "ConstantKeys.h"

@implementation DBUserArchivesController

-(NSArray *)getAllRecord{
    ArchivesModel *model = [[ArchivesModel alloc] init];
    NSArray *dataArr = [self.dbHelper executeToModel:model
                                                 sql:[ArchivesModel getAllArchiveRecords]
                                       withArguments:nil];
    return dataArr;
}

- (ArchivesModel *)getCurrentUserArchive{
    ArchivesModel *model = [[ArchivesModel alloc] init];
    NSString *uid = (NSString *)[[AppCacheManager sharedAppCacheManager] cacheForKey:KCurrentID];
    if (uid && uid.integerValue > 0) {
        NSArray *dataArr = [self.dbHelper executeToModel:model
                                                     sql:[ArchivesModel getCurrentUserArchive]
                                           withArguments:@[uid]];
        if (!dataArr) {
            return nil;
        }
        
        return [dataArr lastObject];
    }
    
    return nil;
}

-(NSArray *)getArchivesRecordPageIndex:(NSInteger)pageIndex{
    ArchivesModel *model = [[ArchivesModel alloc] init];
    NSArray *dataArr = [self.dbHelper executeToModel:model
                                                 sql:[ArchivesModel getArchiveRecordsAgeIndex]
                                       withArguments:@[[NSString stringWithFormat:@"%ld",(long)pageIndex*10]]];
    return dataArr;
}

-(BOOL)insertArchivesRecord:(ArchivesModel *)model{
    if (model == nil)
        return NO;
    
    BOOL success = [self.dbHelper insertDbByTableModels:@[model] columns:[model getPropertyList]];
    if (!success) {
        printf("插入Model失败！！！");
    }
    
    return success;
}

/*
 @brief 更改一条数据
 */
-(BOOL)updateRecord:(ArchivesModel *)model{
    if (model == nil)
        return NO;
    
    BOOL success = [self.dbHelper updateDbByTableModels:@[model] setColumns:[model getPropertyList]  where:@[WS_key(model.ArchivesID)]];
    if (!success) {
        printf("更改Model失败！！！");
    }
    
    return success;
}

-(BOOL)deleteRecord:(ArchivesModel *)model{
    if (model == nil)
        return NO;
    
    BOOL success = [self.dbHelper deleteDbByTableModels:@[model] where:@[WS_key(model.ArchivesID)]];
    if (!success) {
        printf("删除ArchivesRecordModel失败！！！");
    }
    
    return success;
}

/*
 @brief 查询一条数据
 */
-(NSArray *)queryRecord:(ArchivesModel *)model{
    WhereStatement *where_1 = [WhereStatement instanceWithKey:@"Name"
                                                    operation:SqlOperationEqual
                                                 relationShip:SqlLinkRelationShipOr];
    WhereStatement *where_2 = [WhereStatement instanceWithKey:@"IdCard"
                                                    operation:SqlOperationEqual
                                                 relationShip:SqlLinkRelationShipOr];
    
    NSArray *dataArr = [self.dbHelper queryAllToModel:model where:@[where_1,where_2]];
    return dataArr;
}


@end
