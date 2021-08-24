//
//  HealthChartViewController.m
//  FuncGroup
//
//  Created by gary on 2017/2/20.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "HealthChartViewController.h"
#import "HealthRecordChart.h"

@interface HealthChartViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation HealthChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self layoutChartViews];
}

-(void)layoutChartViews{
    float orignX = 60.0, originY = 40.0, space = 30.0, width = (SCREEN_WIDTH - orignX*2 - space)/2, height = 300.0;
    
    HealthRecordChart *chart_1 = [[HealthRecordChart alloc] initWithFrame:CGRectMake(orignX, originY, width, height) type:HealthRecordXueYa];
    [self.scrollView addSubview:chart_1];
    
    HealthRecordChart *chart_2 = [[HealthRecordChart alloc] initWithFrame:CGRectMake(CGRectGetMaxX(chart_1.frame) + space, originY, width, height) type:HealthRecordXueTang];
    [self.scrollView addSubview:chart_2];
    
    HealthRecordChart *chart_3 = [[HealthRecordChart alloc] initWithFrame:CGRectMake(orignX, CGRectGetMaxY(chart_1.frame) + space, width, height) type:HealthRecordTiWen];
    [self.scrollView addSubview:chart_3];
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
