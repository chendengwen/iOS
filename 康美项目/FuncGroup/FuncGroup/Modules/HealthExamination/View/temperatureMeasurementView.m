//
//  temperatureMeasurementView.m
//  FuncGroup
//
//  Created by zhong on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "temperatureMeasurementView.h"
#import "UIImage+Extension.h"

#define LAB_FONT [UIFont boldSystemFontOfSize:12]
#define LAB_COLOR [UIColor colorWithRed:0.61 green:0.64 blue:0.64 alpha:1.00]
//颜色
#define REFERENCE_COLOR [UIColor colorWithRed:0.55 green:0.55 blue:0.56 alpha:1.00]
#define REFERENCE_FONT [UIFont boldSystemFontOfSize:14]

#define BIGRED_COLOR [UIColor colorWithRed:0.88 green:0.21 blue:0.21 alpha:1.00]
#define RED_COLOR [UIColor colorWithRed:1.00 green:0.39 blue:0.39 alpha:1.00]
#define ORANGE_COLOR [UIColor colorWithRed:1.00 green:0.65 blue:0.29 alpha:1.00]
#define YELLOW_COLOR [UIColor colorWithRed:1.00 green:0.85 blue:0.41 alpha:1.00]
#define GREEN_COLOR [UIColor colorWithRed:0.41 green:0.75 blue:0.16 alpha:1.00]
#define BLUE_COLOR [UIColor colorWithRed:0.39 green:0.72 blue:0.99 alpha:1.00]

@interface temperatureMeasurementView ()

@property (nonatomic,weak) UIImageView *temperatureIcon;

@property (nonatomic,weak) UIImageView *scaleValueIcon;

@property (nonatomic,weak) UIButton *infoBtn;

@property (nonatomic,weak) UIImageView *temperatureLine;

@property (nonatomic,weak) UIImageView *circleIcon;

@property (nonatomic,weak) UILabel *titleLab;

@end

@implementation temperatureMeasurementView


