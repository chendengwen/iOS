import Foundation

struct User {

  let name: String
  let age: Int
  let weight: Double
  let isSingle🐶: Bool
  
}

// 任务：由 JSON 构造 User
extension User {
  static func from(json: JSON) -> User? {
    return nil
  }
}

// JSON 的定义和相关方法
/////// Any 就是 JSONSerialization.jsonObject(with: data, options: options) 的返回值
typealias JSON = Any
protocol JSONValue {}

func value<T: JSONValue>(_ json: JSON, _ key: String) -> T? {
    
  return (json as AnyObject).value(forKey: key) as? T
}

extension String: JSONValue {}
extension Int: JSONValue {}
extension Double: JSONValue {}
extension Bool: JSONValue {}
//: [☚](@previous) [☛](@next)
