//
//  BSMeasurementView.h
//  FuncGroup
//
//  Created by zhong on 2017/2/10.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSValueModel.h"

@interface BSMeasurementView : UIView
//提示信息
@property (nonatomic,copy) NSString *title;
//温度
@property (nonatomic,strong) BSValueModel *BSModel;
//是否已测量
@property (nonatomic,assign) BOOL isMeasurement;
@end
