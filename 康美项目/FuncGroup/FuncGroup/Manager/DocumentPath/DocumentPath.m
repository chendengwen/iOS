//
//  DocumentPath.m
//  FuncGroup
//
//  Created by gary on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "DocumentPath.h"

@implementation DocumentPath

#pragma mark ===
#pragma mark === 文件路径方法
// 判断路径存在
+ (BOOL)fileExistsAtPath:(NSString *)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        return YES;
    }else{
        return NO;
    }
}

// 按路径删除文件
+ (void)deleteFileAtPath:(NSString *)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        [fileManager removeItemAtPath:path error:nil];
    }else{
        
    }
}

+ (NSString *)documentPath{
    static NSString* path= nil;
    if (nil == path) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            YES);
        path = [dirs objectAtIndex:0];
    }
    return path;
}

// 缓存路径
+ (NSString *)cachePath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

// 用户根文件 .../Caches/user
+ (NSString *)cachesUserRootPath{
    
    NSString * path = [[self cachePath]stringByAppendingPathComponent:@"user"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        
    }else{
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}

// 用户关联id文件 .../Caches/user/user_id
+ (NSString *)cachesUserPath:(NSString *)userID{
    
    NSString * path = [[self cachesUserRootPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"user_%@",userID]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        
    }else{
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

// 用户头像路径 ...(Caches/user/userIcon)
+ (NSString *)userIconPath{
    
    NSString * path = [[self cachesUserRootPath] stringByAppendingPathComponent:@"userIcon"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        
    }else{
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)pathForResource:(NSString *)relativePath InBundle:(NSBundle *)bundle{
    return [[(bundle == nil ? [NSBundle mainBundle] : bundle) resourcePath]
            stringByAppendingPathComponent:relativePath];
}

+ (NSString *)pathForResrouceInDocuments:(NSString *)relativePath{
    
    return [[DocumentPath documentPath] stringByAppendingPathComponent:relativePath];
}

@end
