//
//  Person.h
//  006--KVO
//
//  Created by H on 2017/5/8.
//  Copyright © 2017年 TZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject{
    @public
    NSString * name;
}

@property(assign,nonatomic)int age;
@end
