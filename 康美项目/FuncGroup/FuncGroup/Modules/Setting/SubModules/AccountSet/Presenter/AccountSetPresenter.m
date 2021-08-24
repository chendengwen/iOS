//
//  AccountSetPresenter.m
//  FuncGroup
//
//  Created by gary on 2017/2/10.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "AccountSetPresenter.h"

@interface NSDictionary (SetPresenterAddition)

-(NSString *)lastKey;
-(NSString *)lastValue;

@end

@implementation NSDictionary (SetPresenterAddition)

-(NSString *)lastKey{
    NSString *lastkey = self.allKeys.lastObject;
    return lastkey;
}

-(NSString *)lastValue{
    NSString *lastkey = self.allKeys.lastObject;
    return [self objectForKey:lastkey];
}

@end


@implementation AccountSetPresenter

-(UIViewController *)getInterface{
    
    return [self accountSetViewController];
}

- (AccountSetViewController *)accountSetViewController{
    AccountSetViewController *vc = [[AccountSetViewController alloc] init];
    vc.presenter = self;
    self.interface = vc;
    
    return vc;
}


#pragma mark === AccountSetVCProtocol
-(void)accountSet:(NSDictionary *)name password:(NSDictionary *)psd newName:(NSDictionary *)newName newPassword:(NSDictionary *)newPSD rePSD:(NSDictionary *)rePSD realName:(NSDictionary *)realName cardIDNum:(NSDictionary *)idNum telephoneNum:(NSDictionary *)telephoneNum{
    NSString *errorTips = nil;
    if (StringWithValue([name lastValue])) {
        errorTips = [name lastKey];
    }else if (StringWithValue([psd lastValue])) {
        errorTips = [psd lastKey];
    }else if (StringWithValue([newName lastValue])) {
        errorTips = [newName lastKey];
    }else if (StringWithValue([newPSD lastValue])) {
        errorTips = [newPSD lastKey];
    }else if (StringWithValue([rePSD lastValue])) {
        errorTips = [rePSD lastKey];
    }else if (![[newPSD lastValue] isEqualToString:[rePSD lastValue]]) {
        errorTips = @"请确认两次输入的密码相同";
    }else if (StringWithValue([realName lastValue])) {
        errorTips = [realName lastKey];
    }else if (StringWithValue([idNum lastValue])) {
        errorTips = [idNum lastKey];
    }else if (StringWithValue([telephoneNum lastValue])) {
        errorTips = [telephoneNum lastKey];
    }
    
    if (errorTips != nil) {
        [SVProgressHUD showErrorWithStatus:errorTips];
    }else {
        [SVProgressHUD showWithStatus:@"数据加载中..."];
        AccountSetOperation *operation = [[AccountSetOperation alloc] init];
        operation.handler = self;
        [operation setAccountData:@{}];
    }
}

#pragma mark === AccountSetOperProtocol
-(void)getAccountDataSuccessed:(NSDictionary *)dataDictionay{
    [SVProgressHUD dismiss];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    // interface展示数据
    [self.interface performSelector:@selector(reloadData:) withObject:dataDictionay];
#pragma clang diagnostic pop
}

-(void)getAccountDataFailed:(NSDictionary *)dataDictionay{
    [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
}

-(void)setAccountDataSuccessed:(NSDictionary *)dataDictionay{
    [SVProgressHUD showSuccessWithStatus:@"设置成功"];
}

-(void)setAccountDataFailed:(NSDictionary *)dataDictionay{
    [SVProgressHUD showErrorWithStatus:@"设置失败"];
}

@end
