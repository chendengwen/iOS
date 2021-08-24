//
//  LoginProtocol.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginInOperProtocol <NSObject>

-(void)loginStateReacte:(NSString *)state;

-(void)loginSuccessed:(NSDictionary *)dataDic;

-(void)loginFailed:(NSDictionary *)dataDic;

@end


@protocol LoginOutOperProtocol <NSObject>

-(void)loginOutStateReacte:(NSString *)state;

-(void)loginOutSuccessed:(NSDictionary *)dataDic;

-(void)loginOutFailed:(NSDictionary *)dataDic;

@end

@protocol ForgetPsdOperProtocol <NSObject>

-(void)fixPasswordStateReacte:(NSString *)state;

-(void)fixPasswordSuccessed:(NSDictionary *)dataDic;

-(void)fixPasswordFailed:(NSDictionary *)dataDic;

@end
