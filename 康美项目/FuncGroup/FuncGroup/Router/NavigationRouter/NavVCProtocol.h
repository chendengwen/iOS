//
//  NavVCProtocol.h
//  FuncGroup
//
//  Created by gary on 2017/2/6.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * navigationController 下级页面向上级页面的回调  
 * 上级页面实现协议  下级页面通过previousVC属性来调用协议方法
 */
@protocol NavVCProtocol <NSObject>

@optional
-(void)functionFinishedWith:(id)callbackParams;



@end
