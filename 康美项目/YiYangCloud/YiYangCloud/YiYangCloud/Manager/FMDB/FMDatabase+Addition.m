//
//  FMDatabase+Addition.m
//  FuncGroup
//
//  Created by gary on 2017/2/23.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "FMDatabase+Addition.h"

@implementation FMDatabase (Addition)

+ (BOOL)enableWALModeForDB:(NSString *)dbPath
{
    BOOL result = NO;
    FMDatabase *database = [[FMDatabase alloc] initWithPath:dbPath];
    if ([database open])
    {
        result = [[[database stringForQuery:@"PRAGMA journal_mode = WAL"] uppercaseString]
                  isEqualToString:@"WAL"];
        
        [database close];
    }
    
    return result;
}

@end
