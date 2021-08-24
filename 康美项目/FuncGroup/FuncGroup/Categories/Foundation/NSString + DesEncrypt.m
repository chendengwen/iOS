//
//  NSString + DesEncrypt.m
//  desTest
//
//  Created by mahailin on 13-1-31.
//  Copyright (c) 2013年 mahailin. All rights reserved.
//

#import "NSString + DesEncrypt.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

#import "CommonFunc.h"
#import "NSData+Additions.h"
#import "NSString+Additions.h"

NSString *const kDesKeyString = @"desKeyString";

@implementation NSString(DesEncrypt)

//static Byte iv[] = {1, 1, 1, 1, 1, 1, 1, 1};

/*!
 @brief     DES加密
 @return    加密后的des string
 */
+ (NSString *)encryptUseDES:(NSString *)encryptString key:(NSString *)keyString
{
    NSString *cipherString = @"";
    NSData *textData = [encryptString dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    
//    size_t bufferLength = (dataLength + kCCKeySizeDES) & ~(kCCKeySizeDES - 1);
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    if (keyString.length == 0)
    {
        keyString = kDesKeyString;
    }
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [keyString UTF8String],
                                          kCCKeySizeDES,
                                          nil,//iv
                                          [textData bytes],
                                          dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        cipherString = [[NSString alloc] initWithFormat:@"%@",[data base64EncodedString]];
    }
    
    return cipherString;
}

/*!
 @brief     DES解密
 @return    解密后的string
 */
+ (NSString *)decryptUseDES:(NSString *)decryptString key:(NSString *)keyString
{
    NSString *clearString = @"";
    NSData *textData = [NSData dataFromBase64String:decryptString];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    if (keyString.length == 0)
    {
        keyString = kDesKeyString;
    }
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [keyString UTF8String],
                                          kCCKeySizeDES,
                                          nil,//iv
                                          [textData bytes],
                                          dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        clearString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return clearString;
}





/*!
 @brief     加密方式 = 拼接所有字符串（注意传参时的顺序） , 字符串装合后再MD5 32位小写加密
 @return    解密后的string
 */
+ (NSString *)decryptUseDDG:(NSString *)string, ...{
    NSMutableString *decryptString = [NSMutableString string];
    va_list arguments;
    id eachObject;
    if (string) {
        va_start(arguments, string);
        
        [decryptString appendString:string];
        while ((eachObject = va_arg(arguments, id))) {
            NSLog(@"%@",eachObject);
            [decryptString appendString:eachObject];
        }
        va_end(arguments);
    }
    
    // MD5 编码后返回
    return [[decryptString dataUsingEncoding:NSUTF8StringEncoding] md5Hash];

}


/////////////// ************  袋袋金核心加密方式   ************** ///////////////

+(NSString *)app_EncodeWithData:(NSString *)data key:(NSString *)key expire:(int)expire
{
 
    //1.对key  md5 加密
    NSString *key_md5 = [key md5Hash];
    //2.对data  base64 加密
    NSString *data_base64 = [CommonFunc base64StringFromText:data];
    
    //获得加密字符串的长度
    long len = data_base64.length;
    //获得加密种子的长度
    long l = key_md5.length;
    
    
    // 3.混淆加密
    int x = 0;
    NSString *charStr= @"";
    
    for (int i = 0; i < len; i++)
    {
        if (x == l)
        {
            x = 0;
        }
        
        NSRange range = {x, 1};
        charStr = [charStr stringByAppendingString:[key_md5 substringWithRange:range]];
        
        x++;
    }
    
    
    //    4.遍历进行ASCII加密
    
    NSString *str;
    
    for (int j = 0 ; j < len ; j++ )
    {
        int num =   [data_base64 characterAtIndex:j] + [charStr characterAtIndex:j] ;
        
        if (j == 0)
        {
            str = [NSString stringWithFormat:@"%@",[NSString strrev:num]];
        }
        else
        {
            str = [str stringByAppendingString:[NSString stringWithFormat:@",%@",[NSString strrev:num]]];
        }
    }

    
    NSString *str_base64 = [CommonFunc base64StringFromText:str];

    
    
    return [NSString encodeFilter:str_base64];
}


+(NSString *)app_DecodeWithData:(NSString *)data key:(NSString *)key expire:(int)expire
{

    //1.对key  md5 加密
    NSString *key_md5 = [key md5Hash];
    data = [NSString decodeFilter:data];
    

    //根据加密字符串补齐BASE64的=号
    int mod4 = data.length % 4;
    
    if (mod4)
    {
        for (int i = 0 ; i < mod4; i++)
        {
            [data stringByAppendingString:@"="];
        }
    }
    //使用BASE64解密

    data = [CommonFunc textFromBase64String:data];
    //将解码后的字符串切成数组
    NSArray *dataArr =[data componentsSeparatedByString:@","];
    
    
    
    
    long len = dataArr.count;
    long l = key_md5.length;
    int x = 0;
    NSString *charStr= @"";
    

    //混淆加密种子值并重新赋值给charStr
    for (int i = 0 ; i < len; i++)
    {
        if (x == l) {
            x = 0;
        }
        
        NSRange range = {x, 1};
        charStr = [charStr stringByAppendingString:[key_md5 substringWithRange:range]];
        
        x++;
    }
    
    //遍历加密串进行ASCII解密处理
    
    NSMutableString *resultString =[NSMutableString string];
    
    for (int j = 0 ; j < len ; j++ )
    {
        
        NSString  *str = dataArr[j];
        NSString *a = [NSString intRev:str];
        int num =  [a intValue]  - (int)[charStr characterAtIndex:j]  ;
        
        str =[NSString stringWithFormat:@"%c",num];
        
        resultString = [NSMutableString stringWithFormat:@"%@",[resultString stringByAppendingString:str]];
        
    }
    
    return [CommonFunc textFromBase64String:resultString];
}


//将  + / =  转化为    - _ 空

+(NSString *)encodeFilter:(NSString *)str
{
    
    str =[str stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    str =[str stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    str =[str stringByReplacingOccurrencesOfString:@"=" withString:@""];
    
    return str;
}

//将 - _ 转化为 + /
+(NSString *)decodeFilter:(NSString *)str
{
    
    str =[str stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    str =[str stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    
    return str;
}

//数字反转   返回字符串
+(NSString *)strrev:(int)num
{
    long n,j;
    char str[10],ch;
    
    //  itoa(num,str,10);//将INT型数据N以十进制的形式存放在str字符数组里面
    
    sprintf(str, "%d",num);
    n=0;
    j=strlen(str)-1;
    //------------------------------字符数组的逆置------
    while(n<j)
    {
        ch=str[n];
        str[n]=str[j];
        str[j]=ch;
        n++;
        j--;
    }
    //    n=atoi(str);//将字符数组里所存放的十进制数据转换为INT型
    
    NSString *new = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
    return new;
}


//字符串反转   返回字符串
+(NSString *)intRev:(NSString *)str
{
    NSMutableString *s = [NSMutableString string];
    for (NSUInteger i=str.length; i>0; i--)
    {
        [s appendString:[str substringWithRange:NSMakeRange(i-1, 1)]];
    }
    return s;
}



@end
