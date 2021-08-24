import Foundation

enum Optional<Wrapped> {

  case none
  case some(Wrapped)
  
}

let a: Int? = 1
let b: Int? = nil

enum Either<L, R> {

  case left(L)
  case right(R)

}

typealias MissingKeyError = String

func either<T>(_ json: JSON, _ key: String) -> Either<MissingKeyError, T> {
  guard let val: T = (json as AnyObject).value(forKey: key) as? T else {
    return .left("Can not decode value from key: \(key)")
  }

  return .right(val)
}

func <§><A, B, E>(_ f: (A) -> B, _ a: (Either<E, A>)) -> Either<E, B> {
  switch a {
  case .left(let l):
    return .left(l)
  case .right(let r):
    return .right(f(r))
  }
}

func <*><A, B, E>(_ f: Either<E, (A) -> B>, _ a: (Either<E, A>)) -> Either<E, B> {
  switch (f, a) {
  case let (.left(l), _):
       return .left(l)
  case let (.right(f), r):
    return f <§> r
  }
}

extension User {

  static func from(json: JSON) -> Either<MissingKeyError, User> {
    return curry(self.init)
      <§> either(json, "name1")
      <*> either(json, "age")
      <*> either(json, "weight1")
      <*> either(json, "isSingle")
  }

}

User.from(json: json)


//: [☚](@previous) [☛](@next)
