//: ## 通用的 curry 函数
func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
  return { a in
    return { b in
      return f(a, b)
    }
  }
}

func curry<A, B, C, D, E>(_ f: @escaping (A, B, C, D) -> E) -> (A) -> (B) -> (C) -> (D) -> E
{
  return { a in { b in { c in { d in f(a, b, c, d) }}}}
}

//: [☚](@previous) [☛](@next)
