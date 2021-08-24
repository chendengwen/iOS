//
//  MemberManager.h
//  FuncGroup
//
//  Created by zhong on 2017/3/3.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArchivesModel.h"
#import "DeviceModel.h"
#import "Archives_DBController.h"

@class DBUserArchivesController;

@interface MemberManager : NSObject
{
    DBUserArchivesController *_dbController;
}
//当前用户档案
@property (nonatomic,strong) ArchivesModel *currentUserArchives;
//绑定的蓝牙设备列表
@property (nonatomic,strong) NSArray<DeviceModel *> *bindingDevices;

@property (nonatomic,strong) Archives_DBController *archives_DBController;

@property (nonatomic,strong) NSMutableArray<ArchivesModel *> *ArchivesArray;

//@property (nonatomic,strong) NSString *Birthday;

+ (instancetype)sharedInstance;

@end
