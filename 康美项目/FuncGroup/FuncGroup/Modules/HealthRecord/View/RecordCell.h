//
//  RecordCell.h
//  FuncGroup
//
//  Created by gary on 2017/2/20.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthRecordModel.h"
#import "HealthModelProtocol.h"

extern NSString *const  RecordCell_ID;

@interface RecordCell : UITableViewCell

@property (nonatomic,strong) NSObject<HealthModelProtocol> *model;

@end
