//: [Previous](@previous)
//:表示并抛出错误
import Foundation

enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

func playGame() throws {
    throw VendingMachineError.insufficientFunds(coinsNeeded: 5)
}

//处理方式1 -- 传递给调用函数
func someonePlayGame() throws {
    try playGame()
}

//处理方式2 -- 将错误转换成可选值
try? someonePlayGame()

//处理方式3 -- 捕捉错误
do {
    try someonePlayGame()
} catch VendingMachineError.invalidSelection {
    
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
} catch {
    
}

//处理方式4 -- 禁用错误传递
//: > 知道某个throwing函数实际上在运行时是不会抛出错误的，在这种情况下，你可以在表达式前面写try!来禁用错误传递，这会把调用包装在一个不会有错误抛出的运行时断言中。如果真的抛出了错误，你会得到一个运行时错误。
func add(num1 a: Int, num2 b :Int) throws {
    print("\(a) + \(b) = \(a+b)")
}

try! add(num1: 1, num2: 2)



//: [Next](@next)
