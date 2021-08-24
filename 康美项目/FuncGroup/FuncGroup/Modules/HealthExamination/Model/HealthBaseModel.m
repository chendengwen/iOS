//
//  HealthBaseModel.m
//  FuncGroup
//
//  Created by gary on 2017/3/1.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "HealthBaseModel.h"
#import <objc/runtime.h>

@implementation HealthBaseModel

/*
 INSERT INTO HealthRecord (date, value, value2, type)]
 VALUES ('2017-12-22 23:23:33', 118, 79, 1);
 */
#pragma mark === SQL statement
+ (NSString *)getAllDBRecord{
    return nil;
}

+ (NSString *)getAllDBRecordByUID:(BOOL)whether{
    return [NSString stringWithFormat:@"select * from [%@]"
            "%@"
            " ORDER BY [data] asc",
            NSStringFromClass([self class]),(whether ? @" where uid = ? ":@"")];
}

//+ (NSString *)getDBRecordAtPage{
//    return [[[self class] getAllDBRecord] stringByAppendingString:@" limit 10 offset ?"];
//}

+ (NSString *)getDBRecordAtPageByUID:(BOOL)whether{
    return [[[self class] getAllDBRecordByUID:whether] stringByAppendingString:@" limit 10 offset ?"];
}

#pragma mark === getPropeties
-(NSArray *)objectPropeties{
    return [self objectPropeties:0];
}

-(NSArray *)objectPropeties:(int)superClasses{
    Class clazz = [self class];
    
    int classCount = superClasses+1;
    NSMutableArray *propertyList = [[NSMutableArray alloc] init];
    
    do {
        if ([NSStringFromClass(clazz) isEqualToString:@"BaseModel"]){
            return propertyList;
        }
        
        u_int count;
        objc_property_t *properties  = class_copyPropertyList(clazz, &count);
        NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
        
        for (int i = 0; i < count ; i++){
            const char* propertyName = property_getName(properties[i]);
            NSString *propertyOCName = [NSString  stringWithUTF8String: propertyName];
            if ([propertyOCName isEqualToString:@"hash"]|| [propertyOCName isEqualToString:@"superclass"]||[propertyOCName isEqualToString:@"description"] ||[propertyOCName isEqualToString:@"debugDescription"]){
                continue;
            }
            
            [propertyArray addObject: propertyOCName];
        }
        
        free(properties);
        [propertyList addObjectsFromArray:propertyArray];
        
        classCount --;
        clazz = [clazz superclass];
    }while (classCount);
    
    return propertyList;
}

@end
