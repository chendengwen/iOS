//
//  DeviceBtnCell.m
//  FuncGroup
//
//  Created by zhong on 2017/3/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "DeviceBtnCell.h"


@interface DeviceBtnCell ()



@end

@implementation DeviceBtnCell

- (instancetype)initWithModel:(DeviceModel *)model Identifier:(NSString *)identifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        self.contentView.backgroundColor = kMainColor;
        self.model = model;
        BluetoothDeviceBtn *BPBtn ;
        if ([model.deviceName isEqualToString:@"血压计"]) {
            BPBtn = [[BluetoothDeviceBtn alloc]initWithImage:[UIImage imageNamed:@"ble_controll_pressure"] selectImage:[UIImage imageNamed:@"ble_controll_pressure_over"] title:@"血压"];
            BPBtn.tag = 100;
        }else if ([model.deviceName isEqualToString:@"体温计"]) {
            
            BPBtn = [[BluetoothDeviceBtn alloc]initWithImage:[UIImage imageNamed:@"ble_controll_temperture"] selectImage:[UIImage imageNamed:@"ble_controll_temperture_over"]title:@"温度"];
            BPBtn.tag = 101;
            
        }else if ([model.deviceName isEqualToString:@"血糖仪"]) {
            BPBtn = [[BluetoothDeviceBtn alloc]initWithImage:[UIImage imageNamed:@"ble_controll_sugar"] selectImage:[UIImage imageNamed:@"ble_controll_sugar_over"] title:@"血糖"];
            BPBtn.tag = 102;
        }else if ([model.deviceName isEqualToString:@"返回"]){
            BPBtn = [[BluetoothDeviceBtn alloc]initWithImage:[UIImage imageNamed:@"ble_controll_back"] selectImage:[UIImage imageNamed:@"ble_controll_back_over"] title:@"返回"];
            BPBtn.tag = 103;
        }
        
        self.Btn = BPBtn;
        
        [self.contentView addSubview:BPBtn];
        [BPBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.equalTo(BPBtn.mas_width).multipliedBy(0.7);
        }];
        [BPBtn addTarget:self action:@selector(didClickBluetoothDeviceBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)didClickBluetoothDeviceBtn:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(didClickBluetoothDeviceBtn:)])
    {
        [self.delegate didClickBluetoothDeviceBtn:sender];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
