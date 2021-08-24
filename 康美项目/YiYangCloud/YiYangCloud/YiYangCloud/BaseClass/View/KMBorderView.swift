//
//  KMBorderView.swift
//  YiYangCloud
//
//  Created by gary on 2017/4/18.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

enum Border:Int {
    
    case Top = 0
    case Left   = 1
    case Botton    = 2
    case Right  = 3
    
    static let allTypes:[Border] = []
    
    typealias RawValue = Int
    
    init?(rawValue: Border.RawValue) {
        switch rawValue{
        case Border.Botton.rawValue:    self = .Botton
        case Border.Left.rawValue:    self = .Left
        case Border.Top.rawValue:    self = .Top
        case Border.Right.rawValue:    self = .Right
        default:
            return nil
        }
    }
    
    func isEquel(_ type:Border) -> Bool! {
        return type.rawValue == self.rawValue
    }
}

@IBDesignable
class KMBorderView: UIView {

    let arr = Border.init(rawValue: 1)
    var rectangle:CGRect = CGRect.zero
    
    @IBInspectable var borderType:Int = 0 {
        willSet {
            let size:CGFloat = 0.6
            let type = Border.init(rawValue: newValue)!
            
            if type.isEquel(.Left) {
                rectangle = CGRect(x: 0, y: 0, width: size, height: self.bounds.size.height)
            }else if type.isEquel(.Right) {
                rectangle = CGRect(x: self.bounds.size.width - 1, y: 0, width:size, height:self.bounds.size.height)
            }else if type.isEquel(.Botton) {
                rectangle = CGRect(x: 0, y: self.bounds.size.height-1, width:self.bounds.size.width+50, height:size)
            }else if type.isEquel(.Top) {
                rectangle = CGRect(x: 0, y: 0, width:self.bounds.size.width+50, height:size)
            }
        }
    }
    
    
    @IBInspectable var offset:CGFloat = 0.0 {
        willSet {
            let type = Border.init(rawValue: borderType)!
            
            if type.isEquel(.Left) || type.isEquel(.Right) {
                var rect:CGRect = rectangle
                rect.origin.y += newValue
                rect.size.height -= 2*newValue
                rectangle = rect
            }else if type.isEquel(.Botton) || type.isEquel(.Top) {
                var rect:CGRect = rectangle
                rect.origin.x += newValue
                rect.size.width -= newValue
                rectangle = rect
            }
        }
    }
    
    override func awakeFromNib() {
        
    }
    
        // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if  borderType >= 0 {
            let ctx:CGContext! = UIGraphicsGetCurrentContext()
            ctx.setFillColor(UIColor.lightGray.cgColor)
            ctx.addRect(rectangle)
            ctx.drawPath(using: .fill)
            UIGraphicsEndImageContext()
        }
    }
}

extension UIView {
    @IBInspectable var cornerRadius:CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
