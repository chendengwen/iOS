//
//  EditArchivesManagementVC.m
//  FuncGroup
//
//  Created by zhong on 2017/2/22.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "EditArchivesManagementVC.h"
#import "EditAMTableViewCell.h"
#import "CellModel.h"
#import "EditDetailsVC.h"
#import "DictionarySearchTool.h"


@interface EditArchivesManagementVC ()<UITableViewDataSource,UITableViewDelegate,EditAMTableViewCellDelegate>

@property (nonatomic,strong) NSMutableArray<CellModel *> *cellModels;

@property (nonatomic,strong) DictionarySearchTool *searchManager;

@end

@implementation EditArchivesManagementVC

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
    
//    UIButton *nextBtn = [[UIButton alloc]init];
//    nextBtn.backgroundColor = [UIColor colorWithRed:0.21 green:0.50 blue:0.79 alpha:1.00];
//    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
//    nextBtn.layer.cornerRadius = 4;
//    nextBtn.layer.masksToBounds = YES;
//    [nextBtn addTarget:self action:@selector(didClickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:nextBtn];
//    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-150);
//        make.height.equalTo(@(40));
//        make.width.equalTo(@(120));
//    }];
    
    //返回按钮
    [self addBackBtn];
}

- (void)didClickNextBtn:(UIButton *)sender{
    //判断必填数据
    for (CellModel *model in self.cellModels) {
        if (model.isMust && (model.currentValue == nil || [model.currentValue isEqualToString:@""])) {
            
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"请输入%@",model.title]];
            return;
        }
    }
    
    //判断身份证
    if (![self CheckIsIdentityCard:self.cellModels[2].currentValue]) {
        [SVProgressHUD showInfoWithStatus:@"身份证号码有误,请重新输入!"];
        return;
    }
    
    ArchivesModel *model = [[ArchivesModel alloc]init];
    model.IdCard = self.cellModels[2].currentValue;
    NSArray<ArchivesModel *> *array = [member.archives_DBController queryRecord:model];
    if (array.count > 0 ) {
        if (self.archivesModel.State == ArchivesManagement_New) {
            [SVProgressHUD showInfoWithStatus:@"该身份证号码已存在!"];
            return;
        }else if (self.archivesModel.State == ArchivesManagement_Edit){
            
            if (![self.archivesModel.ArchivesID isEqual:array[0].ArchivesID]) {
                [SVProgressHUD showInfoWithStatus:@"该身份证号码已存在!"];
                return;
            }
        }
        
    }
    
    for (CellModel *model in self.cellModels) {
        if (model.currentValue == nil) {
            model.currentValue = @"";
        }
    }

    //保存数据
    self.archivesModel.Name = self.cellModels[0].currentValue;
    self.archivesModel.Sex = [self.searchManager searchDictionary:self.cellModels[1]];
    self.archivesModel.IdCard = self.cellModels[2].currentValue;
    self.archivesModel.Birthday = self.cellModels[3].currentValue;
    self.archivesModel.Domicile = self.cellModels[4].currentValue;
    self.archivesModel.Ethnic = [self.searchManager searchDictionary:self.cellModels[5]];
    self.archivesModel.Address = self.cellModels[6].currentValue;
    
    EditDetailsVC *vc = [[EditDetailsVC alloc]init];
    vc.archivesModel = self.archivesModel;
    //下一页
    [self.navigationController pushViewController:vc animated:NO];
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
//- (ArchivesModel *)archivesModel
//{
//    if (_archivesModel != nil) {
//        return _archivesModel;
//    }
//    
//    _archivesModel = [[ArchivesModel alloc]init];
//    return _archivesModel;
//}

