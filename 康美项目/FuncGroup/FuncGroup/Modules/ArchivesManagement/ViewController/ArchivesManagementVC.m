//
//  ArchivesManagementVC.m
//  FuncGroup
//
//  Created by zhong on 2017/2/20.
//  Copyright © 2017年 gary. All rights reserved.
//
#import <MobileCoreServices/MobileCoreServices.h>
#import "ArchivesManagementVC.h"
#import "AMTableViewCell.h"
#import "EditArchivesManagementVC.h"
#import "SKFCamera.h"
#import "TOCropViewController.h"
#import "PhotoManager.h"
#import "MemberManager.h"
#import "AppCacheManager.h"
#import "XYAlertView.h"
#define SEARCH_COLOR [UIColor colorWithRed:0.69 green:0.83 blue:0.88 alpha:0.6]

@interface ArchivesManagementVC ()<UITableViewDataSource,UITableViewDelegate,AMTableViewCellDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,TOCropViewControllerDelegate>
@property (nonatomic, strong) Archives_DBController *dbController;

@property (nonatomic, strong) NSArray<ArchivesModel *> *ArchivesArray;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UITextField *searchText;

@property (nonatomic, weak) AMTableViewCell *selectCell;
//提示框
@property (nonatomic,weak) XYAlertView *contentView;

@property (nonatomic,weak) AMTableViewCell *delectCell;

@end

@implementation ArchivesManagementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshTableView];
}

