//
//  SIEditAlertView.h
//  SIAlertViewExample
//
//  Created by xxjr02 on 16/8/12.
//  Copyright © 2016年 Sumi Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIAlertView.h"

#define TEXTFIELDVIEW_HEIGHT    35.0
#define TEXTFIELDVIEW_PADDING   10.0

@class SIEditAlertView;

typedef void(^SIEditAlertViewHandler)(SIEditAlertView *alertView);

@interface SIEditAlertView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) SIAlertViewTransitionStyle transitionStyle; // default is SIAlertViewTransitionStyleSlideFromBottom
@property (nonatomic, assign) SIAlertViewBackgroundStyle backgroundStyle; // default is SIAlertViewButtonTypeGradient

@property (nonatomic, copy) SIEditAlertViewHandler willShowHandler;
@property (nonatomic, copy) SIEditAlertViewHandler didShowHandler;
@property (nonatomic, copy) SIEditAlertViewHandler willDismissHandler;
@property (nonatomic, copy) SIEditAlertViewHandler didDismissHandler;

@property (nonatomic, assign, readwrite) int starCount;

@property (nonatomic, readonly, getter = isVisible) BOOL visible;

@property (nonatomic, strong) UIColor *viewBackgroundColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *messageColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *titleFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *messageFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *buttonFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat cornerRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is 2.0
@property (nonatomic, assign) CGFloat shadowRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is 8.0

@property (nonatomic, assign) BOOL showFieldEditView;

- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message;

- (void)addButtonWithTitle:(NSString *)title type:(SIAlertViewButtonType)type handler:(SIEditAlertViewHandler)handler;
- (void)addTextFieldWithTitle:(NSString *)title placeHolder:(NSString *)placeholder handler:(SIEditAlertViewHandler)handler;

- (void)show;
- (void)dismissAnimated:(BOOL)animated;

@end
