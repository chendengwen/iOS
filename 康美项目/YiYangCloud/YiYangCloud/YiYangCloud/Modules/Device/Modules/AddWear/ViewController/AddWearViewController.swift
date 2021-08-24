//
//  AddWearViewController.swift
//  YiYangCloud
//
//  Created by zhong on 2017/5/5.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import BarcodeScanner
import SVProgressHUD

class AddWearViewController: UITableViewController {

    @IBOutlet weak var CheckCodeText: UITextField!
    @IBOutlet weak var IMEIText: UITextField!
    @IBOutlet weak var verificationCodeText: UITextField!
    @IBOutlet weak var pooCodeView: PooCodeView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新增穿戴"

        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.didClickVerificationCodeBtn(_:)))
        self.pooCodeView.addGestureRecognizer(tap)
        self.pooCodeView.changeCode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //扫描二维码或条形码
    @IBAction func didClickScanCodeBtn(_ sender: UIButton) {
        let controller = BarcodeScannerController()
        controller.codeDelegate = self
        controller.errorDelegate = self
        controller.dismissalDelegate = self

        present(controller, animated: true, completion: nil)
    }
    //确定按钮
    @IBAction func didClickOKBtn(_ sender: UIButton) {
        if self.pooCodeView.verification(self.verificationCodeText.text!) {
            print("正确")
            KMNetWork.fetchData(urlStrig: "http://\(ServerAddress)/app/deviceMember/setBundlesDevice/3315/866545022045261", success: {
                [unowned self]
                (json) in
                let model = NetMessageModel.model(withJSON: json!)
                if (model?.content)! == "绑定成功" {
                    SVProgressHUD.showSuccess(withStatus: "绑定成功")
                    self.navigationController?.popViewController(animated: true)
                }else {
                    SVProgressHUD.showError(withStatus: "绑定失败")
                }
            }) { (error) in
                SVProgressHUD.showError(withStatus: error)
            }
            
        }else{
            SVProgressHUD.showInfo(withStatus: "验证码有误,请重新输入!")
        }
    }
    //更新验证码
    func didClickVerificationCodeBtn(_ sender: UITapGestureRecognizer) {
        self.pooCodeView.changeCode()
    }
    
}

extension AddWearViewController: BarcodeScannerErrorDelegate,BarcodeScannerDismissalDelegate,BarcodeScannerCodeDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        self.IMEIText.text = code
        controller.dismiss(animated: true, completion: nil)
    }
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

