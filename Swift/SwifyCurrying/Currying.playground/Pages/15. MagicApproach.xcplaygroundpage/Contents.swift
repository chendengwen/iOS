//: 魔幻做法
//public func <§><A, B>(f: (A) -> B, a: A?) -> B?
//public func <*><A, B>(f: ((A) -> B)?, a: A?) -> B?

extension User {

  static func from(json: JSON) -> User? {
    return curry(User.init)
      <§> value(json, "name")
      <*> value(json, "age")
      <*> value(json, "weight")
      <*> value(json, "isSingle")
  }

}
//: [☚](@previous) [☛](@next)
