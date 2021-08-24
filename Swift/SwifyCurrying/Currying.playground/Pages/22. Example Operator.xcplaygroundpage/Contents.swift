// fmap(curry(User.init), value(json, "name"))
let step1 = curry(User.init) <§> value(json, "name")

// applicative(step1, value(json, "age"))
let step2 = step1 <*> value(json, "age")
let step3 = step2 <*> value(json, "weight")
let step4 = step3 <*> value(json, "isSingle")

curry(User.init)
  <§> value(json, "name")
  <*> value(json, "age")
  <*> value(json, "weight")
  <*> value(json, "isSingle")


//: [☚](@previous) [☛](@next)
