//
//  AccountSetOperation.m
//  FuncGroup
//
//  Created by gary on 2017/2/10.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "AccountSetOperation.h"

@implementation AccountSetOperation

-(void)getAccountData{
    [self getAccountDataOperation];
}

-(void)setAccountData:(NSDictionary *)accountData{
    
    
    
    [self setAccountDataOperation:accountData];
}

#pragma mark === getAccountDataOperation  请求操作
-(void)getAccountDataOperation{
    
    if (/* DISABLES CODE */ (1)) {
        // 请求成功
        [self.handler getAccountDataSuccessed:@{}];
    }else {
        // 请求失败
        [self.handler getAccountDataFailed:@{}];
    }
        
}

-(void)setAccountDataOperation:(NSDictionary *)accountData{
    if (/* DISABLES CODE */ (1)) {
        // 请求成功
        [self.handler setAccountDataSuccessed:@{}];
    }else {
        // 请求失败
        [self.handler setAccountDataFailed:@{}];
    }
}

@end
