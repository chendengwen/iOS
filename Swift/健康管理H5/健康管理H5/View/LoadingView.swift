//
//  LoadingView.swift
//  健康管理H5
//
//  Created by Cary on 2019/8/3.
//  Copyright © 2019 Gary. All rights reserved.
//

/**
 设计思路
 1.扩展 ViewController
 2.start stop
 
 */

import UIKit

fileprivate let WH:CGFloat = 80.0
fileprivate let Tag_FactorA = 239 //取余
fileprivate let Tag_FactorB = 89  //取乘积

class LoadingView {
    
    let animateView = UIImageView.init(frame: CGRect.init(x: (SCREEN_WIDTH-WH)/2, y: (SCREEN_HEIGHT-WH)/2, width: WH, height: WH))
    
    init() {
        
        let hashValue = animateView.hashValue
        
        // 以两个质数计算后的值作为tag
        animateView.tag = hashValue % Tag_FactorA * Tag_FactorB
        animateView.image = UIImage.init(named: "loading1")
        
        var imageArr = Array<UIImage>()
        for index in 2...20 {
            imageArr.append(UIImage.init(named: "loading\(index)")!)
        }
        
        animateView.animationDuration = 0.8
        animateView.animationImages = imageArr
    }
    
    func start(_ superview: UIView) {
        superview.addSubview(animateView)
        animateView.startAnimating()
    }
    
    func stop() {
        animateView.stopAnimating()
        animateView.removeFromSuperview()
    }
}

extension UIViewController {
    
    // 新增一个loading
    @discardableResult
    func startLoading() -> LoadingView {
        let loadingView = LoadingView()
        loadingView.start(self.view)
        return loadingView
    }
    
    // 删除所有loading
    func stopLoading() {
        for view in self.view.subviews {
            if view.tag == view.hashValue % Tag_FactorA * Tag_FactorB {
                let animateView = view as! UIImageView
                animateView.stopAnimating()
                animateView.removeFromSuperview()
            }
        }
    }
    
}
