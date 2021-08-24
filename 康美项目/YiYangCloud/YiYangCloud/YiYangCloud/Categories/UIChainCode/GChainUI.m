//
//  GChainTool.m
//  FuncGroup
//
//  Created by gary on 2017/3/8.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GChainUI.h"

@interface GChainUI ()

@end

@implementation GChainUI

+(UIView *)tool_make:(ToolMakeBlock)make{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    make(view);
    return view;
}

@end

@implementation UIView (Chained)

+(id<ChainUIProtocol>)layout_make:(LayoutViewBlock)layoutBlock{
    id<ChainUIProtocol> view = [[[self class] alloc] init];
    layoutBlock(view);
    return view;
}

-(Method_View_Block)G_addToView{
    return ^id<ChainUIProtocol> (UIView *superView){
        [superView addSubview:self];
        return self;
    };
}

-(Method_Origin_Block)G_origin{
    return ^id<ChainUIProtocol> (CGPoint point){
        self.frame = CGRectMake(point.x, point.y, 100, 21);
        return self;
    };
}

-(Method_Frame_Block)G_frame{
    return ^id<ChainUIProtocol> (CGRect rect){
        self.frame = rect;
        return self;
    };
}

-(Method_Color_Block)G_backgroundColor{
    return ^id<ChainUIProtocol> (UIColor *color){
        self.backgroundColor = color;
        return self;
    };
}

-(Method_Float_Block)G_cornerRadius{
    return ^id<ChainUIProtocol> (CGFloat radius){
        self.layer.cornerRadius = radius;
        return self;
    };
}

@end

@implementation UILabel (Chained)

-(Method_Float_Block)G_font{
    return ^id<ChainUIProtocol>(CGFloat fontSize){
        self.font = [UIFont systemFontOfSize:fontSize];
        return self;
    };
}

-(Method_Text_Block)G_title{
    return ^id<ChainUIProtocol>(NSString *title){
        self.text = title;
        return self;
    };
}

-(Method_Color_Block)G_titleColor{
    return ^id<ChainUIProtocol>(UIColor *color){
        self.textColor = color;
        return self;
    };
}

@end

@implementation UIButton (Chained)

-(Method_Float_Block)G_font{
    return ^id<ChainUIProtocol>(CGFloat fontSize){
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        return self;
    };
}

-(Method_Text_Block)G_title{
    return ^id<ChainUIProtocol>(NSString *title){
        [self setTitle:title forState:UIControlStateNormal];
        return self;
    };
}

-(Method_Text_Block)G_titleSelected{
    return ^id<ChainUIProtocol>(NSString *title){
        [self setTitle:title forState:UIControlStateNormal];
        return self;
    };
}

-(Method_Color_Block)G_titleColor{
    return ^id<ChainUIProtocol>(UIColor *color){
        [self setTitleColor:color forState:UIControlStateNormal];
        return self;
    };
}

-(Method_Color_Block)G_titleColorSelected{
    return ^id<ChainUIProtocol>(UIColor *color){
        [self setTitleColor:color forState:UIControlStateSelected];
        return self;
    };
}

-(Method_SEL_Block)G_Selector{
    return ^id<ChainUIProtocol>(SEL selector,id target){
        [self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        return self;
    };
}


@end

@implementation UITextField (Chained)

-(Method_Float_Block)G_font{
    return ^id<ChainUIProtocol>(CGFloat fontSize){
        self.font = [UIFont systemFontOfSize:fontSize];
        return self;
    };
}

-(Method_Text_Block)G_title{
    return ^id<ChainUIProtocol>(NSString *title){
        self.text = title;
        return self;
    };
}



@end


