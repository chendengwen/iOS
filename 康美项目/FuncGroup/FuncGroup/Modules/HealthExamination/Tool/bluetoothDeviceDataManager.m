//
//  bluetoothDeviceDataModel.m
//  FuncGroup
//
//  Created by zhong on 2017/2/16.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "bluetoothDeviceDataManager.h"
#import "KMNetAPI.h"
#import "DBHealthRecordController.h"

#define FILE_PATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject

@implementation bluetoothDeviceDataManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dbController = [DBHealthRecordController dbController];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetDBController) name:kNotificationReadBackup object:nil];
    }
    return self;
}

-(void)resetDBController{
    _dbController = [DBHealthRecordController dbController];
}

- (void)setTModel:(temperatureValueModel *)TModel{
    _TModel = TModel;
    _TModel.data = [self.format stringFromDate:[NSDate date]];
}

- (void)setBSModel:(BSValueModel *)BSModel{
    _BSModel = BSModel;
    _BSModel.data = [self.format stringFromDate:[NSDate date]];
}

- (void)setBPModel:(BPValueModel *)BPModel{
    _BPModel = BPModel;
    _BPModel.data = [self.format stringFromDate:[NSDate date]];
}

-(void)setType:(HealthRecordType)type{
    
    _type = type;
    _dbController.type = type;
}

//清楚数据
- (void)clearData{
    self.TModel = nil;
    self.BPModel = nil;
    self.BSModel = nil;
    self.BSmArray = nil;
    self.TmArray = nil;
    self.BPmArray = nil;    
}

//保存数据
- (void)saveData{
    //所有数据为空不上传\保存
    if (self.TModel == nil && self.BPModel == nil && self.BSModel == nil) {
        return;
    }
    ArchivesModel *model = member.currentUserArchives;
    //用户数据
    NSString *userStr = [NSString stringWithFormat:@"params=[{\"Patient\":{\"Name\":\"%@\",\"Sex\":\"%@\",\"Birthday\":\"%@\",\"Tel\":\"%@\",\"Job\":\"%@\",\"Domicile\":\"%@\",\"Address\":\"%@\",\"ArchiveDate\":\"%@\"},",model.Name,model.Sex,model.Birthday,model.Tel,model.Job,model.Domicile,model.Address,model.ArchiveDate];
    //量测数据
    NSMutableString *mDataStr = [[NSMutableString alloc]init];
    //基础数据
    NSString *deviceData = [NSString stringWithFormat:@"\"MachineNo\":\"%@\",\"IdCard\":\"%@\",\"ExamTime\":\"%@\"}]",model.MachineNo,model.IdCard,model.ExamTime];
    
    if (self.TModel != nil) {
        [_dbController insertRecord:self.TModel];
        [self.TmArray addObject:self.TModel];
        
//        NSDictionary *Tdic = [temperatureValueModel dicWithmodel:self.TModel];
//        [self.TmArray addObject:Tdic];
//        NSString *filePath = FILE_PATH;
//        filePath = [filePath stringByAppendingFormat:@"/%@_Temperature.plist",self.IdCard];
//        [self.TmArray writeToFile:filePath atomically:NO];
        [mDataStr appendFormat:@"\"Temperature\":{\"Temperature\":\"%1.f\"},",self.TModel.value];
    }
    
    if (self.BPModel != nil) {
        [_dbController insertRecord:self.BPModel];
        [self.BPmArray addObject:self.BPModel];
        
//        NSDictionary *BPdic = [BPValueModel dicWithmodel:self.BPModel];
//        [self.BPmArray addObject:BPdic];
//        NSString *filePath = FILE_PATH;
//        filePath = [filePath stringByAppendingFormat:@"/%@_BP.plist",self.IdCard];
//        [self.BPmArray writeToFile:filePath atomically:NO];
        [mDataStr appendFormat:@"\"BloodPressure\":{\"Systolic\":\"%zd\",\"Diastolic\":\"%zd\"},",self.BPModel.HBP,self.BPModel.LBP];
    }
    
    if (self.BSModel != nil) {
        [_dbController insertRecord:self.BSModel];
        [self.BSmArray addObject:self.BSModel];
        
//        NSDictionary *BSdic = [BSValueModel dicWithmodel:self.BSModel];
//        [self.BSmArray addObject:BSdic];
//        NSString *filePath = FILE_PATH;
//        filePath = [filePath stringByAppendingFormat:@"/%@_BS.plist",self.IdCard];
//        [self.BSmArray writeToFile:filePath atomically:NO];
        [mDataStr appendFormat:@"\"BloodGlucose\":{\"Glucose\":\"%.1f\"},",self.BSModel.value];
    }
    
    //上传数据
    NSString *requestUrl = [NSString stringWithFormat:@"http://%@/KM9000/upload",ServerAddress];
    //拼接数据
    NSString *dataStr = [NSString stringWithFormat:@"%@%@%@",userStr,mDataStr,deviceData];
    NSMutableData *postBody=[NSMutableData data];
    [postBody appendData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",requestUrl);
    [[KMNetAPI sharedInstance] postWithUrl:requestUrl body:postBody success:^(NSString *response) {
        DMLog(@"%@",response);
        if ([response containsString:@"成功"]) {
            [SVProgressHUD showSuccessWithStatus:@"量测数据上传成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"量测数据上传失败"];
        }
    } failure:^(NSError *error) {
          [SVProgressHUD showErrorWithStatus:@"量测数据上传失败"];
        DMLog(@"%@",error); 
    }];
    
}

#pragma mark - 读取历史数据
//血压历史数据
- (NSMutableArray *)BPmArray{
    if (_BPmArray != nil) {
        return _BPmArray;
    }
//    //保存路径
//    NSString *filePath = FILE_PATH;
//    filePath = [filePath stringByAppendingFormat:@"/%@_BP.plist",self.IdCard];
//    //读取
//    _BPmArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    _BPmArray = [NSMutableArray arrayWithArray:[_dbController getAllRecordByUID]];
    if (_BPmArray == nil) {
        _BPmArray = [NSMutableArray array];
    }
    
    return _BPmArray;
}
//血糖历史数据
- (NSMutableArray *)BSmArray{
    if (_BSmArray != nil) {
        return _BSmArray;
    }
//    //保存路径
//    NSString *filePath = FILE_PATH;
//    filePath = [filePath stringByAppendingFormat:@"/%@_BS.plist",self.IdCard];
//    
//    //读取
//    _BSmArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    _BSmArray = [NSMutableArray arrayWithArray:[_dbController getAllRecordByUID]];
    if (_BSmArray == nil) {
        _BSmArray = [NSMutableArray array];
    }
    return _BSmArray;
}
//温度历史数据
- (NSMutableArray *)TmArray{
    if (_TmArray != nil) {
        return _TmArray;
    }
//    //保存路径
//    NSString *filePath = FILE_PATH;
//    filePath = [filePath stringByAppendingFormat:@"/%@_Temperature.plist",self.IdCard];
//    
//    //读取
//    _TmArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    _TmArray = [NSMutableArray arrayWithArray:[_dbController getAllRecordByUID]];
    if (_TmArray == nil) {
        _TmArray = [NSMutableArray array];
    }
    
    return _TmArray;
}

- (NSDateFormatter *)format{
    if (_format != nil) {
        return _format;
    }
    _format = [[NSDateFormatter alloc]init];
    _format.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    return _format;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
