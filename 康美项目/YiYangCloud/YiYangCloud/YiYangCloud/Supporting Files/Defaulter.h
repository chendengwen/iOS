//
//  Defaulter.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#ifndef Defaulter_h
#define Defaulter_h

#define Debug 1
#define Device_iPad 1

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPad   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_HEIGHT < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_HEIGHT == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_HEIGHT == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_HEIGHT == 736.0)

// IPAD是横屏模式
#define IS_IPAD_1_2 (IS_IPad && SCREEN_HEIGHT == 768.0)
#define IS_IPAD_3_4 (IS_IPad && SCREEN_HEIGHT == 1536.0)

// 导航栏高度
#ifdef Device_iPad
#define NavHeight 64.0
#else
#define NavHeight 50.0
#endif

// 系统版本
#define OSVersion   [[[UIDevice currentDevice] systemVersion] floatValue]
// iOS8以上
#define iOS8AtLeast (OSVersion >= 8.0)
// iOS8
#define iOS8 (OSVersion < 9.0 && OSVersion >= 8.0)
// iOS9
#define iOS9 (OSVersion < 10.0 && OSVersion >= 9.0)
// iOS10
#define iOS10 (OSVersion >= 10.0)

//default date time format string
#define Default_date1970         [NSDate dateWithTimeIntervalSince1970:0]
#define DefaultDateTimeFormatString         @"yyyy-MM-dd HH:mm:ss"
#define DefaultShortDateFormatString        @"yyyy-M-d"
#define DefaultDateFormatString             @"yyyy-MM-dd"
#define ChineseDateFormatString             @"yyyy年M月d日"
#define ChineseHMFormatString               @"HH时mm分"
#define ShortDateFormatString               @"yyyy-MM-dd HH:mm"
#define HMSFormatString                      @"HHmmss"


//简写
#define G_marr(...)  [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]
#define G_set(...)   [NSSet setWithObjects:__VA_ARGS__, nil]
#define G_mset(...)  [NSMutableSet setWithObjects:__VA_ARGS__, nil]
#define G_mdict(...) [NSMutableDictionary dictionaryWithObjectsAndKeys:__VA_ARGS__, nil]
#define G_dict(key,value) @{key:value}
#define G_str(...)   [NSString stringWithFormat:__VA_ARGS__]
#define G_mstr(...)  [NSMutableString stringWithFormat:__VA_ARGS__]

#define kWeakSelf(type) __weak typeof(type) weak##type = type;
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
//URL
#define DDG_url(val)         [NSURL URLWithString:(val)]
#define DDG_urldict(val,dict) [NSURL URLWithString:(val) paramDictionary:(dict)]


//弧度与角度转换
#ifndef degreesToRadian
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#endif

#ifndef radianToDegrees
#define radianToDegrees(x) (180.0 * (x) / M_PI)
#endif

//单例模式头
#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;
//单例模式实现
#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

// 检测
#define StringWithValue(val)  val == nil || val.length <= 0

// 输出最详细信息
#define GVerboseLog(log, ...) NSLog((@"%s [Line %d] " log), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

/*!
 @brief 处理arc环境下调用performSelector:的警告
 */
#define SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING(code)                        \
_Pragma("clang diagnostic push")                                            \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")         \
code;                                                                       \
_Pragma("clang diagnostic pop")                                             \
((void)0)

#define MAXYEAR 9999
#define MINYEAR 0

// 设备屏幕的大小
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


// 使用方法UIColorFromRGB(0x33aaff)
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((rgbValue >> 16) & 0xFF)/255.f \
green:((rgbValue >> 8) & 0xFF)/255.f \
blue:(rgbValue & 0xFF)/255.f \
alpha:1.0f]

// 使用方法UIColorFromRGB(0x33aaff, 0.8f)
#define UIColorFromRGBA(rgbValue, a) \
[UIColor colorWithRed:((rgbValue >> 16) & 0xFF)/255.f \
green:((rgbValue >> 8) & 0xFF)/255.f \
blue:(rgbValue & 0xFF)/255.f \
alpha:a]

// 随机颜色
#define RandomColor [UIColor colorWithRed:arc4random()%255/255.f green:arc4random()%255/255.f blue:arc4random()%255/255.f alpha:1.f]

// 主色-浅蓝色
#define kMainColor [UIColor colorWithRed:0.41 green:0.75 blue:0.98 alpha:1.00]
// 辅色-深蓝
#define kFuseColor [UIColor colorWithRed:0.21 green:0.50 blue:0.79 alpha:1.00]
// 辅色-深蓝
#define kNavyBlueColor [UIColor colorWithRed:0.19 green:0.43 blue:0.80 alpha:1.00]


#ifdef DEBUG
#define DMLog(...) NSLog(__VA_ARGS__)
#define ServerAddress          @"10.2.20.243:7100"
#else
#define DMLog(...) do { } while (0)
#define ServerAddress          @"healthrecord.kmhealthcloud.cn"

#endif






#endif /* Defaulter_h */
