precedencegroup Map {
  associativity: left
  higherThan: DefaultPrecedence
}

// map
infix operator § : Map

//func §<A, B>(_ f: (A) -> B, _ a: A) -> B {
//  return f(a)
//}

func §<A, B>(_ function: @escaping (A) -> B, _ a:A) -> B {
        return function(a)
}

func aaaa<A, B>(_ function: @escaping (A,B) -> B, _ a:A , _ b:B) -> B {
    return function(a,b)
}

func add(_ a: Int) -> (Int) -> Int {
  return { b in
    return a + b
  }
}

add(1)(2)
add
  § 1
  § 2

curry(User.init)
  § value(json, "name")!
  § value(json, "age")!
  § value(json, "weight")!
  § value(json, "isSingle")!
//: [☚](@previous) [☛](@next)