- (instancetype)init{
    self = [super init];
    if (self) {
        //温度计背景
        UIImageView *temperatureIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"temperature"]];
        [self addSubview:temperatureIcon];
        [temperatureIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-46);
            make.width.equalTo(@(146));
            make.height.equalTo(@(332));
        }];
        //刻度icon
        UIImageView *scaleValueIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scale_value"]];
        [self addSubview:scaleValueIcon];
        [scaleValueIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(temperatureIcon).offset(12);
            make.right.equalTo(temperatureIcon).offset(-4);
            make.height.equalTo(temperatureIcon).multipliedBy(0.55);
            make.width.equalTo(scaleValueIcon.mas_height).multipliedBy(0.14);
        }];
        
        //刻度Lab
        UILabel *lab42 = [[UILabel alloc]init];
        lab42.text = @"42";
        lab42.font = LAB_FONT;
        lab42.textColor = LAB_COLOR;
        [self addSubview:lab42];
        [lab42 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(scaleValueIcon);
            make.left.equalTo(scaleValueIcon.mas_right);
        }];
        
        UILabel *lab35 = [[UILabel alloc]init];
        lab35.text = @"35";
        lab35.font = LAB_FONT;
        lab35.textColor = LAB_COLOR;
        [self addSubview:lab35];
        [lab35 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(scaleValueIcon).offset(-2);
            make.left.equalTo(scaleValueIcon.mas_right);
        }];
        
        //圈圈
        UIImageView *circleIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circle_thin_blue"]];
        self.circleIcon = circleIcon;
        [self addSubview:circleIcon];
        [circleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(temperatureIcon.mas_bottom).offset(-27);
            make.centerX.equalTo(temperatureIcon);
        }];
        
        //参考颜色
        UIView *referenceColorView = [self getReferenceColorView];
        [self addSubview:referenceColorView];
        [referenceColorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(temperatureIcon);
            make.top.equalTo(temperatureIcon.mas_bottom).offset(40);
            make.height.equalTo(@(15));
            make.width.equalTo(@(540));
        }];
        
        //提示图标
        UIImageView *infoIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"info"]];
        [self addSubview:infoIcon];
        [infoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(referenceColorView).offset(100);
            make.top.equalTo(referenceColorView.mas_bottom).offset(32);
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
        
        //温度条
        UIImageView *temperatureLine = [[UIImageView alloc]init];
        self.temperatureLine = temperatureLine;
        temperatureLine.layer.cornerRadius = 2;
        temperatureLine.layer.masksToBounds = YES;
        [self addSubview:temperatureLine];
        //        temperatureLine.backgroundColor = BLUE_COLOR;
        temperatureLine.image = [UIImage imageWithColor:BLUE_COLOR];
        [temperatureLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(circleIcon.mas_top).offset(4);
            make.centerX.equalTo(circleIcon);
            make.height.equalTo(@(1));
            //            make.top.equalTo(scaleValueIcon.mas_bottom);
            make.width.equalTo(@(20));
            
        }];
        
        //titleLab
        UILabel *titleLab = [[UILabel alloc]init];
        self.titleLab = titleLab;
        titleLab.font = [UIFont boldSystemFontOfSize:45];
        [self addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(temperatureIcon);
            make.left.equalTo(lab42.mas_right).offset(30);
        }];
        titleLab.text = @"35.0°C";
        titleLab.textColor = BLUE_COLOR;
        
        
        //监听温度条
        [temperatureLine addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (UIView *)getReferenceColorView{
    
    UIView *referenceColor = [[UIView alloc]init];
    
    UIView *bigRed = [self getSubReferenceColor:BIGRED_COLOR withTitle:@"重度发烧"];
    [referenceColor addSubview:bigRed];
    [bigRed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(referenceColor);
        make.left.equalTo(referenceColor);
        make.width.equalTo(@(90));
    }];
    
    UIView *red = [self getSubReferenceColor:RED_COLOR withTitle:@"高度发烧"];
    [referenceColor addSubview:red];
    [red mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(referenceColor);
        make.left.equalTo(bigRed.mas_right);
        make.width.equalTo(@(90));
    }];
    
    UIView *orange = [self getSubReferenceColor:ORANGE_COLOR withTitle:@"中度发烧"];
    [referenceColor addSubview:orange];
    [orange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(referenceColor);
        make.left.equalTo(red.mas_right);
        make.width.equalTo(@(90));
    }];
    
    UIView *yellow = [self getSubReferenceColor:YELLOW_COLOR withTitle:@"轻度发烧"];
    [referenceColor addSubview:yellow];
    [yellow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(referenceColor);
        make.left.equalTo(orange.mas_right);
        make.width.equalTo(@(90));
    }];
    
    UIView *green = [self getSubReferenceColor:GREEN_COLOR withTitle:@"正常体温"];
    [referenceColor addSubview:green];
    [green mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(referenceColor);
        make.left.equalTo(yellow.mas_right);
        make.width.equalTo(@(90));
    }];
    
    UIView *blue = [self getSubReferenceColor:BLUE_COLOR withTitle:@"体温过低"];
    [referenceColor addSubview:blue];
    [blue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(referenceColor);
        make.left.equalTo(green.mas_right);
        make.width.equalTo(@(90));
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
        
        [self.temperatureLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(1));
        }];
    }
}

- (void)setTemperatureNum:(CGFloat)temperatureNum{
    _temperatureNum = temperatureNum;
    self.isMeasurement = YES;
    
    _titleLab.text = [NSString stringWithFormat:@"%.1f°C",temperatureNum];
    if (temperatureNum == 42.2) {
        _titleLab.text = @"Hi";
    }
    CGFloat height = 28 + (temperatureNum - 35.0) * 26;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [self.temperatureLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
        [self layoutIfNeeded];
    } completion:nil];
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

