//
//  DeviceItemView.h
//  FuncGroup
//
//  Created by gary on 2017/2/17.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScaleSize SCREEN_WIDTH/1024.0
#define Height_DeviceItemView   110.0*ScaleSize
#define Width_DeviceItemView    260.0*ScaleSize

typedef void(^TapBlock)(int index);

@interface DeviceItemView : UIView

@property (nonatomic,copy) NSString *imageName;

@property (nonatomic,copy) NSString *deviceName;

@property (nonatomic,copy) NSString *MAC;

@property (nonatomic,copy) NSString *time;

@property (nonatomic,assign) BOOL locked;

@property (nonatomic,assign) int index;

@property (nonatomic,strong) TapBlock block;

@end
