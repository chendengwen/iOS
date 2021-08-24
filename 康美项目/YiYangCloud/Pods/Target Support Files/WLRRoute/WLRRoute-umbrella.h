#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSError+WLRError.h"
#import "NSString+WLRQuery.h"
#import "UIViewController+WLRRoute.h"
#import "WLRMatchResult.h"
#import "WLRRegularExpression.h"
#import "WLRRoute.h"
#import "WLRRouteHandler.h"
#import "WLRRouteMatcher.h"
#import "WLRRouteMiddlewareProtocol.h"
#import "WLRRouter.h"
#import "WLRRouteRequest.h"

FOUNDATION_EXPORT double WLRRouteVersionNumber;
FOUNDATION_EXPORT const unsigned char WLRRouteVersionString[];

