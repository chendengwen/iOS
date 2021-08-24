//
//  TestCodingModel.h
//  FuncGroup
//
//  Created by gary on 2017/3/3.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "BaseCodingModel.h"

@interface TestCodingModel : BaseCodingModel

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *sex;

-(NSString *)testSomeFunction:(NSString *)testParam;

@end
