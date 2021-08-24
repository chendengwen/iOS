//
//  HealthExaminationVC.m
//  FuncGroup
//
//  Created by zhong on 2017/2/8.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "HealthExaminationVC.h"
#import "BluetoothDeviceBtn.h"
#import "KMAnalysisDataTool.h"
#import "BSMeasurementView.h"
#import "BPMeasurementView.h"
#import "temperatureMeasurementView.h"
#import "BSValueModel.h"
#import "bluetoothDeviceDataManager.h"
#import "HistoryRecordView.h"
#import "XYAlertView.h"
#import "DeviceBtnCell.h"
#import "AppCacheManager.h"
//标题信息字体
#define TITLE_FONT [UIFont boldSystemFontOfSize:29]
//提示信息字体
#define INFO_FONT [UIFont boldSystemFontOfSize:18]
//右边按钮字体
#define RIGHT_BTN_FONT [UIFont boldSystemFontOfSize:20]

#define IdCard @"530322198410150736"

@interface HealthExaminationVC ()<UITableViewDelegate,UITableViewDataSource,DeviceBtnCellDelegate>

@property (nonatomic,strong) NSArray *descriptionArray;

@property (nonatomic,weak) UIView *leftView;

@property (nonatomic,weak) UIView *rightView;

@property (nonatomic,weak) UIView *topView;

@property (nonatomic,weak) UILabel *currentDeviceLab;

@property (nonatomic,weak) UIImageView *bluetoothStateIcon;
//血压视图
@property (nonatomic,weak) UIView *BPView;
//体温视图
@property (nonatomic,weak) UIView *thermometerView;
//血糖视图
@property (nonatomic,weak) UIView *BSView;
//当前视图
@property (nonatomic,weak) UIView *currentView;
//历史记录视图
@property (nonatomic,weak) HistoryRecordView *hisView;
//温度测量视图
@property (nonatomic,weak) temperatureMeasurementView *TMView;
//血压测量视图
@property (nonatomic,weak) BPMeasurementView *BPMView;
//血糖测量视图
@property (nonatomic,weak) BSMeasurementView *BSMView;
//血糖数据模型
@property (nonatomic,strong) BSValueModel *BSModel;

@property (nonatomic,weak) UIView *BPLeftView;

@property (nonatomic,weak) UIButton *infoBtn;
//手动输入|重新测量 按钮
@property (nonatomic,weak) UIButton *inputBtn;

@property (nonatomic,weak) BluetoothDeviceBtn *lastBtn;
//开始按钮
@property (nonatomic,weak) UIButton *startBtn;
//蓝牙数据交互工具
@property (nonatomic,strong) KMAnalysisDataTool *analysisDataTool;
//蓝牙管理者
@property (nonatomic,strong) KMBluetooth *manager;
@property (nonatomic,strong) NSMutableArray *peripherals;
@property (nonatomic,strong) NSMutableArray *peripheralsAD;

@property (nonatomic,copy) NSString *deviceName;
@property (nonatomic,strong) UIButton *connectBtn;
@property (nonatomic,strong) NSMutableArray *services;
@property (nonatomic,strong) CBPeripheral *currPeripheral;
//保存可写入的特征
@property (nonatomic,strong) CBCharacteristic *write;
//保存血糖数据
@property (nonatomic,strong) NSString *bloodSugarStr;
//量测血压数据
@property (nonatomic,strong) NSMutableArray *BPmArray;
//量测温度数据
@property (nonatomic,strong) NSMutableArray *TmArray;
//量测血糖数据
@property (nonatomic,strong) NSMutableArray *BSmArray;
//蓝牙量测数据管理
@property (nonatomic,strong) bluetoothDeviceDataManager *dataManager;
//提示框
@property (nonatomic,weak) XYAlertView *contentView;
//提示框_手动输入
@property (nonatomic,weak) XYAlertView *inputContentView;

@property (nonatomic,weak) UITableView *deviceTableView;

@property (nonatomic,assign) BOOL isDemonstrate;
@end

@implementation HealthExaminationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isDemonstrate = [[[AppCacheManager sharedAppCacheManager] cacheForKey:kDemonstrate] boolValue];
    [self setupUI];
    //初始化其他数据 init other
    self.peripherals = [[NSMutableArray alloc]init];
    self.peripheralsAD = [[NSMutableArray alloc]init];
    //初始化 蓝牙库
    self.manager = [KMBluetooth shareBabyBluetooth];
    //设置代理Block
    [self kmBluetoothDelegate];
    self.analysisDataTool = [KMAnalysisDataTool shareAnalysisDataTool];
    //蓝牙对象管理者
    self.dataManager = [bluetoothDeviceDataManager sharedInstance];
    
    self.dataManager.type = HealthRecordXueYa;
    
    [self.dataManager clearData]; 
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    [self kmBluetoothDelegate];
    //停止之前的连接
    [_manager cancelScan];
    [_manager cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    //    _manager.scanForPeripherals().begin();
    //    [self refreshAction:nil];
    //    [self performSelector:@selector(refreshAction:) withObject:nil afterDelay:1];
    //_manager.scanForPeripherals().begin().stop(10);

    
}

