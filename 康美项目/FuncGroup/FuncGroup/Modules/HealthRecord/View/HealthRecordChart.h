//
//  HealthRecordChart.h
//  FuncGroup
//
//  Created by gary on 2017/2/22.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthRecordPublic.h"

@class DBHealthRecordController;

@interface HealthRecordChart : UIView

@property (nonatomic, strong) DBHealthRecordController *dbController;

-(id)initWithFrame:(CGRect)frame type:(HealthRecordType)type;

@end
