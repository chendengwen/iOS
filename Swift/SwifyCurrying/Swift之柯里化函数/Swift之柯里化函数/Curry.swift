//
//  Curry.swift
//  Swift之柯里化函数
//
//  Created by yz on 15/4/28.
//  Copyright (c) 2015年 yz. All rights reserved.
//

import Foundation

/*
 柯里化函数定义格式
func <#function name#>(<#parameters#>)(<#parameters#>)-> <#return type#>{
    <#statements#>
}
*/

class Curry: NSObject {
    
    // uncurried
    func add(a: Int, b: Int, c: Int) -> Int{
        print("\(a) + \(b) + \(c)")
        return a + b + c
    }
    
    // 手动实现柯里化函数
    // 把上面的函数转换为柯里化函数，首先转成接收第一个参数a，并且返回接收余下第一个参数b的新函数（采用闭包）
    // 基础不牢固可能看不懂,需要拆解来看
    // (a: Int) : 参数
    // (b:Int) -> (c: Int) -> Int : 函数返回值（一个接收参数b的函数,并且这个函数又返回一个接收参数c,返回值为Int类型的函数)
    
    // 定义一个接收参数a,并且返回一个接收参数b的函数,并且这个函数又返回一个接收参数c,返回值为Int类型的函数
    func add(a: Int) -> (_ b:Int) -> (_ c: Int) -> Int{
        
        // 返回一个接收参数b的函数,并且这个函数又返回一个接收参数c,返回值为Int类型的函数
        return { (b:Int) -> (_ c: Int) -> Int in
            
            // 返回一个接收余下第一个参数c，并且有返回结果为Int类型的函数
            return { (c: Int) -> Int in
                
                // 这里为什么能使用参数a,b,c。
                // 利用闭包的值捕获特性，即使这些值作用域不在了，也可以捕获到他们的值。
                // 闭包会自动判断捕获的值是值拷贝还是值引用，如果修改了，就是值引用，否则值拷贝。
                
                // 注意只有在闭包中才可以，a,b,c都在闭包中。
                return a + b + c;
                
            }
            
        }
        
    }

}