#pragma mark -蓝牙配置和操作
//蓝牙网关初始化和委托方法设置
- (void)kmBluetoothDelegate{
    __weak typeof(self) weakSelf = self;
    [_manager setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        
        if (central.state != CBCentralManagerStatePoweredOn) {
            [SVProgressHUD showErrorWithStatus:@"打开蓝牙设备失败"];
        }
    }];
    
    //设置扫描到设备的委托
    [_manager setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        NSLog(@"搜索到了设备:%@",peripheral.name);
        
        if (![strongSelf checkBindingDevice:peripheral]) {
            return ;
        }
        
        if ([peripheral.name hasPrefix:strongSelf.deviceName]) {
            strongSelf.currPeripheral = peripheral;
            strongSelf.manager.having(strongSelf.currPeripheral).channel(NSStringFromClass([strongSelf class])).connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
            [strongSelf.manager cancelScan];
        }
        
    }];
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [_manager setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        //        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]];
        
        NSLog(@"%@",[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]);
        //        strongSelf.connectBtn.selected = YES;
        //        [strongSelf.connectBtn setTitle:@"连接成功" forState:UIControlStateSelected];
        [strongSelf.startBtn setTitle:@"停止" forState:UIControlStateSelected];
        [strongSelf setInfoBtnDescription:@"设备连接成功"];
        strongSelf.bluetoothStateIcon.image = [UIImage imageNamed:@"bluetooth_green"];
        [strongSelf.startBtn setBackgroundImage:[UIImage imageNamed:@"ble_controll_start_green"] forState:UIControlStateSelected];
        //        [strongSelf.connectBtn setBackgroundColor:[UIColor colorWithRed:0.29 green:0.95 blue:0.63 alpha:1.00]];
        
    }];
    
    //设置设备连接失败的委托
    [_manager setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        
        NSLog(@"设备：%@--连接失败",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接失败",peripheral.name]];
        [strongSelf didClickStartBtn:strongSelf.startBtn];
        
    }];
    //设置设备断开连接的委托
    [_manager setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        
        NSLog(@"设备：%@--断开连接",peripheral.name);
        //        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--断开成功",peripheral.name]];
        if (strongSelf.startBtn.isSelected) {
            [strongSelf didClickStartBtn:strongSelf.startBtn];
        }
        
    }];
    
    //设置发现设service的Characteristics的委托
    [_manager setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        //插入row到tableview
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID.description isEqualToString:@"FFE9"]) {
                strongSelf.write = characteristic;
            }
            
            if ([characteristic.UUID.description isEqualToString:@"FFF4"] && !characteristic.isNotifying ) {
                [strongSelf.currPeripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
            
            if ([characteristic.UUID.description isEqualToString:@"FFF2"] && !characteristic.isNotifying ) {
                [strongSelf.currPeripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
            
            if ([characteristic.UUID.description isEqualToString:@"FFE4"] && !characteristic.isNotifying ) {
                [strongSelf.currPeripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
        }
        
    }];
    
    //设置读取characteristics的委托
    [_manager setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        //血压计
        if ([strongSelf.deviceName hasPrefix:SPHYGMOMANOMETER_NAME]) {
            if ([[NSString stringWithFormat:@"%@",characteristic.UUID] isEqual:@"FFF4"] && characteristic.value != nil && [characteristic.value.description hasPrefix:@"<fdfd"]){
                
                //[NSString stringWithFormat:@"测量时间:%@",[self.format stringFromDate:[NSDate date]]];
                BPValueModel *model = [strongSelf.analysisDataTool getBloodPressure:characteristic.value];
                [strongSelf showDataPageWithModel:model];
                
                
            }
        }
        
        if ([characteristic.UUID.description isEqualToString:@"FFE4"]) {
            
            //血糖仪
            if ([strongSelf.deviceName hasPrefix:BLOOD_GLUCOSE_METER_NAME]) {
                strongSelf.BSModel = [strongSelf.analysisDataTool getBloodSugar:characteristic.value WithCurrPeripheral:strongSelf.currPeripheral WithWrite:strongSelf.write WithOldBloodSugarModel:strongSelf.BSModel];
                //                [strongSelf.startBtn setTitle:strongSelf.bloodSugarStr forState:UIControlStateSelected];
                [strongSelf showDataPageWithModel:strongSelf.BSModel];
            }
            //体温计
            if ([strongSelf.deviceName hasPrefix:HERMOMETER_NAME]) {
                temperatureValueModel *model = [strongSelf.analysisDataTool getTemperature:characteristic.value];
                [strongSelf showDataPageWithModel:model];
            }
            
        }
    }];
    //设置查找设备的过滤器
    [_manager setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        //过滤其他蓝牙设备
        if ([peripheralName hasPrefix:BLOOD_GLUCOSE_METER_NAME] || [peripheralName hasPrefix:HERMOMETER_NAME] ||
            [peripheralName hasPrefix:SPHYGMOMANOMETER_NAME]) {
            return YES;
        }
        return NO;
    }];
    
    //设置发现characteristics的descriptors的委托
    [_manager setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
            
        }
    }];
    //设置读取Descriptor的委托
    [_manager setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
}

