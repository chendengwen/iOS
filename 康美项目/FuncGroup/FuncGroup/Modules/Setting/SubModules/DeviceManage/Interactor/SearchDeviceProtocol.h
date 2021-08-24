//
//  SearchDeviceProtocol.h
//  FuncGroup
//
//  Created by gary on 2017/2/13.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchDeviceProtocol <NSObject>

-(void)getLocalDevicesSuccessed:(NSArray *)devices;

-(void)getLocalDevicesFailed:(NSString *)message;

-(void)searchDeviceFailed;

-(void)searchDeviceSuccessed:(NSArray *)devices;

@end
