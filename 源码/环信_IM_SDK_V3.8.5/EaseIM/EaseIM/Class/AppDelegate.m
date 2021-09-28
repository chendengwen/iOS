/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <UserNotifications/UserNotifications.h>
#import "AppDelegate.h"

#import "EaseIMHelper.h"
#import "SingleCallController.h"
#import "ConferenceController.h"
#import "EMGlobalVariables.h"
#import "EMDemoOptions.h"
#import "EMNotificationHelper.h"
#import "EMHomeViewController.h"
#import "EMLoginViewController.h"
#import "UserInfoStore.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <Bugly/Bugly.h>

#define FIRSTLAUNCH @"firstLaunch"

@interface AppDelegate () <UNUserNotificationCenterDelegate,EaseCallDelegate>

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _connectionState = EMConnectionConnected;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self _initDemo];
    [self _initHyphenate];
    BuglyConfig * config = [[BuglyConfig alloc] init];
    // 设置自定义日志上报的级别，默认不上报自定义日志
    config.reportLogLevel = BuglyLogLevelWarn;
    config.version = [EMClient sharedClient].version;
    config.deviceIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    config.unexpectedTerminatingDetectionEnable = true;
    [Bugly startWithAppId:@"3e7704ec60" config:config];
    NSLog(@"imkit version : %@",EaseIMKitManager.shared.version);
    NSLog(@"sdk   version : %@",EMClient.sharedClient.version);
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    EMAlertView *alertView = [[EMAlertView alloc]initWithTitle:@"注册device token失败" message:error.description];
    [alertView show];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    if (gMainController) {
//        [gMainController jumpToChatList];
//    }
    [[EMClient sharedClient] application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
//    if (gMainController) {
//        [gMainController didReceiveLocalNotification:notification];
//    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    [[EMClient sharedClient] application:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
//    if (gMainController) {
//        [gMainController didReceiveUserNotification:response.notification];
//    }
    completionHandler();
}

#pragma mark - EMPushManagerDelegateDevice

// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    EMAlertView *alertView = [[EMAlertView alloc]initWithTitle:@"推送内容" message:str];
    [alertView show];
}

#pragma mark - Hyphenate

- (void)_initHyphenate
{
    EMDemoOptions *demoOptions = [EMDemoOptions sharedOptions];
    [EaseIMKitManager initWithEMOptions:[demoOptions toOptions]];
    gIsInitializedSDK = YES;
    if (demoOptions.isAutoLogin){
        [[NSNotificationCenter defaultCenter] postNotificationName:ACCOUNT_LOGIN_CHANGED object:@(YES)];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:ACCOUNT_LOGIN_CHANGED object:@(NO)];
    }
}

#pragma mark - Demo

- (void)_initDemo
{
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:ACCOUNT_LOGIN_CHANGED object:nil];
    
    //注册推送
    [self _registerRemoteNotification];
    
    //初始化EaseIMHelper，注册 EMClient 监听
    [EaseIMHelper shareHelper];
}

//注册远程通知
- (void)_registerRemoteNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
#if !TARGET_IPHONE_SIMULATOR
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications];
                });
#endif
            }
        }];
        return;
    }
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

- (void)loginStateChange:(NSNotification *)aNotif
{
    UINavigationController *navigationController = nil;
    
    BOOL loginSuccess = [aNotif.object boolValue];
    if (loginSuccess) {//登录成功加载主窗口控制器
        navigationController = (UINavigationController *)self.window.rootViewController;
        if (!navigationController || (navigationController && ![navigationController.viewControllers[0] isKindOfClass:[EMHomeViewController class]])) {
            EMHomeViewController *homeController = [[EMHomeViewController alloc] init];
            navigationController = [[UINavigationController alloc] initWithRootViewController:homeController];
        }
        
        [[EMClient sharedClient].pushManager getPushNotificationOptionsFromServerWithCompletion:^(EMPushOptions * _Nonnull aOptions, EMError * _Nonnull aError) {
        }];
        [[EMClient sharedClient].groupManager getJoinedGroupsFromServerWithPage:0 pageSize:-1 completion:^(NSArray *aList, EMError *aError) {
            if (!aError) {
                [[NSNotificationCenter defaultCenter] postNotificationName:GROUP_LIST_FETCHFINISHED object:nil];
            }
        }];
        [EMNotificationHelper shared];
        [SingleCallController sharedManager];
        [ConferenceController sharedManager];
        [[UserInfoStore sharedInstance] loadInfosFromLocal];
        EaseCallConfig* config = [[EaseCallConfig alloc] init];
        config.agoraAppId = @"15cb0d28b87b425ea613fc46f7c9f974";
        config.enableRTCTokenValidate = YES;

        [[EaseCallManager sharedManager] initWithConfig:config delegate:self];
//        NSString* path = [[NSBundle mainBundle] pathForResource:@"huahai128" ofType:@"mp3"];
//        config.ringFileUrl = [NSURL fileURLWithPath:path];
    } else {//登录失败加载登录页面控制器
        EMLoginViewController *controller = [[EMLoginViewController alloc] init];
        navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    }
    
//    navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_white"] forBarMetrics:UIBarMetricsDefault];
    [navigationController.navigationBar.layer setMasksToBounds:YES];
    navigationController.view.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = navigationController;
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, nil]];
    [[UITableViewHeaderFooterView appearance] setTintColor:kColor_LightGray];
    
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        statusBar.backgroundColor = [UIColor whiteColor];
//    }
}

