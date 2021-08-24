//
//  BaseCodingModel.h
//  FuncGroup
//
//  Created by gary on 2017/3/3.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "BaseModel.h"

/*!
 @class BaseCodingModel
 @brief 所有需要本地化编码实体类的基类
 */
@interface BaseCodingModel : BaseModel<NSCoding>

/*!
 @brief 本地化到沙盒，生成一个(className).data的文件
 ****** 此方法只能类名为文件名，若要自定义文件名需要使用方法 [NSKeyedArchiver archiveRootObject:obj toFile:fileName]
 @return 返回编码文件是否成功
 */
-(BOOL)archiveRootObjectToFile;

/*!
 @brief 反编码(className).data的文件
 @return BaseCodingModel 返回反编码后得到的实体
 */
+(BaseCodingModel *)valuesFromUnarchiveing;

/*!
 @brief 清楚.data文件的内容
 @prama 指定需要清除的文件路径,不指定路径就清除默认路径的文件
 @return 是否成功
 */
+(BOOL)clearCodingDataFilePath:(NSString *)filePath;

@end
