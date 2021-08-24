//
//  cellModel.h
//  FuncGroup
//
//  Created by zhong on 2017/2/23.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, CellState) {
    CellState_sortTextField,
    CellState_Alert,
    CellState_TextField,
    CellState_Checkboxes,
    CellState_Hit_1,
    CellState_Hit_2,
    CellState_LongTextField
};

@interface CellModel : NSObject
//标题
@property (nonatomic,copy) NSString *title;
//输入类型
@property (nonatomic,assign) CellState state;
//是否必填项
@property (nonatomic,assign) BOOL isMust;
//描述
@property (nonatomic,copy) NSString *placeholder;
//当前值
@property (nonatomic,copy) NSString *currentValue;
//选项列表
@property (nonatomic,strong) NSArray *options;
//选中项下标
@property (nonatomic,assign) NSInteger optionIndex;
//cell下标
@property (nonatomic,assign) NSInteger index;
//复选框选中项
//...
//其他内容
@property (nonatomic,copy) NSString *otherStr;
//病史时间
@property (nonatomic,copy) NSString *hitDate;
//病史编辑开关
@property (nonatomic,assign) BOOL isOn;

@property (nonatomic,assign) NSUInteger subCount;


- (instancetype)initWithTitle:(NSString *)title CellState:(CellState)state Must:(BOOL)isMust CurrentValue:(NSString *)currentValue Placeholder:(NSString *)placeholder Index:(NSInteger)index OptionIndex:(NSInteger)optionIndex;

- (instancetype)initWithTitle:(NSString *)title CellState:(CellState)state CurrentValue:(NSString *)currentValue Placeholder:(NSString *)placeholder Index:(NSInteger)index HitDate:(NSString *)hitDate isOn:(BOOL)isOn OptionIndex:(NSInteger)optionIndex;

@end
