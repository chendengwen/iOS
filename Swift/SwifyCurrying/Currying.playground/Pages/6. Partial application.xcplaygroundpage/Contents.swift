/*:
# 部分调用 (Partial Application)
*/

func add(_ a: Int) -> (Int) -> Int {
  return { b in
    return a + b
  }
}

let add1 = add(1)
let add2 = add(2)

add1(10)
add2(10)

//: [☚](@previous) [☛](@next)
