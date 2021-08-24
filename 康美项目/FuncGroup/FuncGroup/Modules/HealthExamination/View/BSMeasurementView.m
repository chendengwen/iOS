//
//  BSMeasurementView.m
//  FuncGroup
//
//  Created by zhong on 2017/2/10.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "BSMeasurementView.h"
#import "UIImage+Extension.h"
#import "ZZCircleProgress.h"

#define RED_COLOR [UIColor colorWithRed:1.00 green:0.39 blue:0.39 alpha:1.00]
#define ORANGE_COLOR [UIColor colorWithRed:1.00 green:0.65 blue:0.29 alpha:1.00]
#define YELLOW_COLOR [UIColor colorWithRed:1.00 green:0.85 blue:0.41 alpha:1.00]
#define GREEN_COLOR [UIColor colorWithRed:0.41 green:0.75 blue:0.16 alpha:1.00]

#define REFERENCE_COLOR [UIColor colorWithRed:0.55 green:0.55 blue:0.56 alpha:1.00]
#define REFERENCE_FONT [UIFont boldSystemFontOfSize:14]

@interface BSMeasurementView ()

@property (nonatomic,weak) ZZCircleProgress *circle;

@property (nonatomic,weak) UILabel *valueLab;

@property (nonatomic,weak) UIButton *infoBtn;

@property (nonatomic,weak) UILabel *unitLa;

@end

@implementation BSMeasurementView

- (instancetype)init{
    self = [super init];
    if (self) {
        ZZCircleProgress *circle = [[ZZCircleProgress alloc] initWithFrame:CGRectZero pathBackColor:ORANGE_COLOR pathFillColor:GREEN_COLOR startAngle:125 strokeWidth:15];
        circle.reduceValue = 70;
        circle.showProgressText = NO;
        circle.showPoint = NO;
        circle.increaseFromLast = NO;
        [self addSubview:circle];
        self.circle = circle;
        [circle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-100);
            make.width.height.equalTo(self.mas_height).multipliedBy(0.3);
        }];
        
        UILabel *valueLab = [[UILabel alloc]init];
        self.valueLab = valueLab;
        valueLab.font = [UIFont boldSystemFontOfSize:35];
        valueLab.text = @"4.80";
        valueLab.textColor = GREEN_COLOR;
        [self addSubview:valueLab];
        [valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(circle);
        }];
        
        UILabel *unitLab = [[UILabel alloc]init];
        self.unitLa = unitLab;
        unitLab.font = [UIFont boldSystemFontOfSize:14];
        unitLab.text = @"mmol/L";
        unitLab.textColor = GREEN_COLOR;
        [self addSubview:unitLab];
        [unitLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(valueLab).offset(4);
            make.left.equalTo(valueLab.mas_right);
        }];
        
        UILabel *BSLab = [[UILabel alloc]init];
        BSLab.font = [UIFont boldSystemFontOfSize:28];
        BSLab.text = @"血糖";
        BSLab.textColor = GREEN_COLOR;
        [self addSubview:BSLab];
        [BSLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.centerX.equalTo(circle);
        }];
        
        //参考颜色
        UIView *referenceColorView = [self getReferenceColorView];
        [self addSubview:referenceColorView];
        [referenceColorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(circle);
            make.top.equalTo(circle.mas_bottom).offset(40);
            make.height.equalTo(@(15));
            make.width.equalTo(@(177));
        }];
        
        //提示图标
        UIImageView *infoIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"info"]];
        [self addSubview:infoIcon];
        [infoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(referenceColorView).offset(100);
//            make.top.equalTo(referenceColorView.mas_bottom).offset(32);
            make.left.equalTo(self.mas_centerX).offset(-180);
            make.top.equalTo(self.mas_centerY).offset(115);
            make.height.width.equalTo(@(40));
        }];
        //提示信息按钮
        UIButton *infoBtn = [[UIButton alloc]init];
        self.infoBtn = infoBtn;
        [self addSubview:infoBtn];
        infoBtn.titleLabel.numberOfLines = 0;
        infoBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [infoBtn setTitleColor:[UIColor colorWithRed:0.45 green:0.45 blue:0.49 alpha:1.00] forState:UIControlStateNormal];
        infoBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        infoBtn.titleEdgeInsets = UIEdgeInsetsMake(-8, -8, -8, -16);
        [infoBtn setBackgroundImage:[UIImage imageNamed:@"ble_controll_tip.9"] forState:UIControlStateNormal];
        [infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(infoIcon);
            make.left.equalTo(infoIcon.mas_right);
        }];
    }
    return self;
}

