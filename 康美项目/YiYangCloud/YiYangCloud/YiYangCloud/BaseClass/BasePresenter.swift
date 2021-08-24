//
//  ViewController.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/27.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

struct StoryBoardName<T>: RawRepresentable {
    typealias RawValue = String
    
    var rawValue: String
    
    init?(rawValue: StoryBoardName.RawValue) {
        self.rawValue = rawValue
    }
}

struct StoryBoardNames {
    
    static let main = StoryBoardName<String>(rawValue: "Main")
    
    static let health = StoryBoardName<String>(rawValue: "Health")
    
    static let family = StoryBoardName<String>(rawValue: "Family")
    
    static let device = StoryBoardName<String>(rawValue: "Device")
    
    static let user = StoryBoardName<String>(rawValue: "User")
    
}

//Mark:展示器需要使用到的方法
@objc protocol PresenterOutput {
    
    func getInterface() -> UIViewController
    
    @objc optional
    //Mark:view层用来回调展示器层
    func performFunctionWith(params:AnyObject)
    
    @objc optional
    //Mark:view层回调展示器层来获取数据
    func performGetDataFunctionWith(params:AnyObject)
    
}



//Mark:展示器基类
class BasePresenter: NSObject {
    
    var interface:UIViewController?
}

//Mark:展示器实现PresenterOutput协议
extension BasePresenter: PresenterOutput{
    func getInterface() -> UIViewController {
        guard let ctl = self.interface else {
            return UIViewController.init()
        }
        
        return ctl
    }
}