- (void)setArchivesModel:(ArchivesModel *)archivesModel{
    _archivesModel = archivesModel;
    if (archivesModel.State == ArchivesManagement_New) {
        
        return;
    }
    self.searchManager = [DictionarySearchTool sharedInstance];
    NSMutableArray *mArray = [[NSMutableArray alloc]initWithCapacity:7];
    
    CellModel *nameCell = [self getTextFieldCellModelWithTitle:@"姓名" Placeholder:@"请输入您的名字" Index:0 isMust:YES CurrentStr:archivesModel.Name State:CellState_sortTextField];
    [mArray addObject:nameCell];
    
    CellModel *sexCell = [self getAlertCellModelWithTitle:@"性别" Value:archivesModel.Sex Index:1 isMust:YES];
    [mArray addObject:sexCell];
    
    CellModel *IDCardCell = [self getTextFieldCellModelWithTitle:@"身份证号" Placeholder:@"请输入您的身份证号码" Index:2 isMust:YES CurrentStr:archivesModel.IdCard State:CellState_sortTextField];
    [mArray addObject:IDCardCell];
    
    CellModel *birthdayCell = [self getTextFieldCellModelWithTitle:@"出生日期" Placeholder:nil Index:3 isMust:NO CurrentStr:archivesModel.Birthday  State:CellState_sortTextField];
    [mArray addObject:birthdayCell];
    
    CellModel *censusRegisterCell = [self getTextFieldCellModelWithTitle:@"户籍地" Placeholder:@"请输入您的户籍地址" Index:4 isMust:YES CurrentStr:archivesModel.Domicile State:CellState_TextField];
    [mArray addObject:censusRegisterCell];
    
    CellModel *nationCell = [self getAlertCellModelWithTitle:@"民族" Value:archivesModel.Ethnic Index:5 isMust:YES];
    [mArray addObject:nationCell];
    
    CellModel *addressCell = [self getTextFieldCellModelWithTitle:@"居住地址" Placeholder:@"请输入您的现居住地址" Index:6 isMust:NO CurrentStr:archivesModel.Address State:CellState_TextField];
    [mArray addObject:addressCell];
    
    _cellModels = mArray.mutableCopy;
}

- (CellModel *)getTextFieldCellModelWithTitle:(NSString *)title Placeholder:(NSString *)placeholder Index:(NSInteger)index isMust:(BOOL)isMust CurrentStr:(NSString *)currentStr State:(CellState)state{
    CellModel *model = [[CellModel alloc]initWithTitle:title CellState:state Must:isMust CurrentValue:currentStr Placeholder:placeholder Index:index OptionIndex:0];
    return model;
}

- (CellModel *)getAlertCellModelWithTitle:(NSString *)title Value:(NSString *)value Index:(NSInteger)index isMust:(BOOL)isMust{
    NSString *currentStr = [self.searchManager searchKeyWithTitle:title andValue:value];
    CellModel *model = [[CellModel alloc]initWithTitle:title CellState:CellState_Alert Must:isMust CurrentValue:currentStr Placeholder:nil Index:index OptionIndex:[self.searchManager searchIndexForKey:title andValue:currentStr]];
    model.options = [self.searchManager getArrayForKey:title];
    
    return model;
}

- (NSMutableArray *)cellModels{
    if (_cellModels != nil) {
        return _cellModels;
    }
    
    NSMutableArray *mArray = [[NSMutableArray alloc]initWithCapacity:7];
    
    CellModel *nameCell = [self getTextFieldCellModelWithTitle:@"姓名" Placeholder:@"请输入您的名字" Index:0 isMust:YES CurrentStr:nil  State:CellState_sortTextField];
    [mArray addObject:nameCell];
    
    CellModel *sexCell = [self getAlertCellModelWithTitle:@"性别" Value:@"1" Index:1 isMust:YES];
    [mArray addObject:sexCell];
    
    CellModel *IDCardCell = [self getTextFieldCellModelWithTitle:@"身份证号" Placeholder:@"请输入您的身份证号码" Index:2 isMust:YES CurrentStr:nil State:CellState_sortTextField];
    [mArray addObject:IDCardCell];
    
    CellModel *birthdayCell = [[CellModel alloc]initWithTitle:@"出生日期" CellState:CellState_sortTextField Must:NO CurrentValue:@"1970-01-01" Placeholder:nil Index:3 OptionIndex:0];
    [mArray addObject:birthdayCell];
    
    CellModel *censusRegisterCell = [self getTextFieldCellModelWithTitle:@"户籍地" Placeholder:@"请输入您的户籍地址" Index:4 isMust:YES CurrentStr:nil State:CellState_TextField];
    [mArray addObject:censusRegisterCell];
    
    CellModel *nationCell = [self getAlertCellModelWithTitle:@"民族" Value:@"1" Index:5 isMust:YES];
    [mArray addObject:nationCell];
    
    CellModel *addressCell = [self getTextFieldCellModelWithTitle:@"居住地址" Placeholder:@"请输入您的现居住地址" Index:6 isMust:NO CurrentStr:nil State:CellState_TextField];
    [mArray addObject:addressCell];
    
    _cellModels = mArray.mutableCopy;
    
    return _cellModels;
}


#pragma mark - CheckAction
//身份证号
- (BOOL)CheckIsIdentityCard: (NSString *)identityCard
{
    //判断是否为空
    if (identityCard==nil||identityCard.length <= 0) {
        return NO;
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:identityCard]){
        return NO;
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [identityCard substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return NO;
    }
    
    //判断校验位
    if(identityCard.length==18)
    {
        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
        for(int i=0;i<17;i++){
            idCardWiSum+=[[identityCard substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
        }
        
        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
        NSString *idCardLast=[identityCard substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
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