#pragma mark - setupUI
- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *leftView = [[UIView alloc]init];
    self.leftView = leftView;
    [self.view addSubview:leftView];
    leftView.backgroundColor = kMainColor;
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.12);
    }];
    //头像背景
    UIImageView *photoBackView = [[UIImageView alloc]init];
    [leftView addSubview:photoBackView];
    photoBackView.image = [UIImage imageNamed:@"page_icon_empty"];
    [photoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView);
        make.top.equalTo(leftView).offset(20);
        make.width.equalTo(leftView).multipliedBy(0.6);
        make.height.equalTo(photoBackView.mas_width);
    }];
    //头像
    UIImageView *photoView = [[UIImageView alloc]init];
    photoView.image = [UIImage imageWithData:[MemberManager sharedInstance].currentUserArchives.Photo];
    [photoBackView addSubview:photoView];
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(photoBackView);
        make.centerY.equalTo(photoBackView);
        make.width.height.equalTo(photoBackView.mas_width).multipliedBy(0.95);
    }];
    photoView.layer.cornerRadius = SCREEN_WIDTH * 0.12 * 0.6 * 0.95 / 2.0;
    photoView.layer.masksToBounds = YES;
    //姓名Lab
    UILabel *nameLab = [[UILabel alloc]init];
    nameLab.text = member.currentUserArchives.Name;
    [leftView addSubview:nameLab];
    nameLab.textColor = [UIColor colorWithRed:0.05 green:0.17 blue:0.36 alpha:1.00];
    nameLab.numberOfLines = 0;
    nameLab.font = [UIFont systemFontOfSize:25];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoBackView.mas_bottom).offset(4);
        make.centerX.equalTo(photoBackView);
    }];
    
    UITableView *deviceTableView = [[UITableView alloc]init];
    self.deviceTableView = deviceTableView;
    [leftView addSubview:deviceTableView];
    deviceTableView.delegate = self;
    deviceTableView.dataSource = self;
    [deviceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLab.mas_bottom);
        make.left.right.bottom.equalTo(leftView);
    }];
    deviceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    deviceTableView.backgroundColor = kMainColor;
    
    //演示模式设置
    if (self.isDemonstrate && member.currentUserArchives == nil) {
        nameLab.text = @"演示";
        photoView.image = [UIImage imageNamed:@"avatar"];
    }
    
    /*
    //血压按钮
    BluetoothDeviceBtn *BPBtn = [[BluetoothDeviceBtn alloc]initWithImage:[UIImage imageNamed:@"ble_controll_pressure"] selectImage:[UIImage imageNamed:@"ble_controll_pressure_over"] title:@"血压"];
    BPBtn.tag = 100;
    [leftView addSubview:BPBtn];
    [BPBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLab.mas_bottom).offset(4);
        make.left.right.equalTo(leftView);
        make.height.equalTo(BPBtn.mas_width).multipliedBy(0.7);
    }];
    [BPBtn addTarget:self action:@selector(didClickBluetoothDeviceBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //体温按钮
    BluetoothDeviceBtn *thermometerBtn = [[BluetoothDeviceBtn alloc]initWithImage:[UIImage imageNamed:@"ble_controll_temperture"] selectImage:[UIImage imageNamed:@"ble_controll_temperture_over"]title:@"温度"];
    thermometerBtn.tag = 101;
    [leftView addSubview:thermometerBtn];
    [thermometerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BPBtn.mas_bottom);
        make.left.right.equalTo(leftView);
        make.height.equalTo(BPBtn.mas_height);
    }];
    [thermometerBtn addTarget:self action:@selector(didClickBluetoothDeviceBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //血糖按钮
    BluetoothDeviceBtn *BSBtn = [[BluetoothDeviceBtn alloc]initWithImage:[UIImage imageNamed:@"ble_controll_sugar"] selectImage:[UIImage imageNamed:@"ble_controll_sugar_over"] title:@"血糖"];
    BSBtn.tag = 102;
    [leftView addSubview:BSBtn];
    [BSBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thermometerBtn.mas_bottom);
        make.left.right.equalTo(leftView);
        make.height.equalTo(BPBtn.mas_height);
    }];
    [BSBtn addTarget:self action:@selector(didClickBluetoothDeviceBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //返回按钮
    BluetoothDeviceBtn *BackBtn = [[BluetoothDeviceBtn alloc]initWithImage:[UIImage imageNamed:@"ble_controll_back"] selectImage:[UIImage imageNamed:@"ble_controll_back_over"] title:@"返回"];
    BackBtn.tag = 103;
    [leftView addSubview:BackBtn];
    [BackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BSBtn.mas_bottom);
        make.left.right.equalTo(leftView);
        make.height.equalTo(BPBtn.mas_height);
    }];
    [BackBtn addTarget:self action:@selector(didClickBluetoothDeviceBtn:) forControlEvents:UIControlEventTouchUpInside];
    */
    UIView *rightView = [[UIView alloc]init];
    self.rightView = rightView;
    [self.view addSubview:rightView];
    rightView.backgroundColor = [UIColor whiteColor];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.view);
        make.left.equalTo(leftView.mas_right).offset(20);
    }];
    
    UIView *topView = [[UIView alloc]init];
    self.topView = topView;
    [rightView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(rightView);
        make.height.equalTo(rightView).multipliedBy(0.15);
    }];
    //蓝牙状态图标
    UIImageView *bluetoothStateIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bluetooth_red"]];
    [topView addSubview:bluetoothStateIcon];
    self.bluetoothStateIcon = bluetoothStateIcon;
    [bluetoothStateIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topView);
        make.left.equalTo(topView).offset(8);
        make.height.equalTo(@(35));
        make.width.equalTo(@(20));
    }];
    //分割线
    UIView *lineView = [[UIView alloc]init];
    [topView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1.00];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(topView);
        make.bottom.equalTo(bluetoothStateIcon.mas_top).offset(-8);
        make.height.equalTo(@(2));
    }];
    
    UILabel *currentDeviceLab = [[UILabel alloc]init];
    self.currentDeviceLab = currentDeviceLab;
    [topView addSubview:currentDeviceLab];
    [currentDeviceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(topView);
        make.bottom.equalTo(lineView).offset(-8);
    }];
    currentDeviceLab.text = @"血压量测";
    currentDeviceLab.font = TITLE_FONT;
    currentDeviceLab.textColor = [UIColor colorWithRed:0.45 green:0.45 blue:0.49 alpha:1.00];
    
    UIView *bottomView = [[UIView alloc]init];
    [rightView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(rightView);
        make.top.equalTo(topView.mas_bottom);
    }];
    
    [self.rightView addSubview:self.currentView];
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView);
        make.right.left.bottom.equalTo(self.rightView);
    }];
    //默认选择第一个
    //    [self didClickBluetoothDeviceBtn:BPBtn];
    //    topView.backgroundColor = [UIColor redColor];
    //    bottomView.backgroundColor = [UIColor blueColor];
    
}

