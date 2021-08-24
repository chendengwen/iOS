//
//  KMTableViewProtocol.swift
//  YiYangCloud
//
//  Created by gary on 2017/5/19.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

//Mark: 响应view事件的回调协议

@objc protocol KMViewAction {

    //Mark: 标准化事件响应名
    @objc optional func actionSubmit()
    
    @objc optional func actionCancel()
    
    //Mark: 标准化动画接口
    @objc optional func animationShow(_ type:Int)
    
    @objc optional func animationDismiss(_ type:Int)
    
}

@objc protocol KMTableViewAction {
    
    // tableView下拉之后的回调
    @objc func refreshData() -> Void
    
    // tableView上拉之后的回调
    @objc optional func loadMoreData()
    
}
