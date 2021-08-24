//
//  PresenterFactory.swift
//  FuncGroup
//
//  Created by gary on 2017/3/9.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import Foundation

protocol PresenterInterface {
    
    func getViewController(_ className:String) -> UIViewController
    
    mutating func performFunction(_ params:Any) -> Any
}

class PresenterFactory: NSObject {

    
    
}

extension PresenterFactory:PresenterInterface{
    
    internal func performFunction(_ params: Any) -> Any {
        return ["result":"ww"]
    }
    
    func getViewController(_ className: String) -> UIViewController {
        let cls:AnyClass = NSClassFromString(className)!
        let ctl:UIViewController = (cls as! UIViewController.Type).init()
        return ctl
    }
}