- (void)callDidEnd:(NSString*)aChannelName reason:(EaseCallEndReason)aReason time:(int)aTm type:(EaseCallType)aCallType
{
    NSString* msg = @"";
    switch (aReason) {
        case EaseCallEndReasonHandleOnOtherDevice:
            msg = @"已在其他端处理";
            break;
        case EaseCallEndReasonBusy:
            msg = @"对方忙";
            break;
        case EaseCallEndReasonRefuse:
            msg = @"拒绝通话";
            break;
        case EaseCallEndReasonCancel:
            msg = @"您已取消呼叫";
            break;
        case EaseCallEndReasonRemoteCancel:
            msg = @"通话已取消";
            break;
        case EaseCallEndReasonRemoteNoResponse:
            msg = @"对方超时未响应";
            break;
        case EaseCallEndReasonNoResponse:
            msg = @"未接听";
            break;
        case EaseCallEndReasonHangup:
            msg = [NSString stringWithFormat:@"通话已结束，通话时长：%d秒",aTm];
            break;
        default:
            break;
    }
    if([msg length] > 0)
       [self showHint:msg];
}
// 多人音视频邀请按钮的回调
- (void)multiCallDidInvitingWithCurVC:(UIViewController*_Nonnull)vc excludeUsers:(NSArray<NSString*> *_Nullable)users ext:(NSDictionary *)aExt
{
    NSString* groupId = nil;
    if(aExt) {
        groupId = [aExt objectForKey:@"groupId"];
    }
    
    ConfInviteUsersViewController * confVC = nil;
    if([groupId length] == 0) {
        confVC = [[ConfInviteUsersViewController alloc] initWithType:ConfInviteTypeUser isCreate:NO excludeUsers:users groupOrChatroomId:nil];
    }else{
        confVC = [[ConfInviteUsersViewController alloc] initWithType:ConfInviteTypeGroup isCreate:NO excludeUsers:users groupOrChatroomId:groupId];
    }
    
    [confVC setDoneCompletion:^(NSArray *aInviteUsers) {
        for (NSString* strId in aInviteUsers) {
            EMUserInfo* info = [[UserInfoStore sharedInstance] getUserInfoById:strId];
            if(info && (info.avatarUrl.length > 0 || info.nickName > 0)) {
                EaseCallUser* user = [EaseCallUser userWithNickName:info.nickName image:[NSURL URLWithString:info.avatarUrl]];
                [[[EaseCallManager sharedManager] getEaseCallConfig] setUser:strId info:user];
            }
        }
        [[EaseCallManager sharedManager] startInviteUsers:aInviteUsers ext:aExt completion:nil];
    }];
    confVC.modalPresentationStyle = UIModalPresentationPopover;
    [vc presentViewController:confVC animated:NO completion:nil];
}
// 振铃时增加回调
- (void)callDidReceive:(EaseCallType)aType inviter:(NSString*_Nonnull)username ext:(NSDictionary*)aExt
{
    EMUserInfo* info = [[UserInfoStore sharedInstance] getUserInfoById:username];
    if(info && (info.avatarUrl.length > 0 || info.nickName > 0)) {
        EaseCallUser* user = [EaseCallUser userWithNickName:info.nickName image:[NSURL URLWithString:info.avatarUrl]];
        [[[EaseCallManager sharedManager] getEaseCallConfig] setUser:username info:user];
    }
}

// 异常回调
- (void)callDidOccurError:(EaseCallError *)aError
{
    
}

