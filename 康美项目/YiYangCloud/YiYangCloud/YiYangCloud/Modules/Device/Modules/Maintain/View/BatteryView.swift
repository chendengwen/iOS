//
//  BatteryView.swift
//  Battery
//
//  Created by 钟晓跃 on 2017/5/17.
//  Copyright © 2017年 钟晓跃. All rights reserved.
//

import UIKit

class BatteryView: UIView {

    var value:CGFloat?{
        didSet{
            if self.value! > CGFloat(0.2) {
                self.color = UIColor(red:0.44, green:0.85, blue:0.22, alpha:1.00)
            }else if self.value! > CGFloat(0.1) {
                self.color = UIColor.orange
            }else {
                self.color = UIColor.red
            }
            self.setNeedsDisplay()
        }
    }
    
    var color:UIColor = UIColor(red:0.44, green:0.85, blue:0.22, alpha:1.00)
    
    
    override func draw(_ rect: CGRect) {
//        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.value * 19, 6)];
        if let value = self.value {
            let path = UIBezierPath.init(rect: CGRect.init(x: rect.origin.x + 1, y: rect.origin.y + 1, width: value * 19, height: 6))
            self.color.set()
            path.fill()
        }
        
    }

}
