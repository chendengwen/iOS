//
//  NSData+Additions.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Additions)


void *NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength);

char *NewBase64Encode(
                      const void *inputBuffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength);


@property (nonatomic, readonly) NSString* md5Hash;

@property (nonatomic, readonly) NSString* sha1Hash;

/**
 *  base64解码
 *
 *  @param aString <#aString description#>
 *
 *  @return <#return value description#>
 */
+ (NSData *)dataFromBase64String:(NSString *)aString;

/**
 *  base64编码
 *
 *  @return <#return value description#>
 */
- (NSString *)base64EncodedString;

//URLEncode
- (NSString *)urlEncodedString;

@end
