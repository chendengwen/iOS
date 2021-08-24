//
//  HealthRecordChart.m
//  FuncGroup
//
//  Created by gary on 2017/2/22.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "HealthRecordChart.h"
#import "ZFChart.h"
#import "DBHealthRecordController.h"
#import "HealthModelProtocol.h"

#define ORANGE_COLOR [UIColor colorWithRed:1.00 green:0.65 blue:0.29 alpha:1.00]
#define REFERENCE_COLOR [UIColor colorWithRed:0.55 green:0.55 blue:0.56 alpha:1.00]
#define REFERENCE_FONT [UIFont boldSystemFontOfSize:14]

@interface HealthRecordChart()<ZFGenericChartDataSource, ZFLineChartDelegate>

@property (nonatomic,strong) ZFLineChart * lineChart;

@property (assign) HealthRecordType type;

@property (nonatomic,retain) NSMutableArray *dataArray;

//量测血压历史数据
@property (nonatomic,strong) NSArray *LBPStr;
@property (nonatomic,strong) NSArray *HBPStr;
//量测温度历史数据
@property (nonatomic,strong) NSArray *TStr;
//量测血糖历史数据
@property (nonatomic,strong) NSArray *BSStr;
//日期
@property (nonatomic,strong) NSArray *dataStr;

@end

@implementation HealthRecordChart

NSString * getTitle(HealthRecordType type){
    switch (type) {
        case HealthRecordXueTang:
            return @"血压历史量测";
            break;
        case HealthRecordXueYa:
            return @"血糖历史量测";
        case HealthRecordTiWen:
            return @"体温历史量测";
        default:
            return @"历史量测";
            break;
    }
}

-(id)initWithFrame:(CGRect)frame type:(HealthRecordType)type{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        
        self.backgroundColor = [UIColor whiteColor];
        
        _dataArray = [NSMutableArray arrayWithCapacity:10];
        if (!_dbController) {
            Class cls = NSClassFromString(GetDBControllerType(HealthRecordAll));
            if (cls) {
                _dbController = [[cls alloc] init];
                _dbController.type = type;
            }
            
            // 开线程读数据库
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
                NSArray *array = [_dbController getAllRecordByUID];
                [_dataArray addObjectsFromArray:array];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self layoutChart];
                    [self layoutUnit];                    
                });
            });
        }
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.lineChart strokePath];
}

-(void)layoutChart{
    self.lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width - 20, self.bounds.size.height - 30 - 20 - 10)];
    
    self.lineChart.dataSource = self;
    self.lineChart.delegate = self;
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
}

-(void)layoutUnit{
    UIView *referenceColor = [[UIView alloc] initWithFrame:CGRectMake(20, self.bounds.size.height - 10 - 30, self.bounds.size.width - 20*2, 30)];
    
    UIView *blue = [self getSubReferenceColor:kMainColor withTitle:getUnit(self.type)];
    [referenceColor addSubview:blue];
    
    float offsetX = 0;
    switch (self.type) {
        case HealthRecordXueYa:
            
            break;
            
        default:
            break;
    }
    
    if (self.type == HealthRecordXueYa) {
        offsetX = (referenceColor.bounds.size.width - 125.0*2 - 10)/2;
    }else {
        offsetX = (referenceColor.bounds.size.width - 125.0)/2;
    }
    
    [blue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(referenceColor);
        make.left.equalTo(referenceColor).offset(offsetX);
        make.width.equalTo(@(125));
    }];
    
    if (self.type == HealthRecordXueYa) {
        UIView *orange = [self getSubReferenceColor:ORANGE_COLOR withTitle:@"收缩压(mmHg)"];
        [referenceColor addSubview:orange];
        [orange mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(referenceColor);
            make.left.equalTo(blue.mas_right).offset(10);
            make.width.equalTo(@(125));
        }];
    }
    
    [self addSubview:referenceColor];
    
}

