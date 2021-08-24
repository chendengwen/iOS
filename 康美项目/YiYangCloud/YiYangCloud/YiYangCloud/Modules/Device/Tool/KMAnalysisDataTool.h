//
//  KMAnalysisDataTool.h
//  藍牙四合一
//
//  Created by zhong on 2017/1/11.
//  Copyright © 2017年 kangmei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPValueModel.h"
#import "temperatureValueModel.h"
#import "BSValueModel.h"

//血糖仪名称
//#define BLOOD_GLUCOSE_METER_NAME @"ZH-G01"
////体温计名称
//#define HERMOMETER_NAME @"AET-WD"
////血压计名称
//#define SPHYGMOMANOMETER_NAME @"AES-XY"



@interface KMAnalysisDataTool : NSObject


+ (instancetype)shareAnalysisDataTool;

//过滤
- (BOOL)filterOnDiscoverName:(NSString *)name;
- (BOOL)checkDeviceName:(NSString *)name forKey:(NSString *)key;

//是否订阅通知
- (BOOL)isNotifiForCharacteristic:(CBCharacteristic *)characteristic;

//根据蓝牙名称获取设备类型
- (NSString *)getDeviceType:(NSString *)name;
//根据蓝牙类型获取蓝牙图片名称
- (NSString *)getDeviceImg:(NSString *)type;

//BP826 血压获取
- (BPValueModel *)getBloodPressureForBP826:(NSData *)value;
//AES-XY 血压获取
- (BPValueModel *)getBloodPressureForAES_XY:(NSData *)value;

- (void)showData:(NSData *)data type:(NSUInteger)intdex;

//BLETemp 体温获取
- (temperatureValueModel *)getTemperature_BLETemp:(NSData *)data;
//R161 体温获取
- (temperatureValueModel *)getTemperature:(NSData *)data;

//ZH-GU01 血糖获取
- (BSValueModel *)getBloodSugar:(NSData *)value WithCurrPeripheral:(CBPeripheral *)currPeripheral WithWrite:(CBCharacteristic *)write WithOldBloodSugarModel:(BSValueModel *)oldBloodSugarModel;
//Glucose 血糖获取
- (BSValueModel *)getBloodSugar_Glucose:(NSData *)value;
//利用UUID获取一个假的MAC地址
- (NSString *)getBuletoothFlaseMAC:(NSString *)value;






////血压计数据解析
//- (NSInteger)getNumWithLowStr:(NSString *)lowStr WithHighStr:(NSString *)highStr;
//
////血压计数据校验 校验位10
//- (BOOL)checkSphygmomanometerData:(NSData *)data;
//
////获取血压计错误信息
//- (NSString *)getBPError:(NSData *)value;

//// 数据校验
//- (BOOL)checkData:(NSData *)data checkIndex:(NSInteger)index;
//
//// 新体温计数据校验
//- (BOOL)checkR111Data:(NSData *)data;
//
////写数据
//-(void)writeCharacteristic:(CBPeripheral *)peripheral
//            characteristic:(CBCharacteristic *)characteristic
//                     value:(NSData *)value;
@end
