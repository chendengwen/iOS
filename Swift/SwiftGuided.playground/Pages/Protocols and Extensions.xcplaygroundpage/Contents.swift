//: ## Protocols and Extensions
//:
//: 使用 protocol 来声明一个协议。
//:
protocol ExampleProtocol {
    var simpleDescription: String { get }
    mutating func adjust()
//    func doSomething()
}

//: 类、枚举和结构体都可以实现协议。
//:
class SimpleClass: ExampleProtocol {
     var simpleDescription: String = "A very simple class."
     var anotherProperty: Int = 69105
     func adjust() {
          simpleDescription += "  Now 100% adjusted."
     }
}
var simpleClassA = SimpleClass()
simpleClassA.adjust()
let aDescription = simpleClassA.simpleDescription

struct SimpleStructure: ExampleProtocol {
    var simpleDescription: String = "A simple structure"
    //mutating 关键字用来标记一个会修改结构体的方法。
    mutating func adjust() {
          simpleDescription += " (adjusted)"
     }
}
var simpleStructureB = SimpleStructure()
simpleStructureB.adjust()
let bDescription = simpleStructureB.simpleDescription

//: - Experiment:
//: 给协议`ExampleProtocol`添加另外一个必须实现的内容（属性、方法）. 看看你需要做什么修改好让`SimpleClass`和`SimpleStructure`仍然遵守协议?

//: 注意声明 SimpleStructure 时候 mutating 关键字用来标记一个会修改结构体的方法。SimpleClass 的声明不需要标记任何方法，因为类中的方法通常可以修改类属性（类的性质）。

//: 使用 extension 来为现有的类型添加功能，比如新的方法和计算属性。你可以使用扩展让某个在别处声明的类型来遵守某个协议，这同样适用于从外部库或者框架引入的类型。
//:
extension Int: ExampleProtocol {
    var simpleDescription: String {
        return "The number \(self)"
    }
    mutating func adjust() {
        self += 42
    }
 }
print(7.simpleDescription)

//: - Experiment:
//: 给 Double 类型写一个扩展，添加 absoluteValue 功能。
//:
//: 你可以像使用其他命名类型一样使用协议名——例如，创建一个有不同类型但是都实现一个协议的对象集合。当你处理类型是协议的值时，协议外定义的方法不可用。
//:
let protocolValue: ExampleProtocol = simpleClassA
print(protocolValue.simpleDescription)
// print(protocolValue.anotherProperty)  // 去掉注释可以看到错误

//: 即使 protocolValue 变量运行时的类型是 simpleClass ，编译器还是会把它的类型当做ExampleProtocol。这表示你不能调用在协议之外的方法或者属性。
//:


//: [Previous](@previous) | [Next](@next)
