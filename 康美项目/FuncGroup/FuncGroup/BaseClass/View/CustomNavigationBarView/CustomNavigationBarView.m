//
//  CustomNavigationBarView.m
//  PMH.Views
//
//  Created by 登文 陈 on 14-7-30.
//  Copyright (c) 2014年 Paidui, Inc. All rights reserved.
//

#import "CustomNavigationBarView.h"


@implementation CustomNavigationBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithTitle:(NSString *)title withBackColorStyle:(NavigationBarViewBackColor)colorStyle{
    
    self = [super initWithFrame:Rect_64];
    if (self) {
        // Initialization code
        
        _Y_Y = 0.f;
        _barCOlor = colorStyle;
        
        [self layoutTitleViewWith:title andColorStyle:colorStyle];
        
    }
    return self;
    
}


-(id)initWithTitle:(NSString *)title withLeftButton:(UIButton *)leftButton withRightButton:(UIButton *)rightButton withBackColorStyle:(NavigationBarViewBackColor)colorStyle{
    
    self = [super initWithFrame:Rect_64];
    if (self) {
        // Initialization code
        _Y_Y = 0.f;
        
        [self layoutTitleViewWith:title andColorStyle:colorStyle];
        
        if (leftButton) {
            leftButton.frame = CGRectMake(0.f,20.f,60.f, 35.0f);
            [self addSubview:leftButton];
        }
        if (rightButton) {
            rightButton.frame = CGRectMake(SCREEN_WIDTH - 60.f,20.f,60.f, 35.0f);
            [self addSubview:rightButton];
        }
    }
    
    return self;
}

-(void)layoutTitleViewWith:(NSString *)title andColorStyle:(NavigationBarViewBackColor)colorStyle{
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 30.0 + _Y_Y, SCREEN_WIDTH - 60.0*2, 18.f)];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont systemFontOfSize:18.0];
    
    
    if (colorStyle == NavigationBarViewBackColorWhite) {
        _titleLab.textColor = [UIColor blackColor];
        self.backgroundColor = [Resource navgationBackGroundColor];
        
        UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(0, 63 - _Y_Y, SCREEN_WIDTH, 0.8)];
        underLine.backgroundColor = UIColorFromRGB(0xdfdfdf);
        [self addSubview:underLine];
        
    }else if(colorStyle == NavigationBarViewBackColorBlack){
        _titleLab.textColor = [Resource navgationTitleColor];
        self.backgroundColor = [Resource navgationBackGroundColor];
    }
    
    _titleLab.text = title;
    [self addSubview:_titleLab];
}

-(id)initWithTitleImgView:(NSString *)imgString withLeftButton:(UIButton *)leftButton withRightButton:(UIButton *)rightButton withBackColorStyle:(NavigationBarViewBackColor)colorStyle{

    self = [super initWithFrame:Rect_64];
        if (self) {
            // Initialization code
            _Y_Y = 0.f;
            
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 131/1.7, 43/1.7)];
            imgView.image = [UIImage imageNamed:imgString];
            CGPoint center = {self.center.x, self.center.y + 10.f};
            imgView.center =  center;
            [self addSubview:imgView];
            
            
            if (leftButton) {
                leftButton.frame = CGRectMake(0.f,25.f,60.f, 35.0f);
                //                leftButton.backgroundColor = [UIColor redColor];
                [self addSubview:leftButton];
            }
            if (rightButton) {
                rightButton.frame = CGRectMake(SCREEN_WIDTH - 60.f,25.f,60.f, 35.0f);
                [self addSubview:rightButton];
            }
            
            
        }
        
        self.backgroundColor = [Resource navgationBackGroundColor];
        
        return self;
}
    
@end