//test
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    if (self.temperatureNum == 42.0) {
//        self.temperatureNum = 35.0;
//    }else{
//        self.temperatureNum = 42.0;
//    }
//
//}

//监听温度条变化 & 改变颜色
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    NSValue *value = [change objectForKey:@"new"];
    CGRect bounds = [value CGRectValue];
    CGFloat temperature = (bounds.size.height - 30) / 26.0 + 35;
    //体温过低
    if (temperature < 36) {
        self.title = @"量测结果:体温过低";
        self.circleIcon.image = [UIImage imageNamed:@"circle_thin_blue"];
        self.temperatureLine.image = [UIImage imageWithColor:BLUE_COLOR];
        self.titleLab.textColor = BLUE_COLOR;
    }
    //正常体温
    if (temperature < 37.5 && temperature >= 36.0) {
        self.title = @"量测结果:体温正常";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.circleIcon.image = [UIImage imageNamed:@"circle_green"];
            self.temperatureLine.image = [UIImage imageWithColor:GREEN_COLOR];
            self.titleLab.textColor = GREEN_COLOR;
        });
    }
    //轻度发烧
    if (temperature < 38.0 && temperature >= 37.5) {
        self.title = @"量测结果:轻度发烧";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.circleIcon.image = [UIImage imageNamed:@"circle_green"];
            self.temperatureLine.image = [UIImage imageWithColor:GREEN_COLOR];
            self.titleLab.textColor = GREEN_COLOR;
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.circleIcon.image = [UIImage imageNamed:@"circle_yellow"];
            self.temperatureLine.image = [UIImage imageWithColor:YELLOW_COLOR];
            self.titleLab.textColor = YELLOW_COLOR;
        });
        
    }
    //中度发烧
    if (temperature < 39.0 && temperature >= 38.0) {
        self.title = @"量测结果:中度发烧";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.circleIcon.image = [UIImage imageNamed:@"circle_green"];
            self.temperatureLine.image = [UIImage imageWithColor:GREEN_COLOR];
            self.titleLab.textColor = GREEN_COLOR;
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.circleIcon.image = [UIImage imageNamed:@"circle_yellow"];
            self.temperatureLine.image = [UIImage imageWithColor:YELLOW_COLOR];
            self.titleLab.textColor = YELLOW_COLOR;
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.circleIcon.image = [UIImage imageNamed:@"circle_orange"];
            self.temperatureLine.image = [UIImage imageWithColor:ORANGE_COLOR];
            self.titleLab.textColor = ORANGE_COLOR;
        });
    }
    //高度发烧
    if (temperature < 40.0 && temperature >= 39.0) {
        self.title = @"量测结果:高度发烧";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.circleIcon.image = [UIImage imageNamed:@"circle_green"];
            self.temperatureLine.image = [UIImage imageWithColor:GREEN_COLOR];
            self.titleLab.textColor = GREEN_COLOR;
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.circleIcon.image = [UIImage imageNamed:@"circle_yellow"];
            self.temperatureLine.image = [UIImage imageWithColor:YELLOW_COLOR];
            self.titleLab.textColor = YELLOW_COLOR;
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.circleIcon.image = [UIImage imageNamed:@"circle_orange"];
            self.temperatureLine.image = [UIImage imageWithColor:ORANGE_COLOR];
            self.titleLab.textColor = ORANGE_COLOR;
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.circleIcon.image = [UIImage imageNamed:@"circle_red"];
            self.temperatureLine.image = [UIImage imageWithColor:RED_COLOR];
            self.titleLab.textColor = RED_COLOR;
        });
        
    }
    //重度发烧
    if (temperature >= 40.0) {
        self.title = @"量测结果:重度发烧";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.circleIcon.image = [UIImage imageNamed:@"circle_green"];
            self.temperatureLine.image = [UIImage imageWithColor:GREEN_COLOR];
            self.titleLab.textColor = GREEN_COLOR;
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.circleIcon.image = [UIImage imageNamed:@"circle_yellow"];
            self.temperatureLine.image = [UIImage imageWithColor:YELLOW_COLOR];
            self.titleLab.textColor = YELLOW_COLOR;
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.circleIcon.image = [UIImage imageNamed:@"circle_orange"];
            self.temperatureLine.image = [UIImage imageWithColor:ORANGE_COLOR];
            self.titleLab.textColor = ORANGE_COLOR;
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.circleIcon.image = [UIImage imageNamed:@"circle_red"];
            self.temperatureLine.image = [UIImage imageWithColor:RED_COLOR];
            self.titleLab.textColor = RED_COLOR;
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.circleIcon.image = [UIImage imageNamed:@"circle_dark_red"];
            self.temperatureLine.image = [UIImage imageWithColor:BIGRED_COLOR];
            self.titleLab.textColor = BIGRED_COLOR;
        });
    }
    
    NSLog(@"new : %f",temperature);

}

-(void)dealloc{
    
    [self.temperatureLine removeObserver:self forKeyPath:@"bounds" context:nil];
    
}

@end