- (void)callDidRequestRTCTokenForAppId:(NSString *)aAppId channelName:(NSString *)aChannelName account:(NSString *)aUserAccount uid:(NSInteger)aAgoraUid
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];

    NSString* strUrl = [NSString stringWithFormat:@"http://a1.easemob.com/token/rtcToken/v1?userAccount=%@&channelName=%@&appkey=%@",[EMClient sharedClient].currentUsername,aChannelName,[EMClient sharedClient].options.appkey];
    NSString*utf8Url = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL* url = [NSURL URLWithString:utf8Url];
    NSMutableURLRequest* urlReq = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlReq setValue:[NSString stringWithFormat:@"Bearer %@",[EMClient sharedClient].accessUserToken ] forHTTPHeaderField:@"Authorization"];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlReq completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data) {
            NSDictionary* body = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"%@",body);
            if(body) {
                NSString* resCode = [body objectForKey:@"code"];
                if([resCode isEqualToString:@"RES_0K"]) {
                    NSString* rtcToken = [body objectForKey:@"accessToken"];
                    NSNumber* uid = [body objectForKey:@"agoraUserId"];
                    [[EaseCallManager sharedManager] setRTCToken:rtcToken channelName:aChannelName uid:[uid unsignedIntegerValue]];
                }
            }
        }
        
        
    }];

    [task resume];
}

-(void)remoteUserDidJoinChannel:( NSString*_Nonnull)aChannelName uid:(NSInteger)aUid username:(NSString*_Nullable)aUserName
{
    if(aUserName.length > 0) {
        EMUserInfo* userInfo = [[UserInfoStore sharedInstance] getUserInfoById:aUserName];
        if(userInfo && (userInfo.avatarUrl.length > 0 || userInfo.nickName.length > 0)) {
            EaseCallUser* user = [EaseCallUser userWithNickName:userInfo.nickName image:[NSURL URLWithString:userInfo.avatarUrl]];
            [[[EaseCallManager sharedManager] getEaseCallConfig] setUser:aUserName info:user];
        }
    }else{
        [self _fetchUserMapsFromServer:aChannelName];
    }
}

- (void)callDidJoinChannel:(NSString*_Nonnull)aChannelName uid:(NSUInteger)aUid
{
    [self _fetchUserMapsFromServer:aChannelName];
}

- (void)_fetchUserMapsFromServer:(NSString*)aChannelName
{
    // 这里设置映射表，设置头像，昵称
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];

    NSString* strUrl = [NSString stringWithFormat:@"http://a1.easemob.com/channel/mapper?userAccount=%@&channelName=%@&appkey=%@",[EMClient sharedClient].currentUsername,aChannelName,[EMClient sharedClient].options.appkey];
    NSString*utf8Url = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL* url = [NSURL URLWithString:utf8Url];
    NSMutableURLRequest* urlReq = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlReq setValue:[NSString stringWithFormat:@"Bearer %@",[EMClient sharedClient].accessUserToken ] forHTTPHeaderField:@"Authorization"];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlReq completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data) {
            NSDictionary* body = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"mapperBody:%@",body);
            if(body) {
                NSString* resCode = [body objectForKey:@"code"];
                if([resCode isEqualToString:@"RES_0K"]) {
                    NSString* channelName = [body objectForKey:@"channelName"];
                    NSDictionary* result = [body objectForKey:@"result"];
                    NSMutableDictionary<NSNumber*,NSString*>* users = [NSMutableDictionary dictionary];
                    for (NSString* strId in result) {
                        NSString* username = [result objectForKey:strId];
                        NSNumber* uId = [NSNumber numberWithInteger:[strId integerValue]];
                        [users setObject:username forKey:uId];
                        EMUserInfo* info = [[UserInfoStore sharedInstance] getUserInfoById:username];
                        if(info && (info.avatarUrl.length > 0 || info.nickName > 0)) {
                            EaseCallUser* user = [EaseCallUser userWithNickName:info.nickName image:[NSURL URLWithString:info.avatarUrl]];
                            [[[EaseCallManager sharedManager] getEaseCallConfig] setUser:username info:user];
                        }
                    }
                    [[EaseCallManager sharedManager] setUsers:users channelName:channelName];
                }
            }
        }
    }];

    [task resume];
}


- (void)showHint:(NSString *)hint
{
    UIWindow *win = [[[UIApplication sharedApplication] windows] firstObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:win animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 10.f;
    CGPoint offset = hud.offset;
    offset.y = 180;
    hud.offset = offset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

@end
