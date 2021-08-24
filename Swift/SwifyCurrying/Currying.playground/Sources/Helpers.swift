import Foundation

public struct User {

  let name: String
  let age: Int
  let weight: Double
  let isSingle🐶: Bool

  public init(name: String, age: Int, weight: Double, isSingle🐶: Bool) {
    self.name = name
    self.age = age
    self.weight = weight
    self.isSingle🐶 = isSingle🐶
  }

}

// JSON 的定义和相关方法
public typealias JSON = Any

public func value<T>(_ json: JSON, _ key: String) -> T? {
  return (json as AnyObject).value(forKey: key) as? T
}

public func curry<A, B, C, D, E>(_ f: @escaping (A, B, C, D) -> E)
  -> (A) -> (B) -> (C) -> (D) -> E
{
  return { a in { b in { c in { d in f(a, b, c, d) }}}}
}

precedencegroup FMapAndApplicative {
  associativity: left
  higherThan: DefaultPrecedence
}

// fmap, like <$> in Haskell
infix operator <§> : FMapAndApplicative
public func <§><A, B>(_ f: (A) -> B, _ a: A?) -> B? {
  return a.map(f)
}

// ap
infix operator <*> : FMapAndApplicative
public func <*><A, B>(_ f: ((A) -> B)?, _ a: A?) -> B? {
  guard let f = f, let a = a else { return nil }
  return f(a)
}

let dic = [
  "name": "CHEN",
  "age": 34,
  "weight": 50.0,
  "isSingle": false
  ] as [String : Any]

let jsonData = try! JSONSerialization.data(withJSONObject: dic)

public let json = try! JSONSerialization.jsonObject(with: jsonData)
