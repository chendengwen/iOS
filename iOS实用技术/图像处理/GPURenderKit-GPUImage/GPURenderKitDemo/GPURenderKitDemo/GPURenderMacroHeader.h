//
//  GPURenderMacroHeader.h
//  DDOpenGLESExample
//
//  Created by 刘海东 on 2018/2/5.
//  Copyright © 2018年 刘海东. All rights reserved.
//

#ifndef GPURenderMacroHeader_h
#define GPURenderMacroHeader_h

#import "GLImageFilterEnumType.h"

#define WEAKSELF __weak __typeof(&*self)weakSelf = self;

/** 屏幕size */
#define kScreen_W [UIScreen mainScreen].bounds.size.width
#define kScreen_H [UIScreen mainScreen].bounds.size.height
/**为了兼容写的宽高**/
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height



#define SafeAreaStatusTopHeight (iPhoneX ? 32 : 0)
#define  SafeTopMargin  (IS_IPHONE_X ? 44.f : 0.f)
#define  SafeBottomMargin         (IS_IPHONE_X ? 34.f : 0.f)
#define  SafeNavigationBarHeight  (IS_IPHONE_X ? 88.f : 64.f)
#define IS_IPHONE_X (kScreen_W == 375.f && kScreen_H == 812.f ? YES : NO)

// 是否为iPhoneX
#define iPhoneX ([UIScreen mainScreen].bounds.size.height == 812)

/** 颜色 */

#define kBlackColor_Alpha_05 [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]
#define RGB(r,g,b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

#define kStingValue(x) [NSString stringWithFormat:@"%@",x]


//统一配置
#define APPConfig(AppconfigKey) ([[NSBundle mainBundle] localizedStringForKey:AppconfigKey value:nil table:@"APPConfig"])

#define kColorHexInt(value) [UIColor colorWithHex:value]

#define kColorHexString(value) [UIColor colorWithHexString:value]


/** 通用代理判断  前提是代理的属性名字是要  delegate*/
#define kDelegateBoolForSelector(selectorName) (self.delegate && [self.delegate respondsToSelector:@selector(selectorName)])
#define kWeakeSelf __weak typeof(self) weakSelf = self;
#define kStrongSelf __strong typeof(weakSelf) strongSelf = weakSelf;


/** 美化教程 */
#define ATBeautyWebDetailPageURLType(type) [NSString stringWithFormat:@"https://hdpage.wecut.com/h5_artist_manual/h5_artist_manual.html?lan=%@&href=%@",[NSString getAtLanString],type]

/** 函数执行时间 */
#define kFuncStartTime CFAbsoluteTimeGetCurrent();
#define kFuncEndTime(timeValue) ((CFAbsoluteTimeGetCurrent() - timeValue)*1000.0)



#define kATRiseMenuView_h 168



/** weak self and storng self**/
#ifndef    weakify
#if __has_feature(objc_arc)

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#else

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
_Pragma("clang diagnostic pop")

#endif
#endif

#ifndef    strongify
#if __has_feature(objc_arc)

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#else

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("clang diagnostic pop")

#endif
#endif
/* weak self and storng self **/




#endif /* GPURenderMacroHeader_h */
