//: 普遍的方法
extension User {

  static func from(json: JSON) -> User? {
    guard
      let name: String = value(json, "name"),
      let age: Int = value(json, "age"),
      let weight: Double = value(json, "weight"),
      let isSingle🐶: Bool = value(json, "isSingle")
    else { return nil }
    
    return User(
      name      : name,
      age       : age,
      weight    : weight,
      isSingle🐶: isSingle🐶
    )
  }

}

//: [☚](@previous) [☛](@next)
