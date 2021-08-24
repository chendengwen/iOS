//
//  BPMeasurementView.m
//  FuncGroup
//
//  Created by zhong on 2017/2/14.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "BPMeasurementView.h"
#import "UIImage+Extension.h"
#define RED_COLOR [UIColor colorWithRed:0.96 green:0.25 blue:0.25 alpha:1.00]
#define ORANGE_COLOR [UIColor colorWithRed:1.00 green:0.65 blue:0.29 alpha:1.00]
#define GREEN_COLOR [UIColor colorWithRed:0.25 green:0.77 blue:0.00 alpha:1.00]
#define YELLOW_COLOR [UIColor colorWithRed:1.00 green:0.85 blue:0.41 alpha:1.00]

#define LAB_FONT [UIFont boldSystemFontOfSize:18]
#define SUBLAB_FONT [UIFont boldSystemFontOfSize:11]
#define BPLAB_COLOR [UIColor colorWithRed:0.43 green:0.44 blue:0.44 alpha:1.00]
#define BPLAB_FONT [UIFont boldSystemFontOfSize:15]

@interface BPMeasurementView ()

@property (nonatomic,weak) UILabel *BPLab;

@property (nonatomic,weak) UISlider *LBPSlider;

@property (nonatomic,weak) UISlider *HBPSlider;

@property (nonatomic,weak) UILabel *LBPValueLab;

@property (nonatomic,weak) UILabel *HBPValueLab;

@property (nonatomic,weak) UIButton *infoBtn;

@property (nonatomic,weak) UIImageView *triangleIcon;

@property (nonatomic,weak) UIView *greenView;

@property (nonatomic,weak) UIView *orangeView;

@end

@implementation BPMeasurementView

