//
//  KMAlertBtn.m
//  FuncGroup
//
//  Created by zhong on 2017/2/23.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "KMAlertBtn.h"

@interface KMAlertBtn ()
//@property (nonatomic,strong) NSArray *titles;
@end

@implementation KMAlertBtn

- (instancetype)init{
    self = [super init];
    if (self) {
//        self.titles = titles;
        
        UILabel *titleLab = [[UILabel alloc]init];
        self.titleLab = titleLab;
        titleLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(4);
            make.centerY.equalTo(self);
        }];
        
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_more"]];
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-4);
            make.centerY.equalTo(self);
        }];
        
    }
    
    return self;
}

@end
