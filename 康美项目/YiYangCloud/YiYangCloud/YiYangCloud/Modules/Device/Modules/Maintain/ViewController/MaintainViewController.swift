//
//  MaintainViewController.swift
//  YiYangCloud
//
//  Created by zhong on 2017/5/4.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit

class MaintainViewController: UITableViewController {
    @IBOutlet weak var photoBtn: UIButton!
    //电池电量
    @IBOutlet weak var batteryView: BatteryView!
    //关系按钮
    @IBOutlet weak var relationshipBtn: UIButton!
    //手表类型
    @IBOutlet weak var watchTypeLab: UILabel!
    //IMEI号
    @IBOutlet weak var IMEILab: UILabel!
    //手机号码
    @IBOutlet weak var phoneLab: UILabel!
    
    @IBOutlet weak var selectView: UIImageView!
    
    var model:WearDataDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "维护穿戴"
        self.tableView.tableFooterView = UIView()
        self.photoBtn.layer.cornerRadius = 25
        self.photoBtn.layer.masksToBounds = true
        //电池电量
        self.batteryView.value = 0.5
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.didClickSaveBtn(sender:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.view.addSubview(self.selectView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.model?.imei != nil {
            self.IMEILab.text = self.model?.imei
        }
    }
    
    @IBAction func didClickRelationshipBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "ChangeWear", bundle: nil)
        self.navigationController?.pushViewController(storyboard.instantiateViewController(withIdentifier: "ChangeWear"), animated: true)
 
    }
    
    //手表按钮
    @IBAction func didClickPushVCBtn(_ sender: UIButton) {
        switch (sender.tag - 100) {
        case 0:
//            let VC = KM8000DialSetViewController.init()
//            self.navigationController?.pushViewController(VC, animated: true)
            let VC = AuthenticationVC.init()
            self.navigationController?.pushViewController(VC, animated: true)
            self.updateSelectBtn(sender: sender)
            break
        case 1:
            let VC = KM8000_KM8010RemindSetVC.init()
            VC.type = "3"
            self.navigationController?.pushViewController(VC, animated: true)
            self.updateSelectBtn(sender: sender)
            break
        case 2:
            let VC = KM8010DialSetViewController.init()
            self.navigationController?.pushViewController(VC, animated: true)
            self.updateSelectBtn(sender: sender)
            break
        case 3:
            let VC = KM8000DialSetViewController.init()
            self.navigationController?.pushViewController(VC, animated: true)
            break
        case 4:
            let VC = KM8020RemindSetVC.init()
            self.navigationController?.pushViewController(VC, animated: true)
            break
        case 5:
            let VC = GeofenceViewController.init()
            self.navigationController?.pushViewController(VC, animated: true)
            break
        default:
            break
        }
    }
    
    @IBAction func didClickChangeWearBtn(_ sender: UIButton) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//Action
extension MaintainViewController {
    
    func updateSelectBtn(sender:UIButton) {
        self.selectView.snp.removeConstraints()
        self.selectView.isHidden = false
        self.selectView.snp.updateConstraints { (make) in
            make.bottom.equalTo(sender).offset(-3)
            make.right.equalTo(sender).offset(3)
            make.height.width.equalTo(23)
        }
    }
    
    func didClickSaveBtn(sender:UIBarButtonItem) {
        
    }
}
