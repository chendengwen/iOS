//
//  DeviceManageViewController.h
//  FuncGroup
//
//  Created by gary on 2017/2/10.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeviceManageVCPProtocol <NSObject>

-(void)saveDevices;

-(void)getDevicesOperation;

-(void)searchDevice:(UIButton *)sender;

-(void)lockDeviceAtIndex:(int)index;

-(void)cancelLockDevice:(NSArray *)array Name:(NSString *)deviceName;
@end


@interface DeviceManageViewController : UIViewController

@property (nonatomic,strong) id<DeviceManageVCPProtocol> presenter;

-(void)reloadData:(NSArray *)dataArray;

@end
