//
//  DeviceBtnCell.h
//  FuncGroup
//
//  Created by zhong on 2017/3/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceModel.h"
#import "BluetoothDeviceBtn.h"
@protocol DeviceBtnCellDelegate <NSObject>

- (void)didClickBluetoothDeviceBtn:(UIButton *)sender;

@end
@interface DeviceBtnCell : UITableViewCell

@property (nonatomic,weak) id<DeviceBtnCellDelegate> delegate;

@property (nonatomic,strong) DeviceModel *model;

- (instancetype)initWithModel:(DeviceModel *)model Identifier:(NSString *)identifier;

@property (nonatomic,weak) BluetoothDeviceBtn *Btn;

@end
