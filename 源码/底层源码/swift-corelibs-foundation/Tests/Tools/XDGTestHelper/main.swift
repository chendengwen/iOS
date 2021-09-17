// This source file is part of the Swift.org open source project
//
// Copyright (c) 2017 - 2018 Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//

#if !DEPLOYMENT_RUNTIME_OBJC && canImport(SwiftFoundation) && canImport(SwiftFoundationNetworking) && canImport(SwiftFoundationXML)
import SwiftFoundation
import SwiftFoundationNetworking
import SwiftFoundationXML
import CoreFoundation

#else
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#endif
#if os(Windows)
import WinSDK
#endif
//
//func opTest(){
//       let op1 = BlockOperation.init {
//           for _ in 0..<3{
//               print("A Excute:\(Thread.current)")
//           }
//       }
//
//       let op2 = BlockOperation.init {
//           for _ in 0..<3{
//               print("B Excute:\(Thread.current)")
//           }
//       }
////       op2.queuePriority = .veryHigh
//       let op3 = BlockOperation.init {
//           for _ in 0..<3{
//               print("C Excute:\(Thread.current)")
//           }
//       }
//
//    op1.addDependency(op2)
////           let opQueue = OperationQueue.init()
////           opQueue.maxConcurrentOperationCount = 6
////           opQueue.underlyingQueue = DispatchQueue(label: "com.lg.queue", qos: .default, attributes: .concurrent)
//
//
//    //系统创建的过程当中是如何指定OperationQueue的队列的
//           opQueue.addOperations([op1,op2,op3], waitUntilFinished: false)
//}
//
//opTest()
//
////RunLoop
RunLoop.current.add(SocketPort.init(), forMode: .common)
RunLoop.current.run()


//助理老师QQ:1900009932
//class LGPerson: Codable {
//    var name: String?
//    var age: Int?
//}
//
//class LGTeacher: LGPerson {
//    var subjectName: String?
//
//}
//
//class LGPartTimeTeacher: LGPerson{
//    var partTime: Double?
//}
//
//let t = LGTeacher()
//t.age = 10
//t.name = "Kody"
//t.subjectName = "Swift"
//
//let encoder = JSONEncoder()
//let encoderData = try encoder.encode(t)
//print(String(data: encoderData, encoding: .utf8))



