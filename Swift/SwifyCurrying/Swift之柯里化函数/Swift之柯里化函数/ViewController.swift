//
//  ViewController.swift
//  Swift之柯里化函数
//
//  Created by yz on 15/4/28.
//  Copyright (c) 2015年 yz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 创建柯里化类的实例
        let curryInstance = Curry()
        
        /*** 调用手动实现的柯里化函数 **/
        let r: Int = curryInstance.add(a: 10)(20)(30)
        // 可能很多人都是第一次看这样的调用，感觉有点不可思议。
        // 让我们回顾下OC创建对象 [[Person alloc] init]，这种写法应该都见过吧，就是一下发送了两个消息，alloc返回一个实例，再用实例调用init初始化,上面也是一样，一下调用多个函数，每次调用都会返回一个函数，然后再次调用这个返回的函数。
        
        /***** 柯里化函数分解调用 *****/
        // 让我来帮你们拆解下，更容易看懂
        // curryInstance.add(10): 调用一个接收参数a,并且返回一个接收参数b的函数,并且这个函数又返回一个接收参数c,返回值为Int类型的函数
        // functionB: 一个接收参数b的函数,并且这个函数又返回一个接收参数c,返回值为Int类型的函数
        var functionB = curryInstance.add(a: 10)
        
        // functionB(b: 20):调用一个接收参数b的函数,并且这个函数又返回一个接收参数c,返回值为Int类型的函数
        // functionC: 一个接收参数c,返回值为Int类型的函数
        var functionC = functionB(20)
        
        // functionC(c: 30): 调用一个接收参数c,返回值为Int类型的函数
        // result: 函数的返回值
        var res: Int = functionC(30);
        
        // 这里会有疑问?，为什么不是调用curryInstance.add(a: 10)，而是curryInstance.add(10),functionB(b: 20),functionC(c: 30),怎么就有b,c,这是因为func add(a: Int) -> (b:Int) -> (c: Int) -> Int这个方法中a是第一个参数，默认是没有外部参数名，只有余下的参数才有外部参数名,b,c都属于余下的参数。
        
        /***** 系统的柯里化函数调用 *****/
        let result: Int = curryInstance.add(a: 10)(20)(30)
        
        /***** 系统的柯里化函数拆解调用 *****/
        // curryInstance.addCur(10) : 调用一个接收参数a,并且返回一个接收参数b的函数,并且这个函数又返回一个接收参数c,返回值为Int类型的函数
        // 注意：Swift是强类型语言，这里没有报错，说明调用系统柯里化函数返回的类型和手动的functionB类型一致
        // functionB: 一个接收参数b的函数,并且这个函数又返回一个接收参数c,返回值为Int类型的函数
        functionB = curryInstance.add(a: 10)
        
        // functionC: 一个接收参数c,返回值为Int类型的函数
        functionC = functionB(20)
        
        // result: 函数的返回值
        res = functionC(30)
        
        // 打印 60，60，60说明手动实现的柯里化函数，和系统的一样。
        print("\(r),\(res),\(result)")
        
        /************************************ 华丽的分割线 *********************************************/
        /*************************** 实例方法的另一种调用方式（柯里化）************************************/
        // 创建柯里化类的实例
        let curryingInstance = Currying()
        
        // 调用function方法
        Currying.function(curryingInstance)()
        
        // 拆解调用function方法
        // 1.获取function方法
        let function = Currying.function(curryingInstance)
        // 2.调用function方法
        function()
        
        // 步骤都是一样，首先获取实例方法，在调用实例方法，实例方法怎么调用，就不需要在教了。
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