- (UIView *)getSubReferenceColor:(UIColor *)color withTitle:(NSString *)title{
    UIView *subReferenceColor = [[UIView alloc] init];
    
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
    colorLab.text = [title copy];
    colorLab.font = REFERENCE_FONT;
    colorLab.textColor = REFERENCE_COLOR;
    [subReferenceColor addSubview:colorLab];
    [colorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(colorView.mas_right).offset(4);
        make.centerY.equalTo(subReferenceColor);
    }];
    
    return subReferenceColor;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    // 阴影
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 0.3;     //阴影透明度，默认0
    self.layer.shadowRadius = 5;        //阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    float x = self.bounds.origin.x;
    float y = self.bounds.origin.y;
    
    CGPoint topLeft      = self.bounds.origin;
    CGPoint topRight     = CGPointMake(x+width,y);
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addLineToPoint:topRight];
    [path addLineToPoint:bottomRight];
    [path addLineToPoint:bottomLeft];
    //设置阴影路径  
    self.layer.shadowPath = path.CGPath;
}


#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    
    if (self.type == HealthRecordXueYa) {
        self.lineChart.topicLabel.text = @"血压历史结果";
        if (self.LBPStr.count == 0) {
           return @[];
        }
        return @[self.LBPStr,self.HBPStr];
    }else if (self.type == HealthRecordTiWen){
        self.lineChart.topicLabel.text = @"温度历史结果";
        if (self.TStr.count == 0) {
            return @[];
        }
        return @[self.TStr];
    }else if (self.type == HealthRecordXueTang){
        self.lineChart.topicLabel.text = @"血糖历史结果";
        if (self.BSStr.count == 0) {
            return @[];
        }
        return @[self.BSStr];
    }
    
    return  nil;
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    if (self.dataStr.count == 0) {
        return @[];
    }
    return self.dataStr;
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[kMainColor, ORANGE_COLOR];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    
    if (self.type == HealthRecordXueYa) {
        return 200;
    }else if (self.type == HealthRecordTiWen){
        return 43;
    }else if (self.type == HealthRecordXueTang){
        return 35;
    }
    return 200;
    
}

- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
    if (self.type == HealthRecordXueYa) {
        return 40;
    }else if (self.type == HealthRecordTiWen){
        return 35;
    }else if (self.type == HealthRecordXueTang){
        return 0;
    }
    return 40;
}

- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    if (self.type == HealthRecordXueYa) {
        return 8;
    }else if (self.type == HealthRecordTiWen){
        return 8;
    }else if (self.type == HealthRecordXueTang){
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


#pragma mark ===  获取历史数据
- (NSArray *)LBPStr{
    if (_LBPStr != nil) {
        return _LBPStr;
    }
    
    NSMutableArray *LBPMArray = [[NSMutableArray alloc] initWithCapacity:self.dataArray.count];
    NSMutableArray *HBPMArray = [[NSMutableArray alloc] initWithCapacity:self.dataArray.count];
    NSMutableArray *dataMArray = [[NSMutableArray alloc] initWithCapacity:self.dataArray.count];
    for (BaseModel<HealthModelProtocol> *model in self.dataArray) {
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
    
    NSMutableArray *LBPMArray = [[NSMutableArray alloc] initWithCapacity:self.dataArray.count];
    NSMutableArray *HBPMArray = [[NSMutableArray alloc] initWithCapacity:self.dataArray.count];
    NSMutableArray *dataMArray = [[NSMutableArray alloc] initWithCapacity:self.dataArray.count];
    for (BaseModel<HealthModelProtocol> *model in self.dataArray) {
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
    
    NSMutableArray *TmArray = [[NSMutableArray alloc]initWithCapacity:self.dataArray.count];
    NSMutableArray *dataMArray = [[NSMutableArray alloc]initWithCapacity:self.dataArray.count];
    for (BaseModel<HealthModelProtocol> *model in self.dataArray) {
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
    
    NSMutableArray *BSmArray = [[NSMutableArray alloc]initWithCapacity:self.dataArray.count];
    NSMutableArray *dataMArray = [[NSMutableArray alloc]initWithCapacity:self.dataArray.count];
    for (BaseModel<HealthModelProtocol> *model in self.dataArray) {
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
