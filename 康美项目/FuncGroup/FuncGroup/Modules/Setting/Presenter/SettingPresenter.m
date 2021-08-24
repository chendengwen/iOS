//
//  SettingPresenter.m
//  FuncGroup
//
//  Created by gary on 2017/2/9.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "SettingPresenter.h"

#import "SettingInteractor.h"
#import "SettingViewController.h"
#import "UUID.h"
#import "UIImage+Additions.h"

@interface SettingPresenter()
{
    SettingInteractor *_interactor;
}

@end

@implementation SettingPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _interactor = [[SettingInteractor alloc] init];
    }
    return self;
}

-(UIViewController *)getInterface{
    SettingViewController *ctl = [[SettingViewController alloc] init];
    self.interface = ctl;
    ctl.presenter = self;
    return ctl;
}

#pragma mark === UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _interactor.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"settingCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
    cell.textLabel.text = [(SettingCellModel *)_interactor.dataArray[indexPath.row] title];
    cell.imageView.image = [[UIImage imageNamed:[(SettingCellModel *)_interactor.dataArray[indexPath.row] imgName]] rescaleImageToSize:CGSizeMake(40, 40)];
    
    return cell;
}

#pragma maek === UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        NSString *uuid = [UUID readUUIDFromKeyChain];
        if (uuid && uuid.length > 18) {
            NSString *uuid12 = [uuid substringWithRange:NSMakeRange(uuid.length-18, 18)];
            uuid = uuid12;
        }
        
        NSString *urlString = [NSString stringWithFormat:@"%@/home/ytjmanage?machinNo=%@#",[URLs getFullAPIPortType:API_PORT_TYPE_WEB],[[UUID currentDeviceUUID]substringWithRange:NSMakeRange(24,12)]];
        [self.interface pushToVC:[(SettingCellModel *)_interactor.dataArray[indexPath.row] vcClassName] params:@{@"title":@"统计数据",kUrl:urlString}];
    } else if (indexPath.row == 5) {
        [self.interface pushToVC:[(SettingCellModel *)_interactor.dataArray[indexPath.row] vcClassName] params:@{@"title":@"关于",kFileName:@"about_ch"}];
    }else {
        [self.interface pushToVC:[(SettingCellModel *)_interactor.dataArray[indexPath.row] vcClassName]];
    }
    
}

@end
