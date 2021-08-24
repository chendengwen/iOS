import Foundation

let dic: [String : Any] = [
  "name": "CHEN",
  "age": 34,
  "weight": 50.0,
  "isSingle": false
]

let jsonData = try! JSONSerialization.data(withJSONObject: dic)

let json = try! JSONSerialization.jsonObject(with: jsonData)

curry(User.init)(value(json, "name")!)(value(json, "age")!)(value(json, "weight")!)(value(json, "isSingle")!)


//: [☚](@previous) [☛](@next)
