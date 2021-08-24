//
//  DictionarySearchTool.m
//  FuncGroup
//
//  Created by zhong on 2017/2/27.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "DictionarySearchTool.h"

@interface DictionarySearchTool ()

@property (nonatomic,strong) NSDictionary *Dictionary;

@property (nonatomic,strong) NSDictionary *OptionDic;

@end

@implementation DictionarySearchTool
+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

//- (ArchivesModel *)archivesModel{
//    if (_archivesModel != nil) {
//        return _archivesModel;
//    }
//
//    _archivesModel = [[ArchivesModel alloc]init];
//    return _archivesModel;
//}

- (NSString *)searchDictionary:(CellModel *)model{
    return [self searchDictionary:model.title andKey:model.currentValue];
}

- (NSString *)searchDictionary:(NSString *)title andKey:(NSString *)key{
    
    return self.Dictionary[title][key];
}

- (NSArray *)getArrayForKey:(NSString *)key{
    return self.OptionDic[key];
}

- (NSInteger)searchIndexForKey:(NSString *)key andValue:(NSString *)value{
    NSArray *array = self.OptionDic[key];
    
    for (int i = 0; i < array.count; i++) {
        NSString *str = [array objectAtIndex:i];
        if ([str isEqualToString:value]) {
            return i;
        }
    }
    return 0;
}

- (NSString *)searchKeyWithTitle:(NSString *)title andValue:(NSString *)value{
    NSDictionary *dic = self.Dictionary[title];
    NSArray *keyArray = dic.allKeys;
    for (NSString *key in keyArray) {
        if ([dic[key] isEqualToString:value]) {
            return key;
        }
        
    }
    
    return 0;
}

- (NSDictionary *)OptionDic{
    if (_OptionDic != nil) {
        return _OptionDic;
    }
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc]init];
    mDic[@"性别"] = @[@"男",@"女"];
    mDic[@"民族"] = @[@"汉族",
                    @"蒙古族",
                    @"回族",
                    @"藏族",
                    @"维吾尔族",
                    @"苗族",
                    @"彝族",
                    @"壮族",
                    @"布依族",
                    @"朝鲜族",
                    @"满族",
                    @"侗族",
                    @"瑶族",
                    @"白族",
                    @"土家族",
                    @"哈尼族",
                    @"哈萨克族",
                    @"傣族",
                    @"黎族",
                    @"傈僳族",
                    @"佤族",
                    @"畲族",
                    @"高山族",
                    @"拉祜族",
                    @"水族",
                    @"东乡族",
                    @"纳西族",
                    @"景颇族",
                    @"柯尔克孜族",
                    @"土族",
                    @"达斡尔族",
                    @"仫佬族",
                    @"羌族",
                    @"布朗族",
                    @"撒拉族",
                    @"毛南族",
                    @"仡佬族",
                    @"锡伯族",
                    @"阿昌族",
                    @"普米族",
                    @"塔吉克族",
                    @"怒族",
                    @"乌兹别克族",
                    @"俄罗斯族",
                    @"鄂温克族",
                    @"德昂族",
                    @"保安族",
                    @"裕固族",
                    @"京族",
                    @"塔塔尔族",
                    @"独龙族",
                    @"鄂伦春族",
                    @"赫哲族",
                    @"门巴族",
                    @"珞巴族",
                    @"基诺族"];
    mDic[@"户籍类型"] = @[@"本地户籍",@"外地户籍",@"未知"];
    mDic[@"婚姻状态"] = @[@"未婚",@"已婚",@"丧偶",@"其他"];
    mDic[@"血型"] = @[@"A型",@"B型",@"O型",@"AB型",@"未知"];
    mDic[@"职业"] = @[@"国家机关,党群组织,企业,事业单位负责人",@"专业技术人员",@"办事人员和有关人员",@"商业,服务业人员",@"农,林,牧,渔,水利业生产人员",@"生产,运输设备操作人员及有关人员",@"军人",@"不便分类的其他从业人员",@"其他",@"未知"];
    mDic[@"文化程度"] = @[@"文盲及半文盲",@"小学",@"初中",@"高中",@"技工学校",@"中等专业学校",@"大学专科和专科学校",@"大学本科",@"研究生",@"未知"];
    mDic[@"RH类型"] = @[@"RH阳性",@"RH阴性",@"未知"];
    mDic[@"既往病史"] = @[@"无",@"高血压",@"糖尿病",@"冠心病",@"慢性阻塞性肺疾病",@"恶性肿瘤",@"脑卒中",@"重性精神疾病",@"结核病",@"肝脏疾病",@"先天畸形",@"职业病",@"肾脏疾病",@"贫血",@"其他法定传染病",@"其他"];
    mDic[@"药物过敏"] = @[@"无",@"青霉素",@"磺胺",@"链霉素",@"其他"];
    mDic[@"暴露史"] = @[@"无",@"化学品",@"毒物",@"射线",@"其他"];
    mDic[@"启用状态"] = @[@"不启用",@"启用"];
    
    _OptionDic = mDic.copy;
    return _OptionDic;
}

