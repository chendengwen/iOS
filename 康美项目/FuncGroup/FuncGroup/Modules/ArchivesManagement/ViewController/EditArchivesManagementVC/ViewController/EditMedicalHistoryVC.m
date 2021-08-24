//
//  EditMedicalHistoryVC.m
//  FuncGroup
//
//  Created by zhong on 2017/2/27.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "EditMedicalHistoryVC.h"
#import "EditAMTableViewCell.h"
#import "CellModel.h"
#import "EditMedicalHistoryCell.h"
#import "DictionarySearchTool.h"
#import "KMNetAPI.h"
#import "Archives_DBController.h"
#import "UUID.h"
#import "AppCacheManager.h"
#import "NSURL+Additions.h"
@interface EditMedicalHistoryVC ()<UITableViewDataSource,UITableViewDelegate,EditAMTableViewCellDelegate,EditMedicalHistoryCellDelegate>
@property (nonatomic,strong) NSMutableArray<CellModel *> *cellModels;
@property (nonatomic,strong) DictionarySearchTool *searchManager;
@property (nonatomic,weak) UITableView *tableView;
//日期格式
@property (nonatomic,strong) NSDateFormatter *format;

@end

@implementation EditMedicalHistoryVC

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
        [nextBtn setTitle:@"完成" forState:UIControlStateNormal];
        nextBtn.layer.cornerRadius = 4;
        nextBtn.layer.masksToBounds = YES;
        [nextBtn addTarget:self action:@selector(didClickFinishBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:nextBtn];
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
            make.height.equalTo(@(40));
            make.width.equalTo(@(120));
        }];
        return cell;
    }
    
    EditMedicalHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditMHCell"];
    if (cell == nil) {
        cell = [[EditMedicalHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EditMHCell"];
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
- (NSString *)getPhoneBluetoothMAC:(NSString *)UUID{
    return [UUID substringWithRange:NSMakeRange(24,12)];
}

- (void)didClickFinishBtn:(UIButton *)sender{
    [self setNULLStr];
    //保存数据
    for (int i = 0; i < self.cellModels.count;i++) {
        CellModel *model = self.cellModels[i];
        if ([model.title isEqualToString:@"既往病史"]) {
            if (!model.isOn) {
                self.archivesModel.Anamneses = @"[]";
                self.archivesModel.Anamneses_1 = @"无";
            }else{
                NSMutableString *str = [[NSMutableString alloc]init];
                [str appendString:@"["];
                [str appendString:[NSString stringWithFormat:@"{\"Anamnesis\":\"%@\",\"AnamnesisTime\":\"%@\"}",[self.searchManager searchDictionary:@"既往病史" andKey:model.currentValue],model.hitDate]];
                self.archivesModel.Anamneses_1 = model.currentValue;
                self.archivesModel.Anamneses_Date_1 = model.hitDate;
                if (model.subCount == 1) {
                    [str appendString:[NSString stringWithFormat:@",{\"Anamnesis\":\"%@\",\"AnamnesisTime\":\"%@\"}",[self.searchManager searchDictionary:@"既往病史" andKey:self.cellModels[i+1].currentValue],self.cellModels[i+1].hitDate]];
                    self.archivesModel.Anamneses_2 = self.cellModels[i+1].currentValue;
                    self.archivesModel.Anamneses_Date_2 = self.cellModels[i+1].hitDate;
                }else if (model.subCount == 2){
                    [str appendString:[NSString stringWithFormat:@",{\"Anamnesis\":\"%@\",\"AnamnesisTime\":\"%@\"}",[self.searchManager searchDictionary:@"既往病史" andKey:self.cellModels[i+1].currentValue],self.cellModels[i+1].hitDate]];
                    self.archivesModel.Anamneses_2 = self.cellModels[i+1].currentValue;
                    self.archivesModel.Anamneses_Date_2 = self.cellModels[i+1].hitDate;
                    [str appendString:[NSString stringWithFormat:@",{\"Anamnesis\":\"%@\",\"AnamnesisTime\":\"%@\"}",[self.searchManager searchDictionary:@"既往病史" andKey:self.cellModels[i+2].currentValue],self.cellModels[i+2].hitDate]];
                    self.archivesModel.Anamneses_3 = self.cellModels[i+2].currentValue;
                    self.archivesModel.Anamneses_Date_3 = self.cellModels[i+2].hitDate;
                }
                [str appendString:@"]"];
                self.archivesModel.Anamneses = str.copy;
            }
        }
        if ([model.title isEqualToString:@"手术"]) {
            if (!model.isOn) {
                self.archivesModel.Operations = @"[]";
            }else{
                NSMutableString *str = [[NSMutableString alloc]init];
                [str appendString:@"["];
                [str appendString:[NSString stringWithFormat:@"{\"OperationName\":\"%@\",\"OperationTime\":\"%@\"}",model.currentValue,model.hitDate]];
                self.archivesModel.Operations_1 = model.currentValue;
                self.archivesModel.Operations_Date_1 = model.hitDate;
                if (model.subCount == 1) {
                    [str appendString:[NSString stringWithFormat:@",{\"OperationName\":\"%@\",\"OperationTime\":\"%@\"}",self.cellModels[i+1].currentValue,self.cellModels[i+1].hitDate]];
                    self.archivesModel.Operations_2 = self.cellModels[i+1].currentValue;
                    self.archivesModel.Operations_Date_2 = self.cellModels[i+1].hitDate;
                }
                [str appendString:@"]"];
                self.archivesModel.Operations = str.copy;
            }
        }
        if ([model.title isEqualToString:@"外伤"]) {
            if (!model.isOn) {
                self.archivesModel.Traumas = @"[]";
            }else{
                NSMutableString *str = [[NSMutableString alloc]init];
                [str appendString:@"["];
                [str appendString:[NSString stringWithFormat:@"{\"TraumaName\":\"%@\",\"TraumaTime\":\"%@\"}",model.currentValue,model.hitDate]];
                self.archivesModel.Traumas_1 = model.currentValue;
                self.archivesModel.Traumas_Date_1 = model.hitDate;
                if (model.subCount == 1) {
                    [str appendString:[NSString stringWithFormat:@",{\"TraumaName\":\"%@\",\"TraumaTime\":\"%@\"}",self.cellModels[i+1].currentValue,self.cellModels[i+1].hitDate]];
                    self.archivesModel.Traumas_2 = self.cellModels[i+1].currentValue;
                    self.archivesModel.Traumas_Date_2 = self.cellModels[i+1].hitDate;
                }
                [str appendString:@"]"];
                self.archivesModel.Traumas = str.copy;
            }
        }
        if ([model.title isEqualToString:@"输血"]) {
            if (!model.isOn) {
                self.archivesModel.Transfutions = @"[]";
            }else{
                NSMutableString *str = [[NSMutableString alloc]init];
                [str appendString:@"["];
                [str appendString:[NSString stringWithFormat:@"{\"Transfution\":\"%@\",\"TransfutionTime\":\"%@\"}",model.currentValue,model.hitDate]];
                self.archivesModel.Transfutions_1 = model.currentValue;
                self.archivesModel.Transfutions_Date_1 = model.hitDate;
                if (model.subCount == 1) {
                    [str appendString:[NSString stringWithFormat:@",{\"Transfution\":\"%@\",\"TransfutionTime\":\"%@\"}",self.cellModels[i+1].currentValue,self.cellModels[i+1].hitDate]];
                    self.archivesModel.Transfutions_2 = self.cellModels[i+1].currentValue;
                    self.archivesModel.Transfutions_Date_2 = self.cellModels[i+1].hitDate;
                }
                [str appendString:@"]"];
                self.archivesModel.Transfutions = str.copy;
            }
        }
        
        if ([model.title isEqualToString:@"遗传史"]) {
            if (!model.isOn) {
                self.archivesModel.HeredityName = @"";
            }else{
                self.archivesModel.HeredityName = model.currentValue;
            }
        }
    }

    
    //获取手机蓝牙MAC地址
    self.archivesModel.MachineNo = [self getPhoneBluetoothMAC:[UUID currentDeviceUUID]];
    
    if (self.archivesModel.State == ArchivesManagement_Edit) {
        self.archivesModel.ExamTime = [self.format stringFromDate:[NSDate date]];
    }else if (self.archivesModel.State == ArchivesManagement_New){
        self.archivesModel.ExamTime = [self.format stringFromDate:[NSDate date]];
        self.archivesModel.ArchiveDate = self.archivesModel.ExamTime ;
    }
    [SVProgressHUD show];
    //保存至数据库
    if (self.archivesModel.State == ArchivesManagement_New) {
        [self updateKeyToDB];
    }else{
        
        //更新
        [member.archives_DBController updateRecord:self.archivesModel];
        
        for (int i = 0; i < member.ArchivesArray.count; i++) {
            if ([member.ArchivesArray[i].ArchivesID isEqual:self.archivesModel.ArchivesID]) {
                ArchivesModel *oldModel = member.ArchivesArray[i];
                if (![oldModel.Name isEqualToString:self.archivesModel.Name]
                    ||![oldModel.Sex isEqualToString:self.archivesModel.Sex]
                    ||![oldModel.IdCard isEqualToString:self.archivesModel.IdCard]||
                    ![oldModel.Tel isEqualToString:self.archivesModel.Tel]) {
                    //如果用户更改手机号\身份证\性别\姓名 重新获取中医体质Key -> 更新到数据库
                    [self updateKeyToDB];
                }else{
                    [self updateDataToServer];
                }
                
                break;
            }
        }
        

    }
    
}

- (void)setNULLStr{
    self.archivesModel.Anamneses_1 = @"";
    self.archivesModel.Anamneses_Date_1 = @"";
    self.archivesModel.Anamneses_2 = @"";
    self.archivesModel.Anamneses_Date_2 = @"";
    self.archivesModel.Anamneses_2 = @"";
    self.archivesModel.Anamneses_Date_2 = @"";
    self.archivesModel.Anamneses_3 = @"";
    self.archivesModel.Anamneses_Date_3 = @"";
    
    self.archivesModel.Operations_1 = @"";
    self.archivesModel.Operations_Date_1 = @"";
    self.archivesModel.Operations_2 = @"";
    self.archivesModel.Operations_Date_2 = @"";
    
    self.archivesModel.Traumas_1 = @"";
    self.archivesModel.Traumas_Date_1 = @"";
    self.archivesModel.Traumas_2 = @"";
    self.archivesModel.Traumas_Date_2 = @"";
    
    self.archivesModel.Transfutions_1 = @"";
    self.archivesModel.Transfutions_Date_1 = @"";
    self.archivesModel.Transfutions_2 = @"";
    self.archivesModel.Transfutions_Date_2 = @"";
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
    self.tableView = AMTableView;
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
    NSMutableArray *mArray = [[NSMutableArray alloc]initWithCapacity:10];
    self.searchManager = [DictionarySearchTool sharedInstance];
    NSInteger index = 0;
    CellModel *anamnesesCell = [[CellModel alloc]initWithTitle:@"既往病史" CellState:CellState_Hit_1 CurrentValue:archivesModel.Anamneses_1 Placeholder:nil Index:index HitDate:archivesModel.Anamneses_Date_1 isOn:![archivesModel.Anamneses_Date_1 isEqualToString:@""] OptionIndex:[self.searchManager searchIndexForKey:@"既往病史" andValue:archivesModel.Anamneses_1]];
    
    index += 1;
    anamnesesCell.options = [self.searchManager getArrayForKey:@"既往病史"];
    [mArray addObject:anamnesesCell];
    
    if (![archivesModel.Anamneses_Date_2 isEqualToString:@""]) {
        CellModel *cell = [[CellModel alloc]initWithTitle:nil CellState:CellState_Hit_2 CurrentValue:archivesModel.Anamneses_2 Placeholder:nil Index:index HitDate:archivesModel.Anamneses_Date_2 isOn:NO OptionIndex:[self.searchManager searchIndexForKey:@"既往病史" andValue:archivesModel.Anamneses_2]];
        index += 1;
        cell.options = [self.searchManager getArrayForKey:@"既往病史"];
        anamnesesCell.subCount = 1;
        [mArray addObject:cell];
    }
    if (![archivesModel.Anamneses_Date_3 isEqualToString:@""]) {
        CellModel *cell = [[CellModel alloc]initWithTitle:nil CellState:CellState_Hit_2 CurrentValue:archivesModel.Anamneses_3 Placeholder:nil Index:index HitDate:archivesModel.Anamneses_Date_3 isOn:NO OptionIndex:[self.searchManager searchIndexForKey:@"既往病史" andValue:archivesModel.Anamneses_3]];
        index += 1;
        cell.options = [self.searchManager getArrayForKey:@"既往病史"];
        anamnesesCell.subCount = 2;
        [mArray addObject:cell];
    }
    CellModel *operationsCell = [[CellModel alloc]initWithTitle:@"手术" CellState:CellState_Hit_1 CurrentValue:archivesModel.Operations_1 Placeholder:@"手术名称" Index:index HitDate:archivesModel.Operations_Date_1 isOn:![archivesModel.Operations_Date_1 isEqualToString:@""] OptionIndex:0];
    index += 1;
    [mArray addObject:operationsCell];
    if (![archivesModel.Operations_Date_2 isEqualToString:@""]) {
        CellModel *cell = [[CellModel alloc]initWithTitle:nil CellState:CellState_Hit_2 CurrentValue:archivesModel.Operations_2 Placeholder:@"手术名称" Index:index HitDate:archivesModel.Operations_Date_2 isOn:NO OptionIndex:0];
        index += 1;
        operationsCell.subCount = 1;
        [mArray addObject:cell];
    }
    CellModel *traumasCell = [[CellModel alloc]initWithTitle:@"外伤" CellState:CellState_Hit_1 CurrentValue:archivesModel.Traumas_1 Placeholder:@"外伤名称" Index:index HitDate:archivesModel.Traumas_Date_1 isOn:![archivesModel.Traumas_Date_1 isEqualToString:@""] OptionIndex:0];
    index += 1;
    [mArray addObject:traumasCell];
    if (![archivesModel.Traumas_Date_2 isEqualToString:@""]) {
        CellModel *cell = [[CellModel alloc]initWithTitle:nil CellState:CellState_Hit_2 CurrentValue:archivesModel.Traumas_2 Placeholder:@"外伤名称" Index:index HitDate:archivesModel.Traumas_Date_2 isOn:NO OptionIndex:0];
        index += 1;
        traumasCell.subCount = 1;
        [mArray addObject:cell];
    }
    CellModel *transfutionCell = [[CellModel alloc]initWithTitle:@"输血" CellState:CellState_Hit_1 CurrentValue:archivesModel.Transfutions_1 Placeholder:@"输血名称" Index:index HitDate:archivesModel.Transfutions_Date_1 isOn:![archivesModel.Transfutions_Date_1 isEqualToString:@""] OptionIndex:0];
    index += 1;
    [mArray addObject:transfutionCell];
    if (![archivesModel.Transfutions_Date_2 isEqualToString:@""]) {
        CellModel *cell = [[CellModel alloc]initWithTitle:nil CellState:CellState_Hit_2 CurrentValue:archivesModel.Transfutions_2 Placeholder:@"输血名称" Index:index HitDate:archivesModel.Transfutions_Date_2 isOn:NO OptionIndex:0];
        index += 1;
        transfutionCell.subCount = 1;
        [mArray addObject:cell];
    }
    
    CellModel *heredityNameCell = [[CellModel alloc]initWithTitle:@"遗传史" CellState:CellState_LongTextField CurrentValue:archivesModel.HeredityName Placeholder:@"请输入遗传病名称" Index:index HitDate:@"1990-01-01" isOn:![archivesModel.HeredityName isEqualToString:@""] OptionIndex:0];
    [mArray addObject:heredityNameCell];
    _cellModels = mArray.mutableCopy;
}

- (NSMutableArray *)cellModels{
    if (_cellModels != nil) {
        return _cellModels;
    }
    
    NSMutableArray *mArray = [[NSMutableArray alloc]initWithCapacity:14];
    //既往病史Anamneses
    CellModel *anamnesesCell = [[CellModel alloc]initWithTitle:@"既往病史" CellState:CellState_Hit_1 CurrentValue:@"无" Placeholder:nil Index:0 HitDate:@"1990-01-01" isOn:NO OptionIndex:0];
    anamnesesCell.options = @[@"无",@"高血压",@"糖尿病",@"冠心病",@"慢性阻塞性肺疾病",
                              @"恶性肿瘤",@"脑卒中",@"重性精神疾病",@"结核病",@"肝脏疾病",@"先天畸形",@"职业病",@"肾脏疾病",@"贫血",@"其他法定传染病",@"其他"];
    [mArray addObject:anamnesesCell];
    //手术Operations
    CellModel *operationsCell = [[CellModel alloc]initWithTitle:@"手术" CellState:CellState_Hit_1 CurrentValue:nil Placeholder:@"手术名称" Index:1 HitDate:@"1990-01-01" isOn:NO OptionIndex:0];
    [mArray addObject:operationsCell];
    //外伤Traumas
    CellModel *traumasCell = [[CellModel alloc]initWithTitle:@"外伤" CellState:CellState_Hit_1 CurrentValue:nil Placeholder:@"外伤名称" Index:2 HitDate:@"1990-01-01" isOn:NO OptionIndex:0];
    [mArray addObject:traumasCell];
    //输血Transfutions
    CellModel *transfutionsCell = [[CellModel alloc]initWithTitle:@"输血" CellState:CellState_Hit_1 CurrentValue:nil Placeholder:@"输血名称" Index:3 HitDate:@"1990-01-01" isOn:NO OptionIndex:0];
    [mArray addObject:transfutionsCell];
    //    遗传史HeredityName
    CellModel *heredityNameCell = [[CellModel alloc]initWithTitle:@"遗传史" CellState:CellState_LongTextField CurrentValue:nil Placeholder:@"请输入遗传病名称" Index:4 HitDate:@"1990-01-01" isOn:NO OptionIndex:0];
    [mArray addObject:heredityNameCell];
    
    _cellModels = mArray.mutableCopy;
    
    return _cellModels;
}

#pragma mark - EditCellDelegate
- (void)setUserValue:(CellModel *)model{
    if (model.isOn == NO && model.subCount > 0) {
        if (model.subCount == 1) {
            [self didClickDeleteBtn:self.cellModels[model.index + 1]];
        }
        
        if (model.subCount == 2) {
            [self didClickDeleteBtn:self.cellModels[model.index + 1]];
            [self didClickDeleteBtn:self.cellModels[model.index + 1]];
        }
    }
    
    
    self.cellModels[model.index] = model;
    
    
}

- (void)didClickDeleteBtn:(CellModel *)model{
    for (NSInteger i = model.index; i >= 0; i--) {
        if (self.cellModels[i].subCount > 0) {
            self.cellModels[i].subCount -= 1;
            break;
        }
    }
    [self.cellModels removeObjectAtIndex:model.index];
    for (NSInteger i = model.index; i < self.cellModels.count; i++) {
        self.cellModels[i].index = i;
    }
    [self.tableView reloadData];
}

- (void)didClickAddBtn:(CellModel *)model{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:model.index + model.subCount inSection:0];
    if ([model.title isEqualToString:@"既往病史"]) {
        CellModel *cell = [[CellModel alloc]initWithTitle:nil CellState:CellState_Hit_2 CurrentValue:@"无" Placeholder:nil Index:indexPath.row HitDate:@"1990-01-01" isOn:NO OptionIndex:0];
        cell.options = @[@"无",@"高血压",@"糖尿病",@"冠心病",@"慢性阻塞性肺疾病",
                                  @"恶性肿瘤",@"脑卒中",@"重性精神疾病",@"结核病",@"肝脏疾病",@"先天畸形",@"职业病",@"肾脏疾病",@"贫血",@"其他法定传染病",@"其他"];
    
        [self.cellModels insertObject:cell atIndex:indexPath.row];
    }else {
        //手术Operations
        CellModel *cell = [[CellModel alloc]initWithTitle:nil CellState:CellState_Hit_2 CurrentValue:nil Placeholder:model.placeholder Index:indexPath.row HitDate:@"1990-01-01" isOn:NO OptionIndex:0];
        [self.cellModels insertObject:cell atIndex:indexPath.row];
    }
    
    for (NSInteger i = indexPath.row + 1; i < self.cellModels.count; i++) {
        self.cellModels[i].index = i;
    }
        
    
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
    [self.tableView reloadData];
}

- (NSDateFormatter *)format{
    if (_format != nil) {
        return _format;
    }
    _format = [[NSDateFormatter alloc]init];
    _format.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    return _format;
}

- (void)updateKeyToDB{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[URLs getFullAPIPortType:API_PORT_TYPE_HEALTH_TEST],@"/tcq/personInfo"] paramArray:@[self.archivesModel.Name?:@"name",self.archivesModel.IdCard?:@"id123",self.archivesModel.Tel,[self.archivesModel.Sex intValue]==1?@"0":@"1"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [[AFNetworkManager sharedAFNetworkManager] dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        //                NSLog(@"%@ %@", response, responseObject);
        
        if (error) {
//            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD showErrorWithStatus:@"更新数据失败,请重试!"];
        }else {
            NSString *content = [(NSDictionary *)responseObject objectForKey:kContent];
            NSString *key = (NSString *) [[[[content componentsSeparatedByString:@"key="] objectAtIndex:1] componentsSeparatedByString:@" ,"] objectAtIndex:0];

            self.archivesModel.physiqueTestKey = key;

            [SVProgressHUD dismiss];
            [self updateDataToServer];
//            [SVProgressHUD showSuccessWithStatus:@"更新中医体质Key成功"];
        }
    }];
    
    [dataTask resume];
}

- (void)updateDataToServer{
    if (self.archivesModel.State == ArchivesManagement_New) {
        //插入
        [member.archives_DBController insertRecord:self.archivesModel];
    }else if (self.archivesModel.State == ArchivesManagement_Edit){
        [member.archives_DBController updateRecord:self.archivesModel];
        
    }
    //更新已选档案
    if ([self.archivesModel.ArchivesID isEqual:member.currentUserArchives.ArchivesID]) {
        member.currentUserArchives = self.archivesModel;
        
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://%@/KM9000/upload",ServerAddress];
    //拼接数据
    NSString *dataStr = [self.archivesModel getDataStr];
    //上传
    NSMutableData *postBody=[NSMutableData data];
    [postBody appendData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
    [[KMNetAPI sharedInstance] postWithUrl:requestUrl body:postBody success:^(NSString *response) {
        DMLog(@"%@",response);
        if ([response containsString:@"成功"]) {
            [SVProgressHUD showSuccessWithStatus:@"档案上传成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"档案上传失败"];
        }
        
    } failure:^(NSError *error) {
        DMLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"量测数据上传失败"];
    }];
    member.ArchivesArray = nil;
    [self.navigationController popToViewController:self.navigationController.childViewControllers[1] animated:YES];
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
