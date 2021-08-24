//
//  DeviceManagerPresenter.m
//  FuncGroup
//
//  Created by gary on 2017/2/13.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "DeviceManagerPresenter.h"
#import "DeviceInteractor.h"
#import "DeviceManageViewController.h"
#import "DeviceItemView.h"
@interface DeviceManagerPresenter()

@property (nonatomic,strong) DeviceInteractor *interactor;
//@property (nonatomic, strong) DeviceManageViewController *interface;

@end

@implementation DeviceManagerPresenter

-(UIViewController *)getInterface{
    
    return [self deviceManagerViewController];
}

- (DeviceManageViewController *)deviceManagerViewController{
    DeviceManageViewController *vc = [[DeviceManageViewController alloc] init];
    vc.presenter = self;
    self.interface = vc;
    
    return vc;
}

-(DeviceInteractor *)interactor{
    if (!_interactor) {
        _interactor = [[DeviceInteractor alloc] init];
        _interactor.handler = self;
    }
    return _interactor;
}


#pragma mark === getDevicesOperation
-(void)saveDevices{
    [self.interactor saveDevices];
}

-(void)getDevicesOperation{
    
    [self.interactor.dataArray removeAllObjects];

    [self.interactor getLocalDevices];
}

#pragma mark === DeviceManageVCPProtocol  视图的点击事件
-(void)searchDevice:(UIButton *)sender{
    
    [sender setTitleColor:[UIColor colorWithRed:0.69 green:0.96 blue:0.40 alpha:1.00] forState:UIControlStateNormal];
    sender.layer.borderColor = [UIColor colorWithRed:0.69 green:0.96 blue:0.40 alpha:1.00].CGColor;
    // 弹框提示搜索
    [SVProgressHUD showWithStatus:@"扫描中,请打开蓝牙设备!"];

    // 交互器开始搜索
    [self.interactor searchDevices:sender];
    
}

-(void)cancelLockDevice:(NSArray *)array Name:(NSString *)deviceName{

    for (int i = 0; i < self.interactor.dataArray.count; i++) {
        DeviceModel *model = self.interactor.dataArray[i];
        DeviceItemView *view = array[i];
        if ([model.deviceName isEqualToString:deviceName]&&model.locked) {
            view.locked = NO;
            model.locked = NO;
        }
    }
}

-(void)lockDeviceAtIndex:(int)index{
    DeviceModel *model = self.interactor.dataArray[index];
    if (model.locked) {
        // 解锁
        // 先弹框确认
        SIEditAlertView *alertView = [[SIEditAlertView alloc] initWithTitle:@"解绑" andMessage:@"确认解除设备绑定?"];
        
        [alertView addButtonWithTitle:@"取消"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIEditAlertView *alertView) {
                                  // 修改model数据
                                  model.locked = YES;
                              }];
        [alertView addButtonWithTitle:@"确定"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIEditAlertView *alertView) {
                                  // 修改model数据
                                  model.locked = NO;
                              }];
        
        alertView.didShowHandler = ^(SIEditAlertView *alertView) {
            
        };
        
        alertView.showFieldEditView = YES;
        alertView.cornerRadius = 5;
        alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
        alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
//        alertView.titleFont = [UIFont systemFontOfSize:14];
        
        [alertView show];
    }else {
        // 绑定
        
        // 解锁
        // 先弹框确认
        SIEditAlertView *alertView = [[SIEditAlertView alloc] initWithTitle:@"绑定" andMessage:@"确认绑定蓝牙设备?"];
        
        [alertView addButtonWithTitle:@"取消"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIEditAlertView *alertView) {
                                  // 修改model数据
                                  model.locked = NO;
                              }];
        [alertView addButtonWithTitle:@"确定"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIEditAlertView *alertView) {
                                  // 修改model数据
//                                  model.locked = NO;
                                  
                                  [self.interactor lockDeviceAtIndex:index lock:YES];
                              }];
        
        alertView.didShowHandler = ^(SIEditAlertView *alertView) {
            
        };
        
        alertView.showFieldEditView = YES;
        alertView.cornerRadius = 5;
        alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
        alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
        //        alertView.titleFont = [UIFont systemFontOfSize:14];
        
        [alertView show];

    }
    
}

#pragma mark === SearchDeviceProtocol 交互器完成数据处理
-(void)getLocalDevicesSuccessed:(NSArray *)devices{
    [(DeviceManageViewController *)self.interface reloadData:devices];
}

-(void)getLocalDevicesFailed:(NSString *)message{
    
}

-(void)searchDeviceFailed{
    [SVProgressHUD showErrorWithStatus:@"搜索失败"];
}

-(void)searchDeviceSuccessed:(NSArray *)devices{
    [SVProgressHUD dismiss];
    
    // 搜索设备成功  页面数据更新
     [(DeviceManageViewController *)self.interface reloadData:devices];
}


@end
