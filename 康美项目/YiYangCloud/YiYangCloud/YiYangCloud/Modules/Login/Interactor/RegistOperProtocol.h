//
//  RegistOperProtocol.h
//  FuncGroup
//
//  Created by gary on 2017/2/14.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RegistOperProtocol <NSObject>

-(void)registStateReacte:(NSString *)state;

-(void)registSuccessed:(NSDictionary *)dataDic;

-(void)registFailed:(NSDictionary *)dataDic;

-(void)getRegistVeriyfCodeSuccessed:(NSString *)message;

-(void)getRegistVeriyfCodeFailed:(NSString *)message;

@end
