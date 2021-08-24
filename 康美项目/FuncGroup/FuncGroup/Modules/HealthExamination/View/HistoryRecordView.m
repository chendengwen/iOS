//
//  HistoryRecordView.m
//  FuncGroup
//
//  Created by zhong on 2017/2/16.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "HistoryRecordView.h"
#import "ZFChart.h"

#define ORANGE_COLOR [UIColor colorWithRed:1.00 green:0.65 blue:0.29 alpha:1.00]
#define REFERENCE_COLOR [UIColor colorWithRed:0.55 green:0.55 blue:0.56 alpha:1.00]
#define REFERENCE_FONT [UIFont boldSystemFontOfSize:14]
//血糖仪名称
#define BLOOD_GLUCOSE_METER_NAME @"ZH-G01"
//体温计名称
#define HERMOMETER_NAME @"AET-WD"
//血压计名称
#define SPHYGMOMANOMETER_NAME @"AES-XY"

@interface HistoryRecordView ()<ZFGenericChartDataSource, ZFLineChartDelegate>
@property (nonatomic,strong) ZFLineChart * lineChart;

@property (nonatomic,assign) CGFloat height;
//量测血压历史数据
@property (nonatomic,strong) NSArray *LBPStr;
@property (nonatomic,strong) NSArray *HBPStr;
//量测温度历史数据
@property (nonatomic,strong) NSArray *TStr;
//量测血糖历史数据
@property (nonatomic,strong) NSArray *BSStr;
//日期
@property (nonatomic,strong) NSArray *dataStr;

@property (nonatomic,weak) UIView *referenceColorView;

@property (nonatomic,strong) bluetoothDeviceDataManager *manager;
@end

@implementation HistoryRecordView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.manager = [bluetoothDeviceDataManager sharedInstance];
        [self setUp];
        [self setupLineChartView];
        
        UIView *rightView = [[UIView alloc]init];
        [self addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.left.equalTo(self.lineChart.mas_right);
        }];
        
        //返回按钮
        UIButton *backBtn = [[UIButton alloc]init];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        backBtn.backgroundColor = kMainColor;
        backBtn.layer.cornerRadius = 4;
        backBtn.layer.masksToBounds = YES;
        backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [backBtn addTarget:self action:@selector(didClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(rightView);
            make.top.equalTo(rightView).offset(50);
            make.width.equalTo(rightView).multipliedBy(0.6);
            make.height.equalTo(backBtn.mas_width).multipliedBy(0.4);
        }];
        
        //参考颜色
        UIView *referenceColorView = [self getReferenceColorView];
        self.referenceColorView = referenceColorView;
        [self addSubview:referenceColorView];
        [referenceColorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.lineChart);
            make.top.equalTo(self.lineChart.mas_bottom).offset(40);
            make.height.equalTo(@(15));
            make.width.equalTo(@(255));
        }];
        
        
        
    }
    return self;
}

#pragma mark - Action
- (void)didClickBackBtn:(UIButton *)sender{
    self.hidden = YES;
}

- (void)setDeviceName:(DeviceName)deviceName{
    _deviceName = deviceName;
    
    [self.lineChart strokePath];
}

- (UIView *)getReferenceColorView{
    
    UIView *referenceColor = [[UIView alloc]init];
    
    UIView *blue = [self getSubReferenceColor:kMainColor withTitle:@"舒张压(mmHg)"];
    [referenceColor addSubview:blue];
    [blue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(referenceColor);
        make.left.equalTo(referenceColor);
        make.width.equalTo(@(125));
    }];
    
    UIView *orange = [self getSubReferenceColor:ORANGE_COLOR withTitle:@"收缩压(mmHg)"];
    [referenceColor addSubview:orange];
    [orange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(referenceColor);
        make.left.equalTo(blue.mas_right).offset(4);
        make.width.equalTo(@(125));
    }];
    
    return referenceColor;
}

- (UIView *)getSubReferenceColor:(UIColor *)color withTitle:(NSString *)title{
    UIView *subReferenceColor = [[UIView alloc]init];
    
    UIView *colorView = [[UIView alloc]init];
    colorView.backgroundColor = color;
    [subReferenceColor addSubview:colorView];
    [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(subReferenceColor);
        make.left.equalTo(subReferenceColor);
        make.height.equalTo(@(10));
        make.width.equalTo(@(25));
    }];
    
    UILabel *colorLab = [[UILabel alloc]init];
    colorLab.text = title;
    colorLab.font = REFERENCE_FONT;
    colorLab.textColor = REFERENCE_COLOR;
    [subReferenceColor addSubview:colorLab];
    [colorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(colorView.mas_right).offset(4);
        make.centerY.equalTo(subReferenceColor);
    }];
    
    return subReferenceColor;
}

