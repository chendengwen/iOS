//
//  NSObject+Additions.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Block_Void)(void);

/*!
 @category  NSObject
 @brief     NSObject的扩展
 */
@interface NSObject (Additions)


/**
 *  获取对象的属性和值
 *
 *  @return 对象的属性和值
 */
- (NSDictionary *)getAllPropertiesAndVaules;

/*!
 @brief     用于向消息传入任意类型的参数
 @param     selector 需要执行的方法名
 @param     value 需要传入的参数类型
 @return    方法执行后的返回值，为任意类型， 使用需要转换
 @discussion 该方法可以传入任意类型的参数，也可以返回任意类型的参数。当有时候参数类型或者返回类型为基础数据类型时，可以使用该方法。
 使用时需要转换，完毕后需要<strong>使用free函数来释放返回值占用内存</strong>. <br />
 使用方法如下:<br />
 floatWithString:将字符串转换为float类型，stringWithInt:将int类型转换为字符串
 @code
 NSString *intStr = @"123.0";
 void *i = [self performSelector:@selector(floatWithString:) withValue:&intStr];
 CGFloat floatValue = *(CGFloat *)i;
 free(i);
 
 NSInteger strInt = 456;
 void *str = [self performSelector:@selector(stringWithInt:) withValue:&strInt];
 NSString *stringValue = *(NSString **)str;
 free(str);
 @endcode
 */
- (void *)performSelector:(SEL)selector withValue:(void *)value;

/*!
 @brief     performSelector:withObject:afterDelay:的简写，传入object参数为nil
 @param     selector A selector that identifies the method to invoke. The method should not have a significant return value
 and should take no arguments.
 @param     delay The minimum time before which the message is sent. Specifying a delay of 0 does not necessarily cause
 the selector to be performed immediately. The selector is still queued on the thread’s run loop and performed
 as soon as possible.
 */
- (void)performSelector:(SEL)selector afterDelay:(NSTimeInterval)delay;

#if NS_BLOCKS_AVAILABLE

/*!
 @brief     延时执行block
 @param     block 执行的block
 @param     delay 延时, 以秒为单位
 */
- (void)performBlock:(Block_Void)block afterDelay:(NSTimeInterval)delay;


#endif

@end
