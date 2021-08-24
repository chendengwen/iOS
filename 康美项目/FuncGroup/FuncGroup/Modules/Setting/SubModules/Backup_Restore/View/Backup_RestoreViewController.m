//
//  Backup_RestoreViewController.m
//  FuncGroup
//
//  Created by gary on 2017/2/13.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "Backup_RestoreViewController.h"
#import "UUID.h"

@interface Backup_RestoreViewController ()
{
    NSDateFormatter *_formatter;
}
@property (weak, nonatomic) IBOutlet UILabel *deviceCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastBackupTimeLabel;


@end

@implementation Backup_RestoreViewController

- (void)dealloc
{
    [BackupRestoreInteractor sharedBackupRestoreInteractor].delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self layoutNaviBarViewWithTitle:@"备份与还原"];
    self.deviceCodeLabel.text = [UUID readUUIDFromKeyChain];
    
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [_formatter stringFromDate:[[BackupRestoreInteractor sharedBackupRestoreInteractor] lastBackupDate]];
    self.lastBackupTimeLabel.text = [NSString stringWithFormat:@"上次备份时间：%@",dateStr];
    
    [BackupRestoreInteractor sharedBackupRestoreInteractor].delegate = self;
}


#pragma mark === ButtonClick
- (IBAction)backupButtonClicked:(id)sender {
    [[BackupRestoreInteractor sharedBackupRestoreInteractor] backupLocalData];
}

- (IBAction)restoreButtonClicked:(id)sender {
    [[BackupRestoreInteractor sharedBackupRestoreInteractor] restoreLocalData];
}

#pragma mark === BackupRestoreOperProtocol
-(void)backupSuccessed{
    [SVProgressHUD showSuccessWithStatus:@"数据备份成功"];
    
    NSString *dateStr = [_formatter stringFromDate:[[BackupRestoreInteractor sharedBackupRestoreInteractor] lastBackupDate]];
    self.lastBackupTimeLabel.text = [NSString stringWithFormat:@"上次备份时间：%@",dateStr];
}

-(void)backupFailed{
    [SVProgressHUD showErrorWithStatus:@"数据备份失败"];
}

-(void)restoreSuccessed{
    [SVProgressHUD showSuccessWithStatus:@"数据还原成功"];
}

-(void)restoreFailed{
    [SVProgressHUD showErrorWithStatus:@"数据还原失败"];
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
