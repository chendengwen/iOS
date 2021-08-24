curry(User.init)

func fmap<A, B>(_ f: (A) -> B, _ a: A?) -> B? {
  if let aa = a { return f(aa) }
  return nil
//  return a.map(f)
}

let fmap_a = fmap(curry(User.init), Optional("CHEN"))
fmap_a

let fmap_b = fmap(curry(User.init), nil)
fmap_b


func apply<A, B>(_ f: ((A) -> B)?, _ a: A?) -> B? {
  guard let f = f, let a = a else { return nil }
  return f(a)
}

apply(fmap_a, Optional(35))
apply(fmap_a, nil)

apply(fmap_b, Optional(35))


precedencegroup FMapAndApplicative {
  associativity: left
  higherThan: DefaultPrecedence
}

// fmap
infix operator <§> : FMapAndApplicative
func <§><A, B>(_ f: (A) -> B, _ a: A?) -> B? {
  return fmap(f, a)
}

// applicative
infix operator <*> : FMapAndApplicative
func <*><A, B>(_ f: ((A) -> B)?, _ a: A?) -> B? {
  return apply(f, a)
}
//: [☚](@previous) [☛](@next)
