//
//  NavigationBar.swift
//  H5演示Demo
//
//  Created by mac on 2019/7/26.
//  Copyright © 2019 Gary. All rights reserved.
//

import UIKit

let NavTopSpace:CGFloat = UIDevice.iPhoneX ? 40.0 : 34.0

class NavigationBar: UIView {
    
    var title:String?
    var viewController:UIViewController?
    
    let titleLabel = UILabel.init()
    let backButton = UIButton.init(type: .custom)
    
    var showBackButton:Bool  {
        set(newVal){
            backButton.isHidden = !newVal
        }
        get{
            return backButton.isHidden
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.main
        
        
        titleLabel.frame = CGRect.init(x: 80, y: NavTopSpace, width: frame.size.width-160, height: 20)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18.0)
        self.addSubview(titleLabel)
        
        backButton.frame = CGRect.init(x: 12, y: NavTopSpace, width: 16, height: 16)
        backButton.setImage(UIImage.init(named: "back_icon_white"), for: .normal)
        self.addSubview(backButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        titleLabel.text = title ?? ""
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
    }
    
    @objc func backButtonClicked() {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
    
    
    
}
