//
//  ArchivesModel.h
//  FuncGroup
//
//  Created by zhong on 2017/2/28.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HealthModelProtocol.h"
#import "BaseCodingModel.h"

typedef NS_ENUM(NSInteger, ArchivesManagement_State) {
    ArchivesManagement_New,
    ArchivesManagement_Edit
};
@interface ArchivesModel : BaseCodingModel<HealthModelProtocol>
//档案ID
@property (nonatomic,assign) NSNumber *ArchivesID;
//姓名
@property (nonatomic,copy) NSString *Name;
//性别
@property (nonatomic,copy) NSString *Sex;
//身份证
@property (nonatomic,copy) NSString *IdCard;
//出生年月
@property (nonatomic,copy) NSString *Birthday;
//籍贯
@property (nonatomic,copy) NSString *Domicile;
//民族
@property (nonatomic,copy) NSString *Ethnic;
//居住地址
@property (nonatomic,copy) NSString *Address;
//户籍类型
@property (nonatomic,copy) NSString *PermanentType;
//婚姻状态
@property (nonatomic,copy) NSString *Marriage;

//血型
@property (nonatomic,copy) NSString *BloodType;
//职业
@property (nonatomic,copy) NSString *Job;
//文化程度
@property (nonatomic,copy) NSString *Educational;
//RH类型
@property (nonatomic,copy) NSString *RH;
//电话
@property (nonatomic,copy) NSString *Tel;
//监护人
@property (nonatomic,copy) NSString *Guardian;
//监护人电话
@property (nonatomic,copy) NSString *GuardianTel;
//药物过敏史
@property (nonatomic,copy) NSString *DrugAllergy;
//其他药物过敏
@property (nonatomic,copy) NSString *OtherDrugAllergy;
//暴露史
@property (nonatomic,copy) NSString *Revealabliity;

//其他暴露史
@property (nonatomic,copy) NSString *OtherRevealabliity;
//责任医师
@property (nonatomic,copy) NSString *Doctor;
//建档人员
@property (nonatomic,copy) NSString *ArchiverManager;
//建档时间
@property (nonatomic,copy) NSString *ArchiveDate;
//UUID
@property (nonatomic,copy) NSString *MachineNo;
//启用状态
@property (nonatomic,copy) NSString *isOn;
//既往病史
@property (nonatomic,copy) NSString *Anamneses;
//既往病史_1
@property (nonatomic,copy) NSString *Anamneses_1;
//既往病史_1_时间
@property (nonatomic,copy) NSString *Anamneses_Date_1;
//既往病史_2
@property (nonatomic,copy) NSString *Anamneses_2;

//既往病史_2_时间
@property (nonatomic,copy) NSString *Anamneses_Date_2;
//既往病史_2
@property (nonatomic,copy) NSString *Anamneses_3;
//既往病史_2_时间
@property (nonatomic,copy) NSString *Anamneses_Date_3;
//手术历史
@property (nonatomic,copy) NSString *Operations;
//手术历史_1
@property (nonatomic,copy) NSString *Operations_1;
//手术历史_1_时间
@property (nonatomic,copy) NSString *Operations_Date_1;
//手术历史_2
@property (nonatomic,copy) NSString *Operations_2;
//手术历史_2_时间
@property (nonatomic,copy) NSString *Operations_Date_2;
//外伤历史
@property (nonatomic,copy) NSString *Traumas;
//外伤历史_1
@property (nonatomic,copy) NSString *Traumas_1;

//外伤历史_1_时间
@property (nonatomic,copy) NSString *Traumas_Date_1;
//外伤历史_2
@property (nonatomic,copy) NSString *Traumas_2;
//外伤历史_2_时间
@property (nonatomic,copy) NSString *Traumas_Date_2;
//输血历史
@property (nonatomic,copy) NSString *Transfutions;
//输血历史_1
@property (nonatomic,copy) NSString *Transfutions_1;
//输血历史_1_时间
@property (nonatomic,copy) NSString *Transfutions_Date_1;
//输血历史_2
@property (nonatomic,copy) NSString *Transfutions_2;
//输血历史_2_时间
@property (nonatomic,copy) NSString *Transfutions_Date_2;
//遗传病史
@property (nonatomic,copy) NSString *HeredityName;
//最后修改时间
@property (nonatomic,copy) NSString *ExamTime;
//修改or编辑
@property (nonatomic,assign) ArchivesManagement_State State;
//用户头像的二进制数据
@property (nonatomic,strong) NSData *Photo;

//中医体质的key
@property (nonatomic,copy) NSString *physiqueTestKey;

- (NSString *)getDataStr;

#pragma mark === SqlStatement 查询语句
/*!
 @brief  当前所有用户的档案
 */
+ (NSString *)getAllArchiveRecords;

/*!
 @brief  当前用户的档案
 */
+ (NSString *)getCurrentUserArchive;

/*!
 @brief  当前用户的档案
 */
+ (NSString *)getArchiveRecordsAgeIndex;


@end
