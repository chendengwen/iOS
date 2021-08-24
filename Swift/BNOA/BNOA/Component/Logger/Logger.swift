//
//  Logger.swift
//  BNOA
//
//  Created by Cary on 2019/11/12.
//  Copyright © 2019 BNIC. All rights reserved.
//

import Foundation

func Log(_ message: String) {
    #if DEBUG
    print(message, separator: " ", terminator: "\n")
    #endif
}

func Log(items: Any...) {
    #if DEBUG
    debugPrint(items, separator: " ", terminator: "\n")
    #endif
}

func LogWithDetail<T>(_ message: T, file: String = #file, function: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):funciton:\(function):line:\(lineNumber)]- \(message)")
    #endif
}
