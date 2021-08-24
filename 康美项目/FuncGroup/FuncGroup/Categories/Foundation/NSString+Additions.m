//
//  NSString+Additions.m
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import "NSString+Additions.h"
#import "NSData+Additions.h"

@implementation NSString (Additions)

+ (NSString *)createUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    NSString *UUIDString = (__bridge NSString *)string;
    
    CFRelease(theUUID);
    CFRelease(string);
    
    return UUIDString;
}

#pragma mark - Utils
- (BOOL)isEmpty
{
    return self.length == 0;
}

- (BOOL)isWhitespaceAndNewlines
{
    NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i)
    {
        unichar c = [self characterAtIndex:i];
        if (![whitespace characterIsMember:c])
        {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isContainChinese
{
    if (self.length == 0) return NO;
    //    static NSUInteger hanziStart    = 19968;
    //    static NSUInteger hanziEnd      = 40869;
    for (NSUInteger i = 0,j = self.length; i < j; i++)
    {
        unichar c = [self characterAtIndex:i];
        if (c >= 19968 && c <= 40869) return YES;
    }
    return NO;
}

- (NSString *)dateString{
    NSDate *result = [NSDate dateWithTimeIntervalSince1970:self.longLongValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = ShortDateFormatString;
    
    return [dateFormatter stringFromDate:result];
}

- (NSString *)defaultDateString{
    NSDate *result = [NSDate dateWithTimeIntervalSince1970:self.longLongValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DefaultDateFormatString;
    
    return [dateFormatter stringFromDate:result];
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)removeWhiteSpace
{
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
            componentsJoinedByString:@""];
}

- (NSString *) stringByUrlEncoding
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                (CFStringRef)self,
                                                                NULL,
                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
}


- (NSString *)stringByUrlDecoding
{
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}


- (NSString *)capitalize
{
    if ([self length] == 0 || islower([self characterAtIndex:0]) == 0) return self;
    return [[self substringToIndex:1].uppercaseString stringByAppendingString:[self substringFromIndex:1]];
}

- (NSString *)lowercaseFirstString
{
    if ([self length] == 0 || isupper([self characterAtIndex:0]) == 0) return self;
    return [[self substringToIndex:1].lowercaseString stringByAppendingString:[self substringFromIndex:1]];
}

/*!
 @brief     以,符号格式化拼接
 @return    拼接后的字符串
 */
- (NSString *)stringWithFormatSplice:(id)str_num{
    if (self.length == 0) {
        return [NSString stringWithFormat:@"%@",str_num];
    }
    // 如果结尾是逗号
    else if ([[self substringWithRange:NSMakeRange(self.length - 1, 1)] isEqualToString:@","]){
        return [NSString stringWithFormat:@"%@%@",self,str_num];
    }
    // 如果结尾没有逗号
    else {
        return [NSString stringWithFormat:@"%@,%@",self,str_num];
    }
    
}

/*!
 @brief     以,符号格式化分割
 @return    拼分割后的数组
 */
-(NSArray *)stringComponentSeparatedByString:(NSString *)string{
    if (self.length > 0){
        return [self componentsSeparatedByString:string];
    }
    return nil;
}


#ifndef PAD_PADCocos2dMacro

- (BOOL)matches:(NSString *)pattern
{
    return [self rangeOfString:pattern options:NSRegularExpressionSearch].location != NSNotFound;
}

- (BOOL)matchesWithCaseInsensitive:(NSString *)pattern
{
    return [self rangeOfString:pattern
                       options:NSRegularExpressionSearch | NSCaseInsensitiveSearch].location != NSNotFound;
}

- (BOOL)isMobileNumber
{
    return [self matches:@"^1[34578]{1}\\d{9}$"];
}

- (BOOL)isValidUsername
{
    return [self matches:@"^[_a-zA-Z0-9\\u4e00-\\u9fa5]{4,16}$"];
}

- (BOOL)isValidMemberCardUserName
{
    return [self matches:@"^[_a-zA-Z_.\\u4e00-\\u9fa5]{1,16}$"];
}

- (BOOL)isValidChineseName
{
    return [self matches:@"^[\\u4e00-\\u9fa5]{1,6}$"];
}

- (BOOL)isValidPassword
{
    return [self matches:@"^[\\w^_]{6,20}$"];
}

//是否为整数
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isContainsEmoji:(NSString *)string
{
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         if ([substring unicodeLength] >2)
         {
             isEomji = YES;
         }
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff)
         {
             if (substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f)
                 {
                     isEomji = YES;
                 }
             }
         }
         else if (substring.length > 1)
         {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3)
             {
                 isEomji = YES;
             }
         }
         else
         {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b)
             {
                 isEomji = YES;
             }
             else if (0x2B05 <= hs && hs <= 0x2b07)
             {
                 isEomji = YES;
             }
             else if (0x2934 <= hs && hs <= 0x2935)
             {
                 isEomji = YES;
             }
             else if (0x3297 <= hs && hs <= 0x3299)
             {
                 isEomji = YES;
             }
             else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030
                      || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a )
             {
                 isEomji = YES;
             }
         }
     }];
    
    return isEomji;
}

