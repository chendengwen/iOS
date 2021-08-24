//
//  DocumentPath.h
//  FuncGroup
//
//  Created by gary on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentPath : NSObject

// 判断路径存在
+ (BOOL)fileExistsAtPath:(NSString *)path;

// 按路径删除文件
+ (void)deleteFileAtPath:(NSString *)path;

//文档路径
+ (NSString *)documentPath;

/*!
 @return    app的cache目录
 */
+ (NSString *)cachePath;


// 用户关联id文件 .../Caches/user/user_id
+ (NSString *)cachesUserPath:(NSString *)userID;

// 用户头像路径 ...(Caches/user/userIcon)
+ (NSString *)userIconPath;

//bundle中资源路径
+ (NSString *)pathForResource:(NSString *)relativePath InBundle:(NSBundle *)bundle;
//文档中资源路径
+ (NSString *)pathForResrouceInDocuments:(NSString *)relativePath;

@end
