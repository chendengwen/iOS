extension User {

  static func from(json: JSON) -> User? {
    return curry(User.init)
      <§> value(json, "name")
      <*> value(json, "age")
      <*> value(json, "weight")
      <*> value(json, "isSingle")
  }
  
}

//: # 大功告成

User.from(json: json)

//: [☚](@previous) [☛](@next)