- (UIView *)getReferenceColorView{
    
    UIView *referenceColor = [[UIView alloc]init];
    
    UIView *yellow = [self getSubReferenceColor:YELLOW_COLOR withTitle:@"偏低"];
    [referenceColor addSubview:yellow];
    [yellow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(referenceColor);
        make.left.equalTo(referenceColor);
        make.width.equalTo(@(57));
    }];
    
    UIView *green = [self getSubReferenceColor:GREEN_COLOR withTitle:@"正常"];
    [referenceColor addSubview:green];
    [green mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(referenceColor);
        make.left.equalTo(yellow.mas_right).offset(3);
        make.width.equalTo(@(57));
    }];
    
    UIView *red = [self getSubReferenceColor:RED_COLOR withTitle:@"偏高"];
    [referenceColor addSubview:red];
    [red mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(referenceColor);
        make.left.equalTo(green.mas_right).offset(3);
        make.width.equalTo(@(57));
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

#pragma mark - Getter && Setter
- (void)setTitle:(NSString *)title{
    _title = title;
    [self setInfoBtnDescription:title];
}

- (void)setIsMeasurement:(BOOL)isMeasurement{
    _isMeasurement = isMeasurement;
    if (!isMeasurement) {
        self.circle.progress = 0.0;
    }
}

- (void)setBSModel:(BSValueModel *)BSModel{
    self.isMeasurement = YES;
    _BSModel = BSModel;
    self.valueLab.text = [NSString stringWithFormat:@"%.2lf",BSModel.value];
    self.unitLa.hidden = NO;
    if (BSModel.value >= 0 && BSModel.value <1.1) {
        self.title = @"量测结果:血糖偏低";
        self.unitLa.textColor = YELLOW_COLOR;
        self.valueLab.textColor = YELLOW_COLOR;
        self.circle.pathBackColor = YELLOW_COLOR;
        self.circle.pathFillColor = YELLOW_COLOR;
    }else if (BSModel.value < 11.1){
        self.title = @"量测结果:血糖正常";
        self.unitLa.textColor = GREEN_COLOR;
        self.valueLab.textColor = GREEN_COLOR;
        self.circle.pathBackColor = ORANGE_COLOR;
        self.circle.pathFillColor = GREEN_COLOR;
    }else if (BSModel.value < 33.3){
        self.title = @"量测结果:血糖偏高";
        self.unitLa.textColor = ORANGE_COLOR;
        self.valueLab.textColor = ORANGE_COLOR;
        self.circle.pathBackColor = ORANGE_COLOR;
        self.circle.pathFillColor = RED_COLOR;
    }else{
        self.title = @"Hi";
        self.valueLab.text = @"Hi";
        self.unitLa.hidden = YES;
        self.valueLab.textColor = RED_COLOR;
        self.circle.pathBackColor = RED_COLOR;
        self.circle.pathFillColor = RED_COLOR;
    }
    
    self.circle.progress = (BSModel.value > 33.29 ? 33.29:BSModel.value) / 33.29;
    
}

#pragma mark - Action
//设置提示信息
- (void)setInfoBtnDescription:(NSString *)description{
    CGSize size = [description sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18]}];
    
    [self.infoBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(size.height + 25));
        make.width.equalTo(@(size.width + 30));
    }];
    
    [self.infoBtn setTitle:description forState:UIControlStateNormal];
}
@end