- (void)setUp{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        //首次进入控制器为横屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT * 0.5;
        
    }else{
        //首次进入控制器为竖屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT;
    }
}

- (void)setupLineChartView{
    self.lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(50, SCREEN_HEIGHT * 0.03, (SCREEN_WIDTH - 20) * 0.6, _height * 0.4)];
    self.lineChart.dataSource = self;
    self.lineChart.delegate = self;
    self.lineChart.topicLabel.text = @"血压历史结果";
    self.lineChart.topicLabel.textColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.56 alpha:1.00];
    self.lineChart.isShowYLineSeparate = YES;
    self.lineChart.isResetAxisLineMinValue = YES;
    self.lineChart.isResetAxisLineMaxValue = YES;
    self.lineChart.isShadow = NO;
    self.lineChart.unitColor = ZFPurple;
    self.lineChart.backgroundColor = ZFWhite;
    self.lineChart.xAxisColor = ZFLightGray;
    self.lineChart.yAxisColor = ZFLightGray;
    self.lineChart.axisLineNameColor = ZFLightGray;
    self.lineChart.axisLineValueColor = ZFLightGray;
    self.lineChart.xLineNameLabelToXAxisLinePadding = 10;
    [self addSubview:self.lineChart];
//    [self.lineChart mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(50);
//        make.top.equalTo(self).equalTo(@(SCREEN_HEIGHT * 0.03));
//        make.width.equalTo(@((SCREEN_WIDTH - 20) * 0.6));
//        make.height.equalTo(@(_height * 0.4));
//    }];
    
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    
    if (self.deviceName == DeviceName_BP) {
        self.lineChart.topicLabel.text = @"血压历史结果";
        self.referenceColorView.hidden = NO;
        if (self.LBPStr.count == 0 || self.deviceName == DeviceName_Demonstrate) {
            return @[];
        }
        return @[self.LBPStr,self.HBPStr];
    }else if (self.deviceName == DeviceName_Temperature){
        self.lineChart.topicLabel.text = @"温度历史结果";
        self.referenceColorView.hidden = YES;
        if (self.TStr.count == 0 || self.deviceName == DeviceName_Demonstrate) {
            return @[];
        }
        return @[self.TStr];
    }else if (self.deviceName == DeviceName_BS){
        self.lineChart.topicLabel.text = @"血糖历史结果";
        self.referenceColorView.hidden = YES;
        if (self.BSStr.count == 0 || self.deviceName == DeviceName_Demonstrate) {
            return @[];
        }
        return @[self.BSStr];
    }

    return  nil;
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    if (self.dataStr.count == 0 || self.deviceName == DeviceName_Demonstrate) {
        return @[];
    }
    return self.dataStr;
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[kMainColor, ORANGE_COLOR];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    
    
    if (self.deviceName == DeviceName_BP) {
        return 200;
    }else if (self.deviceName == DeviceName_Temperature){
        return 43;
    }else if (self.deviceName == DeviceName_BS){
        return 35;
    }
    return 200;
}

- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
    if (self.deviceName == DeviceName_BP) {
        return 40;
    }else if (self.deviceName == DeviceName_Temperature){
        return 35;
    }else if (self.deviceName == DeviceName_BS){
        return 0;
    }
    return 40;
}

- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    if (self.deviceName == DeviceName_BP) {
        return 8;
    }else if (self.deviceName == DeviceName_Temperature){
        return 8;
    }else if (self.deviceName == DeviceName_BS){
        return 7;
    }
    return 8;
}

#pragma mark - ZFLineChartDelegate

//- (CGFloat)groupWidthInLineChart:(ZFLineChart *)lineChart{
//    return 40.f;
//}

- (CGFloat)paddingForGroupsInLineChart:(ZFLineChart *)lineChart{
    return 100.f;
}

//- (CGFloat)circleRadiusInLineChart:(ZFLineChart *)lineChart{
//    return 10.f;
//}

//- (CGFloat)lineWidthInLineChart:(ZFLineChart *)lineChart{
//    return 5.f;
//}

//- (NSArray *)valuePositionInLineChart:(ZFLineChart *)lineChart{
//    return @[@(kChartValuePositionOnTop), @(kChartValuePositionDefalut), @(kChartValuePositionOnBelow)];
//}

