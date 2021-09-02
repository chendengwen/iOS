//
//  HomeModel.h
//  MVVM-demo
//
//  Created by gary on 2021/7/6.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

//======= FatModel ========
@class HomeBannerModel;
@interface HomeBannersModel : BaseModel

@property(strong) NSArray<HomeBannerModel *> *models;

@end

@interface HomeUserInfoModel : BaseModel

@property(copy) NSString *username;
@property(strong) NSDate *logintime;

@end

@class HomeSubjectModel;
@interface HomeSubjectsModel : BaseModel

@property(strong) NSArray<HomeSubjectModel *> *models;

@end

//======== Model =======

@interface HomeBannerModel : NSObject

@property(copy) NSString *imagePath;
@property(copy) NSString *title;

@end

@interface HomeSubjectModel : NSObject

@property(copy) NSString *imagePath;
@property(copy) NSString *title;

@end

