//
//  KMAnalysisDataTool.m
//  藍牙四合一
//
//  Created by zhong on 2017/1/11.
//  Copyright © 2017年 kangmei. All rights reserved.
//

#import "KMAnalysisDataTool.h"

#define BP_ERROR_0E @"0e" //表示 EEPROM异常
#define BP_ERROR_01 @"01" //表示人体心跳信号太小或压力突降
#define BP_ERROR_02 @"02" //表示有杂讯干扰
#define BP_ERROR_03 @"03" //表示测量结果异常，需要重测
#define BP_ERROR_04 @"04" //表示测得的结果异常
#define BP_ERROR_0F @"0f" //表示充气时间过长
#define BP_ERROR_0B @"0b" //表示电源低电压
#define BP_ERROR_0D @"0d" //E-D 过压

@interface KMAnalysisDataTool ()

@property (nonatomic,strong) NSDictionary *deviceNameDict;
@property (nonatomic,strong) NSArray *deviceNameArray;
@property (nonatomic,strong) NSDictionary *deviceImgDict;
@property (nonatomic,strong) NSArray *notifiCharacteristicArray;
@end

@implementation KMAnalysisDataTool
+ (instancetype)shareAnalysisDataTool{
    
    static KMAnalysisDataTool *share = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        share = [[KMAnalysisDataTool alloc]init];
    });
    return share;
    
}