#pragma mark - Action
//检查是否为绑定设备
- (BOOL)checkBindingDevice:(CBPeripheral *)peripheral{
    for (DeviceModel *model in member.bindingDevices) {
        if ([model.UUID isEqualToString:peripheral.identifier.description] && [peripheral.name hasPrefix:model.type]) {
            return YES;
        }
    }
    
    return NO;
}

//历史检查结果 
- (void)didClickHisBtn:(UIButton *)sender{
    if (self.isDemonstrate && member.currentUserArchives == nil) {
        self.hisView.deviceName = DeviceName_Demonstrate;
    }else{
        self.hisView.deviceName = self.startBtn.tag;
    }
    self.hisView.hidden = NO;
}

//保存 & 上传到服务器
- (void)didClickUploadAndSave:(UIButton *)sender{
    //确定
    if (sender.tag == 101) {
        //保存数据
        [self.dataManager saveData];
    }else{
        //移除提示框
    }
}

//手动输入 | 重新测量
- (void)didClickInputBtn:(UIButton *)sender{
    //手动输入
    if (sender.tag == 101) {
        XYAlertView *inputContentView = [[XYAlertView alloc]init];
        self.inputContentView = inputContentView;
        [self.view addSubview:inputContentView];
        [inputContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        switch (self.startBtn.tag) {
            case 0:
            {
                inputContentView.titleLabel.text = @"手动输入血压";
                inputContentView.textsTitleArray = @[@"收缩压(mmHg):",@"舒张压(mmHg):"];
                inputContentView.textsArray = @[@"请手动输入收缩压",@"请手动输入舒张压"];
            }
            break;
            case 1:
            {
                inputContentView.titleLabel.text = @"手动输入体温";
                inputContentView.textsTitleArray = @[@"温度值(°C)"];
                inputContentView.textsArray = @[@"请手动输入体温"];
            }
            break;
            case 2:
            {
                inputContentView.titleLabel.text = @"手动输入血糖";
                inputContentView.textsTitleArray = @[@"血糖值(mmol/L)"];
                inputContentView.textsArray = @[@"请手动输入血糖"];
            }
            break;
            default:
                break;
        }

        inputContentView.buttonsArray = @[@"取消",@"确定"];
        UIButton * cancelButton = inputContentView.realButtons[0];
        UIButton * okButton = inputContentView.realButtons[1];
        cancelButton.tag = 2001;
        okButton.tag = 2002;
        [cancelButton addTarget:self action:@selector(didClickInputOK:) forControlEvents:UIControlEventTouchDown];
        [okButton addTarget:self action:@selector(didClickInputOK:) forControlEvents:UIControlEventTouchDown];
    }else if (sender.tag == 102){
        //重新测量
        
        switch (self.startBtn.tag) {
            case 0:
            {
                self.BPMView.isMeasurement = NO;
                
                self.BPLeftView.hidden = NO;
                self.BPMView.hidden = YES;
                self.TMView.hidden = YES;
                self.BSMView.hidden = YES;
                self.dataManager.BPModel = nil;
            }
                break;
            case 1:
            {
                self.TMView.isMeasurement = NO;
                
                self.BPLeftView.hidden = NO;
                self.BPMView.hidden = YES;
                self.TMView.hidden = YES;
                self.BSMView.hidden = YES;
                self.dataManager.TModel = nil;
            }
                break;
            case 2:
            {
                //不重置可能会出错
                self.BSModel = nil;
                
                self.BSMView.isMeasurement = NO;
                self.BPLeftView.hidden = NO;
                self.BPMView.hidden = YES;
                self.TMView.hidden = YES;
                self.BSMView.hidden = YES;
                
                self.dataManager.BSModel = nil;
            }
                break;
            default:
                break;
        }
        if (self.startBtn.isSelected) {
            [self didClickStartBtn:self.startBtn];
        }
        
        sender.tag = 101;
        [sender setTitle:@"手动输入" forState:UIControlStateNormal];
    }
}

//选择测量类型
- (void)didClickBluetoothDeviceBtn:(BluetoothDeviceBtn *)sender{
    
    if (sender == self.lastBtn) {
        return;
    }
    //返回
    if (sender.tag == 103) {
        if (self.isDemonstrate && member.currentUserArchives == nil) {
            [self.navigationController popViewControllerAnimated:NO];
            return;
        }
        XYAlertView *contentView = [[XYAlertView alloc]init];
        self.contentView = contentView;
        [self.view addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        contentView.titleLabel.text = @"系统提示";
        NSMutableString *str = [[NSMutableString alloc]initWithString:@""];
        NSUInteger count = member.bindingDevices.count;
        
        for (DeviceModel *model in member.bindingDevices) {
            if ([model.deviceName isEqualToString:@"血压计"] && self.dataManager.BPModel == nil) {
                if ([str isEqualToString:@""]) {
                    [str appendString:@"血压"];
                }else{
                    [str appendString:@"、血压"];
                }
                
                count -= 1;
            }
            
            if ([model.deviceName isEqualToString:@"体温计"] && self.dataManager.TModel == nil) {
                
                if ([str isEqualToString:@""]) {
                    [str appendString:@"体温"];
                }else{
                    [str appendString:@"、体温"];
                }
                count -= 1;
            }
            
            if ([model.deviceName isEqualToString:@"血糖仪"] && self.dataManager.BSModel == nil) {
                if ([str isEqualToString:@""]) {
                    [str appendString:@"血糖"];
                }else{
                    [str appendString:@"、血糖"];
                }
                count -= 1;
            }
            
        }
        
        if ([str isEqualToString:@""]) {
            contentView.msgLabel.text = @"本次完成所有项检查,确定完成本次检查吗?";
            contentView.buttonsArray = @[@"取消",@"确定"];
        }else{
            contentView.msgLabel.text = [NSString stringWithFormat:@"本次完成%zd项检查,还有[%@]未完成检查,\n确定完成本次检查吗?",count,str];
            contentView.buttonsArray = @[@"继续检查",@"完成检查"];
        }
        
        UIButton * cancelButton = contentView.realButtons[0];
        UIButton * okButton = contentView.realButtons[1];
        cancelButton.tag = 2001;
        okButton.tag = 2002;
        [cancelButton addTarget:self action:@selector(didClickOKBtn:) forControlEvents:UIControlEventTouchDown];
        [okButton addTarget:self action:@selector(didClickOKBtn:) forControlEvents:UIControlEventTouchDown];
        return;
    }
    
    self.lastBtn.selected = !self.lastBtn.isSelected;
    [self.lastBtn didClick:self.lastBtn.isSelected];
    
    sender.selected = !sender.isSelected;
    [sender didClick:sender.isSelected];
    
    [self resetCurrentView];
    switch (sender.tag) {
        case 100:
        {
            self.currentDeviceLab.text = @"血压量测";
            self.startBtn.tag = 0;
            [self setInfoBtnDescription:self.descriptionArray[0]];
            self.deviceName = SPHYGMOMANOMETER_NAME;
            [self changeViewForTag:0];
            self.dataManager.type = HealthRecordXueYa;
        }
            break;
        case 101:
        {
            self.currentDeviceLab.text = @"温度量测";
            self.startBtn.tag = 1;
            [self setInfoBtnDescription:self.descriptionArray[1]];
            self.deviceName = HERMOMETER_NAME;
            [self changeViewForTag:1];
            self.dataManager.type = HealthRecordTiWen;
        }
            break;
        case 102:
        {
            self.currentDeviceLab.text = @"血糖量测";
            self.startBtn.tag = 2;
            [self setInfoBtnDescription:self.descriptionArray[2]];
            self.deviceName = BLOOD_GLUCOSE_METER_NAME;
            [self changeViewForTag:2];
            self.dataManager.type = HealthRecordXueTang;
        }
            break;
        default:
            break;
    }
    
    self.lastBtn = sender;
}

- (void)didClickOKBtn:(UIButton *)sender{
    if (sender.tag == 2001) {
        [self.contentView dismiss];
    }else if (sender.tag == 2002){
        [self.dataManager saveData];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)didClickInputOK:(UIButton *)sender{
    if (sender.tag == 2001) {
        [self.inputContentView removeFromSuperview];
    }else if (sender.tag == 2002){
        switch (self.startBtn.tag) {
            case 0:
            {
                CGFloat LBP = [[self.inputContentView.realTexts[1] text]floatValue];
                CGFloat HBP = [[self.inputContentView.realTexts[0] text]floatValue];
                if (LBP > 120 || LBP < 30 || HBP > 200 || HBP < 50 || HBP < LBP) {
                    [SVProgressHUD showErrorWithStatus:@"您输入的数值有误,请重新输入!"];
                }else{
                    BPValueModel *model =  [[BPValueModel alloc]init];
                    model.HBP = HBP;
                    model.LBP = LBP;
                    self.TMView.hidden = YES;
                    self.BPLeftView.hidden = YES;
                    self.BPMView.hidden = NO;
                    self.BPMView.BPModel = model;
                    
                    [self.inputBtn setTitle:@"重新测量" forState: UIControlStateNormal];
                    self.inputBtn.tag = 102;
                    
                    self.dataManager.BPModel = model;
                    [self.inputContentView removeFromSuperview];
                }
            }
                break;
            case 1:
            {
                CGFloat TW = [[self.inputContentView.realTexts[0] text]floatValue];
                if (TW < 35 || TW > 42) {
                    [SVProgressHUD showErrorWithStatus:@"您输入的数值有误,请重新输入!"];
                }else{
                    temperatureValueModel *model = [[temperatureValueModel alloc]init];
                    model.value = TW;
                    
                    self.TMView.hidden = NO;
                    self.BPLeftView.hidden = YES;
                    self.BPMView.hidden = YES;
                    self.BSMView.hidden = YES;
                    
                    self.TMView.temperatureNum = model.value;
                    [self.inputBtn setTitle:@"重新测量" forState: UIControlStateNormal];
                    self.inputBtn.tag = 102;
                    
                    self.dataManager.TModel = model;
                    [self.inputContentView removeFromSuperview];
                }
            }
                break;
            case 2:
            {
                CGFloat BS = [[self.inputContentView.realTexts[0] text]floatValue];
                if (BS < 0 || [[self.inputContentView.realTexts[0] text] isEqualToString:@""]/*|| BS > 33.29*/) {
                    [SVProgressHUD showErrorWithStatus:@"您输入的数值有误,请重新输入!"];
                }else{
                    self.BSModel = [[BSValueModel alloc]init];
                    self.BSModel.value = BS;
                    self.TMView.hidden = YES;
                    self.BPLeftView.hidden = YES;
                    self.BPMView.hidden = YES;
                    self.BSMView.hidden = NO;

                    self.BSMView.BSModel = self.BSModel;
                    
                    [self.inputBtn setTitle:@"重新测量" forState: UIControlStateNormal];
                    self.inputBtn.tag = 102;
                    self.dataManager.BSModel = self.BSModel;
                    [self.inputContentView removeFromSuperview];
                }
                
            }
                break;
            default:
                break;
        }
    }
}

//展示数据页面
- (void)showDataPageWithModel:(NSObject *)nsmodel{
//
    switch (self.startBtn.tag) {
        case 0:
        {
            BPValueModel *model = (BPValueModel *)nsmodel;
            if (model.errorStr == nil) {
                self.TMView.hidden = YES;
                self.BPLeftView.hidden = YES;
                self.BPMView.hidden = NO;
                self.BPMView.BPModel = model;
                self.bluetoothStateIcon.hidden = YES;
                [self.inputBtn setTitle:@"重新测量" forState: UIControlStateNormal];
                self.inputBtn.tag = 102;
                
                self.dataManager.BPModel = model;
            }
        }
            break;
        case 1:
        {
            
            temperatureValueModel *model = (temperatureValueModel *)nsmodel;
            if (model.value == 0.0) {
                return ;
            }
            if (model.errorStr == nil) {
                self.bluetoothStateIcon.hidden = YES;
                self.TMView.hidden = NO;
                self.BPLeftView.hidden = YES;
                self.BPMView.hidden = YES;
                self.BSMView.hidden = YES;
                
                self.TMView.temperatureNum = model.value;
                [self.inputBtn setTitle:@"重新测量" forState: UIControlStateNormal];
                self.inputBtn.tag = 102;
                
                self.dataManager.TModel = model;
                
            }else{
                [self didClickStartBtn:self.startBtn];
                [self setInfoBtnDescription:model.errorStr];
            }
            
        }
            break;
        case 2:
        {
            if (self.BSModel.value != -1) {
                if (self.BSModel.value < 0) {
                    [self setInfoBtnDescription:@"测量数据有误,请重新测量!"];
                    if (self.startBtn.isSelected) {
                        [self didClickStartBtn:self.startBtn];
                    }
                    
                    
                }else{
                    self.TMView.hidden = YES;
                    self.BPLeftView.hidden = YES;
                    self.BPMView.hidden = YES;
                    self.BSMView.hidden = NO;
                    self.bluetoothStateIcon.hidden = YES;
                    self.BSMView.BSModel = self.BSModel;
                    
                    [self.inputBtn setTitle:@"重新测量" forState: UIControlStateNormal];
                    self.inputBtn.tag = 102;
                    self.dataManager.BSModel = self.BSModel;
                }
            }

        }
            break;
        default:
            break;
    }
}

//开始量测按钮
- (void)didClickStartBtn:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    self.bluetoothStateIcon.hidden = NO;
    if (sender.isSelected) {
        [self setInfoBtnDescription:@"设备状态:设备连接中..."];
        [sender setTitle:@"连接中" forState:UIControlStateSelected];
        _manager.scanForPeripherals().begin();
    }else{
        [self setInfoBtnDescription:self.descriptionArray[self.startBtn.tag]];
        [_manager cancelScan];
        [_manager cancelAllPeripheralsConnection];
        [sender setTitle:@"开始" forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"ble_controll_start_red"] forState:UIControlStateNormal];
        self.bluetoothStateIcon.image = [UIImage imageNamed:@"bluetooth_red"];
        [sender setBackgroundImage:[UIImage imageNamed:@"ble_controll_start_red"] forState:UIControlStateSelected];
    }
}

//重置页面
- (void)resetCurrentView{
    if (self.startBtn.isSelected) {
        [self didClickStartBtn:self.startBtn];
    }
    self.hisView.hidden = YES;
}

//切换视图
- (void)changeViewForTag:(NSUInteger)tag{
    switch (tag) {
        case 0:
        {
            if (self.BPMView.isMeasurement) {
                self.BPMView.hidden = NO;
                self.bluetoothStateIcon.hidden = YES;
                self.BPLeftView.hidden = YES;
                self.TMView.hidden = YES;
                self.BSMView.hidden = YES;
                
                [self.inputBtn setTitle:@"重新测量" forState: UIControlStateNormal];
                self.inputBtn.tag = 102;
                return;
            }
        }
            break;
        case 1:
        {
            if (self.TMView.isMeasurement) {
                self.TMView.hidden = NO;
                self.bluetoothStateIcon.hidden = YES;
                self.BPMView.hidden = YES;
                self.BPLeftView.hidden = YES;
                self.BSMView.hidden = YES;
                
                [self.inputBtn setTitle:@"重新测量" forState: UIControlStateNormal];
                self.inputBtn.tag = 102;
                return;
            }
            
        }
            break;
        case 2:
        {
            if (self.BSMView.isMeasurement) {
                self.BSMView.hidden = NO;
                self.bluetoothStateIcon.hidden = YES;
                self.BPMView.hidden = YES;
                self.BPLeftView.hidden = YES;
                self.TMView.hidden = YES;
                
                [self.inputBtn setTitle:@"重新测量" forState: UIControlStateNormal];
                self.inputBtn.tag = 102;
                return;
            }
        }
            break;
        default:
            break;
    }
    
    self.BPLeftView.hidden = NO;
    self.bluetoothStateIcon.hidden = NO;
    self.BPMView.hidden = YES;
    self.TMView.hidden = YES;
    self.BSMView.hidden = YES;
    
    [self.inputBtn setTitle:@"手动输入" forState: UIControlStateNormal];
    self.inputBtn.tag = 101;
    
}

//设置提示信息
- (void)setInfoBtnDescription:(NSString *)description{
    CGSize size = [description sizeWithAttributes:@{NSFontAttributeName: INFO_FONT}];
    
    [self.infoBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(size.height + 25));
        make.width.equalTo(@(size.width + 30));
    }];
    
    [self.infoBtn setTitle:description forState:UIControlStateNormal];
}

