//
//  LoginViewController.swift
//  BNOA
//
//  Created by Cary on 2019/11/8.
//  Copyright © 2019 BNIC. All rights reserved.
//

import UIKit

class LoginViewController: BBaseViewController {
    
    lazy var tf_phone: UITextField = {
        let textF = UITextField()
        textF.font = UIFont.systemFont(ofSize: 15.0)
        textF.textColor = UIColor.black
        textF.textAlignment = .left
        textF.borderStyle = .roundedRect
        textF.placeholder = "请输入手机号码"
        textF.keyboardType = .phonePad
        
        return textF
    }()
    
    lazy var tf_password: UITextField = {
        let textF = UITextField()
        textF.font = UIFont.systemFont(ofSize: 15.0)
        textF.textColor = UIColor.black
        textF.textAlignment = .left
        textF.borderStyle = .roundedRect
        textF.placeholder = "请输入密码"
        textF.keyboardType = .numbersAndPunctuation
        
        return textF
    }()
    
    lazy var btn_login: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("登录", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor = UIColor.blue
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var btn_register: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("注册", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.backgroundColor = UIColor.green
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.addTarget(self, action: #selector(registAction), for: .touchUpInside)
        
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "登录"
    }

    override func configUI() {
        view.addSubview(tf_phone)
        tf_phone.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(25)
            make.centerX.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(200)
        }
        
        view.addSubview(tf_password)
        tf_password.snp.makeConstraints { (make) in
            make.width.equalTo(tf_phone)
            make.height.equalTo(tf_phone)
            make.centerX.equalTo(tf_phone)
            make.top.equalTo(tf_phone.snp_bottom).offset(20)
        }
        
        view.addSubview(btn_login)
        btn_login.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.centerX.equalToSuperview()
            make.top.equalTo(tf_password.snp_bottom).offset(40)
        }
        
        view.addSubview(btn_register)
        btn_register.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.right.equalTo(btn_login)
//            make.centerX.equalToSuperview()
            make.top.equalTo(btn_login.snp_bottom).offset(20)
        }
    }
    
    @objc func loginAction() {
        let user = Account.init()
        user.name = "张三2"
        user.phoneNo = "13765566323"
        RealmManager.sharedInstance.add(user)

//        let userA = RealmManager.sharedInstance.objects(Account.self)
//        Logger.log(items: userA)
        
        NotificationCenter.default.post(name: .BUserLoginStatusChanged, object: UserLoginStatus.loginin)
    }
    
    @objc func registAction() {
        navigationController?.pushViewController(RegistViewController(), animated: true)
    }
}
