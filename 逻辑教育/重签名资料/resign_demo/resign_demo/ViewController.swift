//
//  ViewController.swift
//  test
//
//  Created by 陈登文 on 2021/8/12.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        let m = MyArray(data: [1, 2, 3])
        let n = m
        
        m.append(element: 11)
        m.data === n.data // true
    }


}

final class Episode: NSObject {
    var title: String
    var type: String
    var length: Int
    override var description: String {
        return title + "\t" + type + "\t" + String(length)
    }
    init(title: String, type: String, length: Int) {
        self.title = title
        self.type = type
        self.length = length
    }
}

typealias SortDescriptor<T> = (T, T) -> Bool
func makeDescriptor<Key, Value>(key: @escaping (Key) -> Value, _ isAscending: @escaping (Value, Value) -> Bool) -> SortDescriptor<Key> {
    return { isAscending(key($0), key($1)) }
}
let lengthDescriptor: SortDescriptor<Episode> = makeDescriptor(key: { $0.length }, <)
let typeDescriptor: SortDescriptor<Episode> = makeDescriptor(key: { $0.type }, {
    $0.localizedCompare($1) == .orderedAscending
})


extension Array where Element: Comparable {
    mutating func mergeSort(_ begin: Index, _ end: Index) {
        
        // A shared storage across all recursive calls
        var tmp: [Element] = []
        tmp.reserveCapacity(count)
        
        func merge(_ begin: Int, _ mid: Int, _ end: Int) {
            // 1. Use the same shared storage
            tmp.removeAll(keepingCapacity: true)
            // 2. Fetch the smaller one from the two piles
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

enum List {
    case end
    indirect case node(Int, next: List)
}

struct MyArray {
    var data: NSMutableArray
    init(data: NSMutableArray) {
        self.data = data.mutableCopy() as! NSMutableArray
     }
}

extension MyArray {
    func append(element: Any) {
     data.insert(element, at: self.data.count)
     }
}

extension Array: Equatable where Element: Equatable {
// Do not support in Swift 3
}
