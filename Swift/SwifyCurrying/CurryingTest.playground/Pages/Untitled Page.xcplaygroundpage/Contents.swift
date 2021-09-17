//: Playground - noun: a place where people can play

import Cocoa

/************************************ 泛型编程-Begin *********************************************/

// <A,B> 范型编程写法，不指定参数和返回值具体的数据类型
func normalFunction<A,B>(_ a:A, _ b:B) -> String {
        return ""
}
normalFunction(123, true)

/************************************ 泛型编程-End *********************************************/


/************************************ Curry-Begin *********************************************/
// 接收一个 function:(A)->B 参数， 返回一个 function:(A)->B
public func curry<A, B>(_ function: @escaping (A) -> B) -> (A) -> B {
    // A->B闭包返回值
    return { (a:A) ->B in
        return function(a)
    }
}

// 接收一个 function:(A,B)->C 参数， 返回一个 function:(A)->(B)->C
public func curry<A, B, C>(_ function: @escaping (A, B) -> C) -> (A) -> (B) -> C{
    return { (a:A) ->(B) -> C in
        return { (b: B) -> C in
            return function(a,b)
        }
    }
}

// 闭包参数
func function(_ a: integer_t) -> (_ b:integer_t) -> String {
    return { b in
        return "\(a+b)";
    }
}
    
//调用curry
let fff = curry(function)(22)
print("\(fff(2))")
print("\(fff(4))")


precedencegroup Map {
    associativity: left
    higherThan: DefaultPrecedence
}

infix operator ** : Map

func **<A, B>(_ function: @escaping (A) -> B, _ a:A) -> B {
    return function(a)
}

// curry 函数
func add(_ a: Int) -> (Int) -> Int {
    return { b in
        return a + b
    }
}
// 传统 函数
func sum(a:Int, b:Int) -> Int{
    return a+b
}

// 自定义运算符写法，伪函数：**(**(add, 1), 2)
add ** 1 ** 2

curry(add)
    ** 1
    ** 2

curry(sum)
    ** 1
    ** 2

// 标准语法
curry(add)(1)(2)

/************************************ Curry-End *********************************************/


func blockFunc(_ a:integer_t) -> (_ b:integer_t) -> (integer_t) {
    return { b in
        return b;
    }
}


    