- (instancetype)init{
    self = [super init];
    if (self) {
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.font = [UIFont boldSystemFontOfSize:20];
        titleLab.textColor = [UIColor blackColor];
        titleLab.text = @"血压";
        [self addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(50);
            make.top.equalTo(self).offset(SCREEN_HEIGHT * 0.18);
        }];
        
        UILabel *BPLab = [[UILabel alloc]init];
        self.BPLab = BPLab;
        BPLab.textColor = GREEN_COLOR;
        [self addSubview:BPLab];
        BPLab.font = [UIFont boldSystemFontOfSize:40];
        BPLab.text = @"90/60";
        [BPLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLab);
            make.right.equalTo(self);
        }];
        
        UIView *greenView = [[UIView alloc]init];
        self.greenView = greenView;
        greenView.backgroundColor = GREEN_COLOR;
        [self addSubview:greenView];
        [greenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(BPLab.mas_bottom).offset(40);
            make.left.equalTo(titleLab).offset(16);
            make.width.equalTo(self).multipliedBy(0.47);
            make.height.equalTo(@(15));
        }];
        
        UIView *orangeView = [[UIView alloc]init];
        self.orangeView = orangeView;
        orangeView.backgroundColor = ORANGE_COLOR;
        [self addSubview:orangeView];
        [orangeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(greenView);
            make.left.equalTo(greenView.mas_right);
            make.height.equalTo(greenView);
            make.width.equalTo(self).multipliedBy(0.2);
        }];
        
        UIView *redView = [[UIView alloc]init];
        redView.backgroundColor = RED_COLOR;
        [self addSubview:redView];
        [redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(greenView);
            make.left.equalTo(orangeView.mas_right);
            make.height.equalTo(greenView);
            make.width.equalTo(self).multipliedBy(0.2);
        }];
        
        //4条分割线 & 下标
        UIView *line_1 = [[UIView alloc]init];
        [self addSubview:line_1];
        line_1.backgroundColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.56 alpha:1.00];
        [line_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(greenView);
            make.height.equalTo(@(40));
            make.width.equalTo(@(1));
        }];
        UILabel *lab_1 = [self getSubLabWithTitle:@"90/60"];
        [self addSubview:lab_1];
        [lab_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line_1);
            make.top.equalTo(line_1.mas_bottom);
        }];
        
        UIView *line_2 = [[UIView alloc]init];
        [self addSubview:line_2];
        line_2.backgroundColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.56 alpha:1.00];
        [line_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(greenView.mas_right);
            make.top.equalTo(greenView);
            make.height.equalTo(@(40));
            make.width.equalTo(@(1));
        }];
        UILabel *lab_2 = [self getSubLabWithTitle:@"139/90"];
        [self addSubview:lab_2];
        [lab_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line_2);
            make.top.equalTo(line_1.mas_bottom);
        }];
        
        UIView *line_3 = [[UIView alloc]init];
        [self addSubview:line_3];
        line_3.backgroundColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.56 alpha:1.00];
        [line_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(orangeView.mas_right);
            make.top.equalTo(greenView);
            make.height.equalTo(@(40));
            make.width.equalTo(@(1));
        }];
        UILabel *lab_3 = [self getSubLabWithTitle:@"160/95"];
        [self addSubview:lab_3];
        [lab_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line_3);
            make.top.equalTo(line_1.mas_bottom);
        }];
        
        UIView *line_4 = [[UIView alloc]init];
        [self addSubview:line_4];
        line_4.backgroundColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.56 alpha:1.00];
        [line_4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(redView.mas_right);
            make.top.equalTo(greenView);
            make.height.equalTo(@(40));
            make.width.equalTo(@(1));
        }];
        UILabel *lab_4 = [self getSubLabWithTitle:@"180/110"];
        [self addSubview:lab_4];
        [lab_4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(line_4);
            make.top.equalTo(line_1.mas_bottom);
        }];
        
        //正常血压Lab
        UILabel *normalLab = [self getLabWithTitle:@"正常血压" withColor:GREEN_COLOR];
        [self addSubview:normalLab];
        [normalLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(greenView);
            make.top.equalTo(greenView.mas_bottom).offset(6);
        }];
        
        //临界血压
        UILabel *criticalLab = [self getLabWithTitle:@"临界血压" withColor:ORANGE_COLOR];
        [self addSubview:criticalLab];
        [criticalLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(orangeView);
            make.top.equalTo(greenView.mas_bottom).offset(6);
        }];
        
        //高血压
        UILabel *heightLab = [self getLabWithTitle:@"高血压" withColor:RED_COLOR];
        [self addSubview:heightLab];
        [heightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(redView);
            make.top.equalTo(greenView.mas_bottom).offset(6);
        }];
        //收缩压title
        UILabel *HBPTitleLab = [[UILabel alloc]init];
        HBPTitleLab.text = @"收缩压(mmHg)";
        HBPTitleLab.font = BPLAB_FONT;
        HBPTitleLab.textColor = BPLAB_COLOR;
        [self addSubview:HBPTitleLab];
        [HBPTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLab);
            make.top.equalTo(lab_1.mas_bottom).offset(50);
        }];
        //收缩压value
        UILabel *HBPValueLab = [[UILabel alloc]init];
        self.HBPValueLab = HBPValueLab;
        HBPValueLab.text = @"120 mmHg";
        HBPValueLab.font = BPLAB_FONT;
        HBPValueLab.textColor = BPLAB_COLOR;
        [self addSubview:HBPValueLab];
        [HBPValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(redView);
            make.top.equalTo(HBPTitleLab);
        }];
        
        //收缩压滑动条
        UISlider *HBPSlider = [[UISlider alloc]init];
        self.HBPSlider = HBPSlider;
        HBPSlider.maximumValue = 180;
        HBPSlider.minimumValue = 90;
        [self addSubview:HBPSlider];
        [HBPSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(HBPTitleLab.mas_bottom).offset(20);
            make.width.equalTo(self).multipliedBy(0.8);
            make.left.equalTo(greenView.mas_left);
            make.height.equalTo(@(20));
        }];
        UIImage *HBPleftTrack = [[UIImage imageNamed:@"select_slider"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
        [HBPSlider setMinimumTrackImage:HBPleftTrack forState:UIControlStateNormal];
        UIImage *HBPrightTrack = [[UIImage imageNamed:@"nor_slider"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
        [HBPSlider setMaximumTrackImage:HBPrightTrack forState:UIControlStateNormal];
        
        //舒张压title
        UILabel *LBPTitleLab = [[UILabel alloc]init];
        LBPTitleLab.text = @"舒张压(mmHg)";
        LBPTitleLab.font = BPLAB_FONT;
        LBPTitleLab.textColor = BPLAB_COLOR;
        [self addSubview:LBPTitleLab];
        [LBPTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLab);
            make.top.equalTo(HBPSlider.mas_bottom).offset(20);
        }];
        //舒张压value
        UILabel *LBPValueLab = [[UILabel alloc]init];
        self.LBPValueLab = LBPValueLab;
        LBPValueLab.text = @"80 mmHg";
        LBPValueLab.font = BPLAB_FONT;
        LBPValueLab.textColor = BPLAB_COLOR;
        [self addSubview:LBPValueLab];
        [LBPValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(redView);
            make.top.equalTo(LBPTitleLab);
        }];
        
        //舒张压滑动条
        UISlider *LBPSlider = [[UISlider alloc]init];
        self.LBPSlider = LBPSlider;
        LBPSlider.maximumValue = 110;
        LBPSlider.minimumValue = 60;
        [self addSubview:LBPSlider];
        [LBPSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(LBPTitleLab.mas_bottom).offset(20);
            make.width.equalTo(self).multipliedBy(0.8);
            make.left.equalTo(greenView.mas_left);
            make.height.equalTo(@(20));
        }];
        UIImage *LBPleftTrack = [[UIImage imageNamed:@"select_slider"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
        [LBPSlider setMinimumTrackImage:LBPleftTrack forState:UIControlStateNormal];
        UIImage *LBPrightTrack = [[UIImage imageNamed:@"nor_slider"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
        [LBPSlider setMaximumTrackImage:LBPrightTrack forState:UIControlStateNormal];
        
        //提示图标
        UIImageView *infoIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"info"]];
        [self addSubview:infoIcon];
        [infoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(greenView);
            make.top.equalTo(LBPSlider.mas_bottom).offset(40);
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
        
        //三角形图标
        UIImageView *triangleIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"thumb_green"]];
        self.triangleIcon = triangleIcon;
        [self addSubview:triangleIcon];
        [triangleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(greenView.mas_top);
            make.left.equalTo(greenView);
        }];
        
        self.HBPSlider.enabled = NO;
        self.LBPSlider.enabled = NO;
        
        self.title = @"量测结果:正常血压";
    }
    return self;
}

