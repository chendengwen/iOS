//
//  LoginOperation.m
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "LoginOperation.h"
#import "AppCacheManager.h"
#import "UserCacheManager.h"
#import "RegistOperation.h"
#import "NSString+Additions.h"

@implementation LoginOperation

-(void)loginOperate:(NSString *)phoneNum password:(NSString *)psd{
    NSString *reactState;
    if (![phoneNum isMobileNumber]) {
        reactState = NSLocalizedStringFromTable(@"RegistError_UnValidPhoneNum", @"LocalLanguage", nil);
    }else if (StringWithValue(psd)) {
        reactState = NSLocalizedStringFromTable(@"LoginError_NoPassword", @"LocalLanguage", nil);
    }else if (![psd isValidPassword]) {
        reactState = NSLocalizedStringFromTable(@"RegistError_UnValidPassword", @"LocalLanguage", nil);
    }else {
        reactState = nil;
    }
    
    if (reactState) {
        [self.loginInHandler loginStateReacte:reactState];
    }else {
        [self beginLoginOperation:phoneNum password:psd];
    }
}

#pragma mark === LoginInOperation
// 做登录请求
-(void)beginLoginOperation:(NSString *)phoneNum password:(NSString *)psd{
//    [self successed:nil phoneNum:phoneNum password:psd];
//    return;
    // 请求
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:2];
    [params addObject:phoneNum];
    [params addObject:psd];
//    [params addObject:@"86"];
    
    [[AFNetworkManager sharedAFNetworkManager] GetRequestUrl:[URLs getFullLoginsAPI:fuc_loginAuth] parametersArr:params successBlock:^(JsonResult *result) {
        [self successed:nil phoneNum:phoneNum password:psd];
    } failBlock:^(JsonResult *result) {
        [self failed:result];
    }];
}

-(void)successed:(JsonResult *)result phoneNum:(NSString *)phoneNum password:(NSString *)psd{
    // 保存用户数据  保存缓存
    [[AppCacheManager sharedAppCacheManager] setAppCache:@(AppStateLogined) forKey:kAppStatus];
    [[AppCacheManager sharedAppCacheManager] setAppCache:@{kLastAccount:phoneNum,kLastPsd:psd}];
    
    // 界面处理
    [self.loginInHandler loginSuccessed:@{@"success":@(YES)}];
}

-(void)failed:(JsonResult *)result{
    
    [self.loginInHandler loginFailed:@{@"success":@(NO),@"msg":result.msg}];
}


#pragma mark === LoginOutOperation
-(void)loginOutOperate{
    
    [self loginOutSuccessed:nil];
    return;
    
//    NSMutableArray *params = [NSMutableArray arrayWithCapacity:3];
//    
//    [[AFNetworkManager sharedAFNetworkManager] GetRequestUrl:[URLs getFullLoginsAPI:fuc_loginAuth] parametersArr:params successBlock:^(JsonResult *result) {
//        [self loginOutSuccessed:result];
//    } failBlock:^(JsonResult *result) {
//        [self loginOutFailed:result];
//    }];
}

-(void)loginOutSuccessed:(JsonResult *)result{
    // 修改状态和清理用户数据
    [[AppCacheManager sharedAppCacheManager] setAppCache:@(AppStateUnlogin) forKey:kAppStatus];
    [[UserCacheManager sharedUserCacheManager] clearUserData];
    member.currentUserArchives = nil;
    // 界面处理
    [self.loginOutHandler loginOutSuccessed:@{@"success":@(YES)}];
}

-(void)loginOutFailed:(JsonResult *)result{
    [self.loginOutHandler loginOutFailed:@{@"success":@(NO),@"msg":result.msg}];
}

#pragma mark === ForgetPasswordOperation
-(void)beginGetForgetPasswordVetifyCode:(NSString *)phoneNum block:(result)block{
    
    if (![phoneNum isMobileNumber]) {
        [self.forgetPsdHandler fixPasswordStateReacte:NSLocalizedStringFromTable(@"RegistError_UnValidPhoneNum", @"LocalLanguage", nil)];;
    }else {
        [[AFNetworkManager sharedAFNetworkManager] GetRequestUrl:[URLs getFullLoginsAPI:get_verifyCode_forgetPassword] parametersArr:@[phoneNum] successBlock:^(JsonResult *result) {
            block(YES,result.msg);
        } failBlock:^(JsonResult *result) {
            block(NO,result.msg);
        }];
    }
}

-(void)forgetPasswordOperate:(NSString *)phoneNum verifyCode:(NSString *)verifyCode password:(NSString *)psd cardID:(NSString *)cardID{
    
    NSString *reactState;
    if (![phoneNum isMobileNumber]) {
        reactState = NSLocalizedStringFromTable(@"RegistError_UnValidPhoneNum", @"LocalLanguage", nil);
    }else if (![psd isValidPassword]) {
        reactState = NSLocalizedStringFromTable(@"RegistError_UnValidPassword", @"LocalLanguage", nil);
    }else if (StringWithValue(verifyCode)) {
        reactState = NSLocalizedStringFromTable(@"LoginError_NoVerifyCode", @"LocalLanguage", nil);
    }else { 
        reactState = nil;
    }
    
    if (reactState) {
        [self.forgetPsdHandler fixPasswordStateReacte:reactState];
    }else {
        [self beginForgetPasswordOperation:phoneNum verifyCode:verifyCode password:psd];
    }
}

-(void)beginForgetPasswordOperation:(NSString *)phoneNum verifyCode:(NSString *)verifyCode password:(NSString *)psd{
    // 请求
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:3];
    [params addObject:phoneNum];
    [params addObject:verifyCode];
    [params addObject:psd];
    
    [[AFNetworkManager sharedAFNetworkManager] GetRequestUrl:[URLs getFullLoginsAPI:set_forgetPassword] parametersArr:params successBlock:^(JsonResult *result) {
        [self setPsdSuccessed:result];
    } failBlock:^(JsonResult *result) {
        [self setPsdFailed:result];
    }];
}

-(void)setPsdSuccessed:(JsonResult *)result{
    [self.forgetPsdHandler fixPasswordSuccessed:@{@"success":@(YES),@"msg":@"密码修改成功"}];
}

-(void)setPsdFailed:(JsonResult *)result{
    [self.forgetPsdHandler fixPasswordFailed:@{@"success":@(NO),@"msg":result.msg}];
}


#pragma mark === Other Func
+(void)savePsdYesOrNot:(BOOL)save{
    [[AppCacheManager sharedAppCacheManager] setAppCache:@(save) forKey:kPsdOff];
}

-(NSDictionary *)getLocalUserInfo{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    id<idAdditions> lastAccount = [[AppCacheManager sharedAppCacheManager] cacheForKey:kLastAccount];
    if (lastAccount != nil) {
        [dic setObject:lastAccount forKey:kLastAccount];
    }
    id<idAdditions> lastPsd = [[AppCacheManager sharedAppCacheManager] cacheForKey:kLastPsd];
    if (lastPsd != nil) {
        [dic setObject:lastPsd forKey:kLastPsd];
    }
    
    id<idAdditions> psdOff = [[AppCacheManager sharedAppCacheManager] cacheForKey:kPsdOff];
    if (psdOff != nil) {
        [dic setObject:psdOff forKey:kPsdOff];
    }
    
    return dic;
}


@end
