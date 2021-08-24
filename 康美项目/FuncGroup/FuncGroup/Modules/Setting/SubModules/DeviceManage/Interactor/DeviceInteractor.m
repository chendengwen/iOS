//
//  DeviceInteractor.m
//  FuncGroup
//
//  Created by gary on 2017/2/13.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "DeviceInteractor.h"
#import "Device_DBController.h"
#import "BluetoothDeviceBtn.h"
#import "MemberManager.h"
//血糖仪名称
#define BLOOD_GLUCOSE_METER_NAME @"ZH-G01"
//体温计名称
#define HERMOMETER_NAME @"AET-WD"
//血压计名称
#define SPHYGMOMANOMETER_NAME @"AES-XY"
@interface DeviceInteractor ()

//蓝牙管理者
@property (nonatomic,strong) KMBluetooth *manager;
//保存可写入的特征
@property (nonatomic,strong) CBCharacteristic *write;

@property (nonatomic,strong) NSMutableArray *peripherals;

@property (nonatomic,strong) NSMutableDictionary *macDic;

@property (nonatomic,strong) NSDateFormatter *format;

@property (nonatomic, strong) Device_DBController *dbController;

@property (nonatomic,strong) NSArray *oldArray;

@property (nonatomic,weak) UIButton *scanBtn;
@end


@implementation DeviceInteractor

- (instancetype)init{
    self = [super init];
    if (self) {
        //初始化 蓝牙库
        self.manager = [KMBluetooth shareBabyBluetooth];
        //设置代理Block
        [self kmBluetoothDelegate];
        self.peripherals = [[NSMutableArray alloc]init];
        self.macDic = [[NSMutableDictionary alloc]init];
        self.dbController = [[Device_DBController alloc] init];
        
    }
    
    return self;
}

- (void)dealloc{
    [_manager cancelScan];
    [_manager cancelAllPeripheralsConnection];
}

- (void)insertPeripheral:(CBPeripheral *)peripheral{
    
    //手动过滤
    if (!([peripheral.name hasPrefix:BLOOD_GLUCOSE_METER_NAME] || [peripheral.name hasPrefix:HERMOMETER_NAME]|| [peripheral.name hasPrefix:SPHYGMOMANOMETER_NAME])) {
        return ;
    }
    
    if (![self.peripherals containsObject:peripheral.identifier.description]) {
        self.manager.having(peripheral).and.channel(NSStringFromClass([self class])).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
        [self.peripherals addObject:peripheral.identifier.description];
    }
}

