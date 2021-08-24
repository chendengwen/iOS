enum LogType {  case info, warning, error }

func log(_ type: LogType, _ message: String) -> String {
  return "\(type): \(message)"
}

log(.info, "Hello")
log(.info, "World")

func log(_ type: LogType) -> (String) -> String {
  return { message in
    return "\(type): \(message)"
  }
}

let logInfo = log(.info)
logInfo("Hello")
logInfo("World")

let logWarning = log(.warning)
let logError = log(.error)
//: [☚](@previous) [☛](@next)
