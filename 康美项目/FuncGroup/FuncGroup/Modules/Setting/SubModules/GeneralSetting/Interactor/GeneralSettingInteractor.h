//
//  DeviceInteractor.h
//  FuncGroup
//
//  Created by gary on 2017/2/13.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceModel.h"
#import "SearchDeviceProtocol.h"

@interface GeneralSettingInteractor : NSObject

@property (nonatomic,weak) UIViewController<SearchDeviceProtocol> *handler;

-(void)setdemonstrateOff:(BOOL)off;
-(BOOL)getdemonstrateOff;
-(void)setSiteOff:(BOOL)off;
-(BOOL)getSiteOff;

-(NSString *)getInterface;
-(NSString *)getRecordUrl;

/*
 * 设置
 * @brief interface 数据上传接口
 * @brief recordUrl 档案显示页地址
 */
-(void)setInterface:(NSString *)interface recordUrl:(NSString *)recordUrl;

@end
