// 接受多个参数的函数
func add(a: Int, _ b: Int) -> Int {
  return a + b
}

// 一次只能接受一个参数的函数
func add(a: Int) -> (Int) -> Int {
  return { b in
    return a + b
  }
}

add(a:1, 2)

let add1 = add(a: 1)
add(a: 1)(2)
add1(2)
//: [☚](@previous) [☛](@next)
