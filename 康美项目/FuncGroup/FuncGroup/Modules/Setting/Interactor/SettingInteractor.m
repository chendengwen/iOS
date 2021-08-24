//
//  SettingInteractor.m
//  FuncGroup
//
//  Created by gary on 2017/2/9.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "SettingInteractor.h"

@implementation SettingInteractor

-(NSArray *)dataArray{
    if (!_dataArray) {
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:10];
        
        // @"账户信息管理",   ,@"检查更新"
        NSArray *titleArr = @[@"蓝牙设备管理",@"统计数据",@"通用设置",@"备份与还原",@"意见反馈",@"关于",@"帮助"];
        // @"setting_account_info_icon",   ,@"setting_upgrade_icon"
        NSArray *imgNameArr = @[@"setting_ble_device_manager_icon",@"setting_data_statistics_icon",@"setting_comm_icon",@"setting_data_collection_icon",@"setting_feedback_icon",@"setting_about_icon",@"setting_help_icon"];
        // @"AccountSetPresenter",
        NSArray *classNameArr = @[@"DeviceManagerPresenter",@"HtmlViewController",@"GeneralSettingViewController",@"Backup_RestoreViewController",@"FeedBackViewController",@"HtmlViewController",@"HelpViewController"];
        for (int i = 0; i < titleArr.count; i ++) {
            SettingCellModel *model = [[SettingCellModel alloc] init];
            model.title = titleArr[i];
            model.imgName = imgNameArr[i];
            model.vcClassName = classNameArr[i];
            [arr addObject:model];
        }
        
        _dataArray = arr;
    }
    
    return _dataArray;
}

@end
