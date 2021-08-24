//
//  NSEnumerator+Additions.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSEnumerator (Additions)

/*!
 @brief     使用block枚举NSEnumerator元素
 @param     block 枚举元素需要执行的block
 obj
 The element in the NSEnumerator.
 stop
 A reference to a Boolean value. The block can set the value to YES to stop further processing of the array.
 The stop argument is an out-only argument. You should only ever set this Boolean to YES within the Block.
 */
- (void)enumerateObjectsUsingBlock:(void (^)(id obj, BOOL *stop))block;

@end
