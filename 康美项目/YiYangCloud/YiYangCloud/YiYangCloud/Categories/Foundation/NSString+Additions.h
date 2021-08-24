//
//  NSString+Additions.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

//获取UUID
+ (NSString *)createUUID;

#pragma mark utils
//是否为空
- (BOOL)isEmpty;
//当前字符串是否只包含空白字符和换行符
- (BOOL)isWhitespaceAndNewlines;
/*!
 @brief     是否包含汉字
 @return    是否包含汉字
 */
- (BOOL)isContainChinese;
// 时间戳转指定格式字符串
- (NSString *)dateString;
// 默认时间戳转指定格式字符串
- (NSString *)defaultDateString;
//去除字符串前后的空白,包含换行符
- (NSString *)trim;
//去除字符串中所有空白
- (NSString *)removeWhiteSpace;
//将字符串以URL格式编码
- (NSString *)stringByUrlEncoding;
/**
 *  字符串URL解码
 *
 *  @return NSString
 */
- (NSString *)stringByUrlDecoding;
/*!
 @brief     大写第一个字符
 @return    格式化后的字符串
 */
- (NSString *)capitalize;
/*!
 @brief     小写第一个字符
 @return    格式化后的字符串
 */
- (NSString *)lowercaseFirstString;

/*!
 @brief     以,符号格式化拼接
 @return    拼接后的字符串
 */
- (NSString *)stringWithFormatSplice:(id)str_num;

- (NSArray *)stringComponentSeparatedByString:(NSString *)string;


//正则匹配, ios3.2+
#ifndef PAD_PADCocos2dMacro
- (BOOL)matches:(NSString *)pattern;
- (BOOL)matchesWithCaseInsensitive:(NSString *)pattern;

- (BOOL)isMobileNumber;
- (BOOL)isValidUsername;
//是否是正确的会员卡用户名
- (BOOL)isValidMemberCardUserName;
//判断是否是汉字
- (BOOL)isValidChineseName;
- (BOOL)isValidPassword;
//判断是否是整数
+ (BOOL)isPureInt:(NSString*)string;
/**
 *  判断字符串是否是emoji表情
 *
 *  @param string 判断的字符串
 *
 *  @return YES or NO
 */
+ (BOOL)isContainsEmoji:(NSString *)string;


#endif
//正则替换 ios4.0+
- (NSString *)stringByReplacingRegularString:(NSString *)regString withString:(NSString *)replaceString;

//以给定字符串开始,忽略大小写
- (BOOL)startsWith:(NSString *)str;
//以指定条件判断字符串是否以给定字符串开始
- (BOOL)startsWith:(NSString *)str Options:(NSStringCompareOptions) compareOptions;

/*!
 @brief 以给定字符串结束，忽略大小写
 @code
 BOOL isEnd = [@"asdf" endsWith:@"df"];
 @endcode
 @param str 给定字符串
 @return 是否以给定字符串结尾
 */
- (BOOL)endsWith:(NSString *)str;
/*!
 @brief 以指定条件判断字符串是否以给定字符串结尾
 @param str 给定字符串
 @param compareOptions NSStringCompareOptions 枚举值
 */
- (BOOL)endsWith:(NSString *)str Options:(NSStringCompareOptions)compareOptions;
/*!
 @brief 包含给定的字符串, 忽略大小写
 @param str 给定字符串
 */
- (BOOL)containsString:(NSString *)str;
//以指定条件判断是否包含给定的字符串
- (BOOL)containsString:(NSString *)str Options:(NSStringCompareOptions)compareOptions;
//判断字符串是否相同，忽略大小写
- (BOOL)equalsString:(NSString *)str;
//将字符串转换成NSDate
- (NSDate *)convertToCurrentDateWithFormat:(NSString *)format;
//将字符串转换成NSDate
- (NSDate *)convertToDateWithFormat:(NSString *)format;
//转换为url
- (NSURL *)convertToURL;
//判断一个字符串是否邮箱
- (BOOL)isEmailFormat;

//过滤掉字符串中指定字符
- (NSString *)filterString:(NSArray *)charArray;

//金额保留一位小数，无小数时显示整数
- (NSString *)moneyDot1Mask;
//电话号码处理 18612341234 -> 186****1234
- (NSString *)mobileMask;

/**
 *  判断手机号码
 */
-(BOOL) isValidateMobile:(NSString *)mobile;



//字符长度
- (int)bytesLength;

//字节长度（ascii与Unicode混编）
- (NSUInteger)unicodeLength;

- (NSUInteger)numberOfLines;

#pragma mark xml extensions
//编码与解码xml所用的字符串
+ (NSString *)encodeXMLCharactersIn : (NSString *)source;
+ (NSString *)decodeXMLCharactersIn : (NSString *)source;

#pragma mark Hashing
/**
 *  64位编码
 *
 *  @return <#return value description#>
 */
- (NSString *)base64Encoding;
/**
 *  64位解码
 *
 *  @return <#return value description#>
 */
- (NSString *)base64Decoding;

@property (nonatomic, readonly) NSString* md5Hash;
@property (nonatomic, readonly) NSString* sha1Hash;

#pragma mark url
- (NSString *)stringByAppendURLKey:(NSString *)keyName Parameter:(id)parameter;


@end


@interface NSMutableString (DDGUtilsExtras)

// append a parameter to an url
//注意未处理#号
- (NSMutableString *)appendURLKey:(NSString *)keyName Parameter:(id)parameter;

/**
 *  拼接字符串
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+ (NSMutableString *)appendStrings:(NSString *)string, ...;

@end
