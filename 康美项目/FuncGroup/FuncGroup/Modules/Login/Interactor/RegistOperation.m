//
//  RegistOperation.m
//  FuncGroup
//
//  Created by gary on 2017/2/14.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "RegistOperation.h"
#import "AppCacheManager.h"
#import "UserCacheManager.h"
#import "NSString+Additions.h"

//NSString *const RegistError_NoPhoneNum           = @"请输入手机号码";
//NSString *const RegistError_NoPassword           = @"请输入密码";
//NSString *const RegistError_UnValidPhoneNum      = @"请输入正确格式的手机号码";
//NSString *const RegistError_UnValidPassword      = @"密码格式错误：\n请输入6-20位字符或数字";
//NSString *const RegistError_NotEquelPassword     = @"两次密码不一致";
//NSString *const RegistError_NoCardID             = @"请输入密码身份证号";
//NSString *const RegistError_NoVerifyNum          = @"请输入验证码";

@implementation RegistOperation

#pragma mark === Private Method
-(void)registOperate:(NSString *)phoneNum password:(NSString *)psd rePsd:(NSString *)rePsd verifyNum:(NSString *)verifyNum{
    NSString *reactState;
    if (![phoneNum isMobileNumber]) {
        reactState = NSLocalizedStringFromTable(@"RegistError_UnValidPhoneNum", @"LocalLanguage", nil);
    }else if (![psd isValidPassword]) {
        reactState = NSLocalizedStringFromTable(@"RegistError_UnValidPassword", @"LocalLanguage", nil);
    }else if (![psd isEqualToString:rePsd]) {
        reactState = NSLocalizedStringFromTable(@"RegistError_NotEquelPassword", @"LocalLanguage", nil);
    }else if (StringWithValue(verifyNum)) {
        reactState = NSLocalizedStringFromTable(@"RegistError_NoVerifyNum", @"LocalLanguage", nil);
    }else {
        reactState = nil;
    }
    
    if (reactState) {
        [self.handler registStateReacte:reactState];
    }else {
        [self beginRegistOperation:phoneNum password:psd rePsd:rePsd verifyNum:verifyNum];
    }
}

-(void)getRegistVetifyCode:(NSString *)phoneNum{
    if (![phoneNum isMobileNumber]) {
        [self.handler getRegistVeriyfCodeFailed:NSLocalizedStringFromTable(@"RegistError_UnValidPhoneNum", @"LocalLanguage", nil)];
    }else {
        [self beginGetRegistVetifyCode:phoneNum];
    }
}

#pragma mark === RegistOperation
// 做注册请求
-(void)beginRegistOperation:(NSString *)phoneNum password:(NSString *)psd rePsd:(NSString *)rePsd verifyNum:(NSString *)verifyNum{
    
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:3];
    [params addObject:phoneNum];
    [params addObject:verifyNum];
    [params addObject:psd];
    
    [[AFNetworkManager sharedAFNetworkManager] GetRequestUrl:[URLs getFullLoginsAPI:fuc_registAuth] parametersArr:params successBlock:^(JsonResult *result) {
        [self registSuccessed:result];
    } failBlock:^(JsonResult *result) {
        [self registFailed:result];
    }];
}

-(void)beginGetRegistVetifyCode:(NSString *)phoneNum{
    
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:2];
    [params addObject:phoneNum];
    [params addObject:@"86"];
    
    [[AFNetworkManager sharedAFNetworkManager] GetRequestUrl:[URLs getFullLoginsAPI:get_verifyCode_regist] parametersArr:params successBlock:^(JsonResult *result) {
        [self.handler getRegistVeriyfCodeSuccessed:@"验证码发送成功"];
    } failBlock:^(JsonResult *result) {
        [self.handler getRegistVeriyfCodeFailed:result.msg];
    }];
}

-(void)registSuccessed:(JsonResult *)result{
    // 保存用户数据  保存缓存
    [[AppCacheManager sharedAppCacheManager] setAppCache:@(AppStateLogined) forKey:kAppStatus];
    
    
    // 界面处理
    [self.handler registSuccessed:@{@"success":@(YES)}];
}

-(void)registFailed:(JsonResult *)result{
    [self.handler registFailed:@{@"success":@(NO),@"msg":result.msg}];
}





@end