- (BOOL)checkUUID:(NSString *)uuid{
    for (DeviceModel *model in self.oldArray) {
        if ([uuid isEqualToString:model.UUID]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark -蓝牙配置和操作
//蓝牙网关初始化和委托方法设置
- (void)kmBluetoothDelegate{
    __weak typeof(self) weakSelf = self;
    [self.manager setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state != CBCentralManagerStatePoweredOn) {
            [SVProgressHUD showInfoWithStatus:@"设备打开失败，请检查蓝牙功能是否打开"];
        }
    }];
    
    //设置扫描到设备的委托
    [self.manager setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        DMLog(@"搜索到了设备:%@",peripheral.name);
        [weakSelf insertPeripheral:peripheral];
    }];
    
    //设置发现设备的Services的委托
    [self.manager setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            DMLog(@"搜索到服务:%@",service.UUID.UUIDString);
            
        }
    }];
    //设置发现设service的Characteristics的委托
    [self.manager setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        DMLog(@"===service name:%@",service.UUID);
    }];
    //设置读取characteristics的委托
    [self.manager setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        if ([characteristics.UUID.description isEqualToString:@"System ID"]) {
            NSLog(@"%@",characteristics.value);
            
            if (strongSelf.macDic[peripheral] == nil && [strongSelf checkUUID:peripheral.identifier.description]) {
                strongSelf.macDic[peripheral] = peripheral.identifier.description;
                DeviceModel *model = [[DeviceModel alloc]init];
//                BLOOD_GLUCOSE_METER_NAME] || [peripheralName hasPrefix:HERMOMETER_NAME]|| [peripheralName hasPrefix:SPHYGMOMANOMETER_NAME
                if ([peripheral.name containsString:SPHYGMOMANOMETER_NAME]) {
                    model.deviceName = @"血压计";
                    model.deviceIcon = @"device_bloodpress_icon.png";
                    model.MAC = [strongSelf getBuletoothFlaseMAC:peripheral.identifier.description];
                }
                if ([peripheral.name containsString:HERMOMETER_NAME]) {
                    model.deviceName = @"体温计";
                    model.deviceIcon = @"device_temperture.png";
                    model.MAC = [strongSelf getBuletoothMAC:characteristics.value.description];

                }
                if ([peripheral.name containsString:BLOOD_GLUCOSE_METER_NAME]) {
                    model.deviceName = @"血糖仪";
                    model.deviceIcon = @"device_sugar.png";
                    model.MAC = [strongSelf getBuletoothMAC:characteristics.value.description];
                }
                model.UUID = peripheral.identifier.description;
                
                model.time = [strongSelf.format stringFromDate:[NSDate date]];
                model.locked = NO;
                [model addObserver:strongSelf.handler.interface forKeyPath:@"locked" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
                [strongSelf.dataArray addObject:model];
                [strongSelf searchSuccessed:strongSelf.dataArray];
                
//                [strongSelf performSelector:@selector(searchDevices) withObject:nil afterDelay:2.0];
            }

            [strongSelf.manager cancelScan];
            [strongSelf.manager cancelPeripheralConnection:peripheral];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.manager cancelScan];
                [strongSelf.manager cancelPeripheralConnection:peripheral];
                strongSelf.manager.scanForPeripherals().begin();
            });
        }
    }];
    //设置发现characteristics的descriptors的委托
    [self.manager setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [self.manager setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    
    //设置查找设备的过滤器
    [self.manager setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {

        if ([peripheralName hasPrefix:BLOOD_GLUCOSE_METER_NAME] || [peripheralName hasPrefix:HERMOMETER_NAME]|| [peripheralName hasPrefix:SPHYGMOMANOMETER_NAME]) {
            return YES;
        }
        return NO;
    }];
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [_manager setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {

        NSLog(@"%@",[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]);
    }];
    
    //设置设备连接失败的委托
    [_manager setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        
        NSLog(@"设备：%@--连接失败",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接失败",peripheral.name]];
        
    }];
    //设置设备断开连接的委托
    [_manager setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        
        NSLog(@"设备：%@--断开连接",peripheral.name);

    }];
    [self.manager setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
    
    [self.manager setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
//    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
//    [self.manager setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    

}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:4];
    }
    return _dataArray;
}

-(void)saveDevices{
    
    [self.dbController deleteRecord:[[DeviceModel alloc]init
     ]];
    
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    for (DeviceModel *model in self.dataArray) {
        if (model.locked) {
            [mArray addObject:model];
        }
    }
    
    member.bindingDevices = mArray.copy;
    if (mArray.count > 0) {
        [self.dbController insertRecord:mArray.copy];
    }
    
}

-(void)getLocalDevices{
    self.dataArray = [self.dbController getAllRecord].mutableCopy;
    for (int i = 0; i < self.dataArray.count; i++) {
        [self.dataArray[i] addObserver:self.handler.interface forKeyPath:@"locked" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    
    self.oldArray = self.dataArray;
    [self getLocalSuccessed:self.dataArray];

}

-(void)searchDevices:(UIButton *)sender{
    self.scanBtn = sender;
    [self.manager cancelAllPeripheralsConnection];
    self.manager.scanForPeripherals().begin();
}

-(void)lockDeviceAtIndex:(int)index lock:(BOOL)locked{
    DeviceModel *model = self.dataArray[index];
    
    model.locked = locked;
}

#pragma mark === 读取成功
-(void)getLocalSuccessed:(NSArray *)devices{
    [self.handler getLocalDevicesSuccessed:devices];
}

-(void)getLocalFailed:(NSString *)message{
    [self.handler getLocalDevicesFailed:message];
}

#pragma mark === 搜索成功
-(void)searchSuccessed:(NSArray *)devices{
    [SVProgressHUD dismiss];
    [self.scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.scanBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.handler searchDeviceSuccessed:devices];
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

- (NSString *)getBuletoothMAC:(NSString *)value{
    NSMutableString *macString = [[NSMutableString alloc] init];
    [macString appendString:[[value substringWithRange:NSMakeRange(16, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[value substringWithRange:NSMakeRange(14, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[value substringWithRange:NSMakeRange(12, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[value substringWithRange:NSMakeRange(5, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[value substringWithRange:NSMakeRange(3, 2)] uppercaseString]];
    [macString appendString:@":"];
    [macString appendString:[[value substringWithRange:NSMakeRange(1, 2)] uppercaseString]];
    return macString;
}

- (NSDateFormatter *)format{
    if (_format != nil) {
        return _format;
    }
    _format = [[NSDateFormatter alloc]init];
    _format.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    return _format;
}

@end
