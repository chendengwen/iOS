//
//  UserModel.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCodingModel.h"

@interface UserModel : BaseCodingModel

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,copy) NSString *phoneNum;

@property (nonatomic,copy) NSString *password;

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *idCard;

@property (nonatomic,copy) NSNumber *sex;




@end
