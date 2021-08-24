#!/usr/bin/env swift
import Foundation

class Execution{
    class func execute(path:String,arguments:[String]? = nil) -> Int {
        let task = Process();
        task.launchPath = path
        if arguments != nil {
            task.arguments = arguments!
        }
        task.launch()
        task.waitUntilExit()
        return Int(task.terminationStatus)
    }
}

var status :Int = 0

status = Execution.execute(path: "/bin/ls")
print("Status = \(status)")

# status = Execution.execute(path: "/bin/ls", arguments: ["/"])
# print("Status = \(status)")
