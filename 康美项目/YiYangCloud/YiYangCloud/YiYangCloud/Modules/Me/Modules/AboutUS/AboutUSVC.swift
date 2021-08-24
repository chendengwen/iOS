//
//  AboutUSVC.swift
//  YiYangCloud
//
//  Created by gary on 2017/5/27.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SVProgressHUD

class AboutUSVC: UIViewController {

    
    @IBOutlet weak var erweimaImage: UIImageView!
    @IBOutlet weak var versionLab: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navBarBgAlpha = "1.0"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionLab.text = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    }
    
    @IBAction func longPressed(_ sender: UILongPressGestureRecognizer) {
        // 保存二维码
        guard sender.state == .ended else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(erweimaImage.image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error:NSError?,contextInfo: AnyObject) {
        
        if error != nil {
            SVProgressHUD.showError(withStatus: "保存失败")
        } else {
            SVProgressHUD.showSuccess(withStatus: "保存成功，打开微信扫一扫")
        }
    }
}

