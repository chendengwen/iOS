//
//  LoginOutVCProtocol.h
//  FuncGroup
//
//  Created by gary on 2017/2/9.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginOutVCProtocol <NSObject>

-(void)beginLoginOut;

/*
 * @prama data:登出结束需要返回的数据（成功、失败等）
 */
-(void)endLoginOut:(NSDictionary *)data;

@optional
/*
 * 主功能页面跳转 0，1
 */
-(void)pushToFunctionVC:(int)index;

/*
 * 跳转到帮助页面
 */
-(void)pushToHelpVC;

@end
