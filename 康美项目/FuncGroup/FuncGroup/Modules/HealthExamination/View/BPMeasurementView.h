//
//  BPMeasurementView.h
//  FuncGroup
//
//  Created by zhong on 2017/2/14.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPValueModel.h"
@interface BPMeasurementView : UIView

//提示信息
@property (nonatomic,copy) NSString *title;
//血压
@property (nonatomic,strong) BPValueModel *BPModel;
//是否已测量
@property (nonatomic,assign) BOOL isMeasurement;

@end
