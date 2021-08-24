//
//  SplashViewController.swift
//  BNOA
//
//  Created by Cary on 2019/11/15.
//  Copyright © 2019 BNIC. All rights reserved.
//

import UIKit

class SplashViewController: BBaseViewController {

    lazy var btn_enter:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("开始使用", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor = UIColor.blue
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.addTarget(self, action: #selector(enterAction), for: .touchUpInside)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configUI() {
        view.addSubview(btn_enter)
        btn_enter.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(200)
        }
    }
    
    @objc func enterAction() {
        NotificationCenter.default.post(name: .BUserLoginStatusChanged, object: UserLoginStatus.splash)
        updateVersionValue()
    }
    
    // 主程序版本号
    func updateVersionValue() {
        let infoDictionary: [String : Any] = Bundle.main.infoDictionary!
        let mainVersion: Any = infoDictionary["CFBundleShortVersionString"] as Any
        UserDefaults.standard.set(mainVersion, forKey: String.versionKey)
    }

}
