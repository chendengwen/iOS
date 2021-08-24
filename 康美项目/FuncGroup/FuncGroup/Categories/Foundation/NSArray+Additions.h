//
//  NSArray+Additions.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Additions)

/**
 @brief 返回数组第一个元素
 
 @return 数组第一个元素
 */
- (id)firstObject;
/**
 @brief 根据给定索引值，安全获取数组里的元素，index越界时返回nil，不会造成crash
 
 @param index 元素索引值
 
 @return 指定索引的元素
 */
- (id)safeGetObjectAtIndex:(NSUInteger)index;
/*!
 @brief     指定两端索引，返回一个新的子数组，会判断传入参数的合理性
 @param     fromIndex 起始点
 @param     toIndex 结束点
 @return    原数组的子数组
 */
- (NSArray *)subarrayFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

/*!
 @brief     将传入的参数合并到数组，如果传入的是一个数组，将展开一次。该方法来自js的array.concat方法, 注意需要以nil结尾
 @code
 NSArray *originalArray = @[@1,@2,@3];
 NSArray *resultArray = [originalArray concat:@2,@"asdf",@{@"1" : @"2"}, @[@"a",@"b", @[@"c",@"d"]], nil];
 //resultArray = @[@1,@2,@3,@2,@"asdf",@{@"1" : @"2"}, @"a", @"b", @[@"c",@"d"]];
 @endcode
 @param     obj 传入要合并的对象
 @return    合并后的数组
 */
- (NSArray *)concatWithObjects:(id)obj, ... NS_REQUIRES_NIL_TERMINATION;
/*!
 @brief     将传入的数组合并到数组，如果数组的子元素是一个数组，将展开一次。
 @param     concatArray 传入要合并的数组
 @return    合并后的数组
 */
- (NSArray *)concatWithArray:(NSArray *)concatArray;

#if NS_BLOCKS_AVAILABLE

/*!
 @brief 遍历数组查找元素并返回, 注意数组不可变
 */
- (id)find:(BOOL (^)(id obj))block;
/*!
 @brief 遍历数组执行block, 注意数组不可变
 */
- (void)each:(void (^)(id obj))block;
/*!
 @brief     根据给定block对当前数组元素进行处理，返回处理之后的新数组，多用于根据原数组生成一套新的数组
 @param     block 处理数组元素的块
 */
- (NSArray *)map:(id (^)(id obj, NSUInteger idx))block;
/*!
 @brief 遍历数组找到符合条件的元素并返回新数组, 如果没有找到任何数据, 则返回空数组, 注意数组不可变
 */
- (NSArray *)filter:(BOOL (^)(id obj))block;
/*!
 @brief     根据给定的block和合并连接字符串返回合并的字符串，
 该函数是对 componentsJoinedByString: 的扩展，------ 用于数组元素不是NSString成员的时候
 @param     separator 合并数组元素的连接字符
 @param     block 处理数组元素的块
 */
- (NSString *)componentsJoinedByString:(NSString *)separator withBlock:(NSString *(^)(id obj))block;



/*!
 @brief     ascii码排序
 @return    排序后拼接
 */
- (NSString *)sortByASCII;

#endif

@end


@interface NSMutableArray (UtilsExtras)
/**
 @brief 移除数组最后的元素并返回该元素
 
 @return 数组最后的元素
 */
- (id)pop;
/**
 @brief 移除第一个元素并返回该元素
 
 @return 第一个元素
 */
- (id)shift;
/**
 @brief 安全添加对象，加入数组之前验证对象是否为nil
 
 @param anObject 需要添加的对象
 */
- (void)safeAddObject:(id)anObject;
/*!
 @brief     当数据不为空、索引值正常时，
 Inserts a given object into the array's contents at a given index.
 @param     anObject 插入对象，为空时不处理
 @param     index 位置，大于count时不做处理
 */
- (void)safelyInsertObject:(id)anObject atIndex:(NSUInteger)index;
/*!
 @brief     将数组中指定位置的元素移动到新的位置
 @param     fromIndex 要挪动的元素索引
 @param     toIndex 元素新位置索引
 */
- (void)moveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
@end

