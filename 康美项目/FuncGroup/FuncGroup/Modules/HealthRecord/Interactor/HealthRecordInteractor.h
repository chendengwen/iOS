//
//  HealthRecordInteractor.h
//  FuncGroup
//
//  Created by gary on 2017/2/22.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HealthRecordPublic.h"

@interface HealthRecordInteractor : NSObject

+(NSArray *)getHealthRecord:(HealthRecordType)type atIndex:(NSInteger)index;

@end
