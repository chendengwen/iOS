//
//  FMDatabase+Addition.h
//  FuncGroup
//
//  Created by gary on 2017/2/23.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <FMDB/FMDB.h>

@interface FMDatabase (Addition)

/*!
 @brief     将指定路径的数据库，转为wal模式，相关描述参考http://www.sqlite.org/wal.html
 注意数据库连接的有效性，
 @param     dbPath 数据库路径
 @return    是否成功开启WAL模式
 */
+ (BOOL)enableWALModeForDB:(NSString *)dbPath;


/*
 sqlite3 wal模式
 
 从3.7.0版本（对应iOS 4.3）开始，SQLite还提供了Write-Ahead Logging模式。与delete模式相比，WAL模式在大部分情况下更快，并发性更好，读和写之间互不阻塞；而其缺点对于iPhone这种嵌入式设备来说可以忽略，只需注意不要以只读方式打开WAL模式的数据库即可。
 使用WAL模式时，改写操是附加（append）到WAL文件，而不改动数据库文件，因此数据库文件可以被同时读取。当执行checkpoint操作时，WAL文件的内容会被写回数据库文件。当WAL文件达到SQLITE_DEFAULT_WAL_AUTOCHECKPOINT（默认值是1000）页（默认大小是1KB）时，会自动使用当前COMMIT的线程来执行checkpoint操作。也可以关闭自动checkpoint，改为手动定期checkpoint。
 为了避免读取的数据不一致，查询时也需要读取WAL文件，并记录一个结尾标记（end mark）。这样的代价就是读取会变得稍慢，但是写入会变快很多。要提高查询性能的话，可以减小WAL文件的大小，但写入性能也会降低。
 需要注意的是，低版本的SQLite不能读取高版本的SQLite生成的WAL文件，但是数据库文件是通用的。这种情况在用户进行iOS降级时可能会出现，可以把模式改成delete，再改回WAL来修复。
 要对一个数据库连接启用WAL模式，需要执行“PRAGMA journal_mode=WAL;”这条命令，它的默认值是“journal_mode=DELETE”。执行后会返回新的journal_mode字符串值，即成功时为"wal"，失败时为之前的模式（例如"delete"）。一旦启用WAL模式后，数据库会保持这个模式，这样下次打开数据库时仍然是WAL模式。
 要停止自动checkpoint，可以使用wal_autocheckpoint指令或sqlite3_wal_checkpoint()函数。手动执行checkpoint可以使用wal_checkpoint指令或sqlite3_wal_checkpoint()函数。
 */


@end
