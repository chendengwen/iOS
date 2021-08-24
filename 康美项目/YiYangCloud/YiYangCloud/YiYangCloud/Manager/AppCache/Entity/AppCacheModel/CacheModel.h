//
//  CacheModel.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "BaseModel.h"
#import "BaseCodingModel.h"

extern NSString *const K_appStatus;

@interface CacheModel : BaseCodingModel

/*
 * 状态（0首次启动 1未登录 2已登录）
 */
@property (assign) NSNumber *appStatus;


#pragma mark === 用户
/*
 * 上次登录的用户账号
 */
@property (copy) NSString *lastAccount;
@property (copy) NSString *lastPsd;

/*
 * 当前用户cardID
 */
@property (assign) NSString *currentID;

/*
 * 当前用户姓名
 */
@property (assign) NSString *currentName;


#pragma mark === 后端服务器功能

/*
 * 演示功能（0关 1开）
 */
@property (assign) NSNumber *demonstrate;

/*
 * 后端服务器功能（0开 1关）
 */
@property (assign) NSNumber *siteOff;
/*
 * 数据上传接口
 */
@property (assign) NSString *interface;

/*
 * 档案显示页地址
 */
@property (copy) NSString *recordUrl;

/*
 * 保存用户密码（0关 1开）
 */
@property (assign) NSNumber *psdOff;

/*
 * 体质检测与判定html页面用到的key
 */
@property (nonatomic,copy) NSString *healthTestKey;


@end