#endif

- (NSString *)stringByReplacingRegularString:(NSString *)regString withString:(NSString *)replaceString
{
    NSError *error = nil;
    NSRegularExpression *regularExpression = [NSRegularExpression
                                              regularExpressionWithPattern:regString
                                              options:NSRegularExpressionCaseInsensitive
                                              error:&error];
    if (error)
    {
        // GVerboseLog(@"regular expression error: %@", [error localizedDescription]);
        return self;
    }
    
    return [regularExpression stringByReplacingMatchesInString:self
                                                       options:0
                                                         range:NSMakeRange(0, self.length)
                                                  withTemplate:replaceString];
    
}

- (BOOL)startsWith:(NSString *)str
{
    return [self startsWith:str Options:NSCaseInsensitiveSearch];
}

- (BOOL)startsWith:(NSString *)str Options:(NSStringCompareOptions) compareOptions
{
    //	NSParameterAssert(str != nil && [str length]>0 && [self length]>=[str length]);
    return (str != nil) && ([str length] > 0) && ([self length] >= [str length])
    && ([self rangeOfString:str options:compareOptions].location == 0);
}

- (BOOL)endsWith:(NSString *)str
{
    return [self endsWith:str Options:NSCaseInsensitiveSearch];
}
- (BOOL)endsWith:(NSString *)str Options:(NSStringCompareOptions) compareOptions
{
    //	NSParameterAssert(str != nil && [str length]>0 && [self length]>=[str length]);
    return (str != nil) && ([str length] > 0) && ([self length] >= [str length])
    && ([self rangeOfString:str
                    options:(compareOptions | NSBackwardsSearch)].location == ([self length] - [str length]));
}
- (BOOL)containsString:(NSString *)str
{
    return [self containsString:str Options:NSCaseInsensitiveSearch];
}

- (BOOL)containsString:(NSString *)str Options:(NSStringCompareOptions) compareOptions
{
    return (str != nil) && ([str length] > 0) && ([self length] >= [str length])
    && ([self rangeOfString:str options:compareOptions].location != NSNotFound);
}

- (BOOL)equalsString:(NSString *)str
{
    //	return (str != nil) && ([self length] == [str length]) && [[self lowercaseString] isEqualToString:[str lowercaseString]];
    return (str != nil) && ([self length] == [str length])
    && ([self rangeOfString:str options:NSCaseInsensitiveSearch].location == 0);
}

- (NSDate *)convertToCurrentDateWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateStyle:kCFDateFormatterFullStyle];
    //    formatter.timeZone = [NSTimeZone defaultTimeZone];
    formatter.locale  = [NSLocale currentLocale];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:self];
    return date;
}



- (NSDate *)convertToDateWithFormat:(NSString *)format
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateStyle:kCFDateFormatterFullStyle];
    //    formatter.timeZone = [NSTimeZone defaultTimeZone];
    formatter.locale  = [NSLocale currentLocale];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:self];
    return date;
}

- (NSURL *)convertToURL
{
    if (self.length)
        return [NSURL URLWithString:self];
    return nil;
}

- (BOOL)isEmailFormat
{
    //xxx@xxx.com(.cn)
    NSArray *breakArray = [self componentsSeparatedByString:@"@"];
    if ([breakArray count] != 2
        || ((NSString *)[breakArray objectAtIndex:0]).length == 0
        || ((NSString *)[breakArray objectAtIndex:1]).length == 0)
        return NO;
    
    NSString *string = [breakArray objectAtIndex:1];
    breakArray = [string componentsSeparatedByString:@"."];
    if (breakArray.count <= 1
        || ((NSString *)[breakArray objectAtIndex:0]).length == 0
        || ((NSString *)[breakArray objectAtIndex:1]).length == 0
        || ((NSString *)[breakArray objectAtIndex:(breakArray.count - 1)]).length == 0)
        return NO;
    
    return YES;
}

- (NSString *)moneyDot1Mask
{
    if (self == nil)
    {
        return @"0";
    }
    
    NSString *strPrice= @"";
    if ([self intValue] == [self floatValue])
    {
        strPrice = [NSString stringWithFormat:@"%d", [self intValue]];
    }
    else
    {
        strPrice = [NSString stringWithFormat:@"%.1f", [self floatValue]];
    }
    return strPrice;
}

- (NSString *)filterString:(NSArray *)charArray
{
    if (self == nil)
    {
        return @"";
    }
    
    NSString *resString = self;
    
    for (int i=0; i<[charArray count]; i++)
    {
        NSString *tempString = [charArray objectAtIndex:i];
        resString = [resString stringByReplacingOccurrencesOfString:tempString withString:@""];
    }
    return resString;
}

- (NSString *)mobileMask
{
    if (![self isMobileNumber]) return self;
    return [NSString stringWithFormat:@"%@****%@", [self substringToIndex:3], [self substringFromIndex:7]];
}

/**
 *  判断手机号码
 */
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

