//
//  HealthRecordViewController.m
//  FuncGroup
//
//  Created by gary on 2017/2/20.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "HealthRecordViewController.h"
#import "RecordTableView.h"
#import "RecordCell.h"
#import "DBHealthRecordController.h"

#define SelectedBgColor UIColorFromRGB(0x3294F3)

#define RecordTableView_Tag 5120

@interface HealthRecordViewController ()<RecordTableViewDelegate,RecordTableViewDataSource>{
    RecordTableView *_tableView_1;
    RecordTableView *_tableView_2;
    RecordTableView *_tableView_3;
    RecordTableView *_tableView_4;
    
    RecordTableView *_currentTableView;
    
    int _handleButtonSelectedIndex;         // 正在处理的项目的索引
    UIButton *_seletedButton;
}

@property (weak, nonatomic) IBOutlet UIButton *button_1;
@property (weak, nonatomic) IBOutlet UIButton *button_2;
@property (weak, nonatomic) IBOutlet UIButton *button_3;
@property (weak, nonatomic) IBOutlet UIButton *button_4;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation HealthRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _button_1.selected = YES;
    _seletedButton = _button_1;
    [_button_1 setBackgroundColor:SelectedBgColor];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*4, 0);
    _scrollView.frame = CGRectMake(self.scrollView.bounds.origin.x, self.scrollView.bounds.origin.y, self.scrollView.bounds.size.width, SCREEN_HEIGHT - NavHeight);
    
    [self layoutTableViews];
}

-(void)layoutTableViews{
    float height = self.scrollView.bounds.size.height;
    
    _tableView_1 = [[RecordTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0 + 20.0, 0.0, SCREEN_WIDTH - 40.0, height) headView:NO footView:YES];
    _tableView_2 = [[RecordTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 1 + 20.0, 0.0, SCREEN_WIDTH - 40.0, height) headView:NO footView:YES];
    _tableView_3 = [[RecordTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2 + 20.0, 0.0, SCREEN_WIDTH - 40.0, height) headView:NO footView:YES];
    _tableView_4 = [[RecordTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 3 + 20.0, 0.0, SCREEN_WIDTH - 40.0, height) headView:NO footView:YES];
    NSArray *viewArr = @[_tableView_1,_tableView_2,_tableView_3,_tableView_4];
    
    for (int i = 0 ; i < viewArr.count; i ++) {
        RecordTableView *tableView = viewArr[i];
        [tableView.tableView registerNib:[UINib nibWithNibName:@"RecordCell" bundle:nil] forCellReuseIdentifier:RecordCell_ID];
//        tableView.urlString = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"account/dai/rob/robList"];
//        tableView.operationTag = RecordTableView_Tag + i;
        tableView.delegate = self;  tableView.dataSource = self;
        
        DBHealthRecordController *dbController = [[DBHealthRecordController alloc] init];
        dbController.type = i;
        tableView.dbController = dbController;
                
        [self.scrollView addSubview:tableView];
    }
    
    [_tableView_1 loadData];
}

- (IBAction)titleButtonClicked:(id)sender {
    NSArray *tableViewArr = @[_tableView_1,_tableView_2,_tableView_3,_tableView_4];
    UIButton *button = (UIButton *)sender;
    if (button.tag - 3020 != _handleButtonSelectedIndex) {
        button.selected = YES;
        [_seletedButton setBackgroundColor:UIColorFromRGBA(0xA5D7EB, 0.6)];
        
        _seletedButton.selected = NO;
        _seletedButton = button;
        [_seletedButton setBackgroundColor:SelectedBgColor];
        _handleButtonSelectedIndex = (int)(button.tag - 3020);
        
        [SVProgressHUD dismiss];
        
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*_handleButtonSelectedIndex, 0) animated:YES];
        
        RecordTableView *tableView = (RecordTableView *)tableViewArr[_handleButtonSelectedIndex];
        if (tableView.dataArray.count <= 0) {
            [tableView loadData];
        }
        
    }
}

#pragma mark === UITableViewDataSource
-(CGFloat)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(RecordTableView *)aView{
    return 40.0;
}

-(UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(RecordTableView *)aView{
    RecordCell *cell = [aView.tableView dequeueReusableCellWithIdentifier:RecordCell_ID];
    if (!cell) {
        cell = [[RecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RecordCell_ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, -200, 0, -200);
    cell.model = aView.dataArray[aIndexPath.row];
    
    return cell;
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
