//: ## 泛型
//:
//: 在尖括号里写一个名字来创建一个泛型函数或者类型。
//:
func makeArray<Item>(repeating item: Item, numberOfTimes: Int) -> [Item] {
    var result = [Item]()
    for _ in 0..<numberOfTimes {
         result.append(item)
    }
    return result
}
makeArray(repeating: "knock", numberOfTimes: 4)

//: 你也可以创建泛型函数、方法、类、枚举和结构体。
//:
// 重新实现 Swift 标准库中的可选类型
enum OptionalValue<Wrapped> {
    case none
    case some(Wrapped)
}
var possibleInteger: OptionalValue<Int> = .none
possibleInteger = .some(100)

//: 在类型名后面使用 where 来指定对类型的需求，比如，限定类型实现某一个协议，限定两个类型是相同的，或者限定某个类必须有一个特定的父类。
//:
func anyCommonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> Bool
    where T.Element: Equatable, T.Element == U.Element
{
    for lhsItem in lhs {
        for rhsItem in rhs {
            if lhsItem == rhsItem {
                return true
            }
        }
    }
   return false
}
anyCommonElements([1, 2, 3], [3])

//: - Experiment:
//: 修改 anyCommonElements(_:_:) 函数来创建一个函数，返回一个数组，内容是两个序列的共有元素。
//:
//: <T: Equatable> 和 <T> ... where T: Equatable> 的写法是等价的。
//:


//:Any 和 AnyObject 的类型转换
//:>Swift 为不确定类型提供了两种特殊的类型别名：
//:- Any 可以表示任何类型，包括函数类型。
//:- AnyObject 可以表示任何类类型的实例。
//示例，使用 Any 类型来和混合的不同类型一起工作，包括函数类型和非类类型。它创建了一个可以存储 Any 类型的数组 things：
class Person { var name: String? }
var person = Person()
person.name = "Ghostbusters"

var things = [Any]()
things.append(0)
things.append(0.0)
things.append(42)
things.append(3.14159)
things.append("hello")
things.append((3.0, 5.0))
things.append(person)
things.append({ (name: String) -> String in "Hello, \(name)" })


//Any类型可以表示所有类型的值，包括可选类型。
//Swift会在你用Any类型来表示一个可选值的时候，给你一个警告。
//如果你确实想使用Any类型来承载可选值，你可以使用as操作符显式转换为Any，如下所示：
let optionalNumber: Int? = 3
things.append(optionalNumber)        // 警告
things.append(optionalNumber as Any) // 没有警告

//: [Previous](@previous) | [Next](@next)
