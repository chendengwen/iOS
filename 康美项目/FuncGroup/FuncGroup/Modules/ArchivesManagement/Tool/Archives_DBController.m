//
//  Archives_DBController.m
//  FuncGroup
//
//  Created by zhong on 2017/3/1.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "Archives_DBController.h"
#import "WhereStatement.h"
#import "BPValueModel.h"
#import "temperatureValueModel.h"
#import "BSValueModel.h"
@implementation Archives_DBController
-(NSArray *)getArchivesRecordPageIndex:(NSInteger)pageIndex{
    ArchivesModel *model = [[ArchivesModel alloc] init];
    NSArray *dataArr = [self.dbHelper executeToModel:model
                                                 sql:[Archives_DBController getRecordAArchivesageIndex]
                                       withArguments:@[[NSString stringWithFormat:@"%ld",(long)pageIndex*10]]];
    return dataArr;
}

-(NSArray *)getAllArchivesRecord{
    ArchivesModel *model = [[ArchivesModel alloc] init];
    NSArray *dataArr = [self.dbHelper executeToModel:model
                                                 sql:[Archives_DBController getAllRecord]
                                       withArguments:nil];
    return dataArr;
}

-(void)insertArchivesRecord:(ArchivesModel *)model{
    if (model == nil)
        return;
    
    BOOL success = [self.dbHelper insertDbByTableModels:@[model] columns:@[
                                                                           PropertyStr(model.Name),
                                                                           PropertyStr(model.Sex),
                                                                           PropertyStr(model.IdCard),
                                                                           PropertyStr(model.Birthday),
                                                                           PropertyStr(model.Domicile),
                                                                           PropertyStr(model.Ethnic),
                                                                           PropertyStr(model.Address),
                                                                           PropertyStr(model.PermanentType),
                                                                           PropertyStr(model.Marriage),
                                                                           PropertyStr(model.BloodType),
                                                                           PropertyStr(model.Job),
                                                                           PropertyStr(model.Educational),
                                                                           PropertyStr(model.RH),
                                                                           PropertyStr(model.Tel),
                                                                           PropertyStr(model.Guardian),
                                                                           PropertyStr(model.GuardianTel),
                                                                           PropertyStr(model.DrugAllergy),
                                                                           PropertyStr(model.OtherDrugAllergy),
                                                                           PropertyStr(model.Revealabliity),
                                                                           PropertyStr(model.OtherRevealabliity),
                                                                           PropertyStr(model.Doctor),
                                                                           PropertyStr(model.ArchiverManager),
                                                                           PropertyStr(model.ArchiveDate),
                                                                           PropertyStr(model.MachineNo),
                                                                           PropertyStr(model.isOn),
                                                                           PropertyStr(model.Anamneses),
                                                                           PropertyStr(model.Operations),
                                                                           PropertyStr(model.Traumas),
                                                                           PropertyStr(model.Transfutions),
                                                                           PropertyStr(model.HeredityName),
                                                                           PropertyStr(model.ExamTime),
                                                                           PropertyStr(model.Anamneses_1),
                                                                           PropertyStr(model.Anamneses_Date_1),
                                                                           PropertyStr(model.Anamneses_2),
                                                                           PropertyStr(model.Anamneses_Date_2),
                                                                           PropertyStr(model.Anamneses_3),
                                                                           PropertyStr(model.Anamneses_Date_3),
                                                                           PropertyStr(model.Operations_1),
                                                                           PropertyStr(model.Operations_Date_1),
                                                                           PropertyStr(model.Operations_2),
                                                                           PropertyStr(model.Operations_Date_2),
                                                                           PropertyStr(model.Traumas_1),
                                                                           PropertyStr(model.Traumas_Date_1),
                                                                           PropertyStr(model.Traumas_2),
                                                                           PropertyStr(model.Traumas_Date_2),
                                                                           PropertyStr(model.Transfutions_1),
                                                                           PropertyStr(model.Transfutions_Date_1),
                                                                           PropertyStr(model.Transfutions_2),
                                                                           PropertyStr(model.Transfutions_Date_2),PropertyStr(model.Photo),
                                                                           PropertyStr(model.physiqueTestKey)
                                                                           
                                                                           ]];
    if (!success) {
        printf("插入ArchivesRecordModel失败！！！");
    }
}

