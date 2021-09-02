//
//  LoginViewController.swift
//  RxSwiftDemo
//
//  Created by gary on 2021/7/15.
//  Copyright © 2021 LXF. All rights reserved.
//

import UIKit
import RxSwift

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

class LoginViewController: UIViewController {

    let disposeBag = DisposeBag()
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var pwdL: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.layer.borderWidth = 1
        pwdTF.layer.borderWidth = 1
        nameL.text = "Username has to be at least \(minimalUsernameLength) characters"
        pwdL.text = "Password has to be at least \(minimalPasswordLength) characters"
        button.rx.tap.subscribe { (event) in
            print("------------\(event)\n")
        }.disposed(by: disposeBag)
        button.isEnabled = false
        
        // 用户名是否有效
        let usernameValidObservable = nameTF.rx.text.orEmpty
            // 用户名 -> 用户名是否有效
            .map { (text) -> Bool in
                LoginViewController.isValiadName(content: text)
            }.share(replay: 1)
        // 用户名是否有效 -> 变更提示颜色
        usernameValidObservable.map { (valid) -> UIColor in
            let color = valid ? UIColor.green : UIColor.clear
            return color
        }.subscribe(onNext: {
            self.nameTF.layer.borderColor = $0.cgColor
        }).disposed(by: disposeBag)
        // 用户名是否有效 -> 密码输入框是否可用
        usernameValidObservable.bind(to: pwdTF.rx.isEnabled).disposed(by: disposeBag)
        
        // 密码是否有效
        let passwordIsValidObservable = pwdTF.rx.text.orEmpty.map { (text) -> Bool in
            LoginViewController.isValiadPassword(content: text)
        }
        // 根据密码是否有效变更颜色
        passwordIsValidObservable.map { (valid) -> UIColor in
            let color = valid ? UIColor.green : UIColor.clear
            return color
        }.subscribe(onNext: {
            self.pwdTF.layer.borderColor = $0.cgColor
        }).disposed(by: disposeBag)
        
        // 账号+密码是否有效 -> 按钮可以点击
        Observable.combineLatest(usernameValidObservable, passwordIsValidObservable) {
            (validUsername: Bool, validPassword: Bool) -> Bool in
            return validUsername && validPassword
        }.subscribe(onNext: { (isEnable) in
            self.button.isEnabled = isEnable
        }).disposed(by: disposeBag)

        
        
    }

}

extension LoginViewController {
    class func isValiadName(content: String) -> Bool {
        return content.count >= minimalUsernameLength
    }
    
    class func isValiadPassword(content: String) -> Bool {
        return content.count >= minimalPasswordLength
    }
    
    class func isValiadEmail(emali: String) -> Bool {
        let reg = try? NSRegularExpression(pattern: "^\\S+@\\S+\\.\\S+$", options: .caseInsensitive)
        
        if let reg = reg {
            let range = NSMakeRange(0, emali.lengthOfBytes(using: .utf8))
            let result = reg.matches(in: emali, options: .reportProgress, range: range)
            return result.count > 0
        }
        
        return false
    }
    
}
