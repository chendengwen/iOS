//
//  UUID.m
//  FuncGroup
//
//  Created by gary on 2017/2/22.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "UUID.h"
#import  <Security/Security.h>
#import "KeychainItemWrapper.h"

#define DDGTerminalUUIDKey      @"DDGTerminalUUIDKey"

@implementation UUID

+ (NSString *)currentDeviceUUID
{
    NSString *_terminalSign = [[NSUserDefaults standardUserDefaults] objectForKey:DDGTerminalUUIDKey];
    if (_terminalSign == nil)
    {
        _terminalSign = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        //最后再取UUid的值
        if (_terminalSign == nil)
        {
            _terminalSign = [UUID getUUIDString];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:_terminalSign forKey:DDGTerminalUUIDKey];
    }
    return _terminalSign;
}

#pragma mark - 保存和读取UUID
+(void)saveUUIDToKeyChain{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithAccount:@"Identfier" service:@"AppName" accessGroup:nil];
    NSString *string = [keychainItem objectForKey: (__bridge id)kSecAttrGeneric];
    if([string isEqualToString:@""] || !string){
        [keychainItem setObject:[self getUUIDString] forKey:(__bridge id)kSecAttrGeneric];
    }
}

+(NSString *)readUUIDFromKeyChain{
    KeychainItemWrapper *keychainItemm = [[KeychainItemWrapper alloc] initWithAccount:@"Identfier" service:@"AppName" accessGroup:nil];
    NSString *UUID = [keychainItemm objectForKey: (__bridge id)kSecAttrGeneric];
    return UUID;
}

+ (NSString *)getUUIDString
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault , uuidRef);
    NSString *uuidString = [(__bridge NSString*)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(strRef);
    CFRelease(uuidRef);
    return uuidString;
}

@end
