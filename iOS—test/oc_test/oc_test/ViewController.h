//
//  ViewController.h
//  oc_test
//
//  Created by gary on 2021/8/14.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end

@interface User : NSObject<NSMutableCopying>

@property(copy) NSString *name;
@property(assign) int age;
@property(copy) NSMutableString *address;

@end
