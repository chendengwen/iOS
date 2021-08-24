//
//  UUID.h
//  FuncGroup
//
//  Created by gary on 2017/2/22.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUID : NSObject


+(void)saveUUIDToKeyChain;

/*
 * 设备保存在钥匙串里的UUID（可能已过期而和当前真实UUID不同）
 */
+(NSString *)readUUIDFromKeyChain;

/*
 * 设备当前UUID
 */
+ (NSString *)currentDeviceUUID;

@end
