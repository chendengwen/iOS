//
//  InputBox.swift
//  YiYangCloud
//
//  Created by zhong on 2017/4/27.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol InputBoxDelegate: class {
    func getXYModel(model: BPValueModel)
}


class InputBox: UIView {
    

    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var HBPText: UITextField!
    @IBOutlet weak var LBPText: UITextField!
    
    var model = BPValueModel.init()
    weak var delegate: InputBoxDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dismissView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.dismiss)))
        dismiss()
    }

    @IBAction func didClickFnish(_ sender: UIButton) {
        if sender.tag == 1 {
            if LBPText.text == "" || HBPText.text == ""{
                SVProgressHUD.showInfo(withStatus: "您输入的数值有误,请重新输入!")
                return
            }
            model.lbp = Int32(LBPText.text!)!
            model.hbp = Int32(HBPText.text!)!
            if (model.lbp > 120 || model.lbp < 30 || model.hbp > 200 || model.hbp < 50 || model.hbp < model.lbp) {
                SVProgressHUD.showInfo(withStatus: "您输入的数值有误,请重新输入!")
                return
            }
            
            self.delegate?.getXYModel(model: self.model)
        }
        self.removeFromSuperview()
    }
    
}

extension InputBox{
    func dismiss(){
        self.removeFromSuperview()
    }
    

}
