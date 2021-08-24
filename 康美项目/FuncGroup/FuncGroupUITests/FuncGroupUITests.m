//
//  FuncGroupUITests.m
//  FuncGroupUITests
//
//  Created by gary on 2017/2/6.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface FuncGroupUITests : XCTestCase

@end

@implementation FuncGroupUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    //XCUIApplication 这是应用的代理，他能够把你的应用启动起来，并且每次都在一个新进程中。
    XCUIApplication *app = [[XCUIApplication alloc] init];
    //XCUIElement 这是 UI 元素的代理。元素都有类型和唯一标识。可以结合使用来找到元素在哪里，如当前界面上的一个输入框
    XCUIElement *textField = app.textFields[@"\u8bf7\u8f93\u5165\u7528\u6237\u540d"];
    [textField tap];
    
    XCUIElement *key = app.keys[@"1"];
    [key tap];
    [key tap];
    [app.keys[@"3"] tap];
    [textField typeText:@"13"];
    [app.keys[@"6"] tap];
    [textField typeText:@"6"];
    
    XCUIElement *key2 = app.keys[@"4"];
    [key2 tap];
    [key2 tap];
    [key tap];
    [textField typeText:@"41"];
    [key2 tap];
    [textField typeText:@"4"];
    
    XCUIElement *key3 = app.keys[@"7"];
    [key3 tap];
    [key3 tap];
    [app.keys[@"2"] tap];
    [textField typeText:@"7"];
    [app.keys[@"5"] tap];
    [textField typeText:@"25"];
    [key3 tap];
    
    XCUIElement *secureTextField = app.secureTextFields[@"\u5bc6\u7801"];
    [secureTextField typeText:@"70"];
    [secureTextField tap];
    
    XCUIElement *moreKey = [[[[[[app.keyboards childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeKey] matchingIdentifier:@"more"] elementBoundByIndex:0];
    [moreKey tap];
    [moreKey tap];
    [secureTextField typeText:@"123456"];
    [app.toolbars.buttons[@"\u5b8c\u6210"] tap];
    [app.buttons[@"\u767b \u5f55"] tap];
    [app.buttons[@"\u4e2d\u56fd\u4f53\u8d28\u5206\u7c7b\u4e0e\u5224\u5b9a"] tap];
    
    // !!!!!!!  有了这些代码，我们就可以对它进行一些处理了，比如：
    
    //登录成功后的控制器的title为loginSuccess，只需判断控制器的title时候一样便可判断登录是否成功
//    XCTAssertEqualObjects(app.navigationBars.element.identifier, @"loginSuccess");
}

-(void)testLogin{
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *kmBgImage = app.images[@"km_bg"];
    [kmBgImage swipeLeft];
    [app.images[@"km_logo_Chinese"] tap];
    [kmBgImage tap];
    
    
    
}

@end
