//: [Previous](@previous)

import Foundation

var mixStr:String = "Swift很有趣"

//for (index,value) in mixStr.char

//if let cnIndex = mixStr.chara

var array01 = [Int](repeating: 2, count: 5)
array01.forEach { (qq) in
    print(qq)
}

array01.enumerated()

array01.filter { $0 % 2 == 0 }

array01.sorted(by: > ) // > 是 $0>$1的缩写

for value in array01 where value > 0 {
    print(value)
}

extension Array {
    func myReduce<T>(_ initial: T, _ next: (T,Element) -> T) -> T {
        var tmp = initial
        
        for value in self {
            tmp = next(tmp, value)
        }
        
        return tmp
    }
}

extension Dictionary {
    mutating func merge<S:Sequence>(_ sequence:S) where S.Iterator.Element == (key:Key, value:Value) {
        sequence.forEach { self[$0] = $1 }
    }
    
    func mapValue<T>(_ transform: (Value) -> T) -> [Key: T] {
        return Dictionary<Key, T>( uniqueKeysWithValues: map { (k,v) in
            return (k, transform(v))
        })
    }
}

let dicArr: [(key: String, value: Int)] = [
    (key: "uid", value: 12),
    (key: "number", value: 100)
]

"swift".uppercased()

let episodes = [
    "A": 120,
    "B": 270
]

