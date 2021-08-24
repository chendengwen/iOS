//
//  ArchivesModel.m
//  FuncGroup
//
//  Created by zhong on 2017/2/28.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "ArchivesModel.h"
#import "NSObject+YYModel.h"

@implementation ArchivesModel

- (NSString *)getDataStr{
        NSString *dataStr = [NSString stringWithFormat:@"params=[{\"Patient\":{\"Name\":\"%@\",\"Sex\":\"%@\",\"Birthday\":\"%@\",\"Tel\":\"%@\",\"Job\":\"\",\"Domicile\":\"%@\",\"Address\":\"%@\",\"ArchiveDate\":\"%@\",\"Guardian\":\"%@\",\"Ethnic\":\"%@\",\"PermanentType\":\"%@\",\"Educational\":\"%@\",\"Marriage\":\"%@\",\"BloodType\":\"%@\",\"RH\":\"%@\",\"DrugAllergy\":\"%@\",\"OtherDrugAllergy\":\"%@\",\"Revealabliity\":\"%@\",\"OtherRevealabliity\":\"%@\",\"Doctor\":\"%@\",\"ArchiverManager\":\"%@\",\"Anamneses\":%@,\"Operations\":%@,\"Traumas\":%@,\"Transfutions\":%@,\"HeredityName\":\"%@\"},\"MachineNo\":\"%@\",\"IdCard\":\"%@\",\"ExamTime\":\"%@\",\"From\":\"KM900\"}]",self.Name,self.Sex,self.Birthday,self.Tel,self.Domicile,self.Address,self.ArchiveDate,self.Guardian,self.Ethnic,self.PermanentType,self.Educational,self.Marriage,self.BloodType,self.RH,self.DrugAllergy,self.OtherDrugAllergy,self.Revealabliity,self.OtherRevealabliity,self.Doctor,self.ArchiverManager,self.Anamneses,self.Operations,self.Traumas,self.Transfutions,self.HeredityName,self.MachineNo,self.IdCard,self.ExamTime];
    
    return dataStr;
}

#pragma mark === SqlStatement
+ (NSString *)getAllArchiveRecords{
    return @"select * from [ArchivesModel]"
    " ORDER BY [ExamTime] desc";
}

+ (NSString *)getCurrentUserArchive{
    return @"select * from [ArchivesModel]"
    " where ArchivesID = ? "
    " ORDER BY [ExamTime] desc";
}

+ (NSString *)getArchiveRecordsAgeIndex{
    return @"select * from [ArchivesModel]"
    " ORDER BY [ExamTime] desc"
    " limit 10 offset ?";
}

- (NSData *)Photo{
    if (_Photo.length > 0) {
        return _Photo;
    }
    
    _Photo = UIImagePNGRepresentation([UIImage imageNamed:@"avatar"]);
    return _Photo;
}

//- (id)copyWithZone:(NSZone *)zone { return [self modelCopy]; }

- (id)copyWithZone:(NSZone *)zone {
    ArchivesModel * stu = [ [ [ self class ] allocWithZone : zone ] init ] ;
    stu.ArchivesID = self.ArchivesID;
    stu.ArchiveDate = self.ArchiveDate;
    stu.Name = self.Name;
    stu.Sex = self.Sex;
    stu.IdCard = self.IdCard;
    
    stu.Birthday = self.Birthday;
    stu.Domicile = self.Domicile;
    stu.Ethnic = self.Ethnic;
    stu.Address = self.Address;
    stu.PermanentType = self.PermanentType;
    
    stu.Marriage = self.Marriage;
    stu.BloodType = self.BloodType;
    stu.Job = self.Job;
    stu.Educational = self.Educational;
    stu.RH = self.RH;
    
    stu.Tel = self.Tel;
    stu.Guardian = self.Guardian;
    stu.GuardianTel = self.GuardianTel;
    stu.DrugAllergy = self.DrugAllergy;
    stu.OtherDrugAllergy = self.OtherDrugAllergy;
    
    stu.Revealabliity = self.Revealabliity;
    stu.OtherRevealabliity = self.OtherRevealabliity;
    stu.Doctor = self.Doctor;
    stu.ArchiverManager = self.ArchiverManager;
    stu.MachineNo = self.MachineNo;
    
    stu.isOn = self.isOn;
    stu.Anamneses = self.Anamneses;
    stu.Anamneses_1 = self.Anamneses_1;
    stu.Anamneses_2 = self.Anamneses_2;
    stu.Anamneses_3 = self.Anamneses_3;
    
    stu.Anamneses_Date_1 = self.Anamneses_Date_1;
    stu.Anamneses_Date_2 = self.Anamneses_Date_2;
    stu.Anamneses_Date_3 = self.Anamneses_Date_3;
    stu.Operations = self.Operations;
    stu.Operations_1 = self.Operations_1;
    
    stu.Operations_2 = self.Operations_2;
    stu.Operations_Date_1 = self.Operations_Date_1;
    stu.Operations_Date_2 = self.Operations_Date_2;
    stu.Traumas = self.Traumas;
    stu.Traumas_1 = self.Traumas_1;
    
    stu.Traumas_2 = self.Traumas_2;
    stu.Traumas_Date_1 = self.Traumas_Date_1;
    stu.Traumas_Date_2 = self.Traumas_Date_2;
    stu.Transfutions = self.Transfutions;
    stu.Transfutions_1 = self.Transfutions_1;
    
    stu.Transfutions_2 = self.Transfutions_2;
    stu.Transfutions_Date_1 = self.Transfutions_Date_1;
    stu.Transfutions_Date_2 = self.Transfutions_Date_2;
    stu.HeredityName = self.HeredityName;
    stu.ExamTime = self.ExamTime;
    
    stu.State = self.State;
    stu.Photo = self.Photo;
    stu.physiqueTestKey = self.physiqueTestKey;
    return stu ;
}
@end
