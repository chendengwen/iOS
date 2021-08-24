//
//  KMImageView.swift
//  YiYangCloud
//
//  Created by gary on 2017/6/5.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

private var kImageViewTextKey: String = "imageViewTexKey"
extension UIImageView {
    
    var text: String? {
        get { return (objc_getAssociatedObject(self, &kImageViewTextKey) as? String) }
        set(newValue) {
            objc_setAssociatedObject(self, &kImageViewTextKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
    }

    func border(_ width:CGFloat = 2.0, _ color:UIColor = UIColor.red) {
        let layer = CALayer.init()
        layer.frame = Rect(width: self.size.width + width*2, height: self.size.height + width*2)
        layer.backgroundColor = color.cgColor
        layer.cornerRadius = self.size.width/2 + width
        self.layer.addSublayer(layer)
    }
    
}
