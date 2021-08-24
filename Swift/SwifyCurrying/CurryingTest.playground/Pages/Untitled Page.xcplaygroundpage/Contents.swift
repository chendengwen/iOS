//: Playground - noun: a place where people can play

import Cocoa

public struct User {
    
    public init(name: String, age: Int, weight: Double, isSingle🐶: Bool){}
}

// <A,B> 范型编程写法--不指定参数和返回值具体的数据类型
func CurryFunc<A,B>(_ a:A, _ b:B) -> String {
        return ""
}

func test1() {
    CurryFunc("111", "2222")
}
test1()

//// 传入参数和返回一致时
public func curry<A, B>(_ function: @escaping (A) -> B) -> (A) -> B {
//    return { (a: A) -> B in function(a) }
    return { (a:A) ->B in
        return function(a)
        }
}

public func curry<A, B, C>(_ function: @escaping (A, B) -> C) -> (A) -> (B) -> C{
    return { (a:A) ->(B) -> C in
        return { (b: B) -> C in
            return function(a,b)
        }
    }
}

precedencegroup Map {
    associativity: left
    higherThan: DefaultPrecedence
}

infix operator ** : Map

//// 传入参数和返回 不 一致时
func **<A, B>(_ function: @escaping (A) -> B, _ a:A) -> B {
    return function(a)
}

func curry<A, B>(_ function: @escaping (A) -> B, _ a:A) -> B {
    return function(a)
}

func curry2<A, B>(_ function: @escaping (A) -> B) {
    
}

func someTest() {
    
    func function(_ a: integer_t) -> (_ b:integer_t) -> String {
        return { b in
            return "\(a+b)";
        }
    }
    
    let fff = curry(function)(22)
    print("\(fff(2))")
    print("\(fff(4))")
    
    
}

someTest()


func test2(){
    func NumToString(_ a:Int) -> String{
        return "\(a)"
    }

    curry(NumToString,20)
    let curryADD = curry(NumToString)
    curryADD(23)
    
    // swift 写法
    func add(_ a: Int) -> (Int) -> Int {
        return { b in
            return a + b
        }
    }
    // oc写法
    func sum(a:Int, b:Int) -> Int{
        return a+b
    }
    
    // 自定义运算符写法
    add
        ** 1
        ** 2
    curry(add)
        ** 1
        ** 2
    curry(sum)
        ** 1
        ** 2
    
    // swift标准语法
    curry(add(1), 2)
    curry(add)(1)(2)
    
    
    curry2(add(1))
}

test2()


func blockFunc(_ a:integer_t) -> (_ b:integer_t) -> (integer_t) {
    return { b in
        return b;
    }
}


    
