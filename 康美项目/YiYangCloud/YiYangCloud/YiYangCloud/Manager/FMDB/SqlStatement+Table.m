//
//  SqlStatement+Table.m
//  FuncGroup
//
//  Created by gary on 2017/3/1.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "SqlStatement+Table.h"

@implementation SqlStatement (Table)

+ (NSString *)createBPValueModelTable
{
    return @" "
    " CREATE TABLE [BPValueModel] ( "
    " [data] text,  "
    " [type] integer,  "
    " [uid] integer,  "
    " [errorStr] text,  "
    " [LBP] integer,  "
    " [HBP] integer,  "
    " [heartRate] integer,  "
    " [hearRateState] text  "
    " )";
}

+ (NSString *)createBSValueModelTable
{
    return @" "
    " CREATE TABLE [BSValueModel] ( "
    " [data] text,  "
    " [type] integer,  "
    " [uid] integer,  "
    " [errorStr] text,  "
    " [value] float  "
    " )";
}

+ (NSString *)createTemperatureValueModelTable
{
    return @" "
    " CREATE TABLE [temperatureValueModel] ( "
    " [data] char(10),  "
    " [type] integer,  "
    " [uid] integer,  "
    " [errorStr] text,  "
    " [value] float,  "
    " [hit] integer,  "
    " [isTiwen] text  "
    " )";
}

+ (NSString *)createDeviceModelTable
{
    return @" "
    " CREATE TABLE [DeviceModel] ( "
    " [deviceName] text,  "
    " [locked] integer,  "
    " [deviceIcon] text,  "
    " [UUID] text,  "
    " [MAC] text,  "
    " [time] text  "
    " )";
}

+ (NSString *)createArchivesValueModelTable{
    return @" "
    " CREATE TABLE [ArchivesModel] ( "
    " [ArchivesID]  integer PRIMARY KEY autoincrement,  "
    " [Name] text,  "
    " [Sex] text,  "
    " [IdCard] text,  "
    " [Birthday] text,  "
    " [Domicile] text,  "
    " [Ethnic] text,  "
    " [Address] text,  "
    " [PermanentType] text,  "
    " [Marriage] text,  "
    " [BloodType] text,  "
    " [Job] text,  "
    " [Educational] text,  "
    " [RH] text,  "
    " [Tel] text,  "
    " [Guardian] text,  "
    " [GuardianTel] text,  "
    " [DrugAllergy] text,  "
    " [OtherDrugAllergy] text,  "
    " [Revealabliity] text,  "
    " [OtherRevealabliity] text,  "
    " [Doctor] text,  "
    " [ArchiverManager] text,  "
    " [ArchiveDate] text,  "
    " [MachineNo] text,  "
    " [isOn] text,  "
    " [Anamneses] text,  "
    " [Operations] text,  "
    " [Traumas] text,  "
    " [Transfutions] text,  "
    " [ExamTime] text,  "
    " [HeredityName] text,  "
    " [Anamneses_1] text,  "
    " [Anamneses_Date_1] text,  "
    " [Anamneses_2] text,  "
    " [Anamneses_Date_2] text,  "
    " [Anamneses_3] text,  "
    " [Anamneses_Date_3] text,  "
    " [Operations_1] text,  "
    " [Operations_Date_1] text,  "
    " [Operations_2] text,  "
    " [Operations_Date_2] text,  "
    " [Traumas_1] text,  "
    " [Traumas_Date_1] text,  "
    " [Traumas_2] text,  "
    " [Traumas_Date_2] text,  "
    " [Transfutions_1] text,  "
    " [Transfutions_Date_1] text,  "
    " [Transfutions_2] text,  "
    " [Transfutions_Date_2] text,  "
    " [Photo] blob,  "
    " [physiqueTestKey] text  "
    " )";
}

@end
