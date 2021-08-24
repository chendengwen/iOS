//
//  KMViewModelProtocol.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/25.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import HandyJSON

// static 表示类方法（变得和java一样了）
// 所有方法都必须实现
protocol KMViewModelProtocol {
    
    typealias SuccessBlock = (AnyObject,AnyObject)
    typealias FailedBlock = (Error)
    typealias ResponseBlock = (AnyObject,Error)
    typealias ProgressBlock = (Progress)
    
    
    
    /**
     *  加载数据
     */
    func km_loadData(success:SuccessBlock, failed:FailedBlock)
    
    /**
     *  加载数据
     */
//    func km_loadData(progress:Progress, success:SuccessBlock, failed:FailedBlock)
    
    /**
     *  传递模型给view
     */
    func km_viewModelWithModelBlock<T:HandyJSON>(modelBlock:(T))
    
    /**
     *  处理ViewModelInfosBlock
     */
    func km_viewModelWithOtherViewModelBlockOfInfos(info:Dictionary<String, Any>) -> ()
    
    /**
     *  将viewModel中的信息传递出去
     *  @param viewModel   viewModel自己
     *  @param infos 描述信息
     */
    func km_viewMOdel<T:HandyJSON>(viewModel:T, withInfo info:Dictionary<String, Any>)
    
    /**
     *  返回指定viewModel的所引用的控制器
     */
    func km_viewModelWithViewCOntroller() -> UIViewController?
    
    /**
     *
     */
//    static func km_()
}

// @objc optional
// 声明为OC的协议后才支持可选方法
@objc protocol KMViewModelObjecProtocol {
    
    typealias SuccessBlock = (AnyObject)
    typealias FailedBlock = (NSError)
    // !!! OC里面不能写传多个参数的闭包。。。。
    typealias ResponseBlock = (AnyObject,Error)
    
    /**
     *  返回指定viewModel的所引用的控制器
     */
    @objc optional func km_viewModelWithViewCOntroller() -> UIViewController?
    
    /**
     *  加载数据
     */
    @objc optional func km_loadData(success:SuccessBlock, failed:FailedBlock)
    
    /**
     *  传递模型给view
     */
    @objc optional func km_viewModelWithModelBlock(modelBlock:BaseModel) -> NSString
    
    
    @objc optional func km_viewModelWithOtherViewModelBlockOfInfos(info:Dictionary<String, Any>) -> ()
    
    
    
}
