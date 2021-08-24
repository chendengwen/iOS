//
//  OrderByStatement.h
//  DBTest
//
//  Created by paidui-mini on 13-10-18.
//  Copyright (c) 2013年 paidui-mini. All rights reserved.
//

@import Foundation;
#import "DBConstants.h"

#define OBS_key(x) [OrderByStatement instanceWithKey:PropertyStr(x)]
#define OBS_keyType(x,y) [OrderByStatement instanceWithKey:PropertyStr(x) OrderByType:y]

@interface OrderByStatement : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) SelectOrderByType orderByType;

+ (OrderByStatement *)instanceWithKey:(NSString *)mKey;

+ (OrderByStatement *)instanceWithKey:(NSString *)mKey OrderByType:(SelectOrderByType)mType;


@end
