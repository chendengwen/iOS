//
//  KM8000DialSetViewController.swift
//  YiYangCloud
//
//  Created by 钟晓跃 on 2017/5/26.
//  Copyright © 2017年 gary. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import DGElasticPullToRefresh
import MJRefresh

class KM8000DialSetViewController: UIViewController {
    
    let title8000:[String] = ["通话设置","亲情号码","紧急号码"]
    
    var sosArray = ["","",""]
    
    var fmyArray = ["","",""]
    
    var model = KM8000DialSetModel.init()
    
    var timeBtn:UIButton?
    
    var alertView:CustomIOSAlertView?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView.init()
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.loadData()
        })
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "拨号设置"
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .done, target: self, action: #selector(self.saveAction(sender:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        // Do any additional setup after loading the view.
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - NetWork
extension KM8000DialSetViewController{
    func loadData(){
        KMNetWork.fetchData(urlStrig: "http://watch.medquotient.com:8880/kmhc-modem-restful/services/member/deviceManager/13691993691/352151022017391?_type=json", success: {
            [unowned self]
            (json) in
            self.model = KM8000DialSetModel.model(withJSON: json!)!
            self.setData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
}

// MARK: - Action
extension KM8000DialSetViewController{
    func setData(){
        let model:KM8000DialSetList = (self.model.content?.list[0])!
        self.sosArray[0] = model.sosPhoneNo1!
        self.sosArray[1] = model.sosPhoneNo2!
        self.sosArray[2] = model.sosPhoneNo3!
        self.fmyArray[0] = model.fmlyPhoneNo1!
        self.fmyArray[1] = model.fmlyPhoneNo2!
        self.fmyArray[2] = model.fmlyPhoneNo3!
    }
    
    func saveAction(sender:UIBarButtonItem){
        let model = self.model.content?.list[0];
        let jsonData = model?.modelToJSONString()
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        let jsonStr = jsonData?.data(using: .utf8)
        let dict = try! JSONSerialization.jsonObject(with: jsonStr!, options: .mutableContainers) as! [String:Any?]
        print(dict)
        let request = "http://10.2.20.238:7000/app/device/deviceManage/3315/admin/865945021124126/KM8000"
        KMNetWork.fetchDataPost(urlStrig: request, parameters: dict , success: {
//            [unowned self]
            (json) in
            let model = KM8020DialSetModel.model(withJSON: json!)
            if model?.msg != nil && model?.msg == "SOS Contact Info message send Successfully" {
                
            }else{
                SVProgressHUD.showError(withStatus: model?.msg!)
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
    
    func changeSwitch(sender:UISwitch){
        
    }
    
    func showPickerView(){
        self.alertView = CustomIOSAlertView.init()
        let contentView = KMCommonAlertView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH * 0.8, height: 240))
        contentView.titleLabel.text = "通话限时"
        contentView.buttonsArray = ["确定"]
        let okBtn = contentView.realButtons[0] as! UIButton
        okBtn.addTarget(self, action: #selector(self.didClickConfirmBtn(sender:)), for: .touchUpInside)
        let pickerView = UIPickerView.init()
        contentView.customerView.addSubview(pickerView)
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
            make.left.right.equalTo(0)
            make.height.equalTo(140)
        }
        
        if let model = self.model.content?.list[0] {
            pickerView.selectRow(Int(model.phoneLimitTime!)!, inComponent: 0, animated: true)
        }
        
        self.alertView?.containerView = contentView
        self.alertView?.buttonTitles = nil
        self.alertView?.show()
        
    }
    
    func didClickConfirmBtn(sender:UIButton) {
        self.alertView?.close()
        self.tableView.reloadData()
    }
}


// MARK: - UITextFieldDelegate
extension KM8000DialSetViewController:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag >= 10 {
            self.sosArray[textField.tag - 10] = textField.text!
        }else {
            self.fmyArray[textField.tag] = textField.text!
        }
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension KM8000DialSetViewController: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.title8000.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {return 2}
        if section == 1 {return 3}
        if section == 2 {return 3}
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "\(indexPath.section)"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
            cell?.selectionStyle = .none
        }
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell?.textLabel?.text = "防打扰"
                let mSwitch = UISwitch.init()
                mSwitch.addTarget(self, action: #selector(self.changeSwitch(sender:)), for: .valueChanged)
                mSwitch.isOn = (self.model.content?.list[0].nonDistrub != "0")
                cell?.accessoryView = mSwitch
            }else if indexPath.row == 1 {
                cell?.textLabel?.text = "通话限时"
                self.timeBtn = UIButton.init()
                self.timeBtn?.setTitleColor(UIColor.black, for: .normal)
                self.timeBtn?.frame = CGRect.init(x: 0, y: 0, width: 100, height: 30)
                self.timeBtn?.contentHorizontalAlignment = .right
                cell?.accessoryView = timeBtn
                self.timeBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                self.timeBtn?.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
                var str:String?
                if self.model.content?.list[0].phoneLimitTime == "0" || self.model.content?.list[0].phoneLimitTime  == nil {
                    str = "关闭"
                }else{
                    str = "\((self.model.content?.list[0].phoneLimitTime)!)分钟"
                }
                self.timeBtn?.setTitle(str, for: .normal)
                self.timeBtn?.addTarget(self, action: #selector(self.showPickerView), for: .touchUpInside)
            }
        }else {
            cell?.contentView.removeAllSubviews()
            let text = UITextField.init()
            text.delegate = self
            text.font = UIFont.systemFont(ofSize: 15)
            text.keyboardType = .numberPad
            cell?.contentView.addSubview(text)
            text.snp.makeConstraints({ (make) in
                make.left.equalTo((cell?.contentView)!).offset(18)
                make.right.equalTo((cell?.contentView)!).offset(-18)
                make.centerY.equalTo((cell?.contentView)!)
            })
            text.placeholder = "请输入手机号码"
            if indexPath.section == 1 {
                //亲情号码
                text.text = self.fmyArray[indexPath.row]
                text.tag = indexPath.row
            }else if indexPath.section == 2{
                //sos号码
                text.text = self.sosArray[indexPath.row]
                text.tag = indexPath.row + 10
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 40))
        view.backgroundColor = UIColor(red:0.96, green:0.95, blue:0.97, alpha:1.00)
        let lab = UILabel.init()
        lab.text = self.title8000[section]
        lab.textColor = UIColor.init(hex: 0x999999)
        view.addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(18)
            make.centerY.equalTo(view)
        }
        return view
    }

}

extension KM8000DialSetViewController:UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "关闭"
        }else {
            return "\(row)分钟"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.model.content?.list[0].phoneLimitTime = "\(row)"
    }
}