#pragma mark - 血压/温度/血糖视图
- (UIView *)currentView{
    if (_currentView != nil) {
        return _currentView;
    }
    
    UIView *View = [[UIView alloc]init];
    UIView *BPLeftView = [[UIView alloc]init];
    self.BPLeftView = BPLeftView;
    [View addSubview:BPLeftView];
    [BPLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(View);
        make.width.equalTo(View).multipliedBy(0.75);
    }];
    
    //创建血压测量视图 tag == 100
    BPMeasurementView *BPMView = [[BPMeasurementView alloc]init];
    self.BPMView = BPMView;
    //布局并隐藏
    [View addSubview:BPMView];
    [BPMView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(View);
        make.width.equalTo(View).multipliedBy(0.75);
    }];
    BPMView.hidden = YES;
    BPMView.tag = 100;
    
    //创建温度测量视图 tag == 101
    temperatureMeasurementView *TMView = [[temperatureMeasurementView alloc]init];
    self.TMView = TMView;
    //布局并隐藏
    [View addSubview:TMView];
    [TMView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(View);
        make.width.equalTo(View).multipliedBy(0.75);
    }];
    TMView.hidden = YES;
    TMView.tag = 101;
    TMView.title = @"测试测试测试infoBtn \ninfoBtn\n6666";
    
    //创建血糖测量视图 tag == 102
    BSMeasurementView *BSMView = [[BSMeasurementView alloc]init];
    self.BSMView = BSMView;
    //布局并隐藏
    [View addSubview:BSMView];
    [BSMView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(View);
        make.width.equalTo(View).multipliedBy(0.75);
    }];
    BSMView.hidden = YES;
    BSMView.tag = 102;
    BSMView.title = @"测试测试测试infoBtn \ninfoBtn\n6666";
    
    UIView *BPRightView = [[UIView alloc]init];
    [View addSubview:BPRightView];
    [BPRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(View);
        make.left.equalTo(BPLeftView.mas_right);
    }];
    
    //测量按钮
    UIButton *startBtn = [[UIButton alloc]init];
    self.startBtn = startBtn;
    [BPLeftView addSubview:startBtn];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"ble_controll_start_red"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"ble_controll_start_red"] forState:UIControlStateSelected];
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startBtn setTitle:@"连接中" forState:UIControlStateSelected];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:65];
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(BPLeftView);
        make.centerY.equalTo(BPLeftView).offset(-100);
        make.height.width.equalTo(@(280));
    }];
    [startBtn addTarget:self action:@selector(didClickStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    //提示图标
    UIImageView *infoIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"info"]];
    [BPLeftView addSubview:infoIcon];
    [infoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startBtn.mas_bottom).offset(64);
        make.right.equalTo(startBtn.mas_left).offset(-32);
        make.height.width.equalTo(@(40));
    }];
    //提示信息按钮
    UIButton *infoBtn = [[UIButton alloc]init];
    self.infoBtn = infoBtn;
    [BPLeftView addSubview:infoBtn];
    infoBtn.titleLabel.numberOfLines = 0;
    infoBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [infoBtn setTitleColor:[UIColor colorWithRed:0.45 green:0.45 blue:0.49 alpha:1.00] forState:UIControlStateNormal];
    infoBtn.titleLabel.font = INFO_FONT;
    infoBtn.titleEdgeInsets = UIEdgeInsetsMake(-8, -8, -8, -16);
    [infoBtn setBackgroundImage:[UIImage imageNamed:@"ble_controll_tip.9"] forState:UIControlStateNormal];
    [infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoIcon);
        make.left.equalTo(infoIcon.mas_right);
    }];
    //历史检查结果按钮
    UIButton *HistoryBtn = [[UIButton alloc]init];
    [BPRightView addSubview:HistoryBtn];
    HistoryBtn.backgroundColor = kFuseColor;
    HistoryBtn.layer.cornerRadius = 10;
    HistoryBtn.layer.masksToBounds = YES;
    [HistoryBtn addTarget:self action:@selector(didClickHisBtn:)forControlEvents:UIControlEventTouchUpInside];
    [HistoryBtn setTitle:@"历史检查结果" forState:UIControlStateNormal];
    HistoryBtn.titleLabel.font = RIGHT_BTN_FONT;
    [HistoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(BPRightView);
        make.top.equalTo(BPRightView).offset(200);
        make.width.equalTo(BPRightView).multipliedBy(0.7);
        make.height.equalTo(HistoryBtn.mas_width).multipliedBy(0.4);
    }];
    //手动输入按钮
    UIButton *inputBtn = [[UIButton alloc]init];
    self.inputBtn = inputBtn;
    [BPRightView addSubview:inputBtn];
    inputBtn.tag = 101;
    inputBtn.backgroundColor = kFuseColor;
    inputBtn.layer.cornerRadius = 10;
    inputBtn.layer.masksToBounds = YES;
    [inputBtn setTitle:@"手动输入" forState:UIControlStateNormal];
    inputBtn.titleLabel.font = RIGHT_BTN_FONT;
    [inputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(BPRightView);
        make.top.equalTo(HistoryBtn.mas_bottom).offset(40);
        make.width.equalTo(HistoryBtn.mas_width);
        make.height.equalTo(HistoryBtn.mas_height);
    }];
    [inputBtn addTarget:self action:@selector(didClickInputBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _currentView = View;
    return _currentView;
}

- (HistoryRecordView *)hisView{
    if (_hisView != nil) {
        return _hisView;
    }
    HistoryRecordView *view = [[HistoryRecordView alloc]init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(SCREEN_HEIGHT *0.15);
        make.right.bottom.equalTo(self.view);
        make.left.equalTo(self.leftView.mas_right).offset(20);
    }];
    _hisView = view;
    return _hisView;
}