-(void)deleteRecord:(ArchivesModel *)model{
    if (model == nil)
        return;
    
    BOOL success = [self.dbHelper deleteDbByTableModels:@[model] where:@[[WhereStatement instanceWithKey:@"ArchivesID"]]];
    
    BPValueModel *BPModel = [[BPValueModel alloc]init];
    BPModel.uid = model.ArchivesID.integerValue;
    BOOL success_BP = [self.dbHelper deleteDbByTableModels:@[BPModel] where:@[[WhereStatement instanceWithKey:@"uid"]]];
    
    BSValueModel *BSModel = [[BSValueModel alloc]init];
    BSModel.uid = model.ArchivesID.integerValue;
    BOOL success_BS = [self.dbHelper deleteDbByTableModels:@[BSModel] where:@[[WhereStatement instanceWithKey:@"uid"]]];
    
    temperatureValueModel *TModel = [[temperatureValueModel alloc]init];
    TModel.uid = model.ArchivesID.integerValue;
    BOOL success_T = [self.dbHelper deleteDbByTableModels:@[TModel] where:@[[WhereStatement instanceWithKey:@"uid"]]];
    
    
    if (!success) {
        DMLog(@"删除ArchivesRecordModel失败！！！");
    }
    
    if (!success_BP) {
        DMLog(@"删除BPValueModel失败！！！");
    }
    
    if (!success_BS) {
        DMLog(@"删除BSValueModel失败！！！");
    }
    
    if (!success_T) {
        DMLog(@"删除temperatureValueModel失败！！！");
    }
}

-(void)updateRecord:(ArchivesModel *)model{
    if (model == nil)
        return;
    
    BOOL success = [self.dbHelper updateDbByTableModels:@[model] setColumns:@[
                                                               PropertyStr(model.Name),
                                                               PropertyStr(model.Sex),
                                                               PropertyStr(model.IdCard),
                                                               PropertyStr(model.Birthday),
                                                               PropertyStr(model.Domicile),
                                                               PropertyStr(model.Ethnic),
                                                               PropertyStr(model.Address),
                                                               PropertyStr(model.PermanentType),
                                                               PropertyStr(model.Marriage),
                                                               PropertyStr(model.BloodType),
                                                               PropertyStr(model.Job),
                                                               PropertyStr(model.Educational),
                                                               PropertyStr(model.RH),
                                                               PropertyStr(model.Tel),
                                                               PropertyStr(model.Guardian),
                                                               PropertyStr(model.GuardianTel),
                                                               PropertyStr(model.DrugAllergy),
                                                               PropertyStr(model.OtherDrugAllergy),
                                                               PropertyStr(model.Revealabliity),
                                                               PropertyStr(model.OtherRevealabliity),
                                                               PropertyStr(model.Doctor),
                                                               PropertyStr(model.ArchiverManager),
                                                               PropertyStr(model.ArchiveDate),
                                                               PropertyStr(model.MachineNo),
                                                               PropertyStr(model.isOn),
                                                               PropertyStr(model.Anamneses),
                                                               PropertyStr(model.Operations),
                                                               PropertyStr(model.Traumas),
                                                               PropertyStr(model.Transfutions),
                                                               PropertyStr(model.HeredityName),
                                                               PropertyStr(model.ExamTime),
                                                               PropertyStr(model.Anamneses_1),
                                                               PropertyStr(model.Anamneses_Date_1),
                                                               PropertyStr(model.Anamneses_2),
                                                               PropertyStr(model.Anamneses_Date_2),
                                                               PropertyStr(model.Anamneses_3),
                                                               PropertyStr(model.Anamneses_Date_3),
                                                               PropertyStr(model.Operations_1),
                                                               PropertyStr(model.Operations_Date_1),
                                                               PropertyStr(model.Operations_2),
                                                               PropertyStr(model.Operations_Date_2),
                                                               PropertyStr(model.Traumas_1),
                                                               PropertyStr(model.Traumas_Date_1),
                                                               PropertyStr(model.Traumas_2),
                                                               PropertyStr(model.Traumas_Date_2),
                                                               PropertyStr(model.Transfutions_1),
                                                               PropertyStr(model.Transfutions_Date_1),
                                                               PropertyStr(model.Transfutions_2),
                                                               PropertyStr(model.Transfutions_Date_2),
                                                               PropertyStr(model.Photo),
                                                               PropertyStr(model.physiqueTestKey)
                                                               ] where:@[ [WhereStatement instanceWithKey:@"ArchivesID"]]];
    if (!success) {
        printf("更改ArchivesRecordModel失败！！！");
    }
}

-(NSArray *)queryRecord:(ArchivesModel *)model{
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
    return @"select * from [ArchivesModel]"
    " ORDER BY [ExamTime] desc"
    " limit 10 offset ?";
}

+ (NSString *)getAllRecord
{
    return @"select * from [ArchivesModel]"
    " ORDER BY [ExamTime] desc";
}

#pragma mark === HealthDBCtlProtocol
- (NSArray *)getRecordPageIndex:(NSInteger)pageIndex{
    return [self getArchivesRecordPageIndex:pageIndex];
}

-(void)insertRecord:(BaseModel *)model{
    [self insertArchivesRecord:(ArchivesModel *)model];
}

- (NSArray *)getAllRecord{
    return [self getAllArchivesRecord];
}



@end
