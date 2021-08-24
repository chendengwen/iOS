//
//  KMMaskView.swift
//  YiYangCloud
//
//  Created by Cary on 2017/5/10.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

protocol KMMaskViewProtocol {
    
    func showInMask()
    
    func showInMask(setting: KMMaskSettingStruct)
    
    func dismiss()
    
}

struct KMMaskSettingStruct {
    // 背景颜色
    // 透明度
    // 动画时间
    var backgroundColor = UIColor.gray
    var alpha = 0.4
    var duration = 0.3
}

//Mark: 遮罩  弹框 选项卡 的背景色和手势遮挡
//Mark: 覆盖在windows上，全尺寸
class KMMaskView: UIView {
    
    let setting = KMMaskSettingStruct()
    
    weak var contentView:UIView? {
        didSet {
            let tap = UITapGestureRecognizer.init(target: contentView, action: Selector(("dismiss")))
            self.addGestureRecognizer(tap)
        }
    }

    convenience init() {
        self.init(frame: CGRect(x:0,y:0,width:SCREENWIDTH,height:SCREENHEIGHT))
        
        self.backgroundColor = setting.backgroundColor
        self.alpha = 0.0
        
    }
    
}