#pragma mark - Getter && Setter
- (void)setTitle:(NSString *)title{
    _title = title;
    [self setInfoBtnDescription:title];
}

- (void)setIsMeasurement:(BOOL)isMeasurement{
    _isMeasurement = isMeasurement;
    if (!isMeasurement) {
        BPValueModel *model = [[BPValueModel alloc]init];
        model.heartRate = 0;
        model.HBP = 90;
        model.LBP = 60;
        _BPModel = model;
        [self animationWithValue:model.HBP];
    }
}

- (void)setBPModel:(BPValueModel *)BPModel{
    _BPModel = BPModel;
    
    self.isMeasurement = YES;
    //收缩压滑动条
    self.HBPValueLab.text = [NSString stringWithFormat:@"%zd mmHg",BPModel.HBP];
    [self.HBPSlider setValue:BPModel.HBP animated:YES];
    //舒张压滑动条
    self.LBPValueLab.text = [NSString stringWithFormat:@"%zd mmHg",BPModel.LBP];
    [self.LBPSlider setValue:BPModel.LBP animated:YES];
    //血压值
    self.BPLab.text = [NSString stringWithFormat:@"%zd/%zd",BPModel.HBP,BPModel.LBP];
    
    //根据值设置颜色
    if (self.BPModel.HBP > 180 || self.BPModel.LBP > 110){
        self.BPLab.textColor = RED_COLOR;
        self.title = @"量测结果:重度高血压";
    }else if (self.BPModel.HBP > 159 || self.BPModel.LBP > 94) {
        self.BPLab.textColor = RED_COLOR;
        self.title = @"量测结果:高血压";
    }else if (self.BPModel.HBP > 139 || self.BPModel.LBP > 89) {
        self.BPLab.textColor = ORANGE_COLOR;
        self.title = @"量测结果:临界血压";
    }else if (self.BPModel.HBP > 89 || self.BPModel.LBP > 59){
        self.BPLab.textColor = GREEN_COLOR;
        self.title = @"量测结果:正常血压";
    }else if (self.BPModel.HBP > 49 || self.BPModel.LBP > 29){
        self.BPLab.textColor = YELLOW_COLOR;
        self.title = @"量测结果:低血压";
    }
    [self animationWithValue:BPModel.HBP];
}

