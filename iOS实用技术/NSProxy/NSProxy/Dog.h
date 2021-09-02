//
//  CLPersion.h
//  Test
//
//  Created by gary on 2021/6/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Dog : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic) int age;

-(NSString *)barking:(NSInteger)months;

@end

NS_ASSUME_NONNULL_END
