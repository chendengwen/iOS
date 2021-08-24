//
//  bluetoothDeviceDataModel.h
//  FuncGroup
//
//  Created by zhong on 2017/2/16.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HealthRecordPublic.h"
#import "BSValueModel.h"
#import "BPValueModel.h"
#import "temperatureValueModel.h"
typedef NS_ENUM(NSInteger, DeviceName) {
    DeviceName_BP,
    DeviceName_Temperature,
    DeviceName_BS,
    DeviceName_Demonstrate
};

@class DBHealthRecordController;
@interface bluetoothDeviceDataManager : NSObject
//血糖
@property (nonatomic,strong) BSValueModel *BSModel;
//血压
@property (nonatomic,strong) BPValueModel *BPModel;
//温度
@property (nonatomic,strong) temperatureValueModel *TModel;
//量测血压历史数据
@property (nonatomic,strong) NSMutableArray *BPmArray;
//量测温度历史数据
@property (nonatomic,strong) NSMutableArray *TmArray;
//量测血糖历史数据
@property (nonatomic,strong) NSMutableArray *BSmArray;

//日期格式
@property (nonatomic,strong) NSDateFormatter *format;

@property (nonatomic,copy) NSString *IdCard;


@property (nonatomic, strong) DBHealthRecordController *dbController;

@property (nonatomic, assign) HealthRecordType type;

- (void)saveData;

- (void)clearData;

+ (instancetype)sharedInstance;

@end
