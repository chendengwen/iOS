//
//  DeviceModel.m
//  FuncGroup
//
//  Created by gary on 2017/2/13.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "DeviceModel.h"

@implementation DeviceModel

//-(void)setDeviceType:(DeviceType)deviceType{
//    switch (deviceType) {
//        case DeviceTypeXueYa:
//            _deviceName = @"血压计";
//            _deviceIcon = @"device_bloodpress_icon.png";
//            break;
//        case DeviceTypeErWen:
//            _deviceName = @"耳温计";
//            _deviceIcon = @"device_temperture.png";
//            break;
//        case DeviceTypeXueTang:
//            _deviceName = @"血糖仪";
//            _deviceIcon = @"device_sugar.png";
//            break;
//        default:
//            _deviceName = nil;
//            _deviceIcon = nil;
//            break;
//    }
//}

- (NSString *)type{
    
    if ([self.deviceName isEqualToString:@"体温计"]) {
        _type = @"AET-WD";
    }
    
    if ([self.deviceName isEqualToString:@"血压计"]) {
        _type = @"AES-XY";
    }
    
    if ([self.deviceName isEqualToString:@"血糖仪"]) {
        _type =  @"ZH-G01";
    }
    
    return _type;
}

@end
