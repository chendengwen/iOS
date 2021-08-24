//
//  PhotoBtn.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/6/5.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

class PhotoBtn: UIButton {

    var imgV:UIImageView?
    
    var title:UILabel?
    
    init() {
        super.init(frame: CGRect.zero)
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoBtn {
    func configUI() {
        self.setBackgroundImage(UIImage.init(named: "border"), for: .normal)
        
        self.imgV = UIImageView.init(image: UIImage.init(named: "jiaahao"))
        self.addSubview(self.imgV!)
        self.imgV?.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(15)
            make.centerX.equalTo(self)
        }
        
        self.title = UILabel.init()
        self.title?.font = UIFont.systemFont(ofSize: 12)
        self.title?.textColor = UIColor.init(hex: 0x666666)
        self.addSubview(self.title!)
        self.title?.snp.makeConstraints({ (make) in
            
            make.centerX.equalTo(self.imgV!)
            make.top.equalTo((self.imgV?.snp.bottom)!).offset(10)
        })
        
    }
}
