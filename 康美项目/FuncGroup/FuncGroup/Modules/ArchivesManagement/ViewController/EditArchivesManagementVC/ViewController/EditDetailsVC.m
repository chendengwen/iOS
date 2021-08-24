//
//  EditDetailsVC.m
//  FuncGroup
//
//  Created by zhong on 2017/2/24.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "EditDetailsVC.h"
#import "EditAMTableViewCell.h"
#import "CellModel.h"
#import "EditMedicalHistoryVC.h"
#import "DictionarySearchTool.h"
@interface EditDetailsVC ()<UITableViewDataSource,UITableViewDelegate,EditAMTableViewCellDelegate>

@property (nonatomic,strong) NSMutableArray<CellModel *> *cellModels;
@property (nonatomic,strong) DictionarySearchTool *searchManager;
@end

@implementation EditDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchManager = [DictionarySearchTool sharedInstance];
    [self setupUI];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellModels.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.cellModels.count) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"backCell"];
        
        UIButton *nextBtn = [[UIButton alloc]init];
        nextBtn.backgroundColor = [UIColor colorWithRed:0.21 green:0.50 blue:0.79 alpha:1.00];
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        nextBtn.layer.cornerRadius = 4;
        nextBtn.layer.masksToBounds = YES;
        [nextBtn addTarget:self action:@selector(didClickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:nextBtn];
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
            make.height.equalTo(@(40));
            make.width.equalTo(@(120));
        }];
        return cell;
    }
    
    EditAMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditAMCell"];
    if (cell == nil) {
        cell = [[EditAMTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EditAMCell"];
    }
    
    cell.model = self.cellModels[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Action
- (void)didClickNextBtn:(UIButton *)sender{
    //判断必填数据
    for (CellModel *model in self.cellModels) {
        if (model.isMust && (model.currentValue == nil || [model.currentValue isEqualToString:@""])) {
            
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"请输入%@",model.title]];
            return;
        }
    }
    
    if (![self validateContactNumber:self.cellModels[6].currentValue]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的联系电话!"];
        return;
    }
    
    for (CellModel *model in self.cellModels) {
        if (model.currentValue == nil) {
            model.currentValue = @"";
        }
    }
    //保存数据
    self.archivesModel.PermanentType = [self.searchManager searchDictionary:self.cellModels[0]];
    self.archivesModel.Marriage = [self.searchManager searchDictionary:self.cellModels[1]];
    self.archivesModel.BloodType = [self.searchManager searchDictionary:self.cellModels[2]];
    self.archivesModel.Job = [self.searchManager searchDictionary:self.cellModels[3]];
    self.archivesModel.Educational = [self.searchManager searchDictionary:self.cellModels[4]];
    self.archivesModel.RH = [self.searchManager searchDictionary:self.cellModels[5]];
    self.archivesModel.Tel = self.cellModels[6].currentValue;
    self.archivesModel.Guardian = self.cellModels[7].currentValue;
    self.archivesModel.GuardianTel = self.cellModels[8].currentValue;
    self.archivesModel.DrugAllergy = self.cellModels[9].currentValue;
    self.archivesModel.OtherDrugAllergy = self.cellModels[9].otherStr == nil ? @"" :self.cellModels[9].otherStr;
    self.archivesModel.Revealabliity = self.cellModels[10].currentValue;
    self.archivesModel.OtherRevealabliity =  self.cellModels[10].otherStr == nil ? @"" :self.cellModels[10].otherStr;
    self.archivesModel.Doctor = self.cellModels[11].currentValue;
    self.archivesModel.ArchiverManager = self.cellModels[12].currentValue;
    self.archivesModel.isOn = [self.searchManager searchDictionary:self.cellModels[13]];
    
    EditMedicalHistoryVC *vc = [[EditMedicalHistoryVC alloc]init];
    vc.archivesModel = self.archivesModel;
    //下一页
    [self.navigationController pushViewController:vc animated:NO];
}


- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *topView = [[UIView alloc]init];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(80));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor grayColor];
    [topView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topView);
        make.left.equalTo(topView).offset(20);
        make.right.equalTo(topView).offset(-20);
        make.height.equalTo(@(1));
    }];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.font = [UIFont boldSystemFontOfSize:22];
    titleLab.textColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.56 alpha:1.00];
    titleLab.text = @"创建档案";
    [topView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(line).offset(-6);
        make.left.equalTo(topView).offset(20);
    }];
    
    UITableView *AMTableView = [[UITableView alloc]init];
    [self.view addSubview:AMTableView];
    [AMTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(8);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view);
    }];
    AMTableView.dataSource = self;
    AMTableView.delegate = self;
    AMTableView.rowHeight = 60;
    AMTableView.showsVerticalScrollIndicator = NO;
    AMTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    AMTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    AMTableView.bounces = NO;
    
    //返回按钮
    [self addBackBtn];
}

