//
//  SettingCellModel.h
//  FuncGroup
//
//  Created by gary on 2017/2/9.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "BaseModel.h"

@interface SettingCellModel : BaseModel

/*
 * 标题
 */
@property (nonatomic,copy) NSString *title;
/*
 * 图片名
 */
@property (nonatomic,copy) NSString *imgName;
/*
 * 跳转页面的类名
 */
@property (nonatomic,copy) NSString *vcClassName;

@end
