//
//  temperatureMeasurementView.h
//  FuncGroup
//
//  Created by zhong on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface temperatureMeasurementView : UIView
//提示信息
@property (nonatomic,copy) NSString *title;
//温度
@property (nonatomic,assign) CGFloat temperatureNum;
//是否已测量
@property (nonatomic,assign) BOOL isMeasurement;
@end