//过滤
- (BOOL)filterOnDiscoverName:(NSString *)name{
    for (NSString *str in self.deviceNameArray) {
        if ([name hasPrefix:str]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isNotifiForCharacteristic:(CBCharacteristic *)characteristic{
    for (NSString *str in self.notifiCharacteristicArray) {
        if ([characteristic.UUID.UUIDString isEqualToString:str]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)getDeviceType:(NSString *)name{
    NSArray *keys = [self.deviceNameDict allKeys];
    for (NSString *key in keys) {
         NSArray *array = self.deviceNameDict[key];
        for (NSString *str in array) {
            if ([name hasPrefix:str]) {
                return key;
            }
        }
    }
    
    return nil;
}

- (NSString *)getDeviceImg:(NSString *)type{
    return self.deviceImgDict[type];
}

- (BOOL)checkDeviceName:(NSString *)name forKey:(NSString *)key{
    NSArray *array = self.deviceNameDict[key];
    for (NSString *str in array) {
        if ([name hasPrefix:str]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)notifiCharacteristicArray{
    if (_notifiCharacteristicArray != nil) {
        return _notifiCharacteristicArray;
    }
    _notifiCharacteristicArray = @[@"FFF4",@"FFF2",@"FFE4",@"2A18",@"0200706D"];
    return _notifiCharacteristicArray;
}

- (NSDictionary *)deviceImgDict{
    if (_deviceImgDict != nil) {
        return _deviceImgDict;
    }
    
    _deviceImgDict = @{
                       @"血压计":@"device_bloodpress_icon.png",
                       @"血糖仪":@"device_sugar.png",
                       @"体温计":@"device_temperture.png"
                       };
    return _deviceImgDict;
}

- (NSDictionary *)deviceNameDict{
    if (_deviceNameDict != nil) {
        return _deviceNameDict;
    }
    
    _deviceNameDict = @{
                    @"血压计":@[@"AES-XY",@"BP826"],
                    @"血糖仪":@[@"ZH-G01",@"Glucose"],
                    @"体温计":@[@"AET-WD",@"BLE Temp"]
                    };
    return _deviceNameDict;
}

- (NSArray *)deviceNameArray{
    if (_deviceNameArray != nil) {
        return _deviceNameArray;
    }
    
    _deviceNameArray = @[@"AES-XY",@"BP826",@"ZH-G01",@"AET-WD",@"Glucose",@"BLE Temp"];
    return _deviceNameArray;
}

//BP826 血压获取
- (BPValueModel *)getBloodPressureForBP826:(NSData *)value{
    BPValueModel *model = [[BPValueModel alloc]init];
    if ([self checkBP826Data:value]) {
        model.errorStr = @"接收数据失败!";
        return model;
    }
    
    NSString *dataStr = value.description;
    NSString *HBP = [dataStr substringWithRange:NSMakeRange(14, 2)];
    NSString *LBP = [dataStr substringWithRange:NSMakeRange(19, 2)];
    NSString *HDN = [dataStr substringWithRange:NSMakeRange(21, 2)];
    
    NSInteger HBPValue = strtoul([HBP UTF8String], 0, 16);
    NSInteger LBPValue = strtoul([LBP UTF8String], 0, 16);
    NSInteger HDNValue = strtoul([HDN UTF8String], 0, 16);
    model.HBP = HBPValue;
    model.LBP = LBPValue;
    model.heartRate = HDNValue;
    model.hearRateState = @"正常";
    model.errorStr = nil;
    return model;
}

//AES-XY 血压获取
- (BPValueModel *)getBloodPressureForAES_XY:(NSData *)value{

    //  <FDFD5A32 38313546 3455E20D 0A>
    BPValueModel *model = [[BPValueModel alloc]init];
    //数据校验
    if ([self checkSphygmomanometerData:value]) {
        //        [SVProgressHUD showErrorWithStatus:@"接收数据失败!"];
        model.errorStr = @"接收数据失败!";
        return model;
    }
    
    NSString *dataStr = value.description;
    //如果有错误返回错误信息
    if ([[dataStr substringWithRange:NSMakeRange(5, 2)]isEqualToString:@"a5"]) {
        model.errorStr = [self getBPError:value];
        [SVProgressHUD showErrorWithStatus:model.errorStr];
        return model;
    }
    
    //收缩压的值
    NSInteger SBP = [self getNumWithLowStr:[dataStr substringWithRange:NSMakeRange(7, 2)] WithHighStr:[dataStr substringWithRange:NSMakeRange(10, 2)]];
    
    //舒张压的值
    NSInteger DBP = [self getNumWithLowStr:[dataStr substringWithRange:NSMakeRange(12, 2)]
                     
                               WithHighStr:[dataStr substringWithRange:NSMakeRange(14, 2)]];
    
    //心率的值
    NSInteger HR = [self getNumWithLowStr:[dataStr substringWithRange:NSMakeRange(16, 2)] WithHighStr:[dataStr substringWithRange:NSMakeRange(19, 2)]];
    //心率正常的代码为0x55，心率不齐的代码为0XAA
    //心率状态
    NSString *HR_state = [[dataStr substringWithRange:NSMakeRange(21, 2)] isEqualToString:@"55"] ? @"正常" : @"不齐";
    model.HBP = SBP;
    model.LBP = DBP;
    model.heartRate = HR;
    model.hearRateState = HR_state;
    model.errorStr = nil;
    return model;
}

//血压计数据解析
- (NSInteger)getNumWithLowStr:(NSString *)lowStr WithHighStr:(NSString *)highStr{
    //低字节转ASCII码
    char lowC  = strtoul([lowStr UTF8String], 0, 16);
    //高字节转ASCII码
    char highC = strtoul([highStr UTF8String], 0, 16);
    //ASCII码合成十六进制值
    NSString *Hex = [NSString stringWithFormat:@"%c%c",highC,lowC];
    //返回 十六进制转十进制 的值
    return strtoul([Hex UTF8String], 0, 16);
}

- (BOOL)checkBP826Data:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    //fffe084e 55006d00 4242
    unsigned int sum = 0;
    //除了校验位 其他位相加
    for(int i=2;i<[data length];i++){
        //11 为校验位
        if (i != 3) {
            sum += (bytes[i]);
        }
    }
    //相加和 取最后两位
    sum = sum & 0xff;
    
    //与校验位比较
    return !(sum == bytes[3]);
}

//血压计数据校验 校验位10
- (BOOL)checkSphygmomanometerData:(NSData *)data{
    
    Byte *bytes = (Byte *)[data bytes];
    
    unsigned int sum = 0;
    //除了校验位 其他位相加
    for(int i=0;i<[data length];i++){
        //10 为校验位 3~8特殊处理
        if ((i > 2 && i < 9) || i == 10) {
            continue;
        }
        sum += (bytes[i] & 0xff);
    }
    
    sum += strtoul([[NSString stringWithFormat:@"%c%c",bytes[4],bytes[3]] UTF8String], 0, 16);
    sum += strtoul([[NSString stringWithFormat:@"%c%c",bytes[6],bytes[5]] UTF8String], 0, 16);
    sum += strtoul([[NSString stringWithFormat:@"%c%c",bytes[8],bytes[7]] UTF8String], 0, 16);
    
    //相加和 取最后两位
    sum = sum & 0xff;
    
    //与校验位比较
    return !(sum == bytes[10]);
}

//获取血压计错误信息
- (NSString *)getBPError:(NSData *)value{
    NSString *errorStr = [value subdataWithRange:NSMakeRange(3, 1)].description;
    /*
     #define BP_ERROR_0E @"0e" //表示 EEPROM异常
     #define BP_ERROR_01 @"01" //表示人体心跳信号太小或压力突降
     #define BP_ERROR_02 @"02" //表示有杂讯干扰
     #define BP_ERROR_03 @"03" //表示测量结果异常，需要重测
     #define BP_ERROR_04 @"04" //表示测得的结果异常
     #define BP_ERROR_0F @"0f" //表示充气时间过长
     #define BP_ERROR_0B @"0b" //表示电源低电压
     #define BP_ERROR_0D @"0d" //E-D 过压
     */
    if ([errorStr isEqualToString:BP_ERROR_0E]) {
        return @"EEPROM异常";
    }
    if ([errorStr isEqualToString:BP_ERROR_01]) {
        return @"人体心跳信号太小或压力突降";
    }
    if ([errorStr isEqualToString:BP_ERROR_02]) {
        return @"有杂讯干扰";
    }
    if ([errorStr isEqualToString:BP_ERROR_03]) {
        return @"测量结果异常，需要重测";
    }
    if ([errorStr isEqualToString:BP_ERROR_04]) {
        return @"测得的结果异常";
    }
    if ([errorStr isEqualToString:BP_ERROR_0F]) {
        return @"充气时间过长";
    }
    if ([errorStr isEqualToString:BP_ERROR_0B]) {
        return @"电源低电压";
    }
    if ([errorStr isEqualToString:BP_ERROR_0D]) {
        return @"电源过压";
    }
    
    return nil;
}

//Glucose 血糖获取
- (BSValueModel *)getBloodSugar_Glucose:(NSData *)value{
    //870000e0 07010102 3b000000 f00011
    //476c7563 6f736520 53656e73 6f72
    BSValueModel *model = [[BSValueModel alloc]init];
    NSString *valueStr = [value.description substringWithRange:NSMakeRange(30, 2)];
    model.value = strtoul([valueStr UTF8String], 0, 16) / 10.0 * 18.1;
    return model;
}

//ZH-GU01 血糖获取
- (BSValueModel *)getBloodSugar:(NSData *)value WithCurrPeripheral:(CBPeripheral *)currPeripheral WithWrite:(CBCharacteristic *)write WithOldBloodSugarModel:(BSValueModel *)oldBloodSugarModel{
    
    BSValueModel *model = [[BSValueModel alloc]init];
    model.value = -1;
    
    if ([value.description hasPrefix:@"<59025254>"]){
        unsigned char data [4]= {0};
        *(data+0) = '\x59';
        *(data+1) = '\x02';
        *(data+2) = '\xA2';
        *(data+3) = '\xA4';
        
        NSData *nsdata = [NSData dataWithBytes:data length: sizeof(char)*4];
        [self writeCharacteristic:currPeripheral characteristic:write value:nsdata];
        return model;
    }
    
    if ([value.description hasPrefix:@"<590b"]) {
        //血糖
        NSString *num1 = [value.description substringWithRange:NSMakeRange(23, 2)];
        model.value = [[NSString stringWithFormat:@"%.2f",(strtoul([num1 UTF8String],0,16) / 10.0)] floatValue] * 18.1;
        //日期
        unsigned char data [4]= {0};
        *(data+0) = '\x59';
        *(data+1) = '\x02';
        *(data+2) = '\xA1';
        *(data+3) = '\xA3';
        
        NSData *nsdata = [NSData dataWithBytes:data length: sizeof(char)*4];
        [self writeCharacteristic:currPeripheral characteristic:write value:nsdata];
        
        //        oldBloodSugarStr = bloodSugarStr;
        
        return model;
    }
    
    if ([value.description hasPrefix:@"<a512"]) {
        
        unsigned char data [4]= {0};
        *(data+0) = '\x5A';
        *(data+1) = '\x02';
        *(data+2) = '\x51';
        *(data+3) = '\x53';
        
        NSData *nsdata = [NSData dataWithBytes:data length: sizeof(char)*4];
        [self writeCharacteristic:currPeripheral characteristic:write value:nsdata];
        if (oldBloodSugarModel == nil) {
//            return value.description;
            return model;
        }
        return oldBloodSugarModel;
    }
    
    if ([value.description hasPrefix:@"<a50d2a"]) {
        unsigned char data [4]= {0};
        *(data+0) = '\x5A';
        *(data+1) = '\x02';
        *(data+2) = '\x52';
        *(data+3) = '\x54';
        
        NSData *nsdata = [NSData dataWithBytes:data length: sizeof(char)*4];
        [self writeCharacteristic:currPeripheral characteristic:write value:nsdata];
        if (oldBloodSugarModel == nil) {
//            return value.description;
            return model;
        }
        return oldBloodSugarModel;
    }
    return model;
}

//BLE Temp 体温获取
- (temperatureValueModel *)getTemperature_BLETemp:(NSData *)nsdata{
    temperatureValueModel *model = [[temperatureValueModel alloc]init];
    NSLog(@"%@,%zd",nsdata.description,nsdata.length);
    NSString *type = [nsdata.description substringWithRange:NSMakeRange(5, 2)];
//    NSString *Lo = [nsdata.description substringWithRange:NSMakeRange(7, 2)];
    NSString *TH = [nsdata.description substringWithRange:NSMakeRange(10, 2)];
    NSString *TL = [nsdata.description substringWithRange:NSMakeRange(12, 2)];

    CGFloat THNum =  strtoul([TH UTF8String], 0, 16) * 256.0;
    CGFloat TLNum =  strtoul([TL UTF8String], 0, 16);
    CGFloat TiWen = (THNum + TLNum) / 10.0;
    //华氏度转摄氏度
    if ([type isEqualToString:@"15"]) {
        TiWen = (TiWen - 32) / 1.8;
    }

    model.value = TiWen;
    return model;
}

//R161 体温获取
- (temperatureValueModel *)getTemperature:(NSData *)data{
    temperatureValueModel *model = [[temperatureValueModel alloc]init];
    if ([self checkData:data checkIndex:11] && [self checkR111Data:data]) {
        [SVProgressHUD showErrorWithStatus:@"接收数据失败!"];
        model.errorStr = @"接收数据失败 请重新测量!";
        return model;
    }
    
    if ([[data.description substringWithRange:NSMakeRange(3, 2)] isEqualToString:@"fb"]) {
        //体温的整数
        NSString *num1 = [data.description substringWithRange:NSMakeRange(7, 2)];
        //体温的小数
        NSString *num2 = [data.description substringWithRange:NSMakeRange(10, 2)];
        num1 = [num1 stringByAppendingString:num2];
        model.value = [[NSString stringWithFormat:@"%.2lf",strtoul([num1 UTF8String],0,16) / 100.0] floatValue];
        if (model.value < 35 || model.value > 42.2) {
            model.errorStr = @"测量数值有误,请重新测量";
        }else{
            model.errorStr = nil;
        }
        
        return model;
    }else if ([[data.description substringWithRange:NSMakeRange(3, 2)] isEqualToString:@"ff"])
    {
        NSString *Count = [data.description substringWithRange:NSMakeRange(12, 2)];
        if ([Count isEqualToString:@"fa"]) {
            model.hit = -1;
        }else{
            model.hit = [[NSString stringWithFormat:@"记录(%ld)",strtoul([Count UTF8String],0,16)] integerValue];
        }
        
        //环境or体温
        NSString *isTiwen = [data.description substringWithRange:NSMakeRange(19, 2)];
        if ([isTiwen isEqualToString:@"01"]) {
            model.isTiwen = @"室温";
        }else{
            model.isTiwen = @"体温";
        }
        
        //体温的整数
        NSString *num1 = [data.description substringWithRange:NSMakeRange(21, 2)];
        //体温的小数
        NSString *num2 = [data.description substringWithRange:NSMakeRange(23, 2)];
//        return [NSString stringWithFormat:@"%@-%@ : %ld.%ld",Count,isTiwen,strtoul([num1 UTF8String],0,16),strtoul([num2 UTF8String],0,16)];
//        NSLog(@"%@HHHHH%@",num1,num2);
        model.value = [[NSString stringWithFormat:@"%02ld.%02ld",strtoul([num1 UTF8String],0,16),strtoul([num2 UTF8String],0,16)] floatValue];
        if (model.value < 35 || model.value > 42.2) {
            model.errorStr = @"测量数值有误,请重新测量";
        }else{
            model.errorStr = nil;
        }

        return model;
    }
    model.value = 0.0;
    return model;
}

// 数据校验
- (BOOL)checkData:(NSData *)data checkIndex:(NSInteger)index{
    
    Byte *bytes = (Byte *)[data bytes];
    
    unsigned int sum = 0;
    //除了校验位 其他位相加
    for(int i=0;i<[data length];i++){
        //11 为校验位
        if (i != index) {
            sum += (bytes[i] & 0xff);
        }
    }
    //相加和 取最后两位
    sum = sum & 0xff;
    
    //与校验位比较
    return !(sum == bytes[index]);
}

// 新体温计数据校验
- (BOOL)checkR111Data:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    
    unsigned int sum = bytes[1];
    //除了校验位 其他位相加
    for(int i=2 ;i<[data length] - 2;i++){
        
        sum ^= bytes[i];
    }
    
    sum = sum ^ bytes[6];
    
    return !(sum == bytes[5]);
}

//写数据
-(void)writeCharacteristic:(CBPeripheral *)peripheral
            characteristic:(CBCharacteristic *)characteristic
                     value:(NSData *)value{
    
    //打印出 characteristic 的权限，可以看到有很多种，这是一个NS_OPTIONS，就是可以同时用于好几个值，常见的有read，write，notify，indicate，知知道这几个基本就够用了，前连个是读写权限，后两个都是通知，两种不同的通知方式。
    /*
     typedef NS_OPTIONS(NSUInteger, CBCharacteristicProperties) {
     CBCharacteristicPropertyBroadcast												= 0x01,
     CBCharacteristicPropertyRead													= 0x02,
     CBCharacteristicPropertyWriteWithoutResponse									= 0x04,
     CBCharacteristicPropertyWrite													= 0x08,
     CBCharacteristicPropertyNotify													= 0x10,
     CBCharacteristicPropertyIndicate												= 0x20,
     CBCharacteristicPropertyAuthenticatedSignedWrites								= 0x40,
     CBCharacteristicPropertyExtendedProperties										= 0x80,
     CBCharacteristicPropertyNotifyEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)		= 0x100,
     CBCharacteristicPropertyIndicateEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)	= 0x200
     };
     
     */
    NSLog(@"%lu", (unsigned long)characteristic.properties);
    
    
    //只有 characteristic.properties 有write的权限才可以写
    if(characteristic.properties & CBCharacteristicPropertyWrite){
        /*
         最好一个type参数可以为CBCharacteristicWriteWithResponse或type:CBCharacteristicWriteWithResponse,区别是是否会有反馈
         */
        [peripheral writeValue:value forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }else{
        NSLog(@"该字段不可写！");
    }
    
}

//利用UUID获取一个假的MAC地址
- (NSString *)getBuletoothFlaseMAC:(NSString *)value{
    NSMutableString *macString = [[NSMutableString alloc] init];
    [macString appendString:[[value substringWithRange:NSMakeRange(34, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[value substringWithRange:NSMakeRange(32, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[value substringWithRange:NSMakeRange(30, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[value substringWithRange:NSMakeRange(28, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[value substringWithRange:NSMakeRange(26, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[value substringWithRange:NSMakeRange(24, 2)] uppercaseString]];
    return macString;
}

- (void)showData:(NSData *)data type:(NSUInteger)intdex{
//    <fffe05bc 540063ff fe05b954 0060>
//    <fffe05b6 54005d>
    NSString *dataStr = data.description;
    
    if (intdex == 0) {
        NSString *HBP = [dataStr substringWithRange:NSMakeRange(23, 2)];
        NSString *LBP = [dataStr substringWithRange:NSMakeRange(30, 2)];
        NSInteger HBPValue = strtoul([HBP UTF8String], 0, 16);
        NSInteger LBPValue = strtoul([LBP UTF8String], 0, 16);
        
        NSLog(@"%zd -- %zd",HBPValue,LBPValue);
    }else {
        NSString *HBP = [dataStr substringWithRange:NSMakeRange(7, 2)];
        NSString *LBP = [dataStr substringWithRange:NSMakeRange(14, 2)];
        NSInteger HBPValue = strtoul([HBP UTF8String], 0, 16);
        NSInteger LBPValue = strtoul([LBP UTF8String], 0, 16);
        
        NSLog(@"%zd -- %zd",HBPValue - LBPValue,LBPValue);
    }
}

@end
