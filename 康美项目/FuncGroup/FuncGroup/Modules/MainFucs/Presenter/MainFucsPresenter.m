//
//  MainFucsPresenter.m
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "MainFucsPresenter.h"
#import "AppDelegate.h"
#import "LoginOperation.h"
#import "AppCacheManager.h"
#import "NSURL+Additions.h"


@interface MainFucsPresenter()

@property (nonatomic ,strong) LoginOperation *operationLogin;

@property (nonatomic, strong) UIViewController *interface;

@end

@implementation MainFucsPresenter

- (UIViewController *)getInterface
{
    MainFucsViewController *vc = [[MainFucsViewController alloc] init];
    vc.presenter = self;
    self.interface = vc;
    
    return vc;
}

-(LoginOperation *)operationLogin{
    if (!_operationLogin) {
        _operationLogin = [[LoginOperation alloc] init];
        _operationLogin.loginOutHandler = self;
    }
    return  _operationLogin;
}

#pragma privateMethod
-(void)endLoginOut:(NSDictionary *)data{
    
    BOOL result = [[data objectForKey:@"success"] boolValue];
    if (result) {
        //结束登出操作，做相应的交互处理: 等待框 跳页面等
        [SVProgressHUD dismiss];
        // 切换根视图
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.launchRouter installRootViewControllerIntoWindow:appDelegate.window];
    }else{
        
    }
}

-(void)gokHealthTestHtmlView{  // [URLs getBaseWebUrlString]
    NSString *urlString = [NSString stringWithFormat:@"%@/tcq/?key=%@",[URLs getFullAPIPortType:API_PORT_TYPE_HEALTH_TEST],member.currentUserArchives.physiqueTestKey];
    [self.interface pushToVC:@"HtmlViewController" params:@{@"title":@"中医体质问卷",kUrl:urlString}];
}

#pragma mark === PresenterOutput
-(void)performFunctionWith:(id)params{
    int index = [params intValue];
    
    ArchivesModel *model = member.currentUserArchives;
    
    if ([[[AppCacheManager sharedAppCacheManager] cacheForKey:kDemonstrate] boolValue] && index == 0) {
        // 开启了演示功能
    }else if ((index != 2 && index != 3) && model == nil) {
        [SVProgressHUD showInfoWithStatus:@"请选择档案"];
        return;
    }
    
    if (index == 4) {
        // 体质分类的html页面
        // 先判断是否有注册，没有注册就注册，注册了直接传key来调用
        if (model.physiqueTestKey && model.physiqueTestKey.length > 8) {
            [self gokHealthTestHtmlView];
        }else {
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[URLs getFullAPIPortType:API_PORT_TYPE_HEALTH_TEST],@"/tcq/personInfo"] paramArray:@[model.Name?:@"name",model.IdCard?:@"id123",model.Tel,[model.Sex intValue]==1?@"0":@"1"]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLSessionDataTask *dataTask = [[AFNetworkManager sharedAFNetworkManager] dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                
                if (error) {
                    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                }else {
                    NSString *content = [(NSDictionary *)responseObject objectForKey:kContent];
                    NSString *key = (NSString *) [[[[content componentsSeparatedByString:@"key="] objectAtIndex:1] componentsSeparatedByString:@" ,"] objectAtIndex:0];
                    // 保存key
                    [MemberManager sharedInstance].currentUserArchives.physiqueTestKey = key;
                    [[MemberManager sharedInstance].archives_DBController updateRecord:[MemberManager sharedInstance].currentUserArchives];
                    // 跳转html
                    [self gokHealthTestHtmlView];
                }
            }];
            
            [dataTask resume];
        }
    }
    
    NSArray *funcCtlArr = @[@"HealthExaminationVC",@"",@"ArchivesManagementVC",@"SettingPresenter",@"",@"HealthRecordPresenter"];
    
    if (member.bindingDevices.count == 0 && index == 0) {
        [SVProgressHUD showInfoWithStatus:@"请在设置中绑定蓝牙设备"];
        return;
    }
    
    [self.interface pushToVC:funcCtlArr[index]];
}

-(id)performGetDataFunctionWith:(id)params{

    // 调用数据 并返回
    ArchivesModel *model = member.currentUserArchives;
    NSString *cardID =model.IdCard ?: @"";
    NSString *currentName = model.Name ?: @"未选择档案";
    NSData *avatarImgData = model.Photo?:[NSData data];
    return @{KIdCard:cardID,KCurrentName:currentName,KUserAvatar:avatarImgData};
}

#pragma mark === LoginOtVCPProtocol
-(void)beginLoginOut{
    // 开始登出操作，做相应的交互处理: 等待框等
    [self.operationLogin loginOutOperate];
}

#pragma mark === LoginOutOperProtocol
-(void)loginOutStateReacte:(NSString *)state{
    
}

-(void)loginOutSuccessed:(NSDictionary *)dataDic{
    [self endLoginOut:dataDic];
}

-(void)loginOutFailed:(NSDictionary *)dataDic{
    [self endLoginOut:dataDic];
}



@end
