//
//  MemberManager.m
//  FuncGroup
//
//  Created by zhong on 2017/3/3.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "MemberManager.h"
#import "Device_DBController.h"

@implementation MemberManager
//@synthesize currentUserArchives = _currentUserArchives;

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _ArchivesArray = [self.archives_DBController getAllRecord].mutableCopy;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetDBController) name:kNotificationReadBackup object:nil];

    }
    return self;
}

-(void)resetDBController{
    _archives_DBController = nil;
    _ArchivesArray = nil;
    _currentUserArchives = nil;
    _bindingDevices = nil;
}

- (NSArray<DeviceModel *> *)bindingDevices{
    if (_bindingDevices != nil) {
        return _bindingDevices;
    }
    _bindingDevices = [[[Device_DBController alloc] init] getAllRecord].copy;
    
    return _bindingDevices;
}

//-(void)setCurrentUserArchives:(ArchivesModel *)currentUserArchives{
//    if (currentUserArchives) {
//        _currentUserArchives = currentUserArchives;
//        if ([_currentUserArchives archiveRootObjectToFile]) {
//            //NSLog(@"archive success");
//        }
//    }else {
//        if ([ArchivesModel clearCodingDataFilePath:nil]) {
//            //NSLog(@"clear success");
//        }
//    }
//}

//-(void)setCurrentUserArchives:(ArchivesModel *)currentUserArchives{
//    if (currentUserArchives) {
//        _currentUserArchives = currentUserArchives;
//        [_currentUserArchives archiveRootObjectToFile];
//    }else {
//        [ArchivesModel clearCodingDataFilePath:nil];
//    }
//}

//-(ArchivesModel *)currentUserArchives{
//    if (!_currentUserArchives) {
//        _currentUserArchives = (ArchivesModel *)[ArchivesModel valuesFromUnarchiveing];
//    }
//    return _currentUserArchives;
//}

- (Archives_DBController *)archives_DBController{
    if (_archives_DBController != nil) {
        return _archives_DBController;
    }
    
    _archives_DBController = [[Archives_DBController alloc] init];
    
    return _archives_DBController;
}

- (NSArray<ArchivesModel *> *)ArchivesArray{
    if (_ArchivesArray != nil) {
        return _ArchivesArray;
    }
    
    _ArchivesArray = [self.archives_DBController getAllRecord].mutableCopy;
    
    if (_ArchivesArray == nil) {
        _ArchivesArray = [NSMutableArray array];
    }
    return _ArchivesArray;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
