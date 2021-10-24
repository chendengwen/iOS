//
//  ViewController.m
//  Socket_Test
//
//  Created by 陈登文 on 2021/10/23.
//

#import "ViewController.h"
#import "TcpSocketManager.h"
#import "TcpSubscriber.h"

#define kBaiduIP @"163.177.151.110"
#define kGoogleIP @"142.250.191.110"
#define kTcpPort  80

@interface ViewController ()
{
    TcpSocketConnection *_connection;
    long _messageTag;
}
@property (weak, nonatomic) IBOutlet UITextField *sendContentField;
@property (weak, nonatomic) IBOutlet UITextView *logContentView;

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.sendContentField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _connection = [TcpSocketConnection connectionWithIP:kGoogleIP port:kTcpPort];
    _messageTag = 1;
}

- (IBAction)connectAction:(id)sender {
    //连接，连接只会有一个
    [[TcpSocketManager sharedInstance] start:_connection];
    //订阅，订阅可以订阅多次
    __weak typeof(self) weakSelf = self;
    [self subscribe:_connection callback:^(TcpSocketMessage *message) {
        NSLog(@"message %@",message.description);
        NSString *string = [NSString stringWithFormat:@"%@ \n %@",weakSelf.logContentView.text, message.description];
        weakSelf.logContentView.text = string;
    }];
}

- (IBAction)disconnectActiion:(id)sender {
    [[TcpSocketManager sharedInstance] disconnect:_connection];
}

- (IBAction)sendAction:(id)sender {
    NSData *data = [_sendContentField.text dataUsingEncoding:NSUTF8StringEncoding];
    [[TcpSocketManager sharedInstance] writeToConnection:_connection withData:data withTag:_messageTag];
    _messageTag ++;
}

- (IBAction)cleanLog:(id)sender {
    _logContentView.text = @"";
}



@end