//刷新表格
- (void)refreshTableView{
    self.ArchivesArray = nil;
    [self.tableView reloadData];
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *topView = [[UIView alloc]init];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(SCREEN_HEIGHT / 5.5));
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
    
    UIView *searchBackView = [[UIView alloc]init];
    searchBackView.backgroundColor = SEARCH_COLOR;
    searchBackView.layer.cornerRadius = 5;
    searchBackView.layer.masksToBounds = YES;
    [topView addSubview:searchBackView];
    [searchBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(30));
        make.centerY.equalTo(topView);
        make.height.equalTo(@(40));
        make.width.equalTo(@(320));
        
    }];
    
    UITextField *searchText = [[UITextField alloc]init];
    self.searchText = searchText;
    searchText.placeholder = @"请输入姓名或者身份证号进行查询";
    searchText.font = [UIFont systemFontOfSize:14];
    [searchBackView addSubview:searchText];
    [searchText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchBackView).offset(8);
        make.centerY.equalTo(searchBackView);
    }];
    
    UIButton *imgV = [[UIButton alloc]init];
    [imgV setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [imgV addTarget:self action:@selector(didClickSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchBackView);
        make.left.equalTo(searchBackView.mas_right).offset(8);
        make.height.width.equalTo(@(30));
    }];
    
    UIButton *searchBtn = [[UIButton alloc]init];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"add_archives"] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"add_archives_over"] forState:UIControlStateSelected];
    [searchBtn setTitle:@"创建新档案" forState:UIControlStateNormal];
    [searchBtn setTitle:@"创建新档案" forState:UIControlStateSelected];
    [searchBtn addTarget:self action:@selector(didClickAddAM:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    [topView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(topView).offset(-20);
        make.height.equalTo(@(70));
        make.width.equalTo(@(210));
    }];
    
    UILabel *AMLab = [[UILabel alloc]init];
    AMLab.font = [UIFont boldSystemFontOfSize:22];
    AMLab.textColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.56 alpha:1.00];
    AMLab.text = @"档案管理";
    [topView addSubview:AMLab];
    [AMLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(line).offset(-6);
        make.left.equalTo(topView).offset(20);
    }];
    
    UITableView *AMTableView = [[UITableView alloc]init];
    self.tableView = AMTableView;
    [self.view addSubview:AMTableView];
    [AMTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(8);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view);
    }];
    AMTableView.dataSource = self;
    AMTableView.delegate = self;
    AMTableView.rowHeight = 110;
    AMTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    AMTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    AMTableView.showsVerticalScrollIndicator = NO;
    [self addBackBtn];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ArchivesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AMCell"];
    if (cell == nil) {
        cell = [[AMTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AMCell"];
    }
    cell.delegate = self;
    cell.backgroundColor = SEARCH_COLOR;
    cell.model = self.ArchivesArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    EditArchivesManagementVC *vc = [[EditArchivesManagementVC alloc]init];
    ArchivesModel *model = self.ArchivesArray[indexPath.row].copy;
    model.State = ArchivesManagement_Edit;
    vc.archivesModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action

- (void)didClickOKBtn:(UIButton *)sender{
    if (sender.tag == 2001) {
        [self.contentView dismiss];
    }else if (sender.tag == 2002){
        [member.archives_DBController deleteRecord:self.delectCell.model];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:self.delectCell];
        
        [member.ArchivesArray removeObjectAtIndex:indexPath.row];
        
        [MemberManager sharedInstance].currentUserArchives = nil;
        [self refreshTableView];
        [self.contentView dismiss];
    }
}

- (void)didClickAddAM:(UIButton *)sender{
    EditArchivesManagementVC *vc = [[EditArchivesManagementVC alloc]init];
    vc.archivesModel = [[ArchivesModel alloc]init];
    vc.archivesModel.State = ArchivesManagement_New;
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)didClickSearchBtn:(UIButton *)sender{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    ArchivesModel *model = [[ArchivesModel alloc]init];
    model.Name = self.searchText.text;
    model.IdCard = self.searchText.text;
    NSArray *array = [member.archives_DBController queryRecord:model];
    if (array == nil && ![self.searchText.text isEqualToString:@""]) {
        array = [NSArray array];
    }
    self.ArchivesArray = array;
    [self.tableView reloadData];
}

- (void)didClickArchives:(AMTableViewCell *)cell andTag:(NSInteger)tag{
    self.selectCell = cell;
    if (tag == 101) {
        //选择档案
        if (cell.model.Photo.length <= 0) {
            UIImage *img = [UIImage imageNamed:@"avatar"];
            cell.model.Photo = UIImagePNGRepresentation(img);
        }
        
        //切换档案 清除 中医体质页 缓存
        if (![member.currentUserArchives.ArchivesID isEqual:cell.model.ArchivesID]) {
            [[AppCacheManager sharedAppCacheManager] setAppCache:nil forKey:kHealthTestKey];
        }
        
        [MemberManager sharedInstance].currentUserArchives = cell.model;
        [[AppCacheManager sharedAppCacheManager] setAppCache:[NSString stringWithFormat:@"%@",cell.model.ArchivesID] forKey:KCurrentID];
        
        [self.navigationController popViewControllerAnimated:YES];
    }else if (tag == 102){
        self.delectCell = cell;
        XYAlertView *contentView = [[XYAlertView alloc]init];
        self.contentView = contentView;
        contentView.height = 190;
        [self.view addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        contentView.titleLabel.text = @"系统提示";
        contentView.msgLabel.text = @"确定删除档案吗?";
        contentView.buttonsArray = @[@"取消",@"确定"];
        
        UIButton * cancelButton = contentView.realButtons[0];
        UIButton * okButton = contentView.realButtons[1];
        cancelButton.tag = 2001;
        okButton.tag = 2002;
        [cancelButton addTarget:self action:@selector(didClickOKBtn:) forControlEvents:UIControlEventTouchDown];
        [okButton addTarget:self action:@selector(didClickOKBtn:) forControlEvents:UIControlEventTouchDown];

    }else if (tag == 103){
        WS(ws);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择头像来源" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        // 照相机
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                SKFCamera *homec=[[SKFCamera alloc]init];
                __weak typeof(self)myself=self;
                homec.fininshcapture=^(UIImage *img){
                    if (img) {
                        [cell.photoIcon setImage:img forState:UIControlStateNormal];
                        
//                        UIImage *image = [UIImage imageWithData: imageData];
                        //UIImage转换为NSData
                        NSData *imageData = UIImagePNGRepresentation(img);
                        cell.model.Photo = imageData;
                        [member.archives_DBController updateRecord:cell.model];
                        
                        if ([cell.model.ArchivesID isEqual:member.currentUserArchives.ArchivesID]) {
                            member.currentUserArchives.Photo = imageData;
                            
                        }
                        DMLog(@"照片存在");
                    }
                } ;
                [myself presentViewController:homec animated:NO completion:^{}];}
            
        }];
        [alertController addAction:cameraAction];
        
        // 本地相册
        UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"本地相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[PhotoManager getInstance] setShuping];
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = ws;
            imagePicker.allowsEditing = NO;
            imagePicker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
            [ws presentViewController:imagePicker animated:YES completion:nil];
            
        }];
        [alertController addAction:galleryAction];
        
        // 取消
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:action1];
        alertController.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController *popPresenter = alertController.popoverPresentationController;
        popPresenter.sourceView = self.view;
        popPresenter.sourceRect = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
        [self presentViewController:alertController animated:YES completion:nil];
    }
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = nil;
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        img = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:img];
    cropController.delegate = self;
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self presentViewController:cropController animated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
    [[PhotoManager getInstance] setHengping];
    [self.selectCell.photoIcon setImage:image forState:UIControlStateNormal];
    NSData *imageData = UIImagePNGRepresentation(image);
    self.selectCell.model.Photo = imageData;
    [member.archives_DBController updateRecord:self.selectCell.model];
    
    if ([self.selectCell.model.ArchivesID isEqual:member.currentUserArchives.ArchivesID]) {
        member.currentUserArchives.Photo = imageData;
    }
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[PhotoManager getInstance] setHengping];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray<ArchivesModel *> *)ArchivesArray{
    if (_ArchivesArray != nil) {
        return _ArchivesArray;
    }
    _ArchivesArray = member.ArchivesArray;

    return _ArchivesArray;
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
