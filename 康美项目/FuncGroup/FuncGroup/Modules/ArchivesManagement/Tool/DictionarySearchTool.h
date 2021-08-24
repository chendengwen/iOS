//
//  DictionarySearchTool.h
//  FuncGroup
//
//  Created by zhong on 2017/2/27.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellModel.h"

@interface DictionarySearchTool : NSObject

+ (instancetype)sharedInstance;

- (NSArray *)getArrayForKey:(NSString *)key;

- (NSInteger)searchIndexForKey:(NSString *)key andValue:(NSString *)value;

- (NSString *)searchDictionary:(NSString *)title andKey:(NSString *)key;

- (NSString *)searchDictionary:(CellModel *)model;

- (NSString *)searchKeyWithTitle:(NSString *)title andValue:(NSString *)value;

@end
