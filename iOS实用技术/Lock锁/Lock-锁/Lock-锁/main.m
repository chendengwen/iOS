//
//  main.m
//  Lock-锁
//
//  Created by 陈登文 on 2021/8/26.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <pthread/pthread.h>

int main(int argc, char * argv[]) {
    
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
