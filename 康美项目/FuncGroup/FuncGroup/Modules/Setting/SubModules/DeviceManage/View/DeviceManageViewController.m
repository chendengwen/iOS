//
//  DeviceManageViewController.m
//  FuncGroup
//
//  Created by gary on 2017/2/10.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "DeviceManageViewController.h"
#import "CustomNavigationBarView.h"
#import "DeviceItemView.h"
#import "DeviceModel.h"

@interface DeviceManageViewController ()
{
    NSMutableArray<DeviceItemView *> *_viewsArray;
    DeviceItemView *_sel_deviceView;
}

@end

@implementation DeviceManageViewController

- (void)dealloc
{
    [_viewsArray removeAllObjects];
    _viewsArray = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CustomNavigationBarView *navView = [self layoutNaviBarViewWithTitle:@"蓝牙设备管理"];

    [navView addSubview:[self searchButton]];
    
    _viewsArray = [NSMutableArray array];
    [self.presenter getDevicesOperation];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.presenter saveDevices];
}

-(UIButton *)searchButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH - 100.f,26.0,80.f, 28.0f);
    [button setTitle:@"设备扫描" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.cornerRadius = 4.0;
    SEL selector = NSSelectorFromString(@"searchDevice:");
    [button addTarget:self.presenter action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)reloadData:(NSArray<DeviceModel *> *)dataArray{
    [_viewsArray removeAllObjects];
    for (int i = 0; i < dataArray.count; i ++) {
        DeviceModel *model = [dataArray objectAtIndex:i];
        float leftPadding = 70.0, topPadding = 50.0, itemXSpace = (SCREEN_WIDTH - leftPadding*2 - Width_DeviceItemView*3)/2, itemYSpace = 30.0;
        float orign_X = leftPadding + (Width_DeviceItemView + itemXSpace)* (i%3);
        float orign_Y = NavHeight + topPadding + (Height_DeviceItemView + itemYSpace)* (i/3);
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"DeviceItemView" owner:self options:nil];
        DeviceItemView *deviceView = (DeviceItemView *)[arr lastObject];
        
        [_viewsArray addObject:deviceView];
        [self.view addSubview:deviceView];
        
        deviceView.frame = CGRectMake(orign_X, orign_Y, Width_DeviceItemView, Height_DeviceItemView);
        deviceView.imageName = model.deviceIcon;
        deviceView.deviceName = model.deviceName;
        deviceView.MAC = model.MAC;
        deviceView.time = model.time;
        deviceView.locked = model.locked;
        deviceView.index = i;
        
        deviceView.block = ^(int index){
            // 点击了
            _sel_deviceView = deviceView;
            
            [self.presenter lockDeviceAtIndex:i];
            //取消其他相同设备的绑定
            if (_viewsArray[i].locked) {
                for (int i = 0; i < _viewsArray.count; i++) {
                    
                    if ([_sel_deviceView.deviceName isEqualToString:_viewsArray[i].deviceName] && i != index) {
                        _viewsArray[i].locked = NO;
                        dataArray[i].locked = NO;
                    }
                }
            }
        };
        
    }
}

#pragma mark === DeviceManageView的绑定／解绑按钮触发
-(void)deviceLockButtonClick:(UIButton *)button{
    [self.presenter lockDeviceAtIndex:(int)button.tag - 2101];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"locked"])
    {
        _sel_deviceView.locked = [[change valueForKey:@"new"] boolValue];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
