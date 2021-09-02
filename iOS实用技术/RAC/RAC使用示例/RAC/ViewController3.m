//
//  ViewController3.m
//  RAC
//


#import "ViewController3.h"

@interface ViewController3 ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView  *baseV;
@property (nonatomic,strong)NSArray  *sourceArr;
@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sourceArr = @[
                       @"RACSiganl",@"RACSubject_1",
                       @"RACDisposable_",
                       @"RACReplaySubject_1",
                       @"RACSequence_",
                       @"RACCommand_",
                       @"RACMulticastConnection_",
                       @"RACFilter_",
                       @"Mapping_",
                       @"RACCombination_",
                       @"RACBind_",
                       @"RAC_MVVM",
                       @"RAC_MVVM_2",
                       @"RACCommonUsages",
                       @"RACCommonDefines",
                       @"Demo"
                       ];
    [self setUpUI];
}

-(void)setUpUI{
    self.baseV = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.baseV];
    self.baseV.delegate =self;
    self.baseV.dataSource = self;
    self.baseV.tableFooterView  =[UIView new];
    [self.baseV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ViewController3"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViewController3" forIndexPath:indexPath];
    if(cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ViewController3"];
    }
    cell.textLabel.text = self.sourceArr[indexPath.row];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Class cls = NSClassFromString(self.sourceArr[indexPath.row]);
    UIViewController *vc = (UIViewController*)[cls new];
    vc.title = self.sourceArr[indexPath.row];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