- (void)didClickBackBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBackBtn{
    //返回按钮
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.backgroundColor = [UIColor colorWithRed:0.43 green:0.44 blue:0.44 alpha:0.6];
    [self.view addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(50));
    }];
    [backBtn addTarget:self action:@selector(didClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Setter & Getter

- (void)setArchivesModel:(ArchivesModel *)archivesModel{
    _archivesModel = archivesModel;
    if (archivesModel.State == ArchivesManagement_New) {
        
        return;
    }
    self.searchManager = [DictionarySearchTool sharedInstance];
    NSMutableArray *mArray = [[NSMutableArray alloc]initWithCapacity:14];
    
    //户籍类型
    CellModel *permanentTypeCell = [self getAlertCellModelWithTitle:@"户籍类型" Value:archivesModel.PermanentType Index:0 isMust:NO];
    [mArray addObject:permanentTypeCell];
    //婚姻状态
    CellModel *marriageCell = [self getAlertCellModelWithTitle:@"婚姻状态" Value:archivesModel.Marriage Index:1 isMust:NO];
    [mArray addObject:marriageCell];
    //血型
    CellModel *bloodTypeCell = [self getAlertCellModelWithTitle:@"血型" Value:archivesModel.BloodType Index:2 isMust:NO];
    [mArray addObject:bloodTypeCell];
    //职业
    CellModel *jobCell = [self getAlertCellModelWithTitle:@"职业" Value:archivesModel.Job Index:3 isMust:NO];
    [mArray addObject:jobCell];
    //文化程度
    CellModel *EducationalCell = [self getAlertCellModelWithTitle:@"文化程度" Value:archivesModel.Educational Index:4 isMust:NO];
    [mArray addObject:EducationalCell];
    //RH类型
    CellModel *RHCell = [self getAlertCellModelWithTitle:@"RH类型" Value:archivesModel.RH Index:5 isMust:NO];
    [mArray addObject:RHCell];
    //联系电话
    CellModel *TelCell = [[CellModel alloc]initWithTitle:@"联系电话" CellState:CellState_sortTextField Must:YES CurrentValue:archivesModel.Tel Placeholder:@"请输入您的联系电话" Index:6 OptionIndex:0];
    [mArray addObject:TelCell];
    //监护人
    CellModel *guardianCell = [[CellModel alloc]initWithTitle:@"监护人" CellState:CellState_sortTextField Must:NO CurrentValue:archivesModel.Guardian Placeholder:@"请输入您的监护人姓名" Index:7 OptionIndex:0];
    [mArray addObject:guardianCell];
    //监护人联系电话
    CellModel *guardianTelCell = [[CellModel alloc]initWithTitle:@"监护人联系电话" CellState:CellState_sortTextField Must:NO CurrentValue:archivesModel.GuardianTel Placeholder:@"请输入监护人联系电话" Index:8 OptionIndex:0];
    [mArray addObject:guardianTelCell];
    
    //药物过敏
    CellModel *drugAllergyCell = [[CellModel alloc]initWithTitle:@"药物过敏" CellState:CellState_Checkboxes Must:NO CurrentValue:archivesModel.DrugAllergy Placeholder:@"请输入您过敏的药物" Index:9 OptionIndex:0];
    drugAllergyCell.otherStr = archivesModel.OtherDrugAllergy;
    drugAllergyCell.options = @[@"无",@"青霉素",@"磺胺",@"链霉素",@"其他"];
    [mArray addObject:drugAllergyCell];
    //暴露史
    CellModel *revealabliityCell = [[CellModel alloc]initWithTitle:@"暴露史" CellState:CellState_Checkboxes Must:NO CurrentValue:archivesModel.Revealabliity Placeholder:@"请输入您的暴露史" Index:10 OptionIndex:0];
    revealabliityCell.otherStr = archivesModel.OtherRevealabliity;
    revealabliityCell.options = @[@"无",@"化学品",@"毒物",@"射线",@"其他"];
    [mArray addObject:revealabliityCell];
    //责任医师
    CellModel *doctorCell = [[CellModel alloc]initWithTitle:@"责任医师" CellState:CellState_sortTextField Must:NO CurrentValue:archivesModel.Doctor Placeholder:@"请输入您的责任医师姓名" Index:11 OptionIndex:0];
    [mArray addObject:doctorCell];
    //建档人员
    CellModel *archiverManagerCell = [[CellModel alloc]initWithTitle:@"建档人员" CellState:CellState_sortTextField Must:NO CurrentValue:archivesModel.ArchiverManager Placeholder:@"请输入建档人员姓名" Index:12 OptionIndex:0];
    [mArray addObject:archiverManagerCell];
    //启用状态
    CellModel *enableCell = [self getAlertCellModelWithTitle:@"启用状态" Value:archivesModel.isOn Index:13 isMust:NO];
    [mArray addObject:enableCell];
    
    _cellModels = mArray.mutableCopy;
}

- (NSMutableArray *)cellModels{
    if (_cellModels != nil) {
        return _cellModels;
    }
    
    NSMutableArray *mArray = [[NSMutableArray alloc]initWithCapacity:14];
    //户籍类型
    CellModel *permanentTypeCell = [self getAlertCellModelWithTitle:@"户籍类型" Value:@"" Index:1 isMust:NO];
    [mArray addObject:permanentTypeCell];
    //婚姻状态
    CellModel *marriageCell = [[CellModel alloc]initWithTitle:@"婚姻状态" CellState:CellState_Alert Must:NO CurrentValue:@"其他" Placeholder:nil Index:1 OptionIndex:3];
    marriageCell.options = @[@"未婚",@"已婚",@"丧偶",@"其他"];
    [mArray addObject:marriageCell];
    //血型
    CellModel *bloodTypeCell = [[CellModel alloc]initWithTitle:@"血型" CellState:CellState_Alert Must:NO CurrentValue:@"未知" Placeholder:nil Index:2 OptionIndex:4];
    bloodTypeCell.options = @[@"A型",@"B型",@"O型",@"AB型",@"未知"];
    [mArray addObject:bloodTypeCell];
    //职业
    CellModel *jobCell = [[CellModel alloc]initWithTitle:@"职业" CellState:CellState_Alert Must:NO CurrentValue:@"未知" Placeholder:nil Index:3 OptionIndex:8];
    jobCell.options = @[@"国家机关,党群组织,企业,事业单位负责人",
                        @"专业技术人员",
                        @"办事人员和有关人员",
                        @"商业,服务业人员",
                        @"农,林,牧,渔,水利业生产人员",
                        @"生产,运输设备操作人员及有关人员",
                        @"军人",
                        @"不便分类的其他从业人员",
                        @"未知"];
    [mArray addObject:jobCell];
    //文化程度
    CellModel *EducationalCell = [[CellModel alloc]initWithTitle:@"文化程度" CellState:CellState_Alert Must:NO CurrentValue:@"未知" Placeholder:nil Index:4 OptionIndex:9];
    EducationalCell.options = @[@"文盲或半文盲",
                        @"小学",
                        @"初中",
                        @"高中",
                        @"技工学校",
                        @"中等专业学校",
                        @"大学专科和专科学校",
                        @"大学本科",
                        @"研究生",
                        @"未知"];
    [mArray addObject:EducationalCell];
    //RH类型
    CellModel *RHCell = [[CellModel alloc]initWithTitle:@"RH类型" CellState:CellState_Alert Must:NO CurrentValue:@"未知" Placeholder:nil Index:5 OptionIndex:2];
    RHCell.options = @[@"RH阳性",@"RH阴性",@"未知"];
    [mArray addObject:RHCell];
    //联系电话
    CellModel *TelCell = [[CellModel alloc]initWithTitle:@"联系电话" CellState:CellState_sortTextField Must:YES CurrentValue:nil Placeholder:@"请输入您的手机号码" Index:6 OptionIndex:0];
    [mArray addObject:TelCell];
    //监护人
    CellModel *guardianCell = [[CellModel alloc]initWithTitle:@"监护人" CellState:CellState_sortTextField Must:NO CurrentValue:nil Placeholder:@"请输入您的监护人姓名" Index:7 OptionIndex:0];
    [mArray addObject:guardianCell];
    //监护人联系电话
    CellModel *guardianTelCell = [[CellModel alloc]initWithTitle:@"监护人联系电话" CellState:CellState_sortTextField Must:NO CurrentValue:nil Placeholder:@"请输入监护人联系电话" Index:8 OptionIndex:0];
    [mArray addObject:guardianTelCell];
    
    //药物过敏
    CellModel *drugAllergyCell = [[CellModel alloc]initWithTitle:@"药物过敏" CellState:CellState_Checkboxes Must:NO CurrentValue:nil Placeholder:@"请输入您过敏的药物" Index:9 OptionIndex:0];
    drugAllergyCell.options = @[@"无",@"青霉素",@"磺胺",@"链霉素",@"其他"];
    [mArray addObject:drugAllergyCell];
    //暴露史
    CellModel *revealabliityCell = [[CellModel alloc]initWithTitle:@"暴露史" CellState:CellState_Checkboxes Must:NO CurrentValue:nil Placeholder:@"请输入您的暴露史" Index:10 OptionIndex:0];
    revealabliityCell.options = @[@"无",@"化学品",@"毒物",@"射线",@"其他"];
    [mArray addObject:revealabliityCell];
    //责任医师
    CellModel *doctorCell = [[CellModel alloc]initWithTitle:@"责任医师" CellState:CellState_sortTextField Must:NO CurrentValue:nil Placeholder:@"请输入您的责任医师姓名" Index:11 OptionIndex:0];
    [mArray addObject:doctorCell];
    //建档人员
    CellModel *archiverManagerCell = [[CellModel alloc]initWithTitle:@"建档人员" CellState:CellState_sortTextField Must:NO CurrentValue:nil Placeholder:@"请输入建档人员姓名" Index:12 OptionIndex:0];
    [mArray addObject:archiverManagerCell];
    //启用状态
    CellModel *enableCell = [[CellModel alloc]initWithTitle:@"启用状态" CellState:CellState_Alert Must:NO CurrentValue:@"不启用" Placeholder:nil Index:13 OptionIndex:1];
    enableCell.options = @[@"启用",@"不启用"];
    [mArray addObject:enableCell];

    _cellModels = mArray.mutableCopy;
    
    return _cellModels;
}

- (CellModel *)getAlertCellModelWithTitle:(NSString *)title Value:(NSString *)value Index:(NSInteger)index isMust:(BOOL)isMust{
    NSString *currentStr = [self.searchManager searchKeyWithTitle:title andValue:value];
    CellModel *model = [[CellModel alloc]initWithTitle:title CellState:CellState_Alert Must:isMust CurrentValue:currentStr Placeholder:nil Index:index OptionIndex:[self.searchManager searchIndexForKey:title andValue:currentStr]];
    model.options = [self.searchManager getArrayForKey:title];
    
    return model;
}

#pragma mark - CheckAction
- (BOOL)validateContactNumber:(NSString *)mobileNum{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189^\\d{11}$
     */
    NSString * MOBILE = @"^\\d{7,18}$";

    
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    //不带区号的座机 7~8位数字
//    NSString *mobile = @"^\\d{7,8}$";

    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
//    NSPredicate *regextestmobile_1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
//    
    if(([regextestmobile evaluateWithObject:mobileNum] == YES)){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - EditCellDelegate
- (void)setUserValue:(CellModel *)model{
    
    self.cellModels[model.index] = model;
    
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