- (int)bytesLength
{
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    NSUInteger count = [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0 ; i < count ; i++)
    {
        if (*p)
        {
            p++;
            strlength++;
        }
        else
        {
            p++;
        }
    }
    return (strlength+1)/2;
}

- (NSUInteger)numberOfLines {
    return [[self componentsSeparatedByString:@"\n"] count] + 1;
}

-(NSUInteger) unicodeLength
{
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < self.length; i++)
    {
        unichar uc = [self characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}

#pragma mark XML Extensions
+ (NSString *)encodeXMLCharactersIn : (NSString *)source
{
    if (![source isKindOfClass:[NSString class]] || !source)
        return @"";
    
    NSString *result = [NSString stringWithString:source];
    
    if ([result rangeOfString:@"&"].location != NSNotFound)
        result = [[result componentsSeparatedByString:@"&"] componentsJoinedByString:@"&amp;"];
    
    if ([result rangeOfString:@"<"].location != NSNotFound)
        result = [[result componentsSeparatedByString:@"<"] componentsJoinedByString:@"&lt;"];
    
    if ([result rangeOfString:@">"].location != NSNotFound)
        result = [[result componentsSeparatedByString:@">"] componentsJoinedByString:@"&gt;"];
    
    if ([result rangeOfString:@"\""].location != NSNotFound)
        result = [[result componentsSeparatedByString:@"\""] componentsJoinedByString:@"&quot;"];
    
    if ([result rangeOfString:@"'"].location != NSNotFound)
        result = [[result componentsSeparatedByString:@"'"] componentsJoinedByString:@"&apos;"];
    
    return result;
}

+ (NSString *)decodeXMLCharactersIn:(NSString *)source
{
    if (![source isKindOfClass:[NSString class]] || !source)
        return @"";
    
    NSString *result = [NSString stringWithString:source];
    
    if ([result rangeOfString:@"&amp;"].location != NSNotFound)
        result = [[result componentsSeparatedByString:@"&amp;"] componentsJoinedByString:@"&"];
    
    if ([result rangeOfString:@"&lt;"].location != NSNotFound)
        result = [[result componentsSeparatedByString:@"&lt;"] componentsJoinedByString:@"<"];
    
    if ([result rangeOfString:@"&gt;"].location != NSNotFound)
        result = [[result componentsSeparatedByString:@"&gt;"] componentsJoinedByString:@">"];
    
    if ([result rangeOfString:@"&quot;"].location != NSNotFound)
        result = [[result componentsSeparatedByString:@"&quot;"] componentsJoinedByString:@"\""];
    
    if ([result rangeOfString:@"&apos;"].location != NSNotFound)
        result = [[result componentsSeparatedByString:@"&apos;"] componentsJoinedByString:@"'"];
    
    if ([result rangeOfString:@"&nbsp;"].location != NSNotFound)
        result = [[result componentsSeparatedByString:@"&nbsp;"] componentsJoinedByString:@" "];
    
    if ([result rangeOfString:@"&#8220;"].location != NSNotFound)
        result = [[result componentsSeparatedByString:@"&#8220;"] componentsJoinedByString:@"\""];
    
    if ([result rangeOfString:@"&#8221;"].location != NSNotFound)
        result = [[result componentsSeparatedByString:@"&#8221;"] componentsJoinedByString:@"\""];
    
    if ([result rangeOfString:@"&#039;"].location != NSNotFound)
        result = [[result componentsSeparatedByString:@"&#039;"] componentsJoinedByString:@"'"];
    
    return result;
}

#pragma mark - hashing
/**
 *  64位编码
 *
 *  @return <#return value description#>
 */
- (NSString *)base64Encoding
{
    NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedString = [stringData base64EncodedString];
    
    return encodedString;
}

/**
 *  64位解码
 *
 *  @return <#return value description#>
 */
- (NSString *)base64Decoding
{
    NSData *textData = [NSData dataFromBase64String:self];
    NSString *decodedString = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
    
    return decodedString;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Calculate the md5 hash using CC_MD5.
 *
 * @returns md5 hash of this string.
 */
- (NSString*)md5Hash
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Calculate the SHA1 hash using CommonCrypto CC_SHA1.
 *
 * @returns SHA1 hash of this string.
 */
- (NSString*)sha1Hash 
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1Hash];
}

- (NSString *)stringByAppendURLKey:(NSString *)keyName Parameter:(id)parameter
{
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    return [mutableString appendURLKey:keyName Parameter:parameter];
}

@end


@implementation NSMutableString (DDGUtilsExtras)

-(NSMutableString *)appendURLKey:(NSString *)keyName Parameter:(id)parameter{
    /**
     *  <#Description#>
     */
    return nil;
}

+ (NSMutableString *)appendStrings:(NSString *)string, ...{
    NSMutableString *mutableString = [NSMutableString string];
    va_list arguments;
    id eachObject;
    if (string) {
        va_start(arguments, string);
        
        [mutableString appendString:string];
        while ((eachObject = va_arg(arguments, id))) {
            NSLog(@"%@",eachObject);
            [mutableString appendString:eachObject];
        }
        va_end(arguments);
    }
    return mutableString;
}




@end

