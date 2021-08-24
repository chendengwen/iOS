//
//  ChainUIProtocol.h
//  FuncGroup
//
//  Created by gary on 2017/3/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChainUIProtocol;

typedef void (^LayoutViewBlock)(id<ChainUIProtocol> gview);
typedef id<ChainUIProtocol> (^Method_View_Block)(UIView *);

typedef id<ChainUIProtocol> (^Method_Float_Block)(CGFloat);
typedef id<ChainUIProtocol> (^Method_Color_Block)(UIColor *);
typedef id<ChainUIProtocol> (^Method_Origin_Block)(CGPoint);
typedef id<ChainUIProtocol> (^Method_Frame_Block)(CGRect);

typedef id<ChainUIProtocol> (^Method_Text_Block)(NSString *);
typedef id<ChainUIProtocol> (^Method_SEL_Block)(SEL,id);

@protocol ChainUIProtocol <NSObject>

@optional
+(id<ChainUIProtocol>)layout_make:(LayoutViewBlock)mLabel;

#pragma mark === UIView

-(Method_View_Block)G_addToView;

-(Method_Origin_Block)G_origin;

-(Method_Frame_Block)G_frame;

-(Method_Color_Block)G_backgroundColor;

-(Method_Color_Block)G_cornerRadius;

#pragma mark === UILabel
-(Method_Float_Block)G_font;

-(Method_Text_Block)G_title;

-(Method_Color_Block)G_titleColor;

#pragma mark === UIButton

-(Method_Text_Block)G_titleSelected;

-(Method_Color_Block)G_titleColorSelected;

-(Method_SEL_Block)G_Selector;

@end
