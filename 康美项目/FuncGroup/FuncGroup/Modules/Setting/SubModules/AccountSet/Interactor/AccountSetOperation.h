//
//  AccountSetOperation.h
//  FuncGroup
//
//  Created by gary on 2017/2/10.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AccountSetOperProtocol <NSObject>

-(void)getAccountDataSuccessed:(NSDictionary *)dataDictionay;

-(void)getAccountDataFailed:(NSDictionary *)dataDictionay;

-(void)setAccountDataSuccessed:(NSDictionary *)dataDictionay;

-(void)setAccountDataFailed:(NSDictionary *)dataDictionay;

@end

@interface AccountSetOperation : NSObject

@property (nonatomic,weak) id<AccountSetOperProtocol> handler;

-(void)getAccountData;

-(void)setAccountData:(NSDictionary *)accountData;

@end