- (NSArray *)descriptionArray{
    if (_descriptionArray != nil) {
        return _descriptionArray;
    }
    
    _descriptionArray = @[
                          @"测量步骤:\n1.请将臂带按照规定戴好,并使手臂与心脏同高;\n2.打开血压计电源开关;\n3.点击开始按钮,等待提示灯变化成绿色;\n4.测量完成等待结果同步.",
                          @"测量步骤:\n1.请将耳温计开关打开;\n2.点击开始按钮,等待指示灯变化成绿色;\n3.将耳温计口置入耳道,按下 START 进行量测;\n4.测量完成等待结果同步.",
                          @"测量步骤:\n1.请打开血糖仪插入试纸;\n2.点击开始按钮,等待提示灯变化成绿色;\n3.通过采血笔将血液滴入试纸上;\n4.等待量测结果."
                          ];
    return _descriptionArray;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return member.bindingDevices.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == member.bindingDevices.count) {
        DeviceModel *model = [[DeviceModel alloc]init];
        model.deviceName = @"返回";
         DeviceBtnCell *cell = [[DeviceBtnCell alloc]initWithModel:model Identifier:@"cell"];
        cell.delegate = self;
        return cell;
    }
    DeviceBtnCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[DeviceBtnCell alloc]initWithModel:member.bindingDevices[indexPath.row] Identifier:@"cell"];
    }

    cell.delegate = self;
    
    if (indexPath.row == 0 ) {
        [self didClickBluetoothDeviceBtn:cell.Btn];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.leftView.bounds.size.width *0.7;
}

- (void)dealloc{
    DMLog(@"HealthExaminationVC_dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
