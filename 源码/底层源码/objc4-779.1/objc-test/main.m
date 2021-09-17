//
//  main.m
//  objc-test
//
//  Created by maxl on 2020/4/15.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>

void hb_test_method(Class cla, SEL _cmd){
    NSLog(@"我这个添加的方法被调用了");

}
int main(int argc, const char * argv[]) {
    @autoreleasepool {

        Class HBObject = objc_allocateClassPair(objc_getClass("NSObject"), "HBObject", 0);

        class_addIvar(HBObject, "name", sizeof(id), log2(sizeof(id)), @encode(id));

        class_addMethod(HBObject, sel_registerName("hb_test_method"), (IMP)hb_test_method, "v@:");

        objc_registerClassPair(HBObject);

        id newObject = [[HBObject alloc]init];

        [newObject setValue:@"yahibo" forKey:@"name"];

        NSLog(@"name:%@",[newObject valueForKey:@"name"]);

       ((void (*)(id,SEL)) objc_msgSend)(newObject,sel_registerName("hb_test_method"));
    }
    return 0;
}
