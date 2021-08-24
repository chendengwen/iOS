//
//  Encryption.h
//  RSA
//
//  Created by 李燚 on 15/8/18.
//  Copyright (c) 2015年 Clapp Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密

- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密

@end
