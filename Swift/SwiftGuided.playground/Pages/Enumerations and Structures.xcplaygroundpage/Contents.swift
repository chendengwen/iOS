//: ## Enumerations and Structures
//:
//: 使用 enum 来创建一个枚举。就像类和其他所有命名类型一样，枚举可以包含方法。
//:
enum Rank: Int {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king

    func simpleDescription() -> String {
        switch self {
            case .ace:
                return "ace"
            case .jack:
                return "jack"
            case .queen:
                return "queen"
            case .king:
                return "king"
            default:
                return String(self.rawValue)
        }
    }
}
let ace = Rank.ace
//使用 rawValue 属性来访问一个枚举成员的原始值。
let aceRawValue = ace.rawValue
//: - Experiment:
//: 写一个函数，通过比较它们的原始值来比较两个 Rank 值。
//:
func compareRank(rank1: Rank, rank2: Rank) -> Bool {
    if rank1.rawValue >= rank2.rawValue {
        return true
    }else {
        return false
    }
}

var rk1 = Rank(rawValue: 1)
var rk2 = Rank(rawValue: 3)
compareRank(rank1: rk1!, rank2: rk2!)

//:
//: 默认情况下，Swift 按照从 0 开始每次加 1 的方式为原始值进行赋值，不过你可以通过显式赋值进行改变。在上面的例子中，Ace 被显式赋值为 1，并且剩下的原始值会按照顺序赋值。你也可以使用字符串或者浮点数作为枚举的原始值。使用 rawValue 属性来访问一个枚举成员的原始值。
//:
//: 使用 init?(rawValue:) 初始化构造器来创建一个带有原始值的枚举成员。如果存在与原始值相应的枚举成员就返回该枚举成员，否则就返回 nil。
//:
if let convertedRank = Rank(rawValue: 3) {
    let threeDescription = convertedRank.simpleDescription()
}

//: 枚举的关联值是实际值，并不是原始值的另一种表达方法。实际上，如果没有比较有意义的原始值，你就不需要提供原始值。
//:
enum Suit {
    case spades, hearts, diamonds, clubs

    func simpleDescription() -> String {
        switch self {
            case .spades:
                return "spades"
            case .hearts:
                return "hearts"
            case .diamonds:
                return "diamonds"
            case .clubs:
                return "clubs"
        }
    }
}
let hearts = Suit.hearts
let heartsDescription = hearts.simpleDescription()

//: - Experiment:
//: 给 Suit 添加一个 color() 方法，对 spades 和 clubs 返回 “black” ，对 hearts 和 diamonds 返回 “red” 。
//:
//: 注意在上面的例子中用了两种方式引用 hearts 枚举成员：给 hearts 常量赋值时，枚举成员 Suit.hearts 需要用全名来引用，因为常量没有显式指定类型。在 switch 里，枚举成员使用缩写 .hearts 来引用，因为 self 已经是一个 suit 类型，在已知变量类型的情况下可以使用缩写。
//:
//: 如果枚举成员的实例有原始值，那么这些值是在声明的时候就已经决定了，这意味着不同的枚举成员总会有一个相同的原始值。当然我们也可以为枚举成员设定关联值，关联值是在创建实例时决定的。这意味着不同的枚举成员的关联值都可以不同。你可以把关联值想象成枚举成员的寄存属性。例如，考虑从服务器获取日出和日落的时间。服务器会返回正常结果或者错误信息。
//:
enum ServerResponse {
    case result(String, String)
    case failure(String)
}

let success = ServerResponse.result("6:00 am", "8:09 pm")
let failure = ServerResponse.failure("Out of cheese.")

switch success {
    case let .result(sunrise, sunset):
        print("Sunrise is at \(sunrise) and sunset is at \(sunset).")
    case let .failure(message):
        print("Failure...  \(message)")
}

//: - Experiment:
//: 给 ServerResponse 和 switch 添加第三种情况。
//:
//: 注意日升和日落时间是如何从 ServerResponse 中提取到并与 switch 的 case 相匹配的。
//:

//:
//: 使用 struct 来创建一个结构体。结构体和类有很多相同的地方，比如方法和构造器。[它们之间最大的一个区别就是结构体是传值，类是传引用]()。
//:
struct Card {
    var rank: Rank
    var suit: Suit
    func simpleDescription() -> String {
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }
}
let threeOfSpades = Card(rank: .three, suit: .spades)
let threeOfSpadesDescription = threeOfSpades.simpleDescription()

//: - Experiment:
//: 给 Card 添加一个方法，创建一副完整的扑克牌并把每张牌的 rank 和 suit 对应起来。
//:


//: [Previous](@previous) | [Next](@next)
