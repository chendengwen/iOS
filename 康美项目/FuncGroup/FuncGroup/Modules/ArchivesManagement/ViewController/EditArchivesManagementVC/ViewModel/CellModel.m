//
//  cellModel.m
//  FuncGroup
//
//  Created by zhong on 2017/2/23.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "CellModel.h"

@implementation CellModel

- (instancetype)initWithTitle:(NSString *)title CellState:(CellState)state Must:(BOOL)isMust CurrentValue:(NSString *)currentValue Placeholder:(NSString *)placeholder Index:(NSInteger)index OptionIndex:(NSInteger)optionIndex {
    self = [super init];
    if (self) {
        self.title = title;
        self.state = state;
        self.isMust = isMust;
        self.currentValue = currentValue;
        self.placeholder = placeholder;
        self.index = index;
        self.optionIndex = optionIndex;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title CellState:(CellState)state CurrentValue:(NSString *)currentValue Placeholder:(NSString *)placeholder Index:(NSInteger)index HitDate:(NSString *)hitDate isOn:(BOOL)isOn OptionIndex:(NSInteger)optionIndex{
    self = [super init];
    if (self) {
        self.title = title;
        self.state = state;
        self.currentValue = currentValue;
        self.placeholder = placeholder;
        self.index = index;
        self.hitDate = hitDate;
        self.isOn = isOn;
        self.optionIndex = optionIndex;
    }
    return self;
}

@end
