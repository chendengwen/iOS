//
//  DeviceInteractor.h
//  FuncGroup
//
//  Created by gary on 2017/2/13.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceModel.h"
#import "SearchDeviceProtocol.h"
#import "CommonPresenter.h"

@interface DeviceInteractor : NSObject

@property (nonatomic,strong) NSMutableArray<DeviceModel *> *dataArray;

@property (nonatomic,weak) CommonPresenter<SearchDeviceProtocol> *handler;

/*
 * 读取本地设备操作
 */
-(void)getLocalDevices;

/*
 * 搜索操作
 */
-(void)searchDevices:(UIButton *)sender;

/*
 * 保存数据操作
 */
-(void)saveDevices;

/*
 * 绑定操作
 */
-(void)lockDeviceAtIndex:(int)index lock:(BOOL)lock;

@end
