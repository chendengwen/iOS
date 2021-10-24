//
//  ViewController.m
//  net_diagnosis_test
//
//  Created by 陈登文 on 2021/10/20.
//

#import "ViewController.h"
#import <PhoneNetSDK/PhoneNetSDK.h>
#import <Foundation/Foundation.h>
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *domaimField;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *ss;
    
}

- (IBAction)startPing:(id)sender {
    [[PhoneNetManager shareInstance] netStartPing:@"www.baidu.com" packetCount:1 pingResultHandler:^(NSString * _Nullable pingres) {
        NSLog(@"pingres === %@",pingres);
      }];
}

- (IBAction)startTraceroute:(id)sender {
    [[PhoneNetManager shareInstance] netStartTraceroute:@"www.baidu.com" tracerouteResultHandler:^(NSString * _Nullable tracertRes, NSString * _Nullable destIp) {
        NSLog(@"tracertRes === %@ , destIp === %@",tracertRes,destIp);
      }];
}


@end
