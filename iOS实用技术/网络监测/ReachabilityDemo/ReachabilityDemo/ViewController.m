//
//  ViewController.m
//  ReachabilityDemo
//
//  Created by zxs on 2020/8/27.
//  Copyright © 2020 zxs. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"
#import <RealReachability/RealReachability.h>
#import <AFNetworking/AFNetworking.h>

// 三种检测方式的标题
static NSString * const kTitleApple = @"苹果的Reachability";
static NSString * const kTitleRealReachability = @"第三方库RealReachability";
static NSString * const kTitleAFNetworking = @"AFNetworkReachabilityManager";

@interface ViewController ()

// 域名
@property (weak, nonatomic) IBOutlet UITextField *domainTextField;

// 这个打开就采用第三方库RealReachability
@property (weak, nonatomic) IBOutlet UISwitch *isRealSwitch;

// 这个打开就采用第三方库AFNetworking中的Reachability
@property (weak, nonatomic) IBOutlet UISwitch *isAFNetworkingSwitch;

// 开始监控按钮
@property (weak, nonatomic) IBOutlet UIButton *startButton;

// 结束监控按钮
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

// 检查状态按钮
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

// Reachability对象
@property (strong, nonatomic) Reachability *appleReachability;

// AFNetworking对象
@property (strong, nonatomic) AFNetworkReachabilityManager *manage;

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self changeButtonStatus:NO];
    
    // 观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kRealReachabilityChangedNotification object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRealReachabilityChangedNotification object:nil];
}

#pragma mark - selector
/*!
 * Called by Reachability whenever status changes.
 */
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self showAppleMessage:curReach];
}

- (void)networkChanged:(NSNotification *)notification {
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    ReachabilityStatus previousStatus = [reachability previousReachabilityStatus];
    NSLog(@"networkChanged, currentStatus:%@, previousStatus:%@", @(status), @(previousStatus));
    
    [self showRealMessage:status];
}

#pragma mark - action
- (IBAction)checkButtonTouched:(id)sender {
    [self resignFirstResponder];
    
    if (self.isRealSwitch.isOn) {
        [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
            [self showRealMessage:status];
        }];
    } else if (self.isAFNetworkingSwitch.isOn) {
        [self showAFNetworkingMessage:self.manage.networkReachabilityStatus];
    } else {
        [self showAppleMessage:self.appleReachability];
    }
}

- (IBAction)startButtonTouched:(id)sender {
    NSString *hostName = [self.domainTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (self.isRealSwitch.isOn) {
        GLobalRealReachability.hostForPing = hostName;
        GLobalRealReachability.hostForCheck = hostName;
        [GLobalRealReachability startNotifier];
    } else if (self.isAFNetworkingSwitch.isOn) {
        self.manage = [AFNetworkReachabilityManager managerForDomain:hostName];
        __weak __typeof__(self) weakSelf = self;
        [self.manage setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            __strong __typeof__(self) strongSelf = weakSelf;
            [strongSelf showAFNetworkingMessage:status];
        }];
        [self.manage startMonitoring];
    } else {
        self.appleReachability = [Reachability reachabilityWithHostName:hostName];
        [self.appleReachability startNotifier];
    }
    
    [self changeButtonStatus:YES];
}

- (IBAction)stopButtonTouched:(id)sender {
    if (self.isRealSwitch.isOn) {
        [GLobalRealReachability stopNotifier];
    } else if (self.isAFNetworkingSwitch.isOn) {
        [self.manage stopMonitoring];
    } else {
        [self.appleReachability stopNotifier];
    }
    
    [self changeButtonStatus:NO];
}

#pragma mark - private
// 先监控，再检测，最后关闭
- (void)changeButtonStatus:(BOOL)isStart {
    if (isStart) {
        self.startButton.enabled = NO;
        self.startButton.backgroundColor = [UIColor grayColor];
        self.stopButton.enabled = YES;
        self.stopButton.backgroundColor = [UIColor blueColor];
        self.checkButton.enabled = YES;
        self.checkButton.backgroundColor = [UIColor blueColor];
        
        self.isAFNetworkingSwitch.enabled = NO;
        self.isRealSwitch.enabled = NO;
    } else {
        self.startButton.enabled = YES;
        self.startButton.backgroundColor = [UIColor blueColor];
        self.stopButton.enabled = NO;
        self.stopButton.backgroundColor = [UIColor grayColor];
        self.checkButton.enabled = NO;
        self.checkButton.backgroundColor = [UIColor grayColor];
        
        self.isAFNetworkingSwitch.enabled = YES;
        self.isRealSwitch.enabled = YES;
    }
}

// 弹窗信息
- (void)showMessageWithTitle:(NSString *)title andContent:(NSString *)content {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// 苹果提供的检测工具
- (void)showAppleMessage:(Reachability *)reachability {
    NSString *message = @"当前网络状态：";
    NetworkStatus status = [reachability currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            message = [message stringByAppendingString:@"无网络"];
            break;
        case ReachableViaWiFi:
            message = [message stringByAppendingString:@"WiFi"];
            break;
        case ReachableViaWWAN:
            message = [message stringByAppendingString:@"移动数据"];
            break;
        default:
            break;
    }
    if ([reachability connectionRequired]) {
        message = [message stringByAppendingString:@"; 有连接要求"];
    } else {
        message = [message stringByAppendingString:@"; 没有连接要求"];
    }
    
    [self showMessageWithTitle:kTitleApple andContent:message];
}

- (void)showRealMessage:(ReachabilityStatus)status {
    NSString *message = @"";
    switch (status) {
        case RealStatusNotReachable:
            message = [message stringByAppendingString:@"无网络"];
            break;
        case RealStatusViaWiFi:
            message = [message stringByAppendingString:@"WiFi"];
            break;
        case RealStatusViaWWAN:
        {
            WWANAccessType type = [GLobalRealReachability currentWWANtype];
            switch (type) {
                case WWANType2G:
                    message = [message stringByAppendingString:@"2G"];
                    break;
                case WWANType3G:
                    message = [message stringByAppendingString:@"3G"];
                    break;
                case WWANType4G:
                    message = [message stringByAppendingString:@"4G"];
                    break;
                case WWANTypeUnknown:
                    message = [message stringByAppendingString:@"移动网络，未知类型"];
                    break;
                default:
                    message = [message stringByAppendingString:@"移动网络，未知类型"];
                    break;
            }
            break;
        }
        case RealStatusUnknown:
            message = [message stringByAppendingString:@"未知类型"];
            break;
        default:
            message = [message stringByAppendingString:@"未知类型"];
            break;
    }
    if ([GLobalRealReachability isVPNOn]){
        message = [message stringByAppendingString:@"; VPN ON"];
    } else {
        message = [message stringByAppendingString:@"; VPN OFF"];
    }
    [self showMessageWithTitle:kTitleRealReachability andContent:message];
}

- (void)showAFNetworkingMessage:(AFNetworkReachabilityStatus)status {
    NSString *message = @"当前网络状态：";
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            message = [message stringByAppendingString:@"未知网络"];
            break;
        case AFNetworkReachabilityStatusNotReachable:
            message = [message stringByAppendingString:@"无网络"];
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            message = [message stringByAppendingString:@"wifi网络"];
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            message = [message stringByAppendingString:@"移动网络"];
            break;
        default:
            message = [message stringByAppendingString:@"未知网络"];
            break;
    }
    [self showMessageWithTitle:kTitleAFNetworking andContent:message];
}

@end