- (NSDictionary *)Dictionary{
    if (_Dictionary != nil) {
        return _Dictionary;
    }
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc]init];
    mDic[@"性别"] = @{@"男":@"1",@"女":@"2"};
    mDic[@"民族"] = @{@"汉族":@"1",
                    @"蒙古族":@"2",
                    @"回族":@"3",
                    @"藏族":@"4",
                    @"维吾尔族":@"5",
                    @"苗族":@"6",
                    @"彝族":@"7",
                    @"壮族":@"8",
                    @"布依族":@"9",
                    @"朝鲜族":@"10",
                    @"满族":@"11",
                    @"侗族":@"12",
                    @"瑶族":@"13",
                    @"白族":@"14",
                    @"土家族":@"15",
                    @"哈尼族":@"16",
                    @"哈萨克族":@"17",
                    @"傣族":@"18",
                    @"黎族":@"19",
                    @"傈僳族":@"20",
                    @"佤族":@"21",
                    @"畲族":@"22",
                    @"高山族":@"23",
                    @"拉祜族":@"24",
                    @"水族":@"25",
                    @"东乡族":@"26",
                    @"纳西族":@"27",
                    @"景颇族":@"28",
                    @"柯尔克孜族":@"29",
                    @"土族":@"30",
                    @"达斡尔族":@"31",
                    @"仫佬族":@"32",
                    @"羌族":@"33",
                    @"布朗族":@"34",
                    @"撒拉族":@"35",
                    @"毛南族":@"36",
                    @"仡佬族":@"37",
                    @"锡伯族":@"38",
                    @"阿昌族":@"39",
                    @"普米族":@"40",
                    @"塔吉克族":@"41",
                    @"怒族":@"42",
                    @"乌兹别克族":@"43",
                    @"俄罗斯族":@"44",
                    @"鄂温克族":@"45",
                    @"德昂族":@"46",
                    @"保安族":@"47",
                    @"裕固族":@"48",
                    @"京族":@"49",
                    @"塔塔尔族":@"50",
                    @"独龙族":@"51",
                    @"鄂伦春族":@"52",
                    @"赫哲族":@"53",
                    @"门巴族":@"54",
                    @"珞巴族":@"55",
                    @"基诺族":@"56"};
    mDic[@"户籍类型"] = @{@"本地户籍":@"1",@"外地户籍":@"2",@"未知":@""};
    mDic[@"婚姻状态"] = @{@"未婚":@"10",@"已婚":@"20",@"丧偶":@"30",@"其他":@"90"};
    mDic[@"血型"] = @{@"A型":@"1",@"B型":@"2",@"O型":@"3",@"AB型":@"4",@"未知":@"5"};
    mDic[@"职业"] = @{@"国家机关,党群组织,企业,事业单位负责人":@"0",@"专业技术人员":@"1/2",@"办事人员和有关人员":@"3",@"商业,服务业人员":@"4",@"农,林,牧,渔,水利业生产人员":@"5",@"生产,运输设备操作人员及有关人员":@"6",@"军人":@"X",@"不便分类的其他从业人员":@"Y",@"其他":@"",@"未知":@""};
    mDic[@"文化程度"] = @{@"文盲及半文盲":@"90",@"小学":@"80",@"初中":@"70",@"高中":@"60",@"技工学校":@"50",@"中等专业学校":@"40",@"大学专科和专科学校":@"30",@"大学本科":@"20",@"研究生":@"10",@"其他":@"",@"未知":@""};
    mDic[@"RH类型"] = @{@"RH阳性":@"2",@"RH阴性":@"1",@"未知":@"3"};
    mDic[@"既往病史"] = @{@"无":@"1",@"高血压":@"2",@"糖尿病":@"3",@"冠心病":@"4",@"慢性阻塞性肺疾病":@"5",@"恶性肿瘤":@"6",@"脑卒中":@"7",@"重性精神疾病":@"8",@"结核病":@"9",@"肝脏疾病":@"10",@"先天畸形":@"11",@"职业病":@"12",@"肾脏疾病":@"13",@"贫血":@"14",@"其他法定传染病":@"98",@"其他":@"99"};
    mDic[@"药物过敏"] = @{@"无":@"",@"青霉素":@"101",@"磺胺":@"102",@"链霉素":@"103",@"其他":@"199"};
    mDic[@"暴露史"] = @{@"无":@"1",@"化学品":@"2",@"毒物":@"3",@"射线":@"4",@"其他":@"9"};
    mDic[@"启用状态"] = @{@"不启用":@"0",@"启用":@"1"};
    _Dictionary = mDic.copy;
    return  _Dictionary;
}



@end
