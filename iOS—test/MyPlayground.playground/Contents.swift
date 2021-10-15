import UIKit

let f = "we"
f.dropFirst()
f.endIndex


let cafee = "caf\u{0065}\u{0301}"
cafee.count
let start = cafee.startIndex // 0
let end = cafee.endIndex // 5

cafee.prefix(2)

for (index,value) in cafee.enumerated() {
    print("\(index):\(value)")
}

var iterator = cafee.makeIterator()
while let value = iterator.next() {
    print("\(value)")
}

var array1: Array<Int> = [Int](repeating: 3, count: 4)

func getBufferAddress<T>(of array: [T]) -> String {
    return array.withUnsafeBufferPointer { buffer in
        return String(describing: buffer.baseAddress)
    }
}

var a = [1, 2, 3] // [1, 2, 3]
let copyA = a // [1, 2, 3]
getBufferAddress(of: a)
getBufferAddress(of: copyA)

a.append(4)

getBufferAddress(of: a)
getBufferAddress(of: copyA)

extension Dictionary {
    mutating func merge<S:Sequence>(_ sequence: S) where S.Iterator.Element == (key:Key, value:Value) {
        sequence.forEach { self[$0] = $1 }
    }
    
    init<S:Sequence>(_ sequence:S) where S.Iterator.Element == (key:Key, value:Value) {
        self = [:]
        self.merge(sequence)
    }
    
    func mapValue<T>(_ transform:(Value) -> T) -> [Key: T] {
        return Dictionary<Key, T>(
            map({ (k,v) in
                return (k, transform(v))
            })
        )
    }
}

enum RecordType {
    case bool(Bool)
    case number(Int)
    case text(String)
}

let recordPatch: [(key: String, value: RecordType)] = [
    (key: "uid", value: .number(10)),
    (key: "title", value: .text("Common dictionary extensions"))
]

let record1 = Dictionary(recordPatch)
// [
// uid: .number(10),
// "title": .text("Common dictionary extensions")
// ]

let record2 = record1.map {  $1 }
let newRecord11 = record1.mapValue { record -> String in
    switch record {
        case .text(let title):
            return title
        case .number(let exp):
            return String(exp)
        case .bool(let favourite):
            return String(favourite)
    }
}

struct Account {
    var alias :String
    var type :Int
    var createdAt :Date
    
    let INT_BIT = (Int)(CHAR_BIT) * MemoryLayout<Int>.size
    func bitwiseRotate(value: Int, bits: Int) -> Int {
        return (((value) << bits) | ((value) >> (INT_BIT - bits)))
    }
}

extension Account: Hashable {
    
    var hashValue: Int {
        return alias.hashValue ^ type.hashValue ^ createdAt.hashValue
    }
}

extension Account: Equatable {
    static func == (lhs: Account, rhs: Account) -> Bool {
        return lhs.alias == rhs.alias &&
            lhs.type == rhs.type &&
            lhs.createdAt == rhs.createdAt
    }
}

let account = Account(alias: "11", type: 1, createdAt: Date())
let data:[Account: Int] = [ account: 1000]

let hw = "hello world"
let numbers = CharacterSet.init(charactersIn: "hello")
let range = hw.rangeOfCharacter(from: numbers)
range?.upperBound


func forceCast<U>(_ value: Any?, to type: U.Type) -> U {
    return value as! U
}
 
let value: Any? = 42
print(forceCast(value, to: Any.self))
// Prints "Optional(42)"
// (Prior to Swift 5, this would print "42".)
 
print(value as! Any)
// Prints "Optional(42)"

extension Array where Element: Comparable {
    mutating func mergeSort(_ begin: Index, _ end: Index) {
        // A shared storage across all recursive calls
        var tmp: [Element] = []
         tmp.reserveCapacity(count)
        
        func merge(_ begin: Int, _ mid: Int, _ end: Int) {
            // 1. Use the same shared storage
             tmp.removeAll(keepingCapacity: true)
            // The same as before
            var i = begin
            var j = mid
            
            while i != mid && j != end {
            if self[i] < self[j] {
                 tmp.append(self[i])
                 i += 1
             }
            else {
                 tmp.append(self[j])
                 j += 1
             }
             }
            // 3. Append the remaining
             tmp.append(contentsOf: self[i ..< mid])
             tmp.append(contentsOf: self[j ..< end])
            // 4. Update self
             replaceSubrange(begin..<end, with: tmp)
         }
        
        if ((end - begin) > 1) {
            let mid = (begin + end) / 2
             mergeSort(begin, mid)
             mergeSort(mid, end)
             merge(begin, mid, end)
         }
    }
}

let ints = ["1", "2", "3", "4", "five"]

extension Sequence {
    func myFlatMap<T>(_ transform: (Iterator.Element) -> T?) -> [T] {
        return self.map(transform)
         .filter { $0 != nil }
         .map { $0! }
    }
}

let all = ints.myFlatMap { Int($0) }
print(all)