#pragma mark - getSubLab
- (UILabel *)getLabWithTitle:(NSString *)title withColor:(UIColor *)color{
    UILabel *lab = [[UILabel alloc]init];
    lab.textColor = color;
    lab.font = LAB_FONT;
    lab.text = title;
    return lab;
}

- (UILabel *)getSubLabWithTitle:(NSString *)title{
    UILabel *lab = [[UILabel alloc]init];
    lab.textColor = [UIColor colorWithRed:0.61 green:0.64 blue:0.64 alpha:1.00];
    lab.font = SUBLAB_FONT;
    lab.text = title;
    return lab;
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

- (void)animationWithValue:(NSUInteger)value{
    value = value > 180 ? 180 : value;
    value = value < 90 ? 90 : value;
    //最大宽度
    CGFloat maxWidth = self.bounds.size.width * 0.87 -  self.triangleIcon.bounds.size.width;
    //移动距离
    CGFloat width = self.bounds.size.width * 0.87   / 90 * (value - 90);
    //三角形图标
    self.triangleIcon.image = [UIImage imageNamed:@"thumb_green"];
    if (width > (maxWidth)) {
        width = maxWidth;
    }
    
    if (width - self.triangleIcon.bounds.size.width < 0 ) {
        width = self.triangleIcon.bounds.size.width + 3;
    }
    
    if (value < 140) {
        
        [self.triangleIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.greenView).offset(width - self.triangleIcon.bounds.size.width + 1);
        }];
        [UIView animateWithDuration:0.7 animations:^{
            [self layoutIfNeeded];
        }];
    }else{
        [self.triangleIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.greenView).offset(self.greenView.bounds.size.width);
        }];
        [UIView animateWithDuration:0.7 animations:^{
            [self layoutIfNeeded];
        }];
        
        if (value < 160) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.triangleIcon.image = [UIImage imageNamed:@"thumb_orangle"];
                [self.triangleIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.greenView).offset(width - self.triangleIcon.bounds.size.width + 1);
                }];
                [UIView animateWithDuration:0.3 animations:^{
                    [self layoutIfNeeded];
                }];
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.triangleIcon.image = [UIImage imageNamed:@"thumb_orangle"];
                [self.triangleIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.greenView).offset(self.orangeView.bounds.size.width + self.greenView.bounds.size.width);
                }];
                [UIView animateWithDuration:0.3 animations:^{
                    [self layoutIfNeeded];
                }];
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.triangleIcon.image = [UIImage imageNamed:@"thumb_red"];
                [self.triangleIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.greenView).offset(width);
                }];
                [UIView animateWithDuration:0.3 animations:^{
                    [self layoutIfNeeded];
                }];
            });
        }
    }

}

@end
