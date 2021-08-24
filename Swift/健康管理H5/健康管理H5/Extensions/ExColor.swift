//
//  ExColor.swift
//  健康管理H5
//
//  Created by Cary on 2019/8/2.
//  Copyright © 2019 Gary. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r:UInt32 ,g:UInt32 , b:UInt32 , a:CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: a)
    }
    
    class var random: UIColor {
        return UIColor(r: arc4random_uniform(256),
                       g: arc4random_uniform(256),
                       b: arc4random_uniform(256))
    }
    
    class var main: UIColor {
        return UIColor.init(r: 0, g: 141, b: 253)
    }
}
