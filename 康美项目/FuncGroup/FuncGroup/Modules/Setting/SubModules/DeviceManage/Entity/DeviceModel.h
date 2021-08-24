//
//  DeviceModel.h
//  FuncGroup
//
//  Created by gary on 2017/2/13.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum: int{
//    DeviceTypeXueYa,
//    DeviceTypeErWen,
//    DeviceTypeXueTang
//}DeviceType;


@interface DeviceModel : BaseModel<HealthModelProtocol>

//@property (nonatomic,assign) DeviceType deviceType;
@property (nonatomic,assign) BOOL locked;

@property (nonatomic,copy) NSString *deviceName;
@property (nonatomic,copy) NSString *deviceIcon;

@property (nonatomic,copy) NSString *MAC;

@property (nonatomic,copy) NSString *time;

@property (nonatomic,copy) NSString *UUID;

@property (nonatomic,copy) NSString *type;

@end