- (void)lineChart:(ZFLineChart *)lineChart didSelectCircleAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex circle:(ZFCircle *)circle popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld条线========第%ld个",(long)lineIndex,(long)circleIndex);
    
    //可在此处进行circle被点击后的自身部分属性设置,可修改的属性查看ZFCircle.h
    //    circle.circleColor = ZFYellow;
    circle.isAnimated = YES;
    //    circle.opacity = 0.5;
    [circle strokePath];
    
    //    可将isShowAxisLineValue设置为NO，然后执行下句代码进行点击才显示数值
    //    popoverLabel.hidden = NO;
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectPopoverLabelAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld条线========第%ld个",(long)lineIndex,(long)circleIndex);
    //可在此处进行popoverLabel被点击后的自身部分属性设置
    //    popoverLabel.textColor = ZFGold;
    //    [popoverLabel strokePath];
}

#pragma mark - 横竖屏适配(若需要同时横屏,竖屏适配，则添加以下代码，反之不需添加)

/**
 *  PS：size为控制器self.view的size，若图表不是直接添加self.view上，则修改以下的frame值
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator NS_AVAILABLE_IOS(8_0){
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        self.lineChart.frame = CGRectMake(0, 0, size.width, size.height - NAVIGATIONBAR_HEIGHT * 0.5);
    }else{
        self.lineChart.frame = CGRectMake(0, 0, size.width, size.height + NAVIGATIONBAR_HEIGHT * 0.5);
    }
    
    [self.lineChart strokePath];
}

- (NSArray *)LBPStr{
    if (_LBPStr != nil) {
        return _LBPStr;
    }
    
    NSMutableArray *LBPMArray = [[NSMutableArray alloc]initWithCapacity:self.manager.BPmArray.count];
    NSMutableArray *HBPMArray = [[NSMutableArray alloc]initWithCapacity:self.manager.BPmArray.count];
    NSMutableArray *dataMArray = [[NSMutableArray alloc]initWithCapacity:self.manager.BPmArray.count];
    for (BaseModel<HealthModelProtocol> *model in self.manager.BPmArray) {
        [LBPMArray addObject:[NSString stringWithFormat:@"%lu",(unsigned long)[model intValue_1]]];
        [HBPMArray addObject:[NSString stringWithFormat:@"%lu",(unsigned long)[model intValue_2]]];
        [dataMArray addObject:[model date]];
    }
    
    self.dataStr = dataMArray.copy;
    self.HBPStr = HBPMArray.copy;
    return LBPMArray.copy;
}

- (NSArray *)HBPStr{
    if (_HBPStr != nil) {
        return _HBPStr;
    }
    
    NSMutableArray *LBPMArray = [[NSMutableArray alloc]initWithCapacity:self.manager.BPmArray.count];
    NSMutableArray *HBPMArray = [[NSMutableArray alloc]initWithCapacity:self.manager.BPmArray.count];
    NSMutableArray *dataMArray = [[NSMutableArray alloc]initWithCapacity:self.manager.BPmArray.count];
    for (BaseModel<HealthModelProtocol> *model in self.manager.BPmArray) {
        [LBPMArray addObject:[NSString stringWithFormat:@"%lu",(unsigned long)[model intValue_1]]];
        [HBPMArray addObject:[NSString stringWithFormat:@"%lu",(unsigned long)[model intValue_2]]];
        [dataMArray addObject:[model date]];
    }
    
    self.dataStr = dataMArray.copy;
    self.LBPStr = LBPMArray.copy;
    return HBPMArray.copy;
}

- (NSArray *)TStr{
    if (_TStr != nil) {
        return _TStr;
    }
    
    NSMutableArray *TmArray = [[NSMutableArray alloc]initWithCapacity:self.manager.TmArray.count];
    NSMutableArray *dataMArray = [[NSMutableArray alloc]initWithCapacity:self.manager.TmArray.count];
    for (BaseModel<HealthModelProtocol> *model in self.manager.TmArray) {
        [TmArray addObject:[NSString stringWithFormat:@"%.1f",[model floatValue]]];
        [dataMArray addObject:[model date]];
    }
    self.dataStr = dataMArray.copy;
    return TmArray.copy;
}

- (NSArray *)BSStr{
    if (_BSStr != nil) {
        return _BSStr;
    }
    
    NSMutableArray *BSmArray = [[NSMutableArray alloc]initWithCapacity:self.manager.BSmArray.count];
    NSMutableArray *dataMArray = [[NSMutableArray alloc]initWithCapacity:self.manager.BSmArray.count];
    for (BaseModel<HealthModelProtocol> *model in self.manager.BSmArray) {
        [BSmArray addObject:[NSString stringWithFormat:@"%.1f",[model floatValue]]];
        [dataMArray addObject:[model date]];
    }
    self.dataStr = dataMArray.copy;
    return BSmArray.copy;
}

////数组进行倒序输出
//- (NSArray *)reverseArrar:(NSArray *)array{
//    return (NSMutableArray *)[[array reverseObjectEnumerator] allObjects].copy;
//}


@end
